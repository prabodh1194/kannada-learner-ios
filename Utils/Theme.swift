import SwiftUI

extension Color {
    static let neonGreen = Color(red: 0, green: 1, blue: 0.53)
    static let neonPink = Color(red: 1, green: 0, blue: 0.5)
    static let neonBlue = Color(red: 0, green: 0.8, blue: 1)
    static let darkBackground = Color(red: 0.04, green: 0.04, blue: 0.04)
    static let darkSurface = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.69, green: 0.69, blue: 0.69)
}

struct NeonTheme {
    static func apply() {
        // This would typically be used to apply theme-wide settings
        // For now, we'll just define the colors for use in our views
    }
}