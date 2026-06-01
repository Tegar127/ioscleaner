import Foundation

/// Contract for scan history persistence in SmartCleanerAI.
///
/// Backed by SwiftData via `ScanHistoryRepository` in the Data layer.
/// Powers the ScanHistory feature timeline and monetization insights.
///
/// Usage:
/// ```swift
/// try await scanHistoryRepository.save(completedEntry)
/// let history = try await scanHistoryRepository.fetchAll()
/// ```
public protocol ScanHistoryRepositoryProtocol: Sendable {

    /// Saves a completed scan result to persistent storage.
    ///
    /// - Parameter entry: The `ScanHistoryEntity` to persist.
    /// - Throws: `StorageError.persistenceFailed` on SwiftData write failure.
    func save(_ entry: ScanHistoryEntity) async throws

    /// Fetches all scan history entries, sorted newest first.
    ///
    /// - Returns: An array of `ScanHistoryEntity` values.
    func fetchAll() async throws -> [ScanHistoryEntity]

    /// Fetches scan history entries from within the last `days` calendar days.
    ///
    /// - Parameter days: Number of days to look back.
    /// - Returns: Filtered, sorted `ScanHistoryEntity` array.
    func fetchRecent(days: Int) async throws -> [ScanHistoryEntity]

    /// Permanently deletes all scan history from persistent storage.
    func deleteAll() async throws
}
