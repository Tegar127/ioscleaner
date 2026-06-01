import Foundation

/// Contract for AI recommendation caching in SmartCleanerAI.
///
/// Backed by SwiftData via `RecommendationRepository` in the Data layer.
/// Caches AI recommendations with a 24-hour TTL to avoid repeated computation.
///
/// Usage:
/// ```swift
/// let cached = try await recommendationRepository.fetchCached()
/// try await recommendationRepository.save(freshRecommendations)
/// ```
public protocol RecommendationRepositoryProtocol: Sendable {

    /// Returns cached recommendations if within the TTL window.
    ///
    /// - Returns: An array of `RecommendationEntity`, or `nil` if cache is stale/empty.
    func fetchCached() async throws -> [RecommendationEntity]?

    /// Saves a new set of AI recommendations, replacing any existing cache.
    ///
    /// - Parameter recommendations: The recommendations to cache.
    /// - Throws: `StorageError.persistenceFailed` on SwiftData write failure.
    func save(_ recommendations: [RecommendationEntity]) async throws

    /// Marks a specific recommendation as actioned (applied or dismissed).
    ///
    /// - Parameter id: The UUID of the recommendation to mark.
    func markActioned(id: UUID) async throws

    /// Clears all cached recommendations from persistent storage.
    func clearCache() async throws
}
