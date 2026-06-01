import SwiftUI

/// Animated donut chart displaying device storage usage.
///
/// Shows the used fraction of total device storage with a gradient arc,
/// animated in on first appearance with an ease-out draw effect.
///
/// Usage:
/// ```swift
/// StorageRingChart(
///     usedBytes: summary.totalMediaSizeBytes,
///     totalBytes: 128_000_000_000,
///     size: 200
/// )
/// ```
struct StorageRingChart: View {

    // MARK: - Properties

    let usedBytes: Int64
    let totalBytes: Int64
    var size: CGFloat = 200

    @State private var animationProgress: Double = 0

    private var usedFraction: Double {
        guard totalBytes > 0 else { return 0 }
        return min(1.0, Double(usedBytes) / Double(totalBytes))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundRing
            foregroundRing
            centerLabel
        }
        .frame(width: size, height: size)
        .onAppear { animateIn() }
    }

    // MARK: - Private Views

    private var backgroundRing: some View {
        Circle()
            .stroke(AppColors.card, lineWidth: 20)
    }

    private var foregroundRing: some View {
        Circle()
            .trim(from: 0, to: usedFraction * animationProgress)
            .stroke(
                AppColors.accentGradient,
                style: StrokeStyle(lineWidth: 20, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
    }

    private var centerLabel: some View {
        VStack(spacing: UIConstants.Spacing.extraSmall) {
            Text("\(Int(usedFraction * 100))%")
                .font(AppTypography.displaySemibold)
                .foregroundStyle(AppColors.textPrimary)
            Text("storage.used.label".localized)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    // MARK: - Animation

    private func animateIn() {
        withAnimation(.easeOut(duration: UIConstants.Animation.slow)) {
            animationProgress = 1.0
        }
    }
}
