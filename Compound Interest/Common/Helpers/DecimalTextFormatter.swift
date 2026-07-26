import Foundation

struct DecimalTextFormatter {

    // MARK: - Properties

    private let formatter: NumberFormatter

    // MARK: - Init/Deinit

    init(formatter: NumberFormatter = .currency) {
        self.formatter = formatter
    }

    // MARK: - Public methods

    func string(from value: Decimal?) -> String {
        guard let value else {
            return .empty
        }

        return formatter.string(from: value as NSDecimalNumber) ?? .empty
    }

    func decimal(from value: String) -> Decimal? {
        let normalizedValue = normalizedInput(value)

        guard !normalizedValue.isEmpty else {
            return nil
        }

        return formatter.number(from: normalizedValue)?.decimalValue
    }

    // MARK: - Private methods

    private func normalizedInput(_ value: String) -> String {
        let groupingSeparator = formatter.groupingSeparator ?? .empty
        let decimalSeparator = formatter.decimalSeparator ?? .empty

        return value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: String.space, with: String.empty)
            .replacingOccurrences(of: String.nonBreakingSpace, with: String.empty)
            .replacingOccurrences(of: groupingSeparator, with: String.empty)
            .replacingOccurrences(of: String.comma, with: decimalSeparator)
            .replacingOccurrences(of: String.dot, with: decimalSeparator)
    }
}
