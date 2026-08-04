import SwiftUI

struct MonthlyCapitalListView: View {

    // MARK: - Properties

    let monthlyCapital: [KeyIndicatorResult.MonthlyCapital]
    let onExportStarted: () -> Void

    // MARK: - Layout

    var body: some View {
        LazyVStack(alignment: .leading, spacing: Margin.x4) {
            header

            ForEach(monthlyCapital) { item in
                PeriodView(
                    month: item.month,
                    capital: item.capital
                )
            }
        }
        .padding(.vertical, Margin.x3)
    }

    private var header: some View {
        HStack(spacing: Margin.x4) {
            Text(verbatim: Localizations.Main.Periods.Section.title)
                .font(AppFont.headline.bold())
                .foregroundStyle(Color(.Text.primary))

            Spacer()

            ShareLink(
                item: MonthlyCapitalPDFDocument(monthlyCapital: monthlyCapital),
                preview: SharePreview(Localizations.Export.MonthlyIncome.fileName)
            ) {
                Image(systemName: SFSymbols.squareAndArrowUp)
                    .font(AppFont.body.bold())
                    .foregroundStyle(Color(.Text.primary))
                    .padding(.all, Margin.x2)
            }
            .simultaneousGesture(
                TapGesture().onEnded(onExportStarted)
            )
            .accessibilityLabel(Localizations.Export.MonthlyIncome.buttonTitle)
        }
    }
}

// MARK: - Preview

#Preview {
    MonthlyCapitalListView(
        monthlyCapital: [
            KeyIndicatorResult.MonthlyCapital(month: 1, capital: 101_000),
            KeyIndicatorResult.MonthlyCapital(month: 2, capital: 102_010)
        ],
        onExportStarted: {}
    )
    .padding()
}
