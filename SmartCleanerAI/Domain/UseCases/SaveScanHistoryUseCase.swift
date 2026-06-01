import Foundation

// MARK: - ScanSessionResult Input Model

/// Input model representing the results of a completed scan/cleanup session.
public struct ScanSessionResult: Sendable {
    public let completedAt: Date
    public let totalSpaceSavedBytes: Int64
    public let totalItemsDeleted: Int
    public let durationSeconds: Double
    public let breakdown: ScanBreakdown

    public init(
        completedAt: Date = .now,
        totalSpaceSavedBytes: Int64,
        totalItemsDeleted: Int,
        durationSeconds: Double,
        breakdown: ScanBreakdown = ScanBreakdown()
    ) {
        self.completedAt = completedAt
        self.totalSpaceSavedBytes = totalSpaceSavedBytes
        self.totalItemsDeleted = totalItemsDeleted
        self.durationSeconds = durationSeconds
        self.breakdown = breakdown
    }
}

// MARK: - Use Case Protocol

/// Converts a `ScanSessionResult` into a `ScanHistoryEntity` and persists it.
///
/// Called at the end of each user-initiated cleanup action.
///
/// Usage:
/// ```swift
/// let entry = try await saveScanHistoryUseCase.execute(with: sessionResult)
/// ```
public protocol SaveScanHistoryUseCaseProtocol: Sendable {
    func execute(with result: ScanSessionResult) async throws -> ScanHistoryEntity
}

// MARK: - Implementation

public final class SaveScanHistoryUseCase: SaveScanHistoryUseCaseProtocol {

    private let scanHistoryRepository: ScanHistoryRepositoryProtocol

    public init(scanHistoryRepository: ScanHistoryRepositoryProtocol) {
        self.scanHistoryRepository = scanHistoryRepository
    }

    public func execute(with result: ScanSessionResult) async throws -> ScanHistoryEntity {
        let entry = ScanHistoryEntity(
            scanDate: result.completedAt,
            spaceSavedBytes: result.totalSpaceSavedBytes,
            itemsDeleted: result.totalItemsDeleted,
            scanDurationSeconds: result.durationSeconds,
            breakdown: result.breakdown
        )
        try await scanHistoryRepository.save(entry)
        AppLogger.domain.info("Saved scan history: \(entry.formattedSpaceSaved) freed")
        return entry
    }
}
