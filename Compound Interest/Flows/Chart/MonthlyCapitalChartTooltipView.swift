import SwiftUI

struct MonthlyCapitalChartTooltipView: View {

    // MARK: - Properties

    private let month: Int
    private let capital: Decimal
    private let formatter = DecimalTextFormatter()

    // MARK: - Init/Deinit

    init(month: Int, capital: Decimal) {
        self.month = month
        self.capital = capital
    }

    // MARK: - Layout

    var body: some View {
        VStack(alignment: .leading, spacing: Margin.x1) {
            Text(verbatim: Localizations.Chart.Selected.month(month))
                .font(AppFont.caption)
                .foregroundStyle(Color(.Text.comment))

            Text(verbatim: formatter.string(from: capital))
                .font(AppFont.caption.bold())
                .foregroundStyle(Color(.Text.primary))
        }
        .frame(width: .tooltipWidth, alignment: .leading)
        .padding(.horizontal, Margin.x3)
        .padding(.vertical, Margin.x2)
        .background(Color(.Background.modalPrimary))
        .clipShape(.rect(cornerRadius: .tooltipCornerRadius, style: .continuous))
        .shadow(radius: .tooltipShadowRadius)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let tooltipCornerRadius: CGFloat = 10
    static let tooltipShadowRadius: CGFloat = 2
    static let tooltipWidth: CGFloat = 112
}

// MARK: - Preview

#Preview {
    MonthlyCapitalChartTooltipView(month: 12, capital: 1_286_540.75)
        .padding()
}
