import SwiftUI

@MainActor
struct RootView: View {

    // MARK: - Observable properties

    @StateObject private var viewModel: MainViewModel

    // MARK: - Init/Deinit

    init(
        historyRepository: any HistoryRepository,
        analyticsClient: any AnalyticsClient
    ) {
        _viewModel = StateObject(
            wrappedValue: MainViewModel(
                historyRepository: historyRepository,
                analyticsClient: analyticsClient
            )
        )
    }

    // MARK: - Layout

    var body: some View {
        NavigationStack {
            MainView(viewModel: viewModel)
                .navigationTitle(Localizations.App.name)
        }
    }
}

// MARK: - Preview

#Preview {
    RootView(
        historyRepository: InMemoryHistoryRepository(),
        analyticsClient: NoopAnalyticsClient()
    )
}
