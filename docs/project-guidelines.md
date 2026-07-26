# Project Guidelines

Документ фиксирует требования и возможности проекта, которые должны учитывать разработчики и AI-агенты при изменении кода.

## Assets

Проект использует встроенную Xcode/Swift кодогенерацию для доступа к ресурсам из asset catalogs.

Обязательные правила:

- К картинкам и цветам обращаемся через сгенерированные Swift symbols.
- Не используем строковые имена ассетов вроде `Color("Button/primary")` или `Image("iconName")`.
- Исключение — `SFSymbols`: системные символы Apple допускается создавать строками, например `Image(systemName: "chevron.right")`.
- Если Swift symbol для ассета не генерируется, нужно исправить структуру asset catalog или настройки проекта, а не обходить проблему строкой.

Пример предпочтительного доступа к цветам:

```swift
Color(.Button.primary)
Color(.Button.secondary)
```

Пример нежелательного доступа к цветам:

```swift
Color("Button/primary")
Color("Button/secondary")
```

## Swift File Structure

Внутри Swift-файлов используем `// MARK: -` для навигации и явного разделения ответственности. Этот раздел — единственный источник правды по списку секций, их порядку и правилам применения.

Секции не должны добавляться механически. Если раздел пустой или в типе всего несколько строк, `MARK` не нужен.

Рекомендуемый базовый набор секций:

```swift
// MARK: - Typealias
// MARK: - Outputs
// MARK: - Inputs
// MARK: - Properties
// MARK: - Computed properties
// MARK: - Observable properties
// MARK: - Init/Deinit
// MARK: - Layout
// MARK: - Private methods
// MARK: - Public methods
// MARK: - Constants
// MARK: - Preview
```

Protocol conformances выносим в отдельные extensions и маркируем именем протокола:

```swift
// MARK: - Identifiable

extension Model: Identifiable {}
```

## MARK Policy

`MARK` — инструмент навигации, а не ритуал. Хороший `MARK` помогает быстро понять структуру типа. Плохой `MARK` создаёт шум.

Форматирование секций:

- После `// MARK: - ...` всегда ставим одну пустую строку.
- Между секциями оставляем одну пустую строку.
- Если внутри типа используются `MARK`, после открывающей `{` типа оставляем одну пустую строку.
- Перед закрывающей `}` типа пустую строку не ставим.
- Внутри одной секции пустые строки используем только для смысловых групп.

Используем секции, когда они реально отделяют разные виды ответственности:

- `Typealias` — локальные алиасы типа, особенно для callback/output closure типов.
- `Outputs` — события наружу: closures, delegates, publishers, callbacks.
- `Inputs` — зависимости и входные данные, которые приходят извне и управляют типом.
- `Properties` — stored/static properties без UI-observation semantics.
- `Computed properties` — вычисляемые свойства без хранения состояния.
- `Observable properties` — `@State`, `@Binding`, `@Published`, `@ObservedObject`, `@StateObject`, `@Environment` и похожие observable wrappers.
- `Init/Deinit` — инициализация, deinitialization и setup, который логически является частью жизненного цикла.
- `Layout` — `body`, `ViewBuilder`-части и layout-only helpers во `View`.
- `Private methods` — приватная логика типа.
- `Public methods` — внешний API типа, включая значимые `internal` методы.
- `Constants` — нижний блок файла с приватными extensions для файловых констант.
- `Preview` — блок SwiftUI preview в конце файла.
- `ProtocolName` — отдельный extension с conformance конкретному протоколу.

Не используем секции, если они ухудшают читаемость:

- не добавляем пустые секции;
- не дробим маленький `View` на 5 разделов ради формальности;
- не прячем один `body` под `Layout`, если файл очевиден без этого;
- не смешиваем protocol conformance с внутренними секциями основного типа.

## SwiftUI Preview

SwiftUI views должны иметь preview, если preview технически возможен без тяжёлой инфраструктуры.

Обязательные правила:

- Для каждого самостоятельного `View` добавляем `#Preview` в конце файла.
- Перед preview ставим `// MARK: - Preview`.
- Preview должен показывать реалистичное состояние компонента, а не пустую заглушку без смысла.
- Если у компонента есть несколько важных состояний, добавляем несколько preview-вариантов в одном блоке.
- Не протаскиваем production dependencies в preview. Используем constants, mock data, `.constant(...)` и lightweight test doubles.
- Preview можно не добавлять, если `View` невозможно создать без сложной runtime-инфраструктуры. В таком случае причина должна быть очевидна из кода или отдельно зафиксирована при ревью.

## View Responsibility

SwiftUI `View` по умолчанию отвечает за отображение и локальное UI-поведение. Presentation views должны оставаться максимально dumb.

Обязательные правила:

- Presentation view принимает данные и отображает их, но не владеет бизнес-логикой, orchestration и lifecycle-решениями родителя.
- View не должен менять состояние родителя через `Binding`, если он не является control-компонентом.
- `Binding` используем для компонентов, которые редактируют значение как часть своего назначения: `TextField`, `Toggle`, `Slider`, picker, custom input controls.
- Для одноразовых событий используем closures: `action`, `onTap`, `onRetry`, `onClose`.
- Показ, скрытие, таймеры, async lifecycle и orchestration должны жить у владельца состояния: parent view, view model или coordinator.
- Локальное UI-only состояние допустимо внутри `View`, если оно не является бизнес-состоянием и не нужно снаружи.
- Если presentation view начинает принимать много bindings/actions или содержит async-сценарии, это сигнал пересмотреть границу ответственности.

## Layout Metrics

Отступы задаём только через объект `Margin`.

Обязательные правила:

- Не используем literal-значения для layout spacing/padding вроде `.padding(16)`, `VStack(spacing: 12)` или `.offset(y: 8)`.
- Используем существующие значения `Margin.x1`, `Margin.x2`, `Margin.x8` и т.п.
- Если нужного значения нет, сначала проверяем, действительно ли оно нужно. Затем добавляем его в `Margin`, а не локально в конкретный `View`.
- Исключения допустимы только для API, где число не является layout spacing, например `opacity`, `scaleEffect`, `lineLimit`, animation duration или chart/math constants.

## Constants

Константы выносим вниз файла в приватные extensions.

Обязательные правила:

- Не оставляем magic strings, magic numbers и повторяющиеся literal-значения внутри layout/business logic.
- Перед блоком файловых констант ставим один `// MARK: - Constants`.
- Файловые константы объявляем внизу файла через `private extension` подходящего типа: `CGFloat`, `Double`, `String`, `Int` или доменного типа.
- Константы группируем по типу значения, а не создаём глобальные `enum Constants` без необходимости.
- Если значение является частью reusable design system, выносим его в общий объект вроде `Margin`, `Font` или отдельный design token, а не в локальный extension файла.
- Literal-значения внутри `#Preview` не выносим в константы: preview должен оставаться самодостаточным и легко читаемым.
- Literal-значения допустимы inline, если они очевидны и не являются настраиваемыми константами: `0`, `1`, `true`, `false`, пустая строка в явном placeholder-контексте.

## Access Control

По умолчанию сужаем область видимости и поверхность изменения состояния.

Обязательные правила:

- Используем самый строгий access level, который не мешает реальному использованию: `private`, `fileprivate`, `internal`, `public`.
- Stored properties делаем `private`, если они не являются частью внешнего API типа.
- Для состояния, которое должно читаться извне, но изменяться только внутри типа, используем `private(set)`.
- Классы делаем `final`, если наследование явно не нужно.
- Типы, свойства и методы не делаем `public`/`internal` “на всякий случай”. Расширяем доступ только когда появился реальный внешний вызов.
- Не используем `private` механически, если это ухудшает тестируемость, SwiftUI preview ergonomics или требует искусственных wrapper-методов.
