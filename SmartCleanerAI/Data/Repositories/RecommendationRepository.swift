import Foundation
import SwiftData

/// SwiftData-backed implementation of `RecommendationRepositoryProtocol`.
public final class RecommendationRepository: RecommendationRepositoryProtocol {

    // MARK: - Dependencies

    private let modelContext: ModelContext

    // MARK: - Init

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - RecommendationRepositoryProtocol

    public func fetchCached() async throws -> [RecommendationEntity]? {
        let models = try modelContext.fetch(FetchDescriptor<RecommendationCacheModel>())
        guard !models.isEmpty, !(models.first?.isExpired ?? true) else { return nil }
        return models.map { $0.toDomainEntity() }
    }

    public func save(_ recommendations: [RecommendationEntity]) async throws {
        try modelContext.delete(model: RecommendationCacheModel.self)
        recommendations.forEach { modelContext.insert(RecommendationCacheModel(from: $0)) }
        do {
            try modelContext.save()
            AppLogger.data.info("Saved \(recommendations.count) recommendations to cache")
        } catch {
            throw StorageError.persistenceFailed(reason: error.localizedDescription)
        }
    }

    public func markActioned(id: UUID) async throws {
        let descriptor = FetchDescriptor<RecommendationCacheModel>(
            predicate: #Predicate { $0.id == id }
        )
        if let model = try modelContext.fetch(descriptor).first {
            model.isActioned = true
            try modelContext.save()
        }
    }

    public func clearCache() async throws {
        try modelContext.delete(model: RecommendationCacheModel.self)
        try modelContext.save()
        AppLogger.data.info("Recommendation cache cleared")
    }
}
