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
            .foregroundColor(Color("BethanyGreenText"))
            .padding(.horizontal)
            .font(.headline)
            .background(Color("BethanyNavalBackground"))
            .cornerRadius(10)
    }
}

struct SquareButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(minWidth: 150, maxWidth: 150)
            .foregroundColor(Color("BethanyGreenText"))
            .font(.headline)
            .background(Color("BethanyNavalBackground"))
            .cornerRadius(10)
    }
}



struct HeaderModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(minWidth: 0, maxWidth: 350)
            .foregroundColor(.white)
            .padding(.horizontal)
            .font(.headline)
            .background(.blue)
            .cornerRadius(10)
    }
}

struct YellowButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(height: 35)
            .frame(minWidth: 0, maxWidth: 300)
            .foregroundColor(.black)
            .padding(.horizontal, 30)
            .font(.caption)
            .background(Color.yellow)
            .cornerRadius(10)
    }
}

struct ClearButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(height: 35)
            .frame(minWidth: 0, maxWidth: 300)
            .padding(.horizontal, 30)
            .font(.caption)
            .cornerRadius(10)
            .border(.red)
    }
}

struct SquareBlueButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(width: 150, height: 150)
            .font(.callout)
            .background ( .blue )
            .foregroundColor ( .white )
            .cornerRadius(25)
    }
}



struct ImageModifier : ViewModifier {
    var text: String
    var image: Image
    
    func body(content: Content) -> some View{
        content
        ZStack{
            Text(text)
            image
        }
        .frame(width: 300, height: 300)
        .background ( .blue )
        .foregroundColor ( .white )
    }
}

struct OtherBlueButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(width: 300, height: 45)
            .background ( .blue )
            .foregroundColor ( .white )
            .clipShape(Capsule())
    }
}

struct BlueButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(height: 55)
            .frame(minWidth: 0, maxWidth: 300)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .font(.caption)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct RedButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(height: 55)
            .frame(minWidth: 0, maxWidth: 300)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .font(.headline)
            .background(Color.red)
            .cornerRadius(10)
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
            .frame(width: 300, height: 30)
                .font(.callout)
                .padding(.horizontal)
                .background(Color("BethanyPurpleButtons"))
                .foregroundColor(.white)
                .cornerRadius(5)
    }
}

struct DragAndDropButtonModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .frame(width: 210, height: 40)
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
                .padding(.vertical, 2)
                .background(Color("BethanyNavalBackground"))
                .foregroundColor(Color("ChuckText1"))
                .font(.title3)
    }
}



