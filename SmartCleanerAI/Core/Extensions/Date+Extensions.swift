import Foundation

/// `Date` extensions providing formatting and comparison utilities for SmartCleanerAI.
///
/// Usage:
/// ```swift
/// let label = Date().relativeLabel          // "2 days ago"
/// let isOld = someDate.isOlderThan(days: 30)
/// let monthLabel = someDate.monthYearLabel  // "May 2025"
/// ```
extension Date {

    // MARK: - Relative Formatting

    /// Returns a human-readable relative label (e.g., "2 days ago", "Just now").
    var relativeLabel: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: .now)
    }

    /// Returns a short formatted date string (e.g., "May 1, 2025").
    var shortDateLabel: String {
        AppFormatter.shortDate.string(from: self)
    }

    /// Returns a month-and-year label (e.g., "May 2025").
    var monthYearLabel: String {
        AppFormatter.monthYear.string(from: self)
    }

    // MARK: - Comparison

    /// Returns `true` if this date is older than `days` days ago.
    ///
    /// - Parameter days: The number of days threshold.
    func isOlderThan(days: Int) -> Bool {
        guard let threshold = Calendar.current.date(
            byAdding: .day, value: -days, to: .now
        ) else { return false }
        return self < threshold
    }

    /// Returns `true` if this date falls within the current calendar month.
    var isThisMonth: Bool {
        Calendar.current.isDate(self, equalTo: .now, toGranularity: .month)
    }

    /// Returns the number of whole days elapsed since this date (non-negative).
    var daysSinceNow: Int {
        max(0, Calendar.current.dateComponents([.day], from: self, to: .now).day ?? 0)
    }
}
