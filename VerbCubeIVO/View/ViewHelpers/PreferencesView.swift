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
    
    var body: some View {

        ZStack{
            Color(.black)
                .ignoresSafeArea()
            
            VStack{
            HStack{
            Text("Preferences")
                .font(.title)
                Image(systemName: "globe")
                    .font(.largeTitle)
                
            }
                VStack(spacing: 25) {
                    
                    NavigationLink(destination: TenseSelectionView(languageViewModel: languageViewModel)){
                        Text("SetTenses")
                    }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)

                    Button{
                        languageViewModel.toggleSpeechMode()
                        setSpeechModeActiveString()
                        textToSpeech(text: speechModeActiveString, language: .English)
                    } label: {
                        Text(speechModeActiveString)
                    }
                    .frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    Button{
                        switch languageViewModel.getSubjectPronounType() {
                        case .maleInformal:
                            languageViewModel.setSubjectPronounType(spt: .femaleInformal)
                            currenSubjectPronounType = languageViewModel.getSubjectPronounType()
                            currenSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                        case .femaleInformal:
                            languageViewModel.setSubjectPronounType(spt: .maleInformal)
                            currenSubjectPronounType = languageViewModel.getSubjectPronounType()
                            currenSubjectPronounTypeString = languageViewModel.getSubjectPronounType().rawValue
                        default:
                            languageViewModel.setSubjectPronounType(spt: .maleInformal)
                        }
                    } label: {
                        Text("Subject Type: \(languageViewModel.getSubjectPronounType().rawValue)")
                            .frame(minWidth: 0, maxWidth: 400)
                            .frame(height: 50)
                            .background(currenSubjectPronounType == .maleInformal ? .blue: .red)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                            .padding(20)
                    }
                    
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
