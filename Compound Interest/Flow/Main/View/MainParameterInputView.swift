import SwiftUI
import UIKit

struct MainParameterInputView<TrailingView: View, BottomView: View>: View {

    // MARK: - Properties

    private let title: String
    private let placeholder: String
    private let suffix: String
    private let isInputDisabled: Bool
    // TODO: - надо вынести логику работы выше
    private let hint: String
    // TODO: - думаю, что не должно быть тут
    private let formatter = DecimalTextFormatter()
    private let trailingView: TrailingView
    private let bottomView: BottomView

    // MARK: - Observable properties

    @Binding private var value: Decimal?
    @State private var shouldShowHint: Bool = false
    @FocusState private var isInputFocused: Bool

    // MARK: - Computed properties

    private var bindingValue: Binding<String> {
        Binding(
            get: { formatter.string(from: value) },
            set: { value = formatter.decimal(from: $0) }
        )
    }

    private var inputText: String {
        formatter.string(from: value)
    }

    private var measuredInputText: String {
        inputText.isEmpty ? placeholder : inputText
    }

    private var inputTextWidth: CGFloat {
        let textWidth = (measuredInputText as NSString).size(
            withAttributes: [
                .font: UIFont.systemFont(
                    ofSize: .displayFontSize,
                    weight: .bold
                )
            ]
        ).width

        return ceil(textWidth) + .textFieldCaretOffset
    }

    // MARK: - Init/Deinit

    init(
        title: String,
        placeholder: String,
        suffix: String,
        hint: String,
        value: Binding<Decimal?>,
        isInputDisabled: Bool = false,
        @ViewBuilder trailingView: () -> TrailingView,
        @ViewBuilder bottomView: () -> BottomView
    ) {
        self.title = title
        self.placeholder = placeholder
        self.suffix = suffix
        self.hint = hint
        self.isInputDisabled = isInputDisabled
        self.trailingView = trailingView()
        self.bottomView = bottomView()
        _value = value
    }

    // MARK: - Layout

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Margin.x3
        ) {
            titleSection
            inputSection
            bottomView
            Divider()
        }
        .overlay(alignment: .center) {
            hintSection
        }
    }

    private var titleSection: some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(AppFont.body)
                .foregroundStyle(Color(.Text.comment))
                .padding(.horizontal, Margin.x2)
            Button(action: toggleHint) {
                Image(systemName: SFSymbols.infoCircle)
            }
            Spacer()
        }
    }

    private var inputSection: some View {
        HStack(spacing: Margin.x2) {
            inputValueSection

            trailingSection
        }
    }

    private var inputValueSection: some View {
        ViewThatFits(in: .horizontal) {
            inputValueContent(usesMeasuredWidth: true)
            inputValueContent(usesMeasuredWidth: false)
        }
        .padding(.horizontal, Margin.x2)
        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .onTapGesture(perform: focusInput)
    }

    private func inputValueContent(usesMeasuredWidth: Bool) -> some View {
        HStack(spacing: Margin.x1) {
            TextField(
                placeholder,
                text: bindingValue
            )
            .font(AppFont.display.bold())
            .foregroundStyle(Color(.Text.primary))
            .autocorrectionDisabled()
            .keyboardType(.decimalPad)
            .disabled(isInputDisabled)
            .opacity(isInputDisabled ? .disabledOpacity : 1)
            .focused($isInputFocused)
            .frame(width: usesMeasuredWidth ? inputTextWidth : nil, alignment: .leading)
            .frame(
                minWidth: .inputMinWidth,
                maxWidth: usesMeasuredWidth ? nil : .infinity,
                alignment: .leading
            )

            Text(suffix)
                .font(AppFont.display.bold())
                .foregroundStyle(Color(.Text.comment))
                .opacity(isInputDisabled ? .disabledOpacity : 1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var trailingSection: some View {
        trailingView
            .fixedSize(horizontal: true, vertical: false)
            .layoutPriority(.trailingPriority)
    }

    @ViewBuilder
    private var hintSection: some View {
        if shouldShowHint {
            HintView(text: hint)
                .task { await hideHintAfterDelay() }
        }
    }

    // MARK: - Private methods

    private func toggleHint() {
        withAnimation {
            shouldShowHint.toggle()
        }
    }

    private func focusInput() {
        guard !isInputDisabled else {
            return
        }

        isInputFocused = true
    }

    private func hideHintAfterDelay() async {
        try? await Task.sleep(for: .seconds(.hideDelay))

        guard !Task.isCancelled else {
            return
        }

        withAnimation {
            shouldShowHint = false
        }
    }
}

extension MainParameterInputView where BottomView == EmptyView {

    // MARK: - Init/Deinit

    init(
        title: String,
        placeholder: String,
        suffix: String,
        hint: String,
        value: Binding<Decimal?>,
        isInputDisabled: Bool = false,
        @ViewBuilder trailingView: () -> TrailingView
    ) {
        self.init(
            title: title,
            placeholder: placeholder,
            suffix: suffix,
            hint: hint,
            value: value,
            isInputDisabled: isInputDisabled,
            trailingView: trailingView
        ) {
            EmptyView()
        }
    }
}

extension MainParameterInputView where TrailingView == EmptyView, BottomView == EmptyView {

    // MARK: - Init/Deinit

    init(
        title: String,
        placeholder: String,
        suffix: String,
        hint: String,
        value: Binding<Decimal?>,
        isInputDisabled: Bool = false
    ) {
        self.init(
            title: title,
            placeholder: placeholder,
            suffix: suffix,
            hint: hint,
            value: value,
            isInputDisabled: isInputDisabled
        ) {
            EmptyView()
        } bottomView: {
            EmptyView()
        }
    }
}

// MARK: - Constants

private extension Double {
    static let disabledOpacity = 0.45
    static let hideDelay = 3.0
    static let trailingPriority = 1.0
}

private extension CGFloat {
    static let displayFontSize: CGFloat = 28
    static let inputMinWidth: CGFloat = 1
    static let textFieldCaretOffset: CGFloat = 2
}

// MARK: - Preview

#Preview {
    MainParameterInputView(
        title: "Initial Investment",
        placeholder: "10 000",
        suffix: .currencySymbol,
        hint: "The amount that will be deposited at the very beginning",
        value: .constant(nil)
    )
    MainParameterInputView(
        title: "Initial Investment",
        placeholder: "10 000",
        suffix: .currencySymbol,
        hint: "The amount that will be deposited at the very beginning",
        value: .constant(Decimal(1000000.3))
    )
    MainParameterInputView(
        title: "Monthly contribution",
        placeholder: "10 000",
        suffix: .currencySymbol,
        hint: "The amount you add regularly",
        value: .constant(Decimal(10000)),
        trailingView: { EmptyView() },
        bottomView: { ContributionFrequencyView(selectedFrequency: .constant(.monthly)) }
    )
}
