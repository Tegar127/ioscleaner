import Foundation
import SwiftData

/// SwiftData-backed implementation of `ScanHistoryRepositoryProtocol`.
public final class ScanHistoryRepository: ScanHistoryRepositoryProtocol {

    // MARK: - Dependencies

    private let modelContext: ModelContext

    // MARK: - Init

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - ScanHistoryRepositoryProtocol

    public func save(_ entry: ScanHistoryEntity) async throws {
        let model = ScanHistoryModel(from: entry)
        modelContext.insert(model)
        do {
            try modelContext.save()
            AppLogger.data.info("Scan history saved: \(entry.id)")
        } catch {
            throw StorageError.persistenceFailed(reason: error.localizedDescription)
        }
    }

    public func fetchAll() async throws -> [ScanHistoryEntity] {
        let descriptor = FetchDescriptor<ScanHistoryModel>(
            sortBy: [SortDescriptor(\.scanDate, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toDomainEntity() }
    }

    public func fetchRecent(days: Int) async throws -> [ScanHistoryEntity] {
        let all = try await fetchAll()
        return all.filter { !$0.scanDate.isOlderThan(days: days) }
    }

    public func deleteAll() async throws {
        try modelContext.delete(model: ScanHistoryModel.self)
        try modelContext.save()
        AppLogger.data.info("All scan history deleted")
    }
}
