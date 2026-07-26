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

Перед deploy проверьте:

- `Scripts/project.env`
- `Scripts/fastlane/.env`
- App Store Connect API key переменные
- Match credentials

Запуск lane выполняется из папки `Scripts/fastlane`:

```sh
bundle exec fastlane deploy_to_tf
```
