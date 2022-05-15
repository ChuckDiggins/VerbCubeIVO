//
//  View.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/5/22.
//

import SwiftUI
import Combine

struct TextModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(minWidth: 0, maxWidth: 300)
            .foregroundColor(.white)
            .padding(.horizontal)
            .font(.headline)
            .background(.blue)
            .cornerRadius(10)
    }
}


struct BlueButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(minWidth: 0, maxWidth: 300)
            .padding()
            .foregroundColor(.white)
            .padding(.horizontal)
            .font(.headline)
            .background(Color.blue)
            .border(Color(red: 7/255, green: 42/255, blue: 171/255),
                    width: 5)
    }
}

struct GreenButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(minWidth: 0, maxWidth: 300)
            .padding()
            .foregroundColor(.white)
            .padding(.horizontal)
            .font(.headline)
            .background(Color.blue)
            .border(Color(red: 7/255, green: 42/255, blue: 171/255),
                    width: 5)
    }
}

