import SwiftUI

struct HistoryValueRowView: View {

    // MARK: - Properties

    let title: String
    let value: String

    // MARK: - Layout

    var body: some View {
        LabeledContent {
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color(.Text.primary))
        } label: {
            Text(title)
                .foregroundStyle(Color(.Text.comment))
        }
        .font(AppFont.body)
    }
}

// MARK: - Preview

#Preview {
    HistoryValueRowView(
        title: Localizations.History.InitialInvestment.title,
        value: "100 000 ₽"
    )
    .padding()
}
