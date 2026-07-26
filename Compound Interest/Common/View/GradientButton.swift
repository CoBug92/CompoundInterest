import SwiftUI

struct GradientButton: View {

    // MARK: - Typealias

    typealias Action = () -> Void

    // MARK: - Properties

    private let title: String
    private let action: Action

    // MARK: - Init/Deinit

    init(
        title: String,
        action: @escaping Action
    ) {
        self.title = title
        self.action = action
    }

    // MARK: - Layout

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(GradientButtonStyle())
    }
}

private struct GradientButtonStyle: ButtonStyle {

    // MARK: - Computed properties

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(.Button.secondary),
                Color(.Button.primary)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    // MARK: - Layout

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.vertical, Margin.x8)
            .contentShape(.rect)
            .background(backgroundGradient)
            .clipShape(
                .rect(
                    cornerRadius: .cornerRadius,
                    style: .continuous
                )
            )
            .shadow(
                color: .black.opacity(.shadowOpacity),
                radius: .shadowRadius,
                y: .shadowOffsetY
            )
            .opacity(configuration.isPressed ? .pressedOpacity : 1)
            .scaleEffect(configuration.isPressed ? .pressedScale : 1)
            .animation(
                .easeOut(duration: .animationDuration),
                value: configuration.isPressed
            )
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: CGFloat = 18
    static let shadowRadius: CGFloat = 2
    static let shadowOffsetY: CGFloat = 1
    static let pressedScale: CGFloat = 0.98
}

private extension Double {
    static let shadowOpacity = 0.18
    static let pressedOpacity = 0.85
    static let animationDuration = 0.12
}

// MARK: - Preview

#Preview {
    GradientButton(
        title: "Calculate",
        action: {}
    )
    .padding()
}
