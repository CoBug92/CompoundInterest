import SwiftUI

struct HistoryView: View {

    // MARK: - Observable properties

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: HistoryViewModel
    @State private var isDeleteAllConfirmationPresented = false

    // MARK: - Init/Deinit

    init(viewModel: HistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Layout

    var body: some View {
        Group {
            if viewModel.rows.isEmpty {
                emptyState
            } else {
                historyList
            }
        }
        .navigationTitle(Localizations.History.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                deleteAllButton
            }
        }
        .confirmationDialog(
            Localizations.History.DeleteAll.Confirmation.title,
            isPresented: $isDeleteAllConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(
                Localizations.History.DeleteAll.buttonTitle,
                role: .destructive,
                action: viewModel.deleteAll
            )
            Button(Localizations.Common.Cancel.buttonTitle, role: .cancel) {}
        } message: {
            Text(Localizations.History.DeleteAll.Confirmation.message)
        }
        .alert(
            Localizations.History.Error.title,
            isPresented: historyErrorBinding
        ) {
            Button(
                Localizations.Common.Ok.buttonTitle,
                action: viewModel.clearError
            )
        } message: {
            Text(Localizations.History.Error.message)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            Localizations.History.Empty.title,
            systemImage: SFSymbols.clockArrowCirclepath,
            description: Text(Localizations.History.Empty.message)
        )
    }

    private var historyList: some View {
        List(viewModel.rows) { row in
            Button {
                viewModel.select(id: row.id)
                dismiss()
            } label: {
                HistoryRowView(row: row)
            }
            .buttonStyle(.plain)
            .swipeActions {
                Button(role: .destructive) {
                    viewModel.delete(id: row.id)
                } label: {
                    Label(
                        Localizations.Common.Delete.buttonTitle,
                        systemImage: SFSymbols.trash
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var deleteAllButton: some View {
        Button(
            Localizations.History.DeleteAll.buttonTitle,
            systemImage: SFSymbols.trash
        ) {
            isDeleteAllConfirmationPresented = true
        }
        .tint(.red)
        .disabled(viewModel.rows.isEmpty)
    }

    private var historyErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.clearError()
                }
            }
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HistoryView(
            viewModel: HistoryViewModel(
                historyRepository: InMemoryHistoryRepository(
                    entries: [
                        HistoryEntry(
                            id: UUID(),
                            calculatedAt: Date(),
                            calculatedDay: HistoryDay(
                                date: Date(),
                                calendar: .history
                            ),
                            input: CalculationInput(
                                initialInvestment: 100_000,
                                monthlyContribution: 10_000,
                                contributionFrequency: .monthly,
                                investmentDuration: 10,
                                investmentDurationUnit: .years,
                                annualInterestRate: 12
                            )
                        )
                    ]
                ),
                analyticsClient: NoopAnalyticsClient(),
                onSelect: { _ in }
            )
        )
    }
}
