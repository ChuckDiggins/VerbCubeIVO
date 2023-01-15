//
//  GrowingButton.swift
//  Feather2
//
//  Created by Charles Diggins on 1/14/23.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    var buttonColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(buttonColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
