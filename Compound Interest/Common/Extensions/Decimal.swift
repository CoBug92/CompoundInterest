import Foundation

extension Decimal {

    // MARK: - Computed properties

    var doubleValue: Double {
        (self as NSDecimalNumber).doubleValue
    }
}
