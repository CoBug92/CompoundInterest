import SwiftData

enum HistoryMigrationPlan: SchemaMigrationPlan {

    // MARK: - Properties

    static var schemas: [any VersionedSchema.Type] {
        [HistorySchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
