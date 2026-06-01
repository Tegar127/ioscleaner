import Foundation
import StoreKit
import Observation

/// Manages and caches the user's premium subscription status.
///
/// Observes StoreKit 2 transaction updates to keep premium state current.
/// All feature gates must consult `PremiumStatusManager.shared.isPremium`.
///
/// Usage:
/// ```swift
/// if premiumStatusManager.isPremium { showPremiumFeature() }
/// ```
@MainActor
@Observable
public final class PremiumStatusManager {

    // MARK: - Shared Instance

    public static let shared = PremiumStatusManager()

    // MARK: - Observable State

    private(set) var isPremium: Bool = false
    private(set) var isLoading: Bool = false

    // MARK: - Private Properties

    private let storeKitService: StoreKitServiceProtocol
    private var transactionListenerTask: Task<Void, Error>?

    // MARK: - Init

    init(storeKitService: StoreKitServiceProtocol = StoreKitService()) {
        self.storeKitService = storeKitService
    }

    // MARK: - Lifecycle

    /// Starts listening for StoreKit 2 transaction updates.
    ///
    /// Call once at app launch from `SmartCleanerAIApp.body`.
    func startObservingTransactions() {
        transactionListenerTask = Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await refreshStatus()
                }
            }
        }
    }

    /// Refreshes the premium status by querying current entitlements.
    func refreshStatus() async {
        isLoading = true
        isPremium = await storeKitService.isPremium
        isLoading = false
        AppLogger.infrastructure.info("Premium status: \(isPremium)")
    }

    deinit { transactionListenerTask?.cancel() }
}
