import SwiftUI

struct ContributionFrequencyView: View {

    // MARK: - Inputs

    @Binding private var selectedFrequency: ContributionFrequency

    // MARK: - Init/Deinit

    init(selectedFrequency: Binding<ContributionFrequency>) {
        _selectedFrequency = selectedFrequency
    }

    // MARK: - Layout

    var body: some View {
        HStack(spacing: Margin.x1) {
            ForEach(ContributionFrequency.allCases, id: \.self) { frequency in
                frequencyButton(frequency)
            }
        }
        .padding(.all, Margin.x1)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: .cornerRadius, style: .continuous))
    }

    private func frequencyButton(_ frequency: ContributionFrequency) -> some View {
        Button {
            selectedFrequency = frequency
        } label: {
            Text(verbatim: frequency.title)
                .font(AppFont.caption.bold())
                .foregroundStyle(frequency == selectedFrequency ? Color.white : Color(.Text.primary))
                .lineLimit(1)
                .minimumScaleFactor(.minimumScaleFactor)
                .frame(maxWidth: .infinity)
                .frame(minHeight: .buttonMinHeight)
                .padding(.horizontal, Margin.x1)
                .background(backgroundColor(for: frequency))
                .clipShape(.rect(cornerRadius: .buttonCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private methods

    private func backgroundColor(for frequency: ContributionFrequency) -> Color {
        frequency == selectedFrequency ? Color(.Button.primary) : Color.clear
    }
}

// MARK: - Constants

private extension CGFloat {
    static let buttonCornerRadius: CGFloat = 10
    static let buttonMinHeight: CGFloat = 32
    static let cornerRadius: CGFloat = 14
    static let minimumScaleFactor: CGFloat = 0.7
}

// MARK: - Preview

#Preview {
    ContributionFrequencyView(selectedFrequency: .constant(.monthly))
        .padding()
}
