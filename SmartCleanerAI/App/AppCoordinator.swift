import SwiftUI
import Observation

/// Central navigation coordinator for SmartCleanerAI.
///
/// Manages tab selection and modal presentations, decoupling
/// all navigation logic from individual SwiftUI views.
///
/// Usage:
/// ```swift
/// @Environment(AppCoordinator.self) var coordinator
/// coordinator.navigate(to: .history)
/// coordinator.presentModal(.premium)
/// ```
@MainActor
@Observable
public final class AppCoordinator: CoordinatorProtocol {

    // MARK: - CoordinatorProtocol

    public var selectedTab: AppTab = .dashboard
    public var presentedModal: ModalDestination? = nil

    // MARK: - Dependency

    let container: DependencyContainer

    // MARK: - Init

    public init(container: DependencyContainer) {
        self.container = container
    }

    // MARK: - CoordinatorProtocol Methods

    public func navigate(to tab: AppTab) {
        selectedTab = tab
        AppLogger.ui.info("Navigated to tab: \(tab.title)")
    }

    public func presentModal(_ destination: ModalDestination) {
        presentedModal = destination
        AppLogger.ui.info("Presenting modal: \(destination.id)")
    }

    public func dismissModal() {
        presentedModal = nil
    }
}
