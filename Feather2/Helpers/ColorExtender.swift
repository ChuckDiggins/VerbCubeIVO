//
//  ColorExtender.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/9/22.
//

import SwiftUI

struct CC {
    let name: String
    let color: Color

    static var colors: [CC] { [
        CC(name: "lightText", color: .lightText),
        CC(name: "darkText", color: .darkText),
        CC(name: "placeholderText", color: .placeholderText),
        CC(name: "label", color: .label),
        CC(name: "secondaryLabel", color: .secondaryLabel),
        CC(name: "tertiaryLabel", color: .tertiaryLabel),
        CC(name: "quaternaryLabel", color: .quaternaryLabel),
        CC(name: "systemBackground", color: .systemBackground),
        CC(name: "secondarySystemBackground", color: .secondarySystemBackground),
        CC(name: "tertiarySystemBackground", color: .tertiarySystemBackground),
        CC(name: "systemFill", color: .systemFill),
        CC(name: "secondarySystemFill", color: .secondarySystemFill),
        CC(name: "tertiarySystemFill", color: .tertiarySystemFill),
        CC(name: "quaternarySystemFill", color: .quaternarySystemFill),
        CC(name: "systemGroupedBackground", color: .systemGroupedBackground),
        CC(name: "secondarySystemGroupedBackground", color: .secondarySystemGroupedBackground),
        CC(name: "tertiarySystemGroupedBackground", color: .tertiarySystemGroupedBackground),
        CC(name: "systemGray", color: .systemGray),
        CC(name: "systemGray2", color: .systemGray2),
        CC(name: "systemGray3", color: .systemGray3),
        CC(name: "systemGray4", color: .systemGray4),
        CC(name: "systemGray5", color: .systemGray5),
        CC(name: "systemGray6", color: .systemGray6),
        CC(name: "separator", color: .separator),
        CC(name: "opaqueSeparator", color: .opaqueSeparator),
        CC(name: "link", color: .link),
        CC(name: "systemRed", color: .systemRed),
        CC(name: "systemBlue", color: .systemBlue),
        CC(name: "systemPink", color: .systemPink),
        CC(name: "systemTeal", color: .systemTeal),
        CC(name: "systemGreen", color: .systemGreen),
        CC(name: "systemIndigo", color: .systemIndigo),
        CC(name: "systemOrange", color: .systemOrange),
        CC(name: "systemPurple", color: .systemPurple),
        CC(name: "systemYellow", color: .systemYellow)]
    }
}

extension Color {
     
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)

}
