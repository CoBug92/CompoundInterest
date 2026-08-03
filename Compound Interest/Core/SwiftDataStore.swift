import SwiftData

@MainActor
final class SwiftDataStore {

    // MARK: - Properties

    private let container: ModelContainer

    // MARK: - Init/Deinit

    init(container: ModelContainer) {
        self.container = container
    }

    // MARK: - Computed properties

    private var context: ModelContext {
        container.mainContext
    }

    // MARK: - Public methods

    func fetch<Model: PersistentModel>(
        _ descriptor: FetchDescriptor<Model>
    ) throws -> [Model] {
        try context.fetch(descriptor)
    }

    func insert<Model: PersistentModel>(_ model: Model) {
        context.insert(model)
    }

    func delete<Model: PersistentModel>(_ model: Model) {
        context.delete(model)
    }

    func deleteAll<Model: PersistentModel>(_ model: Model.Type) throws {
        try context.delete(model: model)
    }

    func save() throws {
        try context.save()
    }
}
