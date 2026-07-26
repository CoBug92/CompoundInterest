import SwiftUI

struct MainView: View {

    // MARK: - Observable properties

    @ObservedObject private var viewModel: MainViewModel

    // MARK: - Init/Deinit

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Layout

    var body: some View {
        ScrollView(showsIndicators: false) {
            contentView
                .padding(.horizontal, Margin.x5)
                .padding(.top, Margin.x4)
        }
        .scrollDismissesKeyboard(.interactively)
        .animation(.keyMetricsAppearance, value: viewModel.result)
    }

    private var contentView: some View {
        VStack(spacing: Margin.x10) {
            parametersSection
            calculateButton
            resultSection
        }
    }

    private var parametersSection: some View {
        VStack(spacing: Margin.x6) {
            ForEach(MainParameter.allCases, id: \.self) { parameter in
                parameterInputView(parameter)
            }
        }
    }

    @ViewBuilder
    private func parameterInputView(_ parameter: MainParameter) -> some View {
        if parameter == .monthlyContribution {
            MainParameterInputView(
                title: viewModel.contributionFrequency.contributionTitle,
                placeholder: parameter.placeholder,
                suffix: parameter.suffix,
                hint: parameter.hint,
                value: binding(for: parameter),
                isInputDisabled: viewModel.contributionFrequency == .none
            ) {
                EmptyView()
            } bottomView: {
                ContributionFrequencyView(selectedFrequency: $viewModel.contributionFrequency)
            }
        } else if parameter == .investmentDuration {
            MainParameterInputView(
                title: viewModel.investmentDurationUnit.parameterTitle,
                placeholder: viewModel.investmentDurationUnit.placeholder,
                suffix: parameter.suffix,
                hint: parameter.hint,
                value: binding(for: parameter)
            ) {
                InvestmentDurationUnitView(selectedUnit: $viewModel.investmentDurationUnit)
            }
        } else {
            MainParameterInputView(
                title: parameter.title,
                placeholder: parameter.placeholder,
                suffix: parameter.suffix,
                hint: parameter.hint,
                value: binding(for: parameter)
            )
        }
    }

    private var calculateButton: some View {
        GradientButton(
            title: Localizations.Main.Calculate.Button.title,
            action: viewModel.calculateResult
        )
        .padding(.top, Margin.x8)
    }

    @ViewBuilder
    private var resultSection: some View {
        if let result = viewModel.result {
            KeyMetricsView(
                metrics: viewModel.keyIndicators
            )
            .transition(.keyMetricsAppearance)
            YieldChartSectionView(
                monthlyCapital: result.monthlyCapital
            )
            periodsSection(result)
                .transaction { transaction in
                    transaction.animation = nil
                }
        }
    }

    private func periodsSection(_ result: KeyIndicatorResult) -> some View {
        LazyVStack(alignment: .leading, spacing: Margin.x4) {
            Text(verbatim: Localizations.Main.Periods.Section.title)
                .font(AppFont.headline.bold())
                .foregroundStyle(Color(.Text.primary))

            ForEach(result.monthlyCapital) { monthlyCapital in
                PeriodView(
                    month: monthlyCapital.month,
                    capital: monthlyCapital.capital
                )
            }
        }
        .padding(.vertical, Margin.x3)
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

// MARK: - AnyTransition

private extension AnyTransition {
    static let keyMetricsAppearance = opacity
        .combined(with: .scale(scale: .keyMetricsInitialScale, anchor: .top))
}

// MARK: - Animation

private extension Animation {
    static let keyMetricsAppearance = easeOut(duration: .keyMetricsAnimationDuration)
}

// MARK: - Constants

private extension Double {
    static let keyMetricsAnimationDuration: Double = 0.25
}

private extension CGFloat {
    static let keyMetricsInitialScale: CGFloat = 0.98
}

// MARK: - Preview

#Preview {
    MainView(viewModel: MainViewModel())
}
