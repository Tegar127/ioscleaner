import Foundation
import Observation

/// ViewModel for the Scan History screen.
@MainActor
@Observable
public final class ScanHistoryViewModel {

    // MARK: - Observable State

    private(set) var groupedHistory: [String: [ScanHistoryEntity]] = [:]
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil

    var sortedMonthKeys: [String] { groupedHistory.keys.sorted(by: >) }

    // MARK: - Private

    private let scanHistoryRepository: ScanHistoryRepositoryProtocol
    private let saveScanHistoryUseCase: SaveScanHistoryUseCaseProtocol

    // MARK: - Init

    public init(
        scanHistoryRepository: ScanHistoryRepositoryProtocol,
        saveScanHistoryUseCase: SaveScanHistoryUseCaseProtocol
    ) {
        self.scanHistoryRepository = scanHistoryRepository
        self.saveScanHistoryUseCase = saveScanHistoryUseCase
    }

    // MARK: - Actions

    func loadHistory() {
        Task { await fetchHistory() }
    }

    func clearAllHistory() {
        Task { await deleteAll() }
    }

    // MARK: - Private

    private func fetchHistory() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let entries = try await scanHistoryRepository.fetchAll()
            groupedHistory = Dictionary(grouping: entries) { $0.monthYearKey }
        } catch {
            errorMessage = error.localizedDescription
            AppLogger.ui.error("History load failed: \(error)")
        }
    }

    private func deleteAll() async {
        do {
            try await scanHistoryRepository.deleteAll()
            groupedHistory = [:]
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
