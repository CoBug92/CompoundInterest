# Compound Interest

iOS-приложение для расчёта сложного процента. Пользователь задаёт стартовый капитал, регулярные пополнения, срок инвестирования и годовую ставку, а приложение показывает ключевые показатели, график роста капитала и помесячную детализацию.

## Возможности

- Расчёт итогового капитала, внесённой суммы, заработанных процентов и доходности.
- Регулярные пополнения: без пополнений, ежемесячно, ежеквартально или ежегодно.
- Срок инвестирования в годах или месяцах.
- Интерактивный график капитала по месяцам.
- Локализация на русском и английском.

## Технологии

- SwiftUI
- Charts
- XcodeGen для генерации `.xcodeproj`
- SwiftGen для type-safe доступа к локализациям
- SwiftLint для проверки стиля
- Fastlane для TestFlight deploy

## Структура проекта

```text
Compound Interest/
├── App/                 # App entry point и root view
├── Common/              # Общие helpers, extensions и reusable views
├── Flow/                # Экраны и feature-specific UI
├── Models/              # Доменные модели расчёта
└── Resources/           # Assets, localization, Info.plist

Scripts/
├── generate.sh          # SwiftGen + XcodeGen
├── bootstrap.sh         # Установка зависимостей и генерация проекта
├── swiftgen/            # SwiftGen config и wrapper
├── swiftlint/           # SwiftLint config и wrapper
├── xcodegen/            # XcodeGen specs
└── fastlane/            # TestFlight deploy

docs/                    # Проектные правила и документация
```

## Быстрый старт

1. Установите Xcode и command line tools.
2. Установите зависимости через Homebrew/Bundler:

```sh
Scripts/bootstrap.sh
```

Если bootstrap останавливается из-за отсутствующего `Scripts/project.env.example`, создайте локальный `Scripts/project.env` по текущим значениям проекта:

```sh
cat > Scripts/project.env <<'ENV'
PROJECT_NAME="Compound Interest"
APP_DISPLAY_NAME="Сложный процент"
TARGET_NAME=CompoundInterest
TEAM_ID=<your-team-id>
BUNDLE_ID=ru.kostyuchenko.compoundInterest
ENV
```

3. Сгенерируйте ресурсы и Xcode-проект:

```sh
Scripts/generate.sh
```

4. Откройте проект:

```sh
open "Compound Interest.xcodeproj"
```

## Разработка

Запуск SwiftGen и XcodeGen:

```sh
Scripts/generate.sh
```

Запуск SwiftLint:

```sh
Scripts/swiftlint/swiftlint.sh
```

Точечная проверка изменённого файла:

```sh
swiftlint lint --config Scripts/swiftlint/.swiftlint.yml --no-cache "Compound Interest/Flow/Main/View/MainParameterInputView.swift"
```

Проверка сборки без подписи:

```sh
xcodebuild \
  -project "Compound Interest.xcodeproj" \
  -scheme "CompoundInterest" \
  -destination "generic/platform=iOS" \
  CODE_SIGNING_ALLOWED=NO \
  build
```

Если в sandbox/CI нет доступного Simulator runtime, `xcodebuild` может падать на CoreSimulator tooling до запуска приложения. В таком случае отдельно проверяйте SwiftLint и локальную сборку в Xcode.

## CI на Mac mini

Рекомендуемый минимальный вариант — GitHub Actions self-hosted runner на Mac mini. В репозитории используется один workflow `.github/workflows/deploy-testflight.yml`: он запускается при каждом `push` в `master` и вручную через `workflow_dispatch`.

Локально тот же набор проверок запускается командой:

```sh
Scripts/ci.sh
```

Что делает pipeline:

- устанавливает нужные Homebrew-зависимости и Ruby gems из `Gemfile`;
- создаёт локальный `Scripts/project.env` для runner-а;
- запускает SwiftGen/XcodeGen;
- синхронизирует signing через Fastlane Match в readonly-режиме;
- собирает `CompoundInterest` в `Release`;
- загружает новую сборку в TestFlight;
- коммитит обновлённый build number обратно в `master` с `[skip ci]`, чтобы не запускать pipeline по кругу.

На Mac mini нужно один раз установить GitHub Actions runner и добавить ему labels `self-hosted`, `macOS`, `personal` и `compound-interest`.

Минимальная настройка Mac mini:

1. Установите Xcode, откройте его один раз и примите license agreements.
2. Установите Homebrew и Ruby Bundler, если их ещё нет.
3. В GitHub откройте `Settings → Actions → Runners → New self-hosted runner` и выполните команды установки для macOS.
4. При конфигурации runner-а добавьте labels `self-hosted`, `macOS`, `personal` и `compound-interest`.
5. Запустите runner как сервис, чтобы CI переживал перезагрузку Mac mini.

Настройки репозитория для CI:

- `Secrets → Actions → APPLE_TEAM_ID` — Apple Developer Team ID.
- `Variables → Actions → BUNDLE_ID` — bundle id, если нужно переопределить `ru.kostyuchenko.compoundInterest`.

По умолчанию workflow использует `/Applications/Xcode.app`. Если Xcode установлен в другом месте, поменяйте `XCODE_PATH` в `.github/workflows/deploy-testflight.yml`.

## Гайдлайны

Перед изменениями полезно прочитать:

- `docs/project-guidelines.md` — архитектурные и SwiftUI-правила проекта.
- `docs/swift-style.md` — стиль Swift-кода.
- `docs/swiftlint-rules.md` — текущая политика SwiftLint.
- `docs/scripts.md` — устройство скриптов генерации, lint и deploy.

Ключевые правила:

- Используйте сгенерированные symbols для ассетов и локализаций.
- Не добавляйте `MARK`-секции механически: они должны помогать навигации.
- Длинные списки внутри `ScrollView` делайте ленивыми через `LazyVStack`.
- Runtime warnings сначала классифицируйте: системный шум Xcode/Simulator/UIKit не стоит маскировать сложными workaround-ами в app code.
- UI controls с визуальным суффиксом должны иметь корректную hit area и не уезжать за экран на длинных значениях.

## Deploy

Fastlane находится в `Scripts/fastlane`.

Deploy в TestFlight выполняет GitHub Actions workflow `Build and Deploy`. Он автоматически запускается при каждом `push` в `master`, собирает Release, загружает build в TestFlight, повышает build number до следующего относительно App Store Connect и коммитит изменение версии обратно в `master`. Ручной запуск через `workflow_dispatch` тоже доступен; marketing version повышается patch-ом только если выбрать `bump_version=true`.

Для GitHub Actions deploy настройте secrets:

- `APPLE_TEAM_ID`
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY_CONTENT`
- `MATCH_PASSWORD`

Если `APP_STORE_CONNECT_API_KEY_CONTENT` хранится в base64, добавьте secret `APP_STORE_CONNECT_API_KEY_IS_BASE64=1`.

### Match certificates

Сертификаты и provisioning profiles хранятся в общем private repo `Apple-Certificates`. Для нескольких Apple Developer Teams используется отдельная branch на каждую команду/компанию:

- `personal` — личная Apple Developer Team `Q9WXSNT6UT`;
- для компаний используйте стабильное имя компании, например `company-acme`.

CI и deploy всегда используют `MATCH_READONLY=true`, чтобы GitHub Actions не создавал и не пересоздавал signing assets. Первичная генерация или обновление сертификатов выполняется вручную с Mac mini через `MATCH_READONLY=false`.

Перед deploy проверьте:

- `Scripts/project.env`
- `Scripts/fastlane/.env`
- App Store Connect API key переменные
- Match credentials

Запуск lane выполняется из папки `Scripts/fastlane`:

```sh
bundle exec fastlane deploy_to_tf
```
