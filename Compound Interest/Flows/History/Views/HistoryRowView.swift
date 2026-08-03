import SwiftUI

struct HistoryRowView: View {

    // MARK: - Properties

    let row: HistoryRowViewData

    // MARK: - Layout

    var body: some View {
        VStack(alignment: .leading, spacing: Margin.x4) {
            Text(row.date)
                .font(AppFont.headline.bold())
                .foregroundStyle(Color(.Text.primary))

            HistoryValueRowView(
                title: Localizations.History.InitialInvestment.title,
                value: row.initialInvestment
            )
            HistoryValueRowView(
                title: Localizations.History.Contribution.title,
                value: row.contribution
            )
            HistoryValueRowView(
                title: Localizations.History.Duration.title,
                value: row.duration
            )
            HistoryValueRowView(
                title: Localizations.History.AnnualInterestRate.title,
                value: row.annualInterestRate
            )
        }
        .padding(.vertical, Margin.x2)
        .contentShape(.rect)
    }
}

// MARK: - Preview

#Preview {
    HistoryRowView(
        row: HistoryRowViewData(
            id: UUID(),
            date: "2 Aug 2026",
            initialInvestment: "100 000 ₽",
            contribution: "10 000 ₽ · Monthly",
            duration: "10 years",
            annualInterestRate: "12 %"
        )
    )
    .padding()
}
