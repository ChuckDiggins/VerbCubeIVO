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
    
    var body: some View {
        
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Text("Preferences")
                        .font(.title)
                    Image(systemName: "globe")
                        .font(.largeTitle)
                    
                }
                ScrollView {
                    DisclosureGroupPreferences()
                    NavigationLink(destination: TenseSelectionView(languageViewModel: languageViewModel, tenseList: $tenseList)){
                        HStack{
                            Text("Set tenses")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                        }
                    } .modifier(ModelTensePersonButtonModifier())

                    Button{
                        languageViewModel.toggleSpeechMode()
                        setSpeechModeActiveString()
                        textToSpeech(text: speechModeActiveString, language: .English)
                    } label: {
                        HStack{
                            Text(speechModeActiveString)
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                        }
                    }
                    .modifier(ModelTensePersonButtonModifier())
                    
                    ListVerbModelsView(languageViewModel: languageViewModel)
                    PersonTypeButtonView(languageViewModel: languageViewModel, function: dummy)
                    ChangeLanguageView(languageViewModel: languageViewModel)
                    
                    
                    Button{
                        languageViewModel.restoreSelectedVerbs()
                        for vm in languageViewModel.getSelectedVerbModelList(){
                            print("On exit: modelVerb \(vm.modelVerb)")
                        }
                       exit(0)
                    } label: {
                        Text("Exit Application")
                    }.foregroundColor(.red).border(.red)
                       
                    VStack{
                        Text("Testing buttons")
                        
                        Button{
                            languageViewModel.setAllVerbModelsIncomplete()
                        } label: {
                            Text("Set all verb models incomplete")
                        }.modifier(ModelTensePersonButtonModifier())
                        
                        Button{
                            languageViewModel.setSelectedVerbModelsComplete()
                            languageViewModel.selectNextOrderedVerbModel()
                            modelCompleted.toggle()
                        } label: {
                            Text("Set all selected verb models to completed")
                        }.modifier(ModelTensePersonButtonModifier())
                    }
                    .alert("", isPresented: $modelCompleted){
                        //no action
                    } message: {
                        Text("Current verb model: \(languageViewModel.getCurrentVerbModel().modelVerb)")
                    }
                    .padding(25)
                    .border(.red)
                }
                Spacer()
            }.onAppear{
                currenSubjectPronounType = languageViewModel.getSubjectPronounType()
                currenSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                setSpeechModeActiveString()
            }
        }
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
