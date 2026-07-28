import SwiftUI
import UIKit

struct ChartSelectionOverlay: UIViewRepresentable {

    // MARK: - Outputs

    private let onSelect: (CGPoint) -> Void

    // MARK: - Init/Deinit

    init(onSelect: @escaping (CGPoint) -> Void) {
        self.onSelect = onSelect
    }

    // MARK: - Public methods

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap)
        )

        let panGesture = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan)
        )
        panGesture.delegate = context.coordinator

        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)

        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.onSelect = onSelect
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect)
    }
}

extension ChartSelectionOverlay {

    // MARK: - Coordinator

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {

        // MARK: - Outputs

        var onSelect: (CGPoint) -> Void

        // MARK: - Init/Deinit

        init(onSelect: @escaping (CGPoint) -> Void) {
            self.onSelect = onSelect
        }

        // MARK: - Public methods

        @objc
        func handleTap(_ gesture: UITapGestureRecognizer) {
            onSelect(gesture.location(in: gesture.view))
        }

        @objc
        func handlePan(_ gesture: UIPanGestureRecognizer) {
            onSelect(gesture.location(in: gesture.view))
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
                return true
            }

            let velocity = panGesture.velocity(in: panGesture.view)
            return abs(velocity.x) > abs(velocity.y)
        }
    }
}
