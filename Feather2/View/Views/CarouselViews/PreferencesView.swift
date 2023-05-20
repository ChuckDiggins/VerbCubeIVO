//
//  PreferencesView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import SwiftUI
import JumpLinguaHelpers

struct PreferencesView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currenSubjectPronounType = SubjectPronounType.all
    @State var currenSubjectPronounTypeString = "whatever"
    @State var speechModeActiveString = "Speech mode is ACTIVE"
    @State var tenseList = [Tense]()
    @State var modelCompleted = false
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 3A"
    @AppStorage("V2MLesson") var currentV2mLesson = "AR, ER, IR verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("Explanation Page") var explanationPage = 7
    @AppStorage("Selection Lesson Page") var selectionLessonPage = 7
    @AppStorage("Selection Model Page") var selectionModelPage = 8
    @AppStorage("Explore Page") var explorePage = 8
    @AppStorage("Learn Page") var learnPage = 7
    @AppStorage("Test Page") var testPage = 6
    
    var body: some View {
        
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                Text("Click to set Subject Type:")
                PersonTypeButtonView(languageViewModel: languageViewModel, function: dummy)
                Button{
                    print("on exit: \(verbOrModelModeString)")
                    //                        languageViewModel.restoreSelectedVerbs()
                    exit(0)
                } label: {
                    Text("Exit Application")
                }.foregroundColor(.red).border(.red)
//
//                ScrollView {
//                    DisclosureGroupPreferences()
//
//
//                    Button{
//                        languageViewModel.toggleSpeechMode()
//                        setSpeechModeActiveString()
//                        textToSpeech(text: speechModeActiveString, language: .English)
//                    } label: {
//                        HStack{
//                            Text(speechModeActiveString)
//                            Spacer()
//                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
//                        }
//                    }
//                    .modifier(ModelTensePersonButtonModifier())
                    
//                    ListVerbModelsView(languageViewModel: languageViewModel)
                    
//                    ChangeLanguageView(languageViewModel: languageViewModel)
                    
//                    VStack{
//                        Text("Testing buttons")
                        
//                        Button{
//                            languageViewModel.clearAllVerbCountsInCoreData()
//                            print(languageViewModel.getModelVerbCountAt(9))
//                        } label: {
//                            Text("Clear all CoreData verb counts")
//                        }.modifier(ModelTensePersonButtonModifier())
//
//                        Button{
//                            languageViewModel.setAllVerbCountsInCoreData()
//                        } label: {
//                            Text("Set all CoreData verb counts")
//                        }.modifier(ModelTensePersonButtonModifier())
//
//                        Button{
//                            languageViewModel.getAllVerbCountsFromCoreData()
//                        } label: {
//                            Text("Get all CoreData verb counts")
//                        }.modifier(ModelTensePersonButtonModifier())
//
//
//                        Button{
//                            languageViewModel.setSelectedVerbModelsComplete()
//                            languageViewModel.selectNextOrderedVerbModel()
//                            modelCompleted.toggle()
//                        } label: {
//                            Text("Set all selected verb models to completed")
//                        }.modifier(ModelTensePersonButtonModifier())
//
//                        Button{
//                            languageViewModel.setAllLessonsAndModelsEmpty()
//                            exit(0)
//                        } label: {
//                            Text("Set all lessons and models empty")
//                        }.modifier(ModelTensePersonButtonModifier())
                
//                          Button{
                //                        languageViewModel.setAllVerbModelsIncomplete()
                //                    } label: {
                //                        Text("Set all verb models incomplete")
                //                    }.modifier(ModelTensePersonButtonModifier())
                        
//                    }
//
//                }
//                .alert("", isPresented: $modelCompleted){
//                    //no action
//                } message: {
//                    Text("Current verb model: \(languageViewModel.getCurrentVerbModel().modelVerb)")
//                }
//                .padding(25)
//                .border(.red)
//                Spacer()
            }.onAppear{
                currenSubjectPronounType = languageViewModel.getSubjectPronounType()
                currenSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                setSpeechModeActiveString()
            }
        }.foregroundColor(Color("BethanyGreenText"))
    }
    func setSpeechModeActiveString(){
        if languageViewModel.isSpeechModeActive() {
            speechModeActiveString = "Speech mode is ACTIVE"
        }
        else{
            speechModeActiveString = "Speech mode is OFF"
        }
    }
    func dummy(){
        
    }
}

struct VerbTypeStruct : Hashable {
    let id = 0
    var label: String
    var selected : Bool
    
    init(label: String, selected: Bool){
        self.selected = selected
        self.label = label
    }
    
    func getLabel()->String{
        return label
    }
}

struct ToggleButtonsView : View {
    @State private var preferredVerbType = PreferredVerbType.All
    @State private var verbTypeStructList = [VerbTypeStruct]()
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 10){
            Text("Filter by").padding(.top).foregroundColor(.yellow)
            ForEach($verbTypeStructList, id:\.self) {$vts in
                Toggle(isOn: $vts.selected){
                    Text(vts.label)
                        .padding(2)
                }.background(Color.yellow)
                    .foregroundColor(.black)
            }
        }.onAppear{
            verbTypeStructList.removeAll()
            for vt in PreferredVerbType.allCases {
                verbTypeStructList.append(VerbTypeStruct(label: vt.rawValue, selected: false))
            }
            
        }.padding(.vertical)
            .padding(.horizontal, 25)
        Spacer()
    }
}

enum PreferredVerbType : String, CaseIterable {
    case All, AR, ER, IR, OIR, Reflexive, StemChanging, Ortho, Irregular, Phrases, Other
}


//struct PreferencesView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreferencesView()
//    }
//}