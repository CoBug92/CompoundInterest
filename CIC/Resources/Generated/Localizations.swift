// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Localizations {

  public enum Common {
    /// Мес
    public static let month = Localizations.tr("Localizable", "common.month")
  }

  public enum Detail {
    /// График доходности
    public static let chart = Localizations.tr("Localizable", "detail.chart")
    /// Период
    public static let month = Localizations.tr("Localizable", "detail.month")
    /// Доходность по периодам
    public static let yieldPeriod = Localizations.tr("Localizable", "detail.yieldPeriod")
  }

  public enum Main {
    /// Рассчитать
    public static let calculate = Localizations.tr("Localizable", "main.calculate")
    /// Внесенная сумма
    public static let contributedAmount = Localizations.tr("Localizable", "main.contributedAmount")
    /// Начальный депозит
    public static let initialDeposit = Localizations.tr("Localizable", "main.initialDeposit")
    /// Довложения каждый месяц
    public static let investments = Localizations.tr("Localizable", "main.investments")
    /// Ключевые показатели
    public static let keyIndicators = Localizations.tr("Localizable", "main.keyIndicators")
    /// Количество месяцев
    public static let numberOfPeriods = Localizations.tr("Localizable", "main.numberOfPeriods")
    /// Доходность за 1 месяц
    public static let profitability = Localizations.tr("Localizable", "main.profitability")
    /// Смотреть график доходности
    public static let seeGraphic = Localizations.tr("Localizable", "main.seeGraphic")
    /// Сложный процент
    public static let title = Localizations.tr("Localizable", "main.title")
    /// Итоговая сумма за все периоды
    public static let totalCap = Localizations.tr("Localizable", "main.totalCap")
    /// Заработано процентов от внесенной суммы
    public static let totalGrowth = Localizations.tr("Localizable", "main.totalGrowth")
    /// Заработано на процентах
    public static let totalInterest = Localizations.tr("Localizable", "main.totalInterest")
    public enum Hint {
      /// Сумма, которая будет внесена в самом начале
      public static let initialDeposit = Localizations.tr("Localizable", "main.hint.initialDeposit")
      /// Сумма, которую вы будете вносить каждый период (первый месяц не учитывается, так как вы вносите депозит)
      public static let investments = Localizations.tr("Localizable", "main.hint.investments")
      /// Срок в месяцах на который вы планируете открыть счет
      public static let numberOfPeriods = Localizations.tr("Localizable", "main.hint.numberOfPeriods")
      /// Доходный процент за 1 период(месяц)
      public static let profitability = Localizations.tr("Localizable", "main.hint.profitability")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localizations {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
