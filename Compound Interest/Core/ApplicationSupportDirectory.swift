import Foundation

enum ApplicationSupportDirectory {

    // MARK: - Public methods

    static func makeDirectoryURL(
        named name: String,
        fileManager: FileManager = .default
    ) throws -> URL {
        let applicationSupportURL = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let directoryURL = applicationSupportURL.appending(
            path: name,
            directoryHint: .isDirectory
        )
        return try prepareDirectory(
            at: directoryURL,
            fileManager: fileManager
        )
    }

    static func prepareDirectory(
        at directoryURL: URL,
        fileManager: FileManager = .default
    ) throws -> URL {
        if !fileManager.fileExists(atPath: directoryURL.path()) {
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true
            )
        }
        return directoryURL
    }

    static func excludeFromBackup(at directoryURL: URL) throws {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        var mutableDirectoryURL = directoryURL
        try mutableDirectoryURL.setResourceValues(resourceValues)
    }
}
