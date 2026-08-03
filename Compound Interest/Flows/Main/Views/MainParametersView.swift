import SwiftUI

struct MainParametersView: View {

    // MARK: - Observable properties

    @ObservedObject private var viewModel: MainViewModel
    private let focusedParameter: FocusState<MainParameter?>.Binding

    // MARK: - Init/Deinit

    init(
        viewModel: MainViewModel,
        focusedParameter: FocusState<MainParameter?>.Binding
    ) {
        self.viewModel = viewModel
        self.focusedParameter = focusedParameter
    }

    // MARK: - Layout

    var body: some View {
        VStack(spacing: Margin.x6) {
            ForEach(MainParameter.allCases, id: \.self) { parameter in
                parameterInputView(parameter)
            }
        }
    }

    @ViewBuilder
    private func parameterInputView(_ parameter: MainParameter) -> some View {
        switch parameter {
        case .monthlyContribution:
            monthlyContributionInput(parameter)
        case .investmentDuration:
            investmentDurationInput(parameter)
        case .initialInvestment, .annualInterestRate:
            defaultInput(parameter)
        }
    }

    private func monthlyContributionInput(_ parameter: MainParameter) -> some View {
        MainParameterInputView(
            parameter: parameter,
            title: viewModel.contributionFrequency.contributionTitle,
            placeholder: parameter.placeholder,
            suffix: parameter.suffix,
            hint: parameter.hint,
            value: binding(for: parameter),
            isInputDisabled: viewModel.contributionFrequency == .none,
            focusedParameter: focusedParameter
        ) {
            EmptyView()
        } bottomView: {
            ContributionFrequencyView(selectedFrequency: $viewModel.contributionFrequency)
        }
    }

    private func investmentDurationInput(_ parameter: MainParameter) -> some View {
        MainParameterInputView(
            parameter: parameter,
            title: viewModel.investmentDurationUnit.parameterTitle,
            placeholder: viewModel.investmentDurationUnit.placeholder,
            suffix: parameter.suffix,
            hint: parameter.hint,
            value: binding(for: parameter),
            focusedParameter: focusedParameter
        ) {
            InvestmentDurationUnitView(selectedUnit: $viewModel.investmentDurationUnit)
        }
    }

    private func defaultInput(_ parameter: MainParameter) -> some View {
        MainParameterInputView(
            parameter: parameter,
            title: parameter.title,
            placeholder: parameter.placeholder,
            suffix: parameter.suffix,
            hint: parameter.hint,
            value: binding(for: parameter),
            focusedParameter: focusedParameter
        )
    }

    // MARK: - Private methods

    private func binding(for parameter: MainParameter) -> Binding<Decimal?> {
        switch parameter {
        case .initialInvestment:
            return $viewModel.initialInvestment
        case .monthlyContribution:
            return $viewModel.monthlyContribution
        case .investmentDuration:
            return $viewModel.investmentDuration
        case .annualInterestRate:
            return $viewModel.annualInterestRate
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @FocusState var focusedParameter: MainParameter?

    MainParametersView(
        viewModel: MainViewModel(),
        focusedParameter: $focusedParameter
    )
    .padding()
}
