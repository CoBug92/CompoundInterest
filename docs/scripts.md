# Scripts Directory Guide

Документ описывает назначение папки `Scripts`, основные entrypoint-скрипты и правила изменения генерации проекта.

## Общая идея

`Scripts` содержит инфраструктуру первичной настройки проекта, генерации ресурсов и `.xcodeproj`, SwiftLint и Fastlane deploy. Основной пользовательский сценарий — проверить `Scripts/project.env`, при его отсутствии создать файл из `Scripts/project.env.example`, а затем запустить `Scripts/bootstrap.sh` или `Scripts/generate.sh`.

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
  xcodegen/
```

`Scripts/project.env` содержит настройки конкретного приложения. Его можно передавать и хранить в репозитории, если команде нужны общие значения. Секреты следует хранить отдельно — например, в GitHub Secrets или `Scripts/fastlane/.env`.

## Environment

`Scripts/project.env.example` содержит пример обязательных переменных:

```sh
PROJECT_NAME="Compound Interest"
APP_DISPLAY_NAME="Сложный процент"
TARGET_NAME=CompoundInterest
TEAM_ID=YOUR_APPLE_TEAM_ID
BUNDLE_ID=ru.kostyuchenko.compoundInterest
```

Назначение переменных:

- `PROJECT_NAME` — имя директории приложения и `.xcodeproj`.
- `APP_DISPLAY_NAME` — отображаемое имя приложения.
- `TARGET_NAME` — имя app target и основной scheme.
- `TEAM_ID` — Apple Developer Team ID.
- `BUNDLE_ID` — bundle identifier приложения.

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

Проект генерирует app target и target модульных тестов:

```yaml
targets:
  ${TARGET_NAME}:
    templates: [CommonTarget]
  UnitTests:
    type: bundle.unit-test
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

`APP_STORE_CONNECT_API_KEY_CONTENT` всегда должен быть закодирован в base64: Fastlane вызывает `app_store_connect_api_key` с `is_key_content_base64: true`.

Перед реальным deploy нужно проверить `Matchfile`, CI secrets и значения в `Scripts/project.env`.

## CI и deploy

Локальный `Scripts/ci.sh` запускает `bundle exec fastlane ios ci`. Lane выполняет:

- генерацию ресурсов и `.xcodeproj` через `Scripts/generate.sh`;
- SwiftLint в строгом режиме;
- чистую неподписанную Debug-сборку.

GitHub Actions workflow `.github/workflows/deploy-testflight.yml` не вызывает `Scripts/ci.sh`. Он создаёт `Scripts/project.env` из настроек workflow, repository variable и secrets, а затем запускает `bundle exec fastlane ios deploy_to_tf` из `Scripts/fastlane`. Deploy lane синхронизирует signing, собирает Release, загружает сборку в TestFlight и коммитит обновлённую версию.

## Правила изменения

- Не дублируйте логику генерации в CI, Xcode build phases и локальных командах: лучше обновлять wrapper-скрипты.
- Если меняются переменные проекта, согласованно обновляйте `project.env.example`, использующие их скрипты и XcodeGen spec.
- Если добавляется новый tool config, кладите config и wrapper в отдельную подпапку внутри `Scripts`.
- После изменений запускайте минимум `Scripts/generate.sh` или соответствующий wrapper напрямую.
- После изменения XcodeGen проверяйте список target/scheme через `xcodebuild -list -project ${PROJECT_NAME}.xcodeproj`.
