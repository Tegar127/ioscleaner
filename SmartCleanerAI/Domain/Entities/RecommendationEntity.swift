import Foundation

/// Represents an AI-generated cleanup recommendation in the domain layer.
///
/// Produced by `RecommendationEngine` and cached via `RecommendationRepository`.
/// Ranked by estimated space saved and confidence score.
///
/// Usage:
/// ```swift
/// let rec = RecommendationEntity(
///     type: .screenshots,
///     title: "Clear Screenshots",
///     estimatedSpaceSavedBytes: 1_200_000_000,
///     confidenceScore: 0.95
/// )
/// ```
public struct RecommendationEntity: Identifiable, Hashable, Sendable {

    // MARK: - Identity

    public let id: UUID

    // MARK: - Recommendation Data

    public let type: RecommendationType
    public let title: String
    public let description: String
    public let estimatedSpaceSavedBytes: Int64
    public let confidenceScore: Float     // 0.0 – 1.0
    public let affectedAssetIdentifiers: [String]
    public let generatedAt: Date
    public var isActioned: Bool

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        type: RecommendationType,
        title: String,
        description: String,
        estimatedSpaceSavedBytes: Int64,
        confidenceScore: Float,
        affectedAssetIdentifiers: [String] = [],
        generatedAt: Date = .now,
        isActioned: Bool = false
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.estimatedSpaceSavedBytes = estimatedSpaceSavedBytes
        self.confidenceScore = confidenceScore
        self.affectedAssetIdentifiers = affectedAssetIdentifiers
        self.generatedAt = generatedAt
        self.isActioned = isActioned
    }

    // MARK: - Computed

    /// Human-readable estimated space saved (e.g., "1.2 GB").
    var formattedSpaceSaved: String {
        AppFormatter.byteCount.string(fromByteCount: estimatedSpaceSavedBytes)
    }

    /// Confidence as a percentage string (e.g., "95%").
    var confidenceLabel: String {
        AppFormatter.percentage.string(from: NSNumber(value: confidenceScore)) ?? "—"
    }
}

// MARK: - RecommendationType

/// Enumerates the types of AI recommendations in SmartCleanerAI.
public enum RecommendationType: String, CaseIterable, Codable, Sendable {
    case duplicatePhotos = "duplicate_photos"
    case blurryPhotos    = "blurry_photos"
    case similarPhotos   = "similar_photos"
    case screenshots     = "screenshots"
    case largeVideos     = "large_videos"
    case duplicateContacts = "duplicate_contacts"
    case unusedFiles     = "unused_files"

    var systemIcon: String {
        switch self {
        case .duplicatePhotos:    return "photo.on.rectangle.angled"
        case .blurryPhotos:       return "camera.filters"
        case .similarPhotos:      return "rectangle.stack.badge.play"
        case .screenshots:        return "camera.viewfinder"
        case .largeVideos:        return "video.badge.ellipsis"
        case .duplicateContacts:  return "person.2.badge.gearshape"
        case .unusedFiles:        return "archivebox"
        }
    }
}
