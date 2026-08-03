import SwiftUI

struct MainParameterInputView<TrailingView: View, BottomView: View>: View {

    // MARK: - Properties

    private let title: String
    private let parameter: MainParameter
    private let placeholder: String
    private let suffix: String
    private let isInputDisabled: Bool
    private let hint: String
    private let trailingView: TrailingView
    private let bottomView: BottomView
    private let focusedParameter: FocusState<MainParameter?>.Binding

    // MARK: - Observable properties

    @Binding private var value: Decimal?
    @State private var shouldShowHint: Bool = false

    // MARK: - Init/Deinit

    init(
        parameter: MainParameter,
        title: String,
        placeholder: String,
        suffix: String,
        hint: String,
        value: Binding<Decimal?>,
        isInputDisabled: Bool = false,
        focusedParameter: FocusState<MainParameter?>.Binding,
        @ViewBuilder trailingView: () -> TrailingView,
        @ViewBuilder bottomView: () -> BottomView
    ) {
        self.parameter = parameter
        self.title = title
        self.placeholder = placeholder
        self.suffix = suffix
        self.hint = hint
        self.isInputDisabled = isInputDisabled
        self.focusedParameter = focusedParameter
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
        DecimalInputView(
            parameter: parameter,
            placeholder: placeholder,
            suffix: suffix,
            value: $value,
            isDisabled: isInputDisabled,
            focusedParameter: focusedParameter
        )
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
        parameter: MainParameter,
        title: String,
        placeholder: String,
        suffix: String,
        hint: String,
        value: Binding<Decimal?>,
        isInputDisabled: Bool = false,
        focusedParameter: FocusState<MainParameter?>.Binding,
        @ViewBuilder trailingView: () -> TrailingView
    ) {
        self.init(
            parameter: parameter,
            title: title,
            placeholder: placeholder,
            suffix: suffix,
            hint: hint,
            value: value,
            isInputDisabled: isInputDisabled,
            focusedParameter: focusedParameter,
            trailingView: trailingView
        ) {
            EmptyView()
        }
    }
}

extension MainParameterInputView where TrailingView == EmptyView, BottomView == EmptyView {

    // MARK: - Init/Deinit

    init(
        parameter: MainParameter,
        title: String,
        placeholder: String,
        suffix: String,
        hint: String,
        value: Binding<Decimal?>,
        isInputDisabled: Bool = false,
        focusedParameter: FocusState<MainParameter?>.Binding
    ) {
        self.init(
            parameter: parameter,
            title: title,
            placeholder: placeholder,
            suffix: suffix,
            hint: hint,
            value: value,
            isInputDisabled: isInputDisabled,
            focusedParameter: focusedParameter
        ) {
            EmptyView()
        } bottomView: {
            EmptyView()
        }
    }
}

// MARK: - Constants

private extension Double {
    static let hideDelay = 3.0
    static let trailingPriority = 1.0
}

// MARK: - Preview

#Preview {
    @Previewable @FocusState var focusedParameter: MainParameter?

    VStack {
        MainParameterInputView(
            parameter: .initialInvestment,
            title: "Initial Investment",
            placeholder: "10 000",
            suffix: .currencySymbol,
            hint: "The amount that will be deposited at the very beginning",
            value: .constant(nil),
            focusedParameter: $focusedParameter
        )
        MainParameterInputView(
            parameter: .initialInvestment,
            title: "Initial Investment",
            placeholder: "10 000",
            suffix: .currencySymbol,
            hint: "The amount that will be deposited at the very beginning",
            value: .constant(Decimal(1000000.3)),
            focusedParameter: $focusedParameter
        )
        MainParameterInputView(
            parameter: .monthlyContribution,
            title: "Monthly contribution",
            placeholder: "10 000",
            suffix: .currencySymbol,
            hint: "The amount you add regularly",
            value: .constant(Decimal(10000)),
            focusedParameter: $focusedParameter,
            trailingView: { EmptyView() },
            bottomView: { ContributionFrequencyView(selectedFrequency: .constant(.monthly)) }
        )
    }
}
