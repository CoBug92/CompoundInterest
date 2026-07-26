# Scripts Directory Guide

Документ описывает назначение папки `Scripts`, основные entrypoint-скрипты и правила изменения генерации проекта.

## Общая идея

`Scripts` содержит инфраструктуру шаблона: первичную настройку проекта, генерацию ресурсов, генерацию `.xcodeproj`, SwiftLint-конфигурацию, Fastlane deploy и шаблоны Xcode. Основной пользовательский сценарий — заполнить `Scripts/project.env` и запустить `Scripts/bootstrap.sh` или `Scripts/generate.sh`.

## Структура

```text
Scripts/
  bootstrap.sh
  generate.sh
  project.env.example
  project.env
  fastlane/
  swiftgen/
  swiftlint/
  templates/
  xcodegen/
```

`Scripts/project.env` — локальный файл с настройками конкретного приложения. Он не должен храниться в template-репозитории, если содержит реальные идентификаторы, team id или SDK-токены.

## Environment

`Scripts/project.env.example` содержит пример обязательных переменных:

```sh
PROJECT_NAME=AppName
APP_DISPLAY_NAME=AppName
TARGET_NAME=AppName
TEAM_ID=TEAM_ID
BUNDLE_ID=com.company-name.template

FACEBOOK_APP_ID=FACEBOOK_APP_ID
FACEBOOK_CLIENT_TOKEN=FACEBOOK_CLIENT_TOKEN
FACEBOOK_URL_SCHEME=fbFACEBOOK_APP_ID
```

Назначение переменных:

- `PROJECT_NAME` — имя директории приложения и `.xcodeproj`.
- `APP_DISPLAY_NAME` — отображаемое имя приложения.
- `TARGET_NAME` — имя единственного app target и основной scheme.
- `TEAM_ID` — Apple Developer Team ID.
- `BUNDLE_ID` — bundle identifier приложения.
- `FACEBOOK_*` — значения для Facebook SDK в `Info.plist`.

## Entrypoints

### `bootstrap.sh`

`Scripts/bootstrap.sh` — первичная настройка локального окружения.

Он делает следующее:

- устанавливает CLI-инструменты из `Brewfile` через `brew bundle`;
- устанавливает Ruby-зависимости через `bundle install`, если Bundler доступен;
- проверяет наличие `Scripts/project.env`;
- загружает переменные окружения;
- просит подтвердить, что env настроен;
- запускает `Scripts/generate.sh`;
- открывает `${PROJECT_NAME}.xcodeproj` в Xcode.

Используйте его при первом разворачивании проекта из шаблона:

```sh
./Scripts/bootstrap.sh
```

### `generate.sh`

`Scripts/generate.sh` — основной неинтерактивный сценарий генерации.

Он делает следующее:

- загружает `Scripts/project.env`;
- если `PROJECT_NAME` отличается от `AppName`, переименовывает директорию `AppName`;
- создаёт `${PROJECT_NAME}/Resources/Generated`;
- запускает SwiftGen;
- запускает XcodeGen.

Используйте его после изменения XcodeGen, SwiftGen, env или структуры проекта:

```sh
cd Scripts
./generate.sh
```

## XcodeGen

Файлы XcodeGen находятся в `Scripts/xcodegen`:

- `project.yml` — верхнеуровневый spec, packages, configs и include `Application.yml`;
- `Application.yml` — app target, build settings, Info.plist values, scripts и dependencies;
- `xcodegen.sh` — безопасный wrapper вокруг `xcodegen`.

Проект генерирует один app target:

```yaml
targets:
  ${TARGET_NAME}:
    templates: [CommonTarget]
```

Проект не генерирует `IDETemplateMacros.plist`, поэтому новые файлы в Xcode создаются без автоматической шапки и начинаются сразу с кода.

## SwiftGen

Файлы SwiftGen находятся в `Scripts/swiftgen`:

- `swiftgen.yml` — конфигурация генерации;
- `swiftgen.sh` — wrapper, который добавляет `/opt/homebrew/bin` в `PATH` и запускает SwiftGen.

Запуск вручную:

```sh
Scripts/swiftgen/swiftgen.sh
```

SwiftGen используется для type-safe доступа к локализационным строкам. Если проект переходит на String Catalog workflow без SwiftGen, этот блок нужно пересмотреть отдельно.

## SwiftLint

Файлы SwiftLint находятся в `Scripts/swiftlint`:

- `.swiftlint.yml` — whitelist-конфигурация правил;
- `swiftlint.sh` — wrapper для локального запуска, Xcode build phase и CI.

Запуск вручную:

```sh
Scripts/swiftlint/swiftlint.sh
```

Особенности wrapper-а:

- запускает SwiftLint от корня проекта;
- берёт config из `Scripts/swiftlint/.swiftlint.yml`;
- проверяет только директорию `${PROJECT_NAME}`;
- использует `--no-cache`, чтобы избежать ошибок записи cache-файлов в sandbox/CI;
- не ломает Xcode build при warning/error SwiftLint, а выводит warning и завершает работу с `0`.

Если нужно сделать SwiftLint строго блокирующим для CI, это лучше вынести в отдельный CI-only режим, а не менять поведение Xcode build phase.

## Templates

`Scripts/templates` зарезервирована для файлов, которые могут понадобиться генерации проекта. Сейчас папка не используется.

## Fastlane

Fastlane находится в `Scripts/fastlane`:

- `Appfile` — берёт app identifier из `BUNDLE_ID`;
- `Fastfile` — lane `deploy_to_tf` для TestFlight;
- `Matchfile` — настройки match;
- `.env.example` — пример переменных для deploy-окружения.

Deploy lane использует:

- `ENV["XCODE_PROJ_PATH"]`;
- `ENV["TARGET_NAME"]` как scheme;
- `BUNDLE_ID` как app identifier;
- App Store Connect API key переменные;
- `MATCH_PASSWORD` и keychain password.

Перед реальным deploy нужно проверить `Matchfile`, CI secrets и значения в `Scripts/project.env`.

## CI

GitHub Actions workflow использует скрипты из `Scripts` напрямую:

- `Scripts/swiftgen/swiftgen.sh` для ресурсов;
- `Scripts/xcodegen/xcodegen.sh` для `.xcodeproj`;
- `Scripts/swiftlint/swiftlint.sh` для SwiftLint;
- `bundle exec fastlane deploy_to_tf` из `Scripts/fastlane`.

CI ожидает, что `Scripts/project.env` уже создан из секретов или хранится в проекте осознанно.

## Правила изменения

- Не дублируйте логику генерации в CI, Xcode build phases и локальных командах: лучше обновлять wrapper-скрипты.
- Если меняется структура проекта, сначала обновите `project.env.example`, затем `generate.sh`, затем XcodeGen spec.
- Если добавляется новый tool config, кладите config и wrapper в отдельную подпапку внутри `Scripts`.
- После изменений запускайте минимум `Scripts/generate.sh` или соответствующий wrapper напрямую.
- После изменения XcodeGen проверяйте список target/scheme через `xcodebuild -list -project ${PROJECT_NAME}.xcodeproj`.
