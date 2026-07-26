import SwiftUI

struct RootView: View {

    // MARK: - Observable properties

    @StateObject private var viewModel = MainViewModel()

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
    RootView()
}
