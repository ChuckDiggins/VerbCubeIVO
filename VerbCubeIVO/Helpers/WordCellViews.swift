//
//  WordCellViews.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/10/22.
//

import SwiftUI
import JumpLinguaHelpers

struct WordCell: View {
    var wordText : String
    var backgroundColor: Color
    var foregroundColor: Color
    var fontSize : Font
    
    var body: some View {
        Text(wordText)
            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
            .font(fontSize)
        
    }

}

