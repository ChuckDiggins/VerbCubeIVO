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

struct ExitButtonViewWithSpeechIcon : View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    var setSpeechModeActive: () -> Void
    @State var speechModeActive = false
    var body: some View {
        HStack{
            Button(action: {
                router.reset()
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
                    .font(.title2)
                    .padding(20)
            })
            Spacer()
            Image(systemName: "speaker.wave.3.fill")
                .foregroundColor(speechModeActive ? Color("BethanyGreenText") : .red)
                .font(speechModeActive ? .title3 : .callout)
                .onTapGesture{
                    speechModeActive.toggle()
                    setSpeechModeActive()
                }
        }
    }
}


struct ExitButtonView : View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    @AppStorage("modelWalkThrough") var modelWalkThroughPage = 3

    var body: some View {
        HStack{
            Button(action: {
                router.reset()
                if modelWalkThroughPage < 5 {
                    modelWalkThroughPage += 1
                }
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
                    .font(.title2)
                    .padding(20)
            })
            Spacer()
        }
    }
}

struct JustExit  {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    
    func exit(){
        router.reset()
        dismiss()
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
                case .femaleInformal:
                    languageViewModel.setSubjectPronounType(spt: .maleInformal)
                    currentSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                case .maleInformal:
                    languageViewModel.setSubjectPronounType(spt: .maleFormal)
                    currentSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                case .maleFormal:
                    languageViewModel.setSubjectPronounType(spt: .femaleFormal)
                    currentSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                case .femaleFormal:
                    languageViewModel.setSubjectPronounType(spt: .femaleInformal)
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

