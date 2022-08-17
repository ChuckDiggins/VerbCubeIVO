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
            .frame(minWidth: 0, maxWidth: 350)
            .frame(height: 30)
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

struct ModelTensePersonButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(width: 300, height: 45)
                .font(.callout)
                .padding(.horizontal)
                .background(Color("BethanyPurpleButtons"))
                .foregroundColor(.white)
                .cornerRadius(5)
    }
}

struct DisclosureGroupModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(Color("BethanyNavalBackground"))
                .foregroundColor(Color("ChuckText1"))
                .font(.title2)
    }
}



