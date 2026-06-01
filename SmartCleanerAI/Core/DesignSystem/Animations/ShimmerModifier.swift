import SwiftUI

/// A SwiftUI view modifier that applies a shimmering skeleton-loading animation.
///
/// Renders a sweeping gradient highlight over the view to simulate content loading.
///
/// Usage:
/// ```swift
/// RoundedRectangle(cornerRadius: 8)
///     .fill(AppColors.card)
///     .frame(height: 20)
///     .shimmer(isActive: isLoading)
/// ```
struct ShimmerModifier: ViewModifier {

    // MARK: - Properties

    let isActive: Bool
    @State private var phase: CGFloat = -1.0

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay { if isActive { shimmerOverlay } }
            .onAppear { if isActive { startAnimation() } }
    }

    // MARK: - Private Views

    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [.clear, .white.opacity(0.12), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width * 3)
            .offset(x: phase * geometry.size.width)
        }
        .clipped()
    }

    // MARK: - Animation

    private func startAnimation() {
        withAnimation(
            .linear(duration: UIConstants.Animation.shimmer)
            .repeatForever(autoreverses: false)
        ) {
            phase = 1.5
        }
    }
}

// MARK: - View Extension

extension View {
    /// Applies the shimmer loading animation to this view.
    ///
    /// - Parameter isActive: Pass `true` to activate the shimmer effect.
    func shimmer(isActive: Bool) -> some View {
        modifier(ShimmerModifier(isActive: isActive))
    }
}
