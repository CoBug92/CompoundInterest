@testable import CompoundInterest
import Foundation
import SwiftData
import XCTest

@MainActor
final class HistoryStoreTests: XCTestCase {

    // MARK: - Tests

    func testMakeRepositoryPreservesExistingSentinelFile() throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        let sentinelURL = directoryURL.appending(path: "sentinel")
        let sentinelData = Data("preserve me".utf8)
        try sentinelData.write(to: sentinelURL)

        _ = try HistoryStore.makeRepository(
            directoryURL: directoryURL,
            fileManager: .default
        )

        XCTAssertEqual(try Data(contentsOf: sentinelURL), sentinelData)
    }

    func testMakeRepositoryExcludesStoreDirectoryFromBackup() throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer { try? FileManager.default.removeItem(at: directoryURL) }

        _ = try HistoryStore.makeRepository(directoryURL: directoryURL)

        let resourceValues = try directoryURL.resourceValues(
            forKeys: [.isExcludedFromBackupKey]
        )
        XCTAssertEqual(resourceValues.isExcludedFromBackup, true)
    }

    func testRepositoryPersistsV1EntryAcrossReopen() throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        let repository = try HistoryStore.makeRepository(
            directoryURL: directoryURL
        )
        let input = makeInput()
        let date = Date(timeIntervalSinceReferenceDate: 123_456)

        try repository.saveIfNeeded(input, at: date)

        let reopenedRepository = try HistoryStore.makeRepository(
            directoryURL: directoryURL
        )

        let entry = try XCTUnwrap(reopenedRepository.loadAll().first)
        XCTAssertEqual(entry.calculatedAt, date)
        XCTAssertEqual(entry.input, input)
    }

    func testRepositoryPersistsMonthDurationUnitAcrossReopen() throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        let repository = try HistoryStore.makeRepository(
            directoryURL: directoryURL
        )
        let input = makeInput(investmentDurationUnit: .months)

        try repository.saveIfNeeded(input, at: Date())

        let reopenedRepository = try HistoryStore.makeRepository(
            directoryURL: directoryURL
        )

        XCTAssertEqual(try reopenedRepository.loadAll().first?.input, input)
    }

    func testRepositoryOpensLegacyUnversionedV1Store() throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        let input = makeInput()
        let date = Date(timeIntervalSinceReferenceDate: 123_456)

        do {
            let schema = Schema([HistoryModel.self])
            let configuration = ModelConfiguration(
                "History",
                schema: schema,
                url: directoryURL.appending(path: "History.store"),
                allowsSave: true,
                cloudKitDatabase: .none
            )
            let legacyContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            let context = legacyContainer.mainContext
            context.insert(
                HistoryModel(
                    calculatedAt: date,
                    sequenceNumber: .zero,
                    input: input
                )
            )
            try context.save()
        }

        let repository = try HistoryStore.makeRepository(directoryURL: directoryURL)
        let entry = try XCTUnwrap(repository.loadAll().first)

        XCTAssertEqual(entry.calculatedAt, date)
        XCTAssertEqual(entry.input, input)
    }

    func testMakeRepositoryDoesNotDeleteInvalidExistingStore() throws {
        let directoryURL = makeTemporaryDirectoryURL()
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        let storeURL = directoryURL.appending(path: "History.store")
        let invalidStoreData = Data("not a SwiftData store".utf8)
        try invalidStoreData.write(to: storeURL)
        let sentinelURL = directoryURL.appending(path: "sentinel")
        let sentinelData = Data("preserve me".utf8)
        try sentinelData.write(to: sentinelURL)

        XCTAssertThrowsError(
            try HistoryStore.makeRepository(directoryURL: directoryURL)
        )
        XCTAssertEqual(try Data(contentsOf: storeURL), invalidStoreData)
        XCTAssertEqual(try Data(contentsOf: sentinelURL), sentinelData)
    }

    // MARK: - Private methods

    private func makeTemporaryDirectoryURL() -> URL {
        FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString, directoryHint: .isDirectory)
    }

    private func makeInput(
        investmentDurationUnit: InvestmentDurationUnit = .years
    ) -> CalculationInput {
        CalculationInput(
            initialInvestment: 100_000,
            monthlyContribution: 10_000,
            contributionFrequency: .monthly,
            investmentDuration: 10,
            investmentDurationUnit: investmentDurationUnit,
            annualInterestRate: 12
        )
    }
}
