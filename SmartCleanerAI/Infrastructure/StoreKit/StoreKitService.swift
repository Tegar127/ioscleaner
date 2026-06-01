import StoreKit
import Foundation

// MARK: - Protocol

/// Contract for StoreKit 2 subscription management.
public protocol StoreKitServiceProtocol: Sendable {
    func fetchProducts() async throws -> [Product]
    func purchase(_ product: Product) async throws -> Bool
    func restorePurchases() async throws -> Bool
    var isPremium: Bool { get async }
}

// MARK: - Product IDs

private enum ProductID {
    static let premiumYearly  = "com.smartcleanerai.premium.yearly"
    static let premiumMonthly = "com.smartcleanerai.premium.monthly"
    static let allIDs         = [premiumYearly, premiumMonthly]
}

// MARK: - Implementation

/// StoreKit 2 subscription manager for SmartCleanerAI Premium.
///
/// Manages product fetching, purchase, restore, and entitlement verification.
/// All operations use StoreKit 2's modern async/await API.
public final class StoreKitService: StoreKitServiceProtocol {

    public init() {}

    // MARK: - StoreKitServiceProtocol

    public var isPremium: Bool {
        get async { await checkEntitlement() }
    }

    public func fetchProducts() async throws -> [Product] {
        let products = try await Product.products(for: ProductID.allIDs)
        AppLogger.infrastructure.info("Fetched \(products.count) StoreKit products")
        return products
    }

    public func purchase(_ product: Product) async throws -> Bool {
        AppLogger.infrastructure.info("Initiating purchase: \(product.id)")
        let result = try await product.purchase()
        switch result {
        case .success(let verification): return handleVerification(verification)
        case .userCancelled:
            AppLogger.infrastructure.info("Purchase cancelled by user")
            return false
        case .pending:
            AppLogger.infrastructure.info("Purchase is pending approval")
            return false
        @unknown default: return false
        }
    }

    public func restorePurchases() async throws -> Bool {
        AppLogger.infrastructure.info("Restoring purchases via AppStore.sync()")
        try await AppStore.sync()
        return await checkEntitlement()
    }

    // MARK: - Private Helpers

    private func handleVerification(_ result: VerificationResult<Transaction>) -> Bool {
        switch result {
        case .verified(let transaction):
            Task { await transaction.finish() }
            AppLogger.infrastructure.info("Purchase verified: \(transaction.productID)")
            return true
        case .unverified:
            AppLogger.infrastructure.warning("Transaction verification failed")
            return false
        }
    }

    private func checkEntitlement() async -> Bool {
        for await entitlement in Transaction.currentEntitlements {
            if case .verified(let tx) = entitlement,
               ProductID.allIDs.contains(tx.productID) {
                return true
            }
        }
        return false
    }
}
