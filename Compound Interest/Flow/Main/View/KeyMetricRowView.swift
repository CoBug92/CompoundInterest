import SwiftUI

struct KeyMetricRowView: View {

    // MARK: - Properties

    private let title: String
    private let value: Decimal
    private let valueColor: Color
    // TODO: - думаю, что не должно быть тут
    private let formatter = DecimalTextFormatter()

    // MARK: - Computed properties

    private var stringValue: String {
        formatter.string(from: value)
    }

    // MARK: - Init/Deinit

    init(
        title: String,
        value: Decimal,
        valueColor: Color
    ) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
    }

    // MARK: - Layout

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(stringValue)
                .font(AppFont.title.bold())
                .foregroundStyle(valueColor)
                .padding(.top, Margin.x6)
                .padding(.horizontal, Margin.x2)
            Text(title)
                .multilineTextAlignment(.leading)
                .font(AppFont.body)
                .foregroundStyle(Color(.Text.comment))
                .padding(.top, Margin.x2)
                .padding(.horizontal, Margin.x2)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

// MARK: - Preview

#Preview {
    KeyMetricRowView(
        title: "Contributed Amount",
        value: Decimal(13000000),
        valueColor: Color(.Text.primary)
    )
}
