import Foundation

/// Represents estimated device storage usage data for the Storage Advisor.
///
/// - Important: iOS restricts third-party access to other apps' storage.
///   All values are **estimates** derived from shared data caches and
///   system-reported storage APIs. This must be clearly disclosed in-app.
///
/// Usage:
/// ```swift
/// let summary = StorageAdvisorEntity(
///     totalDeviceBytes: 128_000_000_000,
///     usedBytes: 95_000_000_000,
///     appEstimates: [...]
/// )
/// ```
public struct StorageAdvisorEntity: Identifiable, Sendable {

    public let id: UUID
    public let fetchDate: Date
    public let totalDeviceBytes: Int64
    public let usedBytes: Int64
    public let appEstimates: [AppStorageEstimate]

    // MARK: - Computed

    public var freeBytes: Int64 { totalDeviceBytes - usedBytes }

    public var usedFraction: Double {
        guard totalDeviceBytes > 0 else { return 0 }
        return Double(usedBytes) / Double(totalDeviceBytes)
    }

    public var formattedUsed: String  { AppFormatter.byteCount.string(fromByteCount: usedBytes) }
    public var formattedFree: String  { AppFormatter.byteCount.string(fromByteCount: freeBytes) }
    public var formattedTotal: String { AppFormatter.byteCount.string(fromByteCount: totalDeviceBytes) }

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        fetchDate: Date = .now,
        totalDeviceBytes: Int64,
        usedBytes: Int64,
        appEstimates: [AppStorageEstimate] = []
    ) {
        self.id = id
        self.fetchDate = fetchDate
        self.totalDeviceBytes = totalDeviceBytes
        self.usedBytes = usedBytes
        self.appEstimates = appEstimates
    }
}

// MARK: - AppStorageEstimate

/// Estimated storage for a single app category (e.g., "Social Media").
public struct AppStorageEstimate: Identifiable, Sendable {
    public let id: UUID
    public let categoryName: String
    public let estimatedBytes: Int64
    public let systemIcon: String

    public var formattedSize: String {
        AppFormatter.byteCount.string(fromByteCount: estimatedBytes)
    }

    public init(categoryName: String, estimatedBytes: Int64, systemIcon: String) {
        self.id = UUID()
        self.categoryName = categoryName
        self.estimatedBytes = estimatedBytes
        self.systemIcon = systemIcon
    }
}
