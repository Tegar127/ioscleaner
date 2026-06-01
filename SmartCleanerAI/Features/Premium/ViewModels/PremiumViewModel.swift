import StoreKit
import Foundation
import Observation

/// ViewModel for the Premium Paywall screen.
@MainActor
@Observable
public final class PremiumViewModel {

    // MARK: - Observable State

    private(set) var products: [Product] = []
    private(set) var isLoadingProducts: Bool = false
    private(set) var isPurchasing: Bool = false
    private(set) var errorMessage: String? = nil
    var selectedProductID: String? = nil

    // MARK: - Private

    private let storeKitService: StoreKitServiceProtocol

    // MARK: - Init

    public init(storeKitService: StoreKitServiceProtocol) {
        self.storeKitService = storeKitService
    }

    // MARK: - Lifecycle

    func onAppear() {
        Task { await loadProducts() }
    }

    // MARK: - Actions

    func purchaseSelected() {
        guard let id = selectedProductID,
              let product = products.first(where: { $0.id == id }) else { return }
        Task { await purchase(product) }
    }

    func restorePurchases() {
        Task { await restore() }
    }

    // MARK: - Private

    private func loadProducts() async {
        isLoadingProducts = true
        defer { isLoadingProducts = false }
        do {
            products = try await storeKitService.fetchProducts()
            selectedProductID = products.first?.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func purchase(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            let success = try await storeKitService.purchase(product)
            if success { await PremiumStatusManager.shared.refreshStatus() }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func restore() async {
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            let _ = try await storeKitService.restorePurchases()
            await PremiumStatusManager.shared.refreshStatus()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
