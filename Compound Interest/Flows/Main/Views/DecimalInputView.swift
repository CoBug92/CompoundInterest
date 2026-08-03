import SwiftUI
import UIKit

struct DecimalInputView: View {

    // MARK: - Properties

    private let parameter: MainParameter
    private let placeholder: String
    private let suffix: String
    private let isDisabled: Bool
    private let focusedParameter: FocusState<MainParameter?>.Binding
    private let formatter = DecimalTextFormatter()

    // MARK: - Observable properties

    @Binding private var value: Decimal?

    // MARK: - Computed properties

    private var bindingValue: Binding<String> {
        Binding(
            get: { formatter.string(from: value) },
            set: { value = formatter.decimal(from: $0) }
        )
    }

    private var inputTextWidth: CGFloat {
        let inputText = formatter.string(from: value)
        let measuredText = inputText.isEmpty ? placeholder : inputText
        let textWidth = (measuredText as NSString).size(
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
        parameter: MainParameter,
        placeholder: String,
        suffix: String,
        value: Binding<Decimal?>,
        isDisabled: Bool,
        focusedParameter: FocusState<MainParameter?>.Binding
    ) {
        self.parameter = parameter
        self.placeholder = placeholder
        self.suffix = suffix
        self.isDisabled = isDisabled
        self.focusedParameter = focusedParameter
        _value = value
    }

    // MARK: - Layout

    var body: some View {
        ViewThatFits(in: .horizontal) {
            inputContent(usesMeasuredWidth: true)
            inputContent(usesMeasuredWidth: false)
        }
        .padding(.horizontal, Margin.x2)
        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .onTapGesture(perform: focusInput)
    }

    private func inputContent(usesMeasuredWidth: Bool) -> some View {
        HStack(spacing: Margin.x1) {
            TextField(placeholder, text: bindingValue)
                .font(AppFont.display.bold())
                .foregroundStyle(Color(.Text.primary))
                .autocorrectionDisabled()
                .keyboardType(.decimalPad)
                .disabled(isDisabled)
                .opacity(isDisabled ? .disabledOpacity : 1)
                .focused(focusedParameter, equals: parameter)
                .frame(width: usesMeasuredWidth ? inputTextWidth : nil, alignment: .leading)
                .frame(
                    minWidth: .inputMinWidth,
                    maxWidth: usesMeasuredWidth ? nil : .infinity,
                    alignment: .leading
                )

            Text(suffix)
                .font(AppFont.display.bold())
                .foregroundStyle(Color(.Text.comment))
                .opacity(isDisabled ? .disabledOpacity : 1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }

    // MARK: - Private methods

    private func focusInput() {
        guard !isDisabled else {
            return
        }

        focusedParameter.wrappedValue = parameter
    }
}

// MARK: - Constants

private extension Double {
    static let disabledOpacity = 0.45
}

private extension CGFloat {
    static let displayFontSize: CGFloat = 28
    static let inputMinWidth: CGFloat = 1
    static let textFieldCaretOffset: CGFloat = 2
}

// MARK: - Preview

#Preview {
    @Previewable @State var initialInvestment: Decimal? = 100_000
    @Previewable @FocusState var focusedParameter: MainParameter?

    VStack(alignment: .leading, spacing: Margin.x4) {
        DecimalInputView(
            parameter: .initialInvestment,
            placeholder: "10 000",
            suffix: "₽",
            value: $initialInvestment,
            isDisabled: false,
            focusedParameter: $focusedParameter
        )

        DecimalInputView(
            parameter: .monthlyContribution,
            placeholder: "10 000",
            suffix: "₽",
            value: .constant(5_000),
            isDisabled: true,
            focusedParameter: $focusedParameter
        )
    }
    .padding()
}
