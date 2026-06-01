import Foundation

/// `String` extensions providing localization helpers and formatting utilities.
///
/// Usage:
/// ```swift
/// let text = "dashboard.title".localized
/// let msg  = "storage.error.scanFailed".localizedFormat("timeout")
/// let size = String.formattedFileSize(bytes: 4_200_000_000) // "4.2 GB"
/// ```
extension String {

    // MARK: - Localization

    /// Returns the localized string for this key from the main bundle.
    var localized: String {
        NSLocalizedString(self, bundle: .main, comment: "")
    }

    /// Returns a formatted localized string using this key as the format.
    ///
    /// - Parameter args: Values to substitute into the localized format string.
    /// - Returns: A localized and formatted string.
    func localizedFormat(_ args: CVarArg...) -> String {
        String(format: localized, arguments: args)
    }

    // MARK: - Validation

    /// Returns `true` if the string is non-empty after whitespace trimming.
    var isNotEmpty: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - File Size Display

    /// Converts a byte count into a human-readable file size string.
    ///
    /// - Parameter bytes: The byte count to format.
    /// - Returns: A localized file size string (e.g., "4.2 GB").
    static func formattedFileSize(bytes: Int64) -> String {
        AppFormatter.byteCount.string(fromByteCount: bytes)
    }
}
