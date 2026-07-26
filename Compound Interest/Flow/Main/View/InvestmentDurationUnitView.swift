import SwiftUI

struct InvestmentDurationUnitView: View {

    // MARK: - Inputs

    @Binding private var selectedUnit: InvestmentDurationUnit

    // MARK: - Init/Deinit

    init(selectedUnit: Binding<InvestmentDurationUnit>) {
        _selectedUnit = selectedUnit
    }

    // MARK: - Layout

    var body: some View {
        HStack(spacing: Margin.x1) {
            ForEach(InvestmentDurationUnit.allCases, id: \.self) { unit in
                unitButton(unit)
            }
        }
        .padding(.all, Margin.x1)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: .cornerRadius, style: .continuous))
        .fixedSize(horizontal: true, vertical: false)
    }

    private func unitButton(_ unit: InvestmentDurationUnit) -> some View {
        Button {
            selectedUnit = unit
        } label: {
            Text(verbatim: unit.title)
                .font(AppFont.caption.bold())
                .foregroundStyle(unit == selectedUnit ? Color.white : Color(.Text.primary))
                .frame(minWidth: .buttonMinWidth)
                .frame(minHeight: .buttonMinHeight)
                .padding(.horizontal, Margin.x3)
                .background(backgroundColor(for: unit))
                .clipShape(.rect(cornerRadius: .buttonCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private methods

    private func backgroundColor(for unit: InvestmentDurationUnit) -> Color {
        unit == selectedUnit ? Color(.Button.primary) : Color.clear
    }
}

// MARK: - Constants

private extension CGFloat {
    static let buttonCornerRadius: CGFloat = 10
    static let buttonMinHeight: CGFloat = 32
    static let buttonMinWidth: CGFloat = 58
    static let cornerRadius: CGFloat = 12
}

// MARK: - Preview

#Preview {
    InvestmentDurationUnitView(selectedUnit: .constant(.years))
        .padding()
}
