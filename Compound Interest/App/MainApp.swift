import FirebaseCore
import SwiftUI

@main
struct MainApp: App {

    // MARK: - Properties

    private let historyRepository: any HistoryRepository
    private let analyticsClient: any AnalyticsClient

    // MARK: - Init/Deinit

    init() {
        Self.configureFirebaseIfNeeded()
        analyticsClient = FirebaseAnalyticsClient()

        do {
            historyRepository = try HistoryStore.makeRepository()
        } catch {
            historyRepository = UnavailableHistoryRepository(
                underlyingError: error
            )
        }
    }

    // MARK: - Private methods

    private static func configureFirebaseIfNeeded() {
        guard FirebaseApp.app() == nil else {
            return
        }

        FirebaseApp.configure()
    }

    // MARK: - Layout

    var body: some Scene {
        WindowGroup {
            RootView(
                historyRepository: historyRepository,
                analyticsClient: analyticsClient
            )
        }
    }
}
