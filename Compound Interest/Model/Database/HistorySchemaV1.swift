import SwiftData

enum HistorySchemaV1: VersionedSchema {

    // MARK: - Properties

    static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    static var models: [any PersistentModel.Type] {
        [HistoryModel.self]
    }
}
