import Foundation

// MARK: - Use Case Protocol

/// Aggregates all Dashboard data into a single `DashboardSummary`.
///
/// Executes storage analysis, recommendation generation, and scan history
/// concurrently, preventing a fat ViewModel by encapsulating all orchestration.
///
/// Usage:
/// ```swift
/// let summary = try await dashboardAggregatorUseCase.execute()
/// ```
public protocol DashboardAggregatorUseCaseProtocol: Sendable {
    func execute() async throws -> DashboardSummary
}

// MARK: - Implementation

public final class DashboardAggregatorUseCase: DashboardAggregatorUseCaseProtocol {

    // MARK: - Dependencies

    private let analyzeStorageUseCase: AnalyzeStorageUseCaseProtocol
    private let generateRecommendationUseCase: GenerateRecommendationUseCaseProtocol
    private let scanHistoryRepository: ScanHistoryRepositoryProtocol

    // MARK: - Init

    public init(
        analyzeStorageUseCase: AnalyzeStorageUseCaseProtocol,
        generateRecommendationUseCase: GenerateRecommendationUseCaseProtocol,
        scanHistoryRepository: ScanHistoryRepositoryProtocol
    ) {
        self.analyzeStorageUseCase = analyzeStorageUseCase
        self.generateRecommendationUseCase = generateRecommendationUseCase
        self.scanHistoryRepository = scanHistoryRepository
    }

    // MARK: - Execute

    public func execute() async throws -> DashboardSummary {
        AppLogger.domain.info("Aggregating dashboard data")

        async let analysis         = analyzeStorageUseCase.execute()
        async let recommendations  = generateRecommendationUseCase.execute()
        async let recentHistory    = scanHistoryRepository.fetchRecent(days: 30)

        let (analysisResult, recs, history) = try await (analysis, recommendations, recentHistory)

        return DashboardSummary(
            photoCount: analysisResult.photoCount,
            videoCount: analysisResult.videoCount,
            contactCount: analysisResult.contactCount,
            totalPhotoSizeBytes: analysisResult.totalPhotoSizeBytes,
            totalVideoSizeBytes: analysisResult.totalVideoSizeBytes,
            estimatedReclaimableBytes: recs.reduce(0) { $0 + $1.estimatedSpaceSavedBytes },
            topRecommendations: Array(recs.prefix(3)),
            lastScanDate: history.first?.scanDate,
            totalSpaceSavedHistoricBytes: history.reduce(0) { $0 + $1.spaceSavedBytes }
        )
    }
}

// MARK: - DashboardSummary Model

/// Aggregated data model powering the Dashboard screen.
///
/// Produced exclusively by `DashboardAggregatorUseCase`.
public struct DashboardSummary: Sendable {
    public let photoCount: Int
    public let videoCount: Int
    public let contactCount: Int
    public let totalPhotoSizeBytes: Int64
    public let totalVideoSizeBytes: Int64
    public let estimatedReclaimableBytes: Int64
    public let topRecommendations: [RecommendationEntity]
    public let lastScanDate: Date?
    public let totalSpaceSavedHistoricBytes: Int64

    public var totalMediaSizeBytes: Int64 { totalPhotoSizeBytes + totalVideoSizeBytes }

    public var formattedReclaimable: String {
        AppFormatter.byteCount.string(fromByteCount: estimatedReclaimableBytes)
    }

    public var formattedTotalSaved: String {
        AppFormatter.byteCount.string(fromByteCount: totalSpaceSavedHistoricBytes)
    }

    public init(
        photoCount: Int, videoCount: Int, contactCount: Int,
        totalPhotoSizeBytes: Int64, totalVideoSizeBytes: Int64,
        estimatedReclaimableBytes: Int64, topRecommendations: [RecommendationEntity],
        lastScanDate: Date?, totalSpaceSavedHistoricBytes: Int64
    ) {
        self.photoCount = photoCount; self.videoCount = videoCount
        self.contactCount = contactCount
        self.totalPhotoSizeBytes = totalPhotoSizeBytes
        self.totalVideoSizeBytes = totalVideoSizeBytes
        self.estimatedReclaimableBytes = estimatedReclaimableBytes
        self.topRecommendations = topRecommendations
        self.lastScanDate = lastScanDate
        self.totalSpaceSavedHistoricBytes = totalSpaceSavedHistoricBytes
    }
}
