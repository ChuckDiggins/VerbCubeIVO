//
//  WordCellButton.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/20/22.
//

import SwiftUI

struct WordCellButton: View {
    var wordText : String
    var backgroundColor = Color.green
    var foregroundColor =  Color.black
    var fontSize = Font.callout
    @State var isActive : Bool
    
    var body: some View {
        Button(wordText){
            isActive.toggle()
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(isActive ? .green : .red)
        .foregroundColor(isActive ? .black : .yellow)
        .cornerRadius(8)
        .font(fontSize)
    }
}

struct MatchCellButton: View {
    var index : Int
    var wordText : String
    var matchID : Int
    var backgroundColor = Color.green
    var foregroundColor =  Color.black
    var fontSize = Font.callout
    var disabled = false
    var function: (_ index: Int, _ wordText: String) -> Void
    
    var body: some View {
        Button(wordText){
            function(index, wordText)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(backgroundColor)
        .disabled(disabled)
        .cornerRadius(8)
        .font(fontSize)
    }
}
struct MixCellButton: View {
    var index : Int
    var wordText : String
    var matchText : String
    var matchID : Int
    var backgroundColor = Color.green
    var foregroundColor =  Color.black
    var fontSize = Font.callout
    var disabled = false
    var function: (_ index: Int, _ matchText: String) -> Void
    
    var body: some View {
        Button(wordText){
            function(index, matchText)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(backgroundColor)
        .disabled(disabled)
        .cornerRadius(8)
        .font(fontSize)
    }
}



