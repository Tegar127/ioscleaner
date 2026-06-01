import Photos
import Contacts
import Foundation

/// Manages system permission requests for SmartCleanerAI.
///
/// Provides a centralized, async-friendly interface for requesting and
/// checking authorization status for Photos and Contacts access.
///
/// Usage:
/// ```swift
/// let granted = await PermissionsManager.shared.requestPhotosAccess()
/// let status  = PermissionsManager.shared.photosAuthorizationStatus
/// ```
@MainActor
public final class PermissionsManager: ObservableObject {

    // MARK: - Shared Instance

    public static let shared = PermissionsManager()

    // MARK: - Published State

    @Published private(set) var photosAuthorizationStatus: PHAuthorizationStatus = .notDetermined
    @Published private(set) var contactsAuthorizationStatus: CNAuthorizationStatus = .notDetermined

    // MARK: - Init

    private init() { refreshStatuses() }

    // MARK: - Photos Access

    /// Requests full Photos library access from the user.
    ///
    /// - Returns: `true` if access is granted (`.authorized` or `.limited`).
    func requestPhotosAccess() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        photosAuthorizationStatus = status
        AppLogger.permissions.info("Photos authorization: \(status.rawValue)")
        return status == .authorized || status == .limited
    }

    /// Returns `true` if Photos access is currently authorized or limited.
    var isPhotosAccessGranted: Bool {
        photosAuthorizationStatus == .authorized || photosAuthorizationStatus == .limited
    }

    // MARK: - Contacts Access

    /// Requests Contacts access from the user.
    ///
    /// - Returns: `true` if access was granted.
    func requestContactsAccess() async -> Bool {
        do {
            let granted = try await CNContactStore().requestAccess(for: .contacts)
            contactsAuthorizationStatus = granted ? .authorized : .denied
            AppLogger.permissions.info("Contacts authorization: \(granted)")
            return granted
        } catch {
            AppLogger.permissions.error("Contacts access error: \(error.localizedDescription)")
            contactsAuthorizationStatus = .denied
            return false
        }
    }

    /// Returns `true` if Contacts access is currently authorized.
    var isContactsAccessGranted: Bool {
        contactsAuthorizationStatus == .authorized
    }

    // MARK: - Private

    private func refreshStatuses() {
        photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        contactsAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    }
}
