import SwiftUI

@main
struct MainApp: App {

    // MARK: - Properties

    private let historyRepository: any HistoryRepository

    // MARK: - Init/Deinit

    init() {
        do {
            historyRepository = try HistoryStore.makeRepository()
        } catch {
            historyRepository = UnavailableHistoryRepository(
                underlyingError: error
            )
        }
    }

    // MARK: - Layout

    var body: some Scene {
        WindowGroup {
            RootView(historyRepository: historyRepository)
        }
    }
}
