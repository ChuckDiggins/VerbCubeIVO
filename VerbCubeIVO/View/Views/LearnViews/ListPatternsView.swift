//
//  ListPatternsView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/13/22.
//

import SwiftUI
import JumpLinguaHelpers


struct ListPatternsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var currentLanguage = LanguageType.Spanish
    @State var patternStructList = [ModelPatternStruct]()
    @State var patternList = [SpecialPatternType]()
    @State private var selectedPattern = SpecialPatternType(rawValue: "")
    @State private var selectedPatternIndex = 0
    
    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Pattern List").font(.title2).foregroundColor(Color("ChuckText1"))

                ScrollView{
                    let gridFixSize = CGFloat(200.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]

                    LazyVGrid(columns: gridItems, spacing: 5){
                        ForEach (0..<patternStructList.count, id: \.self){ i in
                           if patternStructList[i].count > 0 {
                                Button{
                                    selectedPatternIndex = i
                                    selectThisPattern()
                                } label: {
                                    HStack{
                                        Text(patternStructList[i].name)
                                        Text(": \(patternStructList[i].count)").foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                        .foregroundColor(Color("BethanyGreenText"))
                        .cornerRadius(8)
                        .font(fontSize)
                    }

                }.onAppear{
                    loadVerbPatterns()
                    currentLanguage = languageViewModel.getCurrentLanguage()
                }
            }
        }
    }

    func selectThisPattern(){
//        var patternList = SpecialPatternType.stemChangingCommonSpanish
        var patternList = SpecialPatternType.stemChangingPresentSpanish
        languageViewModel.setCurrentPattern(pattern: patternList[selectedPatternIndex])
        let verbList = languageViewModel.getVerbsForPatternGroup(patternType: patternList[selectedPatternIndex])
        languageViewModel.setFilteredVerbList(verbList: verbList)
        languageViewModel.initializeStudentScoreModel()
        dismiss()
    }
    

    func loadVerbPatterns(){
        patternList.removeAll()
//        var patternList = SpecialPatternType.stemChangingCommonSpanish
        var patternList = SpecialPatternType.stemChangingPresentSpanish
        
        for pattern in patternList {
            print("\npattern: \(pattern)")
            let verbList = languageViewModel.getVerbsForPatternGroup(patternType: pattern)
            for verb in verbList{
                print("verb = \(verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))")
            }
            patternStructList.append(ModelPatternStruct(id: 0, name: pattern.rawValue, count: verbList.count))
        }
    }
}
