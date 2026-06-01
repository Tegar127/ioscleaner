import Foundation
import Observation

/// ViewModel for the Dashboard screen.
///
/// Delegates all data orchestration to `DashboardAggregatorUseCase`,
/// keeping this ViewModel lean (state management only, no business logic).
///
/// Usage:
/// ```swift
/// @State private var viewModel = DashboardViewModel(aggregatorUseCase: ...)
/// ```
@MainActor
@Observable
public final class DashboardViewModel {

    // MARK: - Observable State

    private(set) var summary: DashboardSummary? = nil
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil

    // MARK: - Private Properties

    private let aggregatorUseCase: DashboardAggregatorUseCaseProtocol
    private var loadTask: Task<Void, Never>?

    // MARK: - Init

    public init(aggregatorUseCase: DashboardAggregatorUseCaseProtocol) {
        self.aggregatorUseCase = aggregatorUseCase
    }

    // MARK: - Actions

    /// Loads or refreshes the dashboard data, cancelling any in-flight request.
    func loadDashboard() {
        loadTask?.cancel()
        loadTask = Task { await fetchDashboardData() }
    }

    /// Cancels any in-progress loading task.
    func cancelLoading() {
        loadTask?.cancel()
        isLoading = false
    }

    // MARK: - Private

    private func fetchDashboardData() async {
        guard !Task.isCancelled else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            summary = try await aggregatorUseCase.execute()
            AppLogger.ui.info("Dashboard data loaded successfully")
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
            AppLogger.ui.error("Dashboard load failed: \(error)")
        }
    }
}
