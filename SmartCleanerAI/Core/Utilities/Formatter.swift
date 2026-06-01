import Foundation

/// Centralized formatter singletons for SmartCleanerAI.
///
/// Reuses formatter instances to avoid repeated allocation overhead.
/// All text formatting in the app should go through this namespace.
///
/// Usage:
/// ```swift
/// AppFormatter.byteCount.string(fromByteCount: 4_200_000_000) // "4.2 GB"
/// AppFormatter.shortDate.string(from: Date())                 // "May 1, 2025"
/// ```
public enum AppFormatter {

    // MARK: - Byte Count

    /// Formats byte counts into human-readable strings (e.g., "4.2 GB").
    static let byteCount: ByteCountFormatter = {
        let f = ByteCountFormatter()
        f.allowedUnits = [.useGB, .useMB, .useKB]
        f.countStyle = .file
        return f
    }()

    // MARK: - Date Formatters

    /// Short date style: "May 1, 2025".
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    /// Month and year: "May 2025".
    static let monthYear: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f
    }()

    // MARK: - Number Formatters

    /// Decimal number with up to 1 fraction digit (e.g., "4.2").
    static let decimal: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 0
        return f
    }()

    /// Percentage with no decimal places (e.g., "72%").
    static let percentage: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .percent
        f.maximumFractionDigits = 0
        return f
    }()
}
