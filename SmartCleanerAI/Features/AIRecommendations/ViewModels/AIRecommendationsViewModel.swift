import Foundation
import Observation

/// ViewModel for the AI Recommendations screen.
@MainActor
@Observable
public final class AIRecommendationsViewModel {

    private(set) var recommendations: [RecommendationEntity] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil

    var totalReclaimable: String {
        let total = recommendations.reduce(Int64(0)) { $0 + $1.estimatedSpaceSavedBytes }
        return AppFormatter.byteCount.string(fromByteCount: total)
    }

    private let generateRecommendationUseCase: GenerateRecommendationUseCaseProtocol
    private var loadTask: Task<Void, Never>?

    public init(generateRecommendationUseCase: GenerateRecommendationUseCaseProtocol) {
        self.generateRecommendationUseCase = generateRecommendationUseCase
    }

    func load() {
        loadTask?.cancel()
        loadTask = Task { await fetchRecommendations() }
    }

    func refresh() {
        loadTask?.cancel()
        loadTask = Task { await fetchRecommendations() }
    }

    private func fetchRecommendations() async {
        isLoading = true
        defer { isLoading = false }
        do {
            recommendations = try await generateRecommendationUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
            AppLogger.ui.error("Recommendations load failed: \(error)")
        }
    }
}
