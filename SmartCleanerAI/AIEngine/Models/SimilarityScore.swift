import Foundation

/// Represents the cosine similarity score between two images.
///
/// A score of 1.0 means the images are identical; 0.0 means completely different.
/// Scores at or above `AppConstants.Scan.similarityThreshold` (0.92) are classified as duplicates.
public struct SimilarityScore: Sendable {
    public let firstIdentifier: String
    public let secondIdentifier: String
    /// Normalized similarity in [0.0, 1.0].
    public let score: Float

    /// Returns `true` if the score meets the duplicate classification threshold.
    public var isDuplicate: Bool { score >= AppConstants.Scan.similarityThreshold }

    /// Returns `true` if the score meets a "similar but not identical" range.
    public var isSimilar: Bool { score >= 0.8 && score < AppConstants.Scan.similarityThreshold }

    public init(firstIdentifier: String, secondIdentifier: String, score: Float) {
        self.firstIdentifier  = firstIdentifier
        self.secondIdentifier = secondIdentifier
        self.score = score
    }
}
