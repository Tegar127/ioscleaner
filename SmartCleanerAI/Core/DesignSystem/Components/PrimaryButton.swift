import SwiftUI

/// A primary action button following SmartCleanerAI's design system.
///
/// Supports three visual styles, a loading spinner state, and a
/// scale-down press animation for tactile feedback.
///
/// Usage:
/// ```swift
/// PrimaryButton(title: "Start Scan", isLoading: viewModel.isScanning) {
///     viewModel.startScan()
/// }
/// PrimaryButton(title: "Delete", style: .destructive) { delete() }
/// ```
struct PrimaryButton: View {

    // MARK: - Properties

    let title: String
    var isLoading: Bool = false
    var style: ButtonStyle = .gradient
    let action: () -> Void

    // MARK: - Button Style Enum

    enum ButtonStyle { case gradient, outline, destructive }

    // MARK: - Body

    var body: some View {
        Button(action: action) { buttonContent }
            .disabled(isLoading)
            .buttonStyle(ScaleButtonStyle())
    }

    // MARK: - Private Views

    private var buttonContent: some View {
        ZStack {
            buttonBackground
            buttonLabel
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.button))
    }

    @ViewBuilder
    private var buttonBackground: some View {
        switch style {
        case .gradient:    AppColors.accentGradient
        case .outline:
            Color.clear.overlay(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.button)
                    .stroke(AppColors.accent, lineWidth: 1.5)
            )
        case .destructive: AppColors.error.opacity(0.18)
        }
    }

    private var buttonLabel: some View {
        Group {
            if isLoading {
                ProgressView().tint(.white)
            } else {
                Text(title)
                    .font(AppTypography.bodyMedium)
                    .foregroundStyle(labelColor)
            }
        }
    }

    private var labelColor: Color {
        switch style {
        case .gradient:    return .white
        case .outline:     return AppColors.accent
        case .destructive: return AppColors.error
        }
    }
}

// MARK: - Scale Button Style

private struct ScaleButtonStyle: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(
                .easeInOut(duration: UIConstants.Animation.fast),
                value: configuration.isPressed
            )
    }
}
