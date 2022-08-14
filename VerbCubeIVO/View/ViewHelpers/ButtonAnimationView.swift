//
//  ButtonAnimationView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/12/22.
//

import SwiftUI

struct ThemeAnimationStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.green : Color.black)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) //<- change scale value as per need. scaleEffect(configuration.isPressed ? 1.2 : 1.0)
    }
}
