//
//  TeachMeCommonControls.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/6/22.
//

import SwiftUI
import JumpLinguaHelpers

struct ListVerbModelsView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentModelString = ""
    var body: some View {
        
        NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
            HStack{
                Text("Current model: \(currentModelString)")
                Spacer()
                Image(systemName: "chevron.right")
            }.modifier(ModelTensePersonButtonModifier())
        }.task {
            currentModelString = (languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo())
        }
    }
}

struct ChangeLanguageView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguageStr = ""
    var body: some View {
        Button{
            switch languageViewModel.getCurrentLanguage() {
            case .Spanish:
                languageViewModel.setLanguage(language: .French)
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
            case .French:
                languageViewModel.setLanguage(language: .English)
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
            case .English:
                languageViewModel.setLanguage(language: .Spanish)
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
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
        }
    }
}
struct TenseButtonView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var function: () -> Void
    @State var currentTenseString = ""
    var body: some View {
        VStack{
            Button(action: {
                currentTenseString = languageViewModel.getNextTense().rawValue
                function()
            }){
                HStack{
                    Text("Tense: \(currentTenseString)")
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }
                .modifier(ModelTensePersonButtonModifier())
            }
        }.onAppear{
            currentTenseString = languageViewModel.getCurrentTense().rawValue
        }
    }
}

struct CurrentPersonButtonView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var function: () -> Void
//    var function: (_ verbFilters: [VerbModelFilter]) -> Void
    @State var currentPersonString = ""
    var body: some View {
        Button(action: {
            currentPersonString = languageViewModel.getNextPerson().getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
            function()
        }){
            Text("Person: \(currentPersonString)")
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
        }
        .onAppear{
            currentPersonString = languageViewModel.getCurrentPerson().getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
        }
        .modifier(ModelTensePersonButtonModifier())
    }
        
}

struct CurrentVerbButtonView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var function: () -> Void
    @State var currentVerbString = ""
    var body: some View {
        Button(action: {
            languageViewModel.setNextFilteredVerb()
            currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
            function()
        }){
            Text("Verb: \(currentVerbString)")
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
        }
        .modifier(ModelTensePersonButtonModifier())
        .onAppear{
            currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        }
    }
}

struct RandomVerbButtonView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var function: () -> Void
    @State var currentVerbString = ""
    var body: some View {
        Button(action: {
            currentVerbString = languageViewModel.getRandomVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
            function()
        }){
            Text("Verb: \(currentVerbString)")
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
        }
        .modifier(ModelTensePersonButtonModifier())
        .onAppear{
            currentVerbString = languageViewModel.getCurrentRandomVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        }
    }
}



struct PersonTypeButtonView : View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var function: () -> Void
    @State var currentSubjectPronounTypeString = ""
    var body: some View {
        VStack{
            Button{
                switch languageViewModel.getSubjectPronounType() {
                case .maleInformal:
                    languageViewModel.setSubjectPronounType(spt: .femaleInformal)
                    currentSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                case .femaleInformal:
                    languageViewModel.setSubjectPronounType(spt: .maleInformal)
                    currentSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                default:
                    languageViewModel.setSubjectPronounType(spt: .maleInformal)
                }
                function()
            } label: {
                HStack{
                    Text("Subject Type: \(currentSubjectPronounTypeString)")
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }
                .modifier(ModelTensePersonButtonModifier())
            }
        }.onAppear{
            currentSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
        }
       
    }
}

