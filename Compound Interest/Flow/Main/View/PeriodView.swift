import SwiftUI

struct PeriodView: View {

    // MARK: - Properties

    private let month: Int
    private let capital: Decimal
    // TODO: - думаю, что не должно быть тут
    private let formatter = DecimalTextFormatter()

    // MARK: - Computed properties

    private var formattedCapital: String {
        formatter.string(from: capital)
    }

    // MARK: - Init/Deinit

    init(
        month: Int,
        capital: Decimal
    ) {
        self.month = month
        self.capital = capital
    }

    // MARK: - Layout

    var body: some View {
        HStack {
            periodSection
            Spacer()
            valueSection
        }
        .padding(.all, Margin.x6)
        .background(Color(.Background.modalSecondary))
        .clipShape(.rect(cornerRadius: .cornerRadius, style: .continuous))
        .shadow(radius: .shadowRadius)
    }

    private var periodSection: some View {
        VStack {
            Text(verbatim: String(month))
                .font(AppFont.headline.bold())
                .foregroundStyle(Color(.Text.primary))
            Text(verbatim: Localizations.Period.Month.title)
                .font(AppFont.caption)
                .foregroundStyle(Color(.Text.comment))
        }
    }

    private var valueSection: some View {
        HStack(spacing: .zero) {
            Text(verbatim: formattedCapital)
                .font(AppFont.body.bold())
                .foregroundStyle(Color(.Text.primary))
            Text(verbatim: .currencySymbol)
                .font(AppFont.body.bold())
                .foregroundStyle(Color(.Text.primary))
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: CGFloat = 18
    static let shadowRadius: CGFloat = 2
}

// MARK: - Preview

#Preview {
    PeriodView(
        month: 1,
        capital: Decimal(1000000.23)
    )
}
