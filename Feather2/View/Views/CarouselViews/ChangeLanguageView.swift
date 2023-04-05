//
//  ChangeLanguageView.swift
//  Feather2
//
//  Created by Charles Diggins on 4/4/23.
//

import SwiftUI
import JumpLinguaHelpers

struct ChangeLanguageView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @AppStorage("Language") var languageString = "Spanish"
    
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 3A"
    @AppStorage("V2MLesson") var currentV2mLesson = "AR, ER IR verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    
    @AppStorage("SpanishV2MChapter") var currentSpanishV2mChapter = "Chapter 3A"
    @AppStorage("SpanishV2MLesson") var currentSpanishV2mLesson = "AR, ER IR verbs"
    @AppStorage("SpanishCurrentVerbModel") var currentSpanishVerbModelString = "encontrar"
    
    @AppStorage("FrenchV2MChapter") var currentFrenchV2mChapter = "French 1B"
    @AppStorage("FrenchV2MLesson") var currentFrenchV2mLesson = "1B: Harder verbs, more tenses"
    @AppStorage("FrenchCurrentVerbModel") var currentFrenchVerbModelString = "manger"
    
    @State var currentLanguageStr = ""
    @State var currentLanguage = LanguageType.Spanish
    var body: some View {
        Button{
            switch currentLanguage {
            case .Spanish:  //changing to French
                languageViewModel.setLanguage(language: .French)
                languageString = "French"
                currentV2mChapter = currentFrenchV2mChapter
                currentV2mLesson = currentFrenchV2mLesson
                currentVerbModelString = currentFrenchVerbModelString
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
                languageViewModel.restoreV2MPackage()
            case .French: //changing to Spanish
                languageViewModel.setLanguage(language: .Spanish)
                languageString = "Spanish"
                currentV2mChapter = currentSpanishV2mChapter
                currentV2mLesson = currentSpanishV2mLesson
                currentVerbModelString = currentSpanishVerbModelString
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
                languageViewModel.restoreV2MPackage()
//            case .English:
//                languageViewModel.setLanguage(language: .Spanish)
//                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
            default:
                languageViewModel.setLanguage(language: .Spanish)
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
            }
        } label: {
            HStack{
                Text("Active language: \(currentLanguageStr)")
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
            } .modifier(ModelTensePersonButtonModifier())
        }
        .onAppear{
            currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
            currentLanguage = languageViewModel.getCurrentLanguage()
        }
    }
}

