import CoreGraphics

enum Margin {

    // MARK: - Properties

    static let x1: CGFloat = 2
    static let x2: CGFloat = x1 * 2
    static let x3: CGFloat = x1 * 3
    static let x4: CGFloat = x1 * 4
    static let x5: CGFloat = x1 * 5
    static let x6: CGFloat = x1 * 6
    static let x7: CGFloat = x1 * 7
    static let x8: CGFloat = x1 * 8
    static let x9: CGFloat = x1 * 9
    static let x10: CGFloat = x1 * 10
    static let x11: CGFloat = x1 * 11
    static let x12: CGFloat = x1 * 12
    static let x13: CGFloat = x1 * 13
    static let x14: CGFloat = x1 * 14
    static let x15: CGFloat = x1 * 15
    static let x16: CGFloat = x1 * 16
    static let x17: CGFloat = x1 * 17
    static let x18: CGFloat = x1 * 18
    static let x19: CGFloat = x1 * 19
    static let x20: CGFloat = x1 * 20

    // MARK: - Public methods

    static func x(_ value: CGFloat) -> CGFloat {
        x1 * value
    }
}
