import SwiftUI

/// Base protocol for navigation coordinators in SmartCleanerAI.
///
/// Coordinators decouple navigation logic from SwiftUI views,
/// enabling testable and reusable routing throughout the app.
///
/// Usage:
/// ```swift
/// @Environment(AppCoordinator.self) var coordinator
/// coordinator.navigate(to: .history)
/// coordinator.presentModal(.premium)
/// ```
@MainActor
public protocol CoordinatorProtocol: AnyObject, Observable {

    /// The currently selected tab in the root tab bar.
    var selectedTab: AppTab { get set }

    /// The currently presented modal destination, if any.
    var presentedModal: ModalDestination? { get set }

    /// Navigates to a given tab.
    func navigate(to tab: AppTab)

    /// Presents a modal sheet over the current content.
    func presentModal(_ destination: ModalDestination)

    /// Dismisses the currently presented modal.
    func dismissModal()
}

// MARK: - AppTab

/// Represents each tab in the root tab bar.
public enum AppTab: Int, CaseIterable, Identifiable {
    case dashboard = 0
    case cleaner
    case aiRecommendations
    case history
    case settings

    public var id: Int { rawValue }

    var title: String {
        switch self {
        case .dashboard:         return "tab.dashboard".localized
        case .cleaner:           return "tab.cleaner".localized
        case .aiRecommendations: return "tab.ai".localized
        case .history:           return "tab.history".localized
        case .settings:          return "tab.settings".localized
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard:         return "gauge.with.dots.needle.33percent"
        case .cleaner:           return "sparkles"
        case .aiRecommendations: return "brain"
        case .history:           return "clock.arrow.circlepath"
        case .settings:          return "gearshape"
        }
    }
}

// MARK: - ModalDestination

/// Represents available modal presentation destinations.
public enum ModalDestination: Identifiable {
    case premium
    case permissionRequest
    case scanDetail(id: String)

    public var id: String {
        switch self {
        case .premium:              return "premium"
        case .permissionRequest:    return "permissionRequest"
        case .scanDetail(let id):   return "scanDetail_\(id)"
        }
    }
}
