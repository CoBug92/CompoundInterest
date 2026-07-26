import Foundation

extension String {

    // MARK: - Properties

    static let empty = ""
    static let comma = ","
    static let dot = "."
    static let nonBreakingSpace = "\u{00A0}"
    static let space = " "

    // MARK: - Computed properties

    static let currencySymbol = Locale.current.currencySymbol ?? ""
}
