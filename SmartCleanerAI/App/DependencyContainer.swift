import Foundation
import SwiftData

/// Central dependency injection container for SmartCleanerAI.
///
/// Creates and wires all data sources, repositories, services, use cases,
/// and view models. Single source of truth for all dependency injection.
///
/// Usage:
/// ```swift
/// let container = try DependencyContainer()
/// let dashboardVM = container.makeDashboardViewModel()
/// ```
@MainActor
public final class DependencyContainer {

    // MARK: - SwiftData

    private let modelContainer: ModelContainer
    private var modelContext: ModelContext { modelContainer.mainContext }

    // MARK: - Data Sources (lazy, single instance)

    private lazy var photoKitDataSource  = PhotoKitDataSource()
    private lazy var contactsDataSource  = ContactsDataSource()

    // MARK: - AI Engine (lazy, single instance)

    private lazy var featureExtractor    = ImageFeatureExtractor()
    private lazy var blurEngine: BlurDetectionEngineProtocol         = BlurDetectionEngine()
    private lazy var similarityEngine: PhotoSimilarityEngineProtocol = PhotoSimilarityEngine(featureExtractor: featureExtractor)
    private lazy var recommendationEngine: RecommendationEngineProtocol = RecommendationEngine()
    private lazy var predictionEngine: UsagePredictionEngineProtocol    = UsagePredictionEngine()

    // MARK: - Repositories (lazy, single instance)

    private lazy var photoRepository: PhotoRepositoryProtocol       = PhotoRepository(dataSource: photoKitDataSource)
    private lazy var videoRepository: VideoRepositoryProtocol       = VideoRepository(dataSource: photoKitDataSource)
    private lazy var contactRepository: ContactRepositoryProtocol   = ContactRepository(dataSource: contactsDataSource)
    private lazy var scanHistoryRepository: ScanHistoryRepositoryProtocol     = ScanHistoryRepository(modelContext: modelContext)
    private lazy var recommendationRepository: RecommendationRepositoryProtocol = RecommendationRepository(modelContext: modelContext)

    // MARK: - Services (exposed for app-level configuration)

    private(set) lazy var deletionService = DeletionService(
        photoRepository: photoRepository,
        videoRepository: videoRepository,
        contactRepository: contactRepository
    )

    private(set) lazy var storageScannerService = StorageScannerService(
        photoRepository: photoRepository,
        videoRepository: videoRepository,
        contactRepository: contactRepository
    )

    // MARK: - Init

    public init() throws {
        self.modelContainer = try SwiftDataContainer.makeContainer()
    }

    // MARK: - Use Case Factories (private)

    func makeAnalyzeStorageUseCase() -> AnalyzeStorageUseCaseProtocol {
        AnalyzeStorageUseCase(
            photoRepository: photoRepository,
            videoRepository: videoRepository,
            contactRepository: contactRepository
        )
    }

    func makeGenerateRecommendationUseCase() -> GenerateRecommendationUseCaseProtocol {
        GenerateRecommendationUseCase(
            recommendationRepository: recommendationRepository,
            recommendationEngine: recommendationEngine,
            photoRepository: photoRepository,
            videoRepository: videoRepository
        )
    }

    // MARK: - ViewModel Factories (public)

    public func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(aggregatorUseCase: DashboardAggregatorUseCase(
            analyzeStorageUseCase: makeAnalyzeStorageUseCase(),
            generateRecommendationUseCase: makeGenerateRecommendationUseCase(),
            scanHistoryRepository: scanHistoryRepository
        ))
    }

    public func makeScanHistoryViewModel() -> ScanHistoryViewModel {
        ScanHistoryViewModel(
            scanHistoryRepository: scanHistoryRepository,
            saveScanHistoryUseCase: SaveScanHistoryUseCase(
                scanHistoryRepository: scanHistoryRepository
            )
        )
    }

    public func makeAIRecommendationsViewModel() -> AIRecommendationsViewModel {
        AIRecommendationsViewModel(
            generateRecommendationUseCase: makeGenerateRecommendationUseCase()
        )
    }

    public func makePremiumViewModel() -> PremiumViewModel {
        PremiumViewModel(storeKitService: StoreKitService())
    }
}
