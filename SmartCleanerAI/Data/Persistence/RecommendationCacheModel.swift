import SwiftData
import Foundation

/// SwiftData persistent model for caching AI recommendations.
///
/// Each record represents one `RecommendationEntity`.
/// Records expire after `AppConstants.Persistence.recommendationCacheTTL` (24h).
@Model
public final class RecommendationCacheModel {

    @Attribute(.unique) public var id: UUID
    public var typeRawValue: String
    public var title: String
    public var descriptionText: String
    public var estimatedSpaceSavedBytes: Int64
    public var confidenceScore: Float
    public var generatedAt: Date
    public var isActioned: Bool

    // MARK: - Init

    public init(from entity: RecommendationEntity) {
        self.id                        = entity.id
        self.typeRawValue              = entity.type.rawValue
        self.title                     = entity.title
        self.descriptionText           = entity.description
        self.estimatedSpaceSavedBytes  = entity.estimatedSpaceSavedBytes
        self.confidenceScore           = entity.confidenceScore
        self.generatedAt               = entity.generatedAt
        self.isActioned                = entity.isActioned
    }

    // MARK: - Cache Validity

    /// Returns `true` if this cache entry has exceeded the configured TTL.
    var isExpired: Bool {
        Date.now.timeIntervalSince(generatedAt) > AppConstants.Persistence.recommendationCacheTTL
    }

    // MARK: - Domain Mapping

    func toDomainEntity() -> RecommendationEntity {
        RecommendationEntity(
            id: id,
            type: RecommendationType(rawValue: typeRawValue) ?? .unusedFiles,
            title: title,
            description: descriptionText,
            estimatedSpaceSavedBytes: estimatedSpaceSavedBytes,
            confidenceScore: confidenceScore,
            generatedAt: generatedAt,
            isActioned: isActioned
        )
    }
}
