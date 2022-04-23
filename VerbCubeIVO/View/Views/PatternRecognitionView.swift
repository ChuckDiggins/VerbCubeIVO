//
//  PatternRecognitionView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/23/22.
//

import SwiftUI
import JumpLinguaHelpers

struct PatternRecognitionView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PatternRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        PatternRecognitionView(languageViewModel: LanguageViewModel(language: .Agnostic))
    }
}
