import Foundation

/// Custom error types for all SmartCleanerAI domain operations.
///
/// Conforms to `LocalizedError` to provide user-friendly messages.
/// All repositories and use cases throw `StorageError` variants.
///
/// Usage:
/// ```swift
/// throw StorageError.permissionDenied
/// } catch StorageError.deletionFailed(let reason) {
///     showAlert("storage.error.deletionFailed".localizedFormat(reason))
/// }
/// ```
public enum StorageError: LocalizedError {

    // MARK: - Permission Errors
    case permissionDenied
    case permissionLimited

    // MARK: - Scan / Fetch Errors
    case scanFailed(reason: String)
    case assetFetchFailed
    case assetNotFound

    // MARK: - Deletion Errors
    case deletionFailed(reason: String)
    case deletionPartialFailure(succeeded: Int, failed: Int)

    // MARK: - Contacts Errors
    case mergeFailed(reason: String)

    // MARK: - Persistence Errors
    case persistenceFailed(reason: String)

    // MARK: - AI Engine Errors
    case featureExtractionFailed
    case modelLoadFailed

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "storage.error.permissionDenied".localized
        case .permissionLimited:
            return "storage.error.permissionLimited".localized
        case .scanFailed(let reason):
            return "storage.error.scanFailed".localizedFormat(reason)
        case .assetFetchFailed:
            return "storage.error.assetFetchFailed".localized
        case .assetNotFound:
            return "storage.error.assetNotFound".localized
        case .deletionFailed(let reason):
            return "storage.error.deletionFailed".localizedFormat(reason)
        case .deletionPartialFailure(let ok, let fail):
            return "storage.error.partialFailure".localizedFormat(ok, fail)
        case .mergeFailed(let reason):
            return "storage.error.mergeFailed".localizedFormat(reason)
        case .persistenceFailed(let reason):
            return "storage.error.persistenceFailed".localizedFormat(reason)
        case .featureExtractionFailed:
            return "storage.error.featureExtractionFailed".localized
        case .modelLoadFailed:
            return "storage.error.modelLoadFailed".localized
        }
    }
}
