import Foundation
import SwiftData

enum HistoryStore {

    // MARK: - Public methods

    @MainActor
    static func makeRepository(
        fileManager: FileManager = .default
    ) throws -> SwiftDataHistoryRepository {
        let directoryURL = try ApplicationSupportDirectory.makeDirectoryURL(
            named: .directoryName,
            fileManager: fileManager
        )
        return try makeRepository(
            directoryURL: directoryURL,
            fileManager: fileManager
        )
    }

    @MainActor
    static func makeRepository(
        directoryURL: URL,
        fileManager: FileManager = .default
    ) throws -> SwiftDataHistoryRepository {
        let directoryURL = try ApplicationSupportDirectory.prepareDirectory(
            at: directoryURL,
            fileManager: fileManager
        )
        try ApplicationSupportDirectory.excludeFromBackup(at: directoryURL)
        let storeURL = directoryURL.appending(path: String.storeFileName)
        let schema = Schema(versionedSchema: HistorySchemaV1.self)
        let configuration = ModelConfiguration(
            .storeName,
            schema: schema,
            url: storeURL,
            allowsSave: true,
            cloudKitDatabase: .none
        )
        let container = try ModelContainer(
            for: schema,
            migrationPlan: HistoryMigrationPlan.self,
            configurations: [configuration]
        )
        return SwiftDataHistoryRepository(
            store: SwiftDataStore(container: container)
        )
    }
}

// MARK: - Constants

private extension String {
    static let directoryName = "History"
    static let storeFileName = "History.store"
    static let storeName = "History"
}
