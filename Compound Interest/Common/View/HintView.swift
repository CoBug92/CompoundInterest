import SwiftUI

struct HintView: View {

    // MARK: - Properties

    private let text: String

    // MARK: - Init/Deinit

    init(text: String) {
        self.text = text
    }

    // MARK: - Layout

    var body: some View {
        Text(text)
            .font(AppFont.caption)
            .multilineTextAlignment(.leading)
            .padding(Margin.x4)
            .background(.thinMaterial)
            .clipShape(
                .rect(
                    cornerRadius: .cornerRadius,
                    style: .continuous
                )
            )
            .shadow(radius: .shadowRadius)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
            .offset(y: Margin.x5)
            .transition(.opacity)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: CGFloat = 8
    static let shadowRadius: CGFloat = 8
}

// MARK: - Preview

#Preview {
    HintView(text: "The amount that will be deposited at the very beginning")
        .padding()
}
