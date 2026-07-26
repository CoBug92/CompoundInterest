import UIKit

extension UIApplication {

    // MARK: - Public methods

    @MainActor
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
