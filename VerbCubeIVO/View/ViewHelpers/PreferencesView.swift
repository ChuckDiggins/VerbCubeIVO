//
//  PreferencesView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import SwiftUI

enum SubjectPronounType : String {
    case maleFormal = "male formal"
    case femaleFormal = "female formal"
    case maleInformal = "male informal"
    case femaleInformal = "female informal"
}

struct PreferencesView: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @State var verbCount = 6
    @State var preferredVerbType = PreferredVerbType.All
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SubjectButtons(selected: languageViewModel.getSubjectPronounType())){
                    Text("Subject Type: \(languageViewModel.getSubjectPronounType().rawValue)")
                }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.green.opacity(0.5))
                .foregroundColor(.yellow)
                .cornerRadius(10)

                VStack(spacing: 25) {
                    Image(systemName: "globe")
                        .font(.largeTitle)
                    Text("Preferences")
                        .font(.title)
                    Text("Introduction")
                        .foregroundColor(.gray)
                    Text("Insert que/qui before subjunctive")
                    Text("Use present progressive for English present tense")
                }
                .font(.caption)
                .padding(.top, 25)
                .foregroundColor(.black)
                .background(.yellow)
                Spacer()
            }
            // This creates a title in your nav bar
            .navigationBarTitle(Text("Program preferences"))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct SubjectButtons : View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @State var selected : SubjectPronounType
    
    let sptList = [SubjectPronounType.maleFormal, .maleInformal, .femaleFormal, .femaleInformal]
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    HStack{
                        Text("Preferred subject pronouns: ")
                        Text("\(selected.rawValue)")
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(sptList, id: \.self){ spt in
                    Button(action: {
                        selected = spt
                        languageViewModel.setSubjectPronounType(spt: spt)
                    }) {
                        Text("\(spt.rawValue))")
                            .font(.title)
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 12, height: 12)
                            if self.selected == spt {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.yellow)
        .cornerRadius(30)
    }
}
//    Button(action: {
//        currentTense = languageViewModel.getLanguageEngine().getNextTense()
//        currentTenseString = currentTense.rawValue
//        setCurrentVerb()
//    }){
//        Text("Next tense")
//    }

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


struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
