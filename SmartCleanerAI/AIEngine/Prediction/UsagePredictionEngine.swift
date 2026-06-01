import Foundation

// MARK: - Supporting Types

/// A photo paired with its predicted usage score.
public struct ScoredAsset: Sendable {
    public let photo: PhotoEntity
    /// Usefulness score in [0.0, 1.0]. Lower = less useful (candidate for cleanup).
    public let score: Float
}

// MARK: - Protocol

/// Contract for usage prediction capabilities.
public protocol UsagePredictionEngineProtocol: Sendable {
    func scoreAssets(_ photos: [PhotoEntity]) async -> [ScoredAsset]
}

// MARK: - Implementation

/// Scores photos by estimated usefulness using recency and content heuristics.
///
/// Assets with low scores are surfaced as cleanup candidates.
/// Algorithm: recency weight + favorite bonus − blur penalty − screenshot penalty.
public final class UsagePredictionEngine: UsagePredictionEngineProtocol {

    public init() {}

    // MARK: - UsagePredictionEngineProtocol

    /// Scores each photo on a usefulness scale of [0.0, 1.0].
    ///
    /// - Parameter photos: The photos to score.
    /// - Returns: `ScoredAsset` array sorted ascending by score (least useful first).
    public func scoreAssets(_ photos: [PhotoEntity]) async -> [ScoredAsset] {
        AppLogger.ai.info("Scoring \(photos.count) assets for usage prediction")
        return photos
            .map { ScoredAsset(photo: $0, score: calculateScore(for: $0)) }
            .sorted { $0.score < $1.score }
    }

    // MARK: - Scoring Algorithm

    private func calculateScore(for photo: PhotoEntity) -> Float {
        var score: Float = 0.5
        score += recencyScore(for: photo.creationDate)
        if photo.isFavorite  { score += 0.30 }
        if photo.isBlurry    { score -= 0.30 }
        if photo.isScreenshot { score -= 0.15 }
        if photo.isDuplicate  { score -= 0.20 }
        return max(0, min(1, score))
    }

    private func recencyScore(for date: Date?) -> Float {
        guard let date else { return -0.2 }
        switch date.daysSinceNow {
        case 0..<7:    return  0.30
        case 7..<30:   return  0.15
        case 30..<90:  return  0.00
        case 90..<365: return -0.10
        default:       return -0.20
        }
    }
}
