//
//  ListVerbsForModelView.swift
//  Feather2
//
//  Created by Charles Diggins on 11/5/22.
//

import SwiftUI
import JumpLinguaHelpers

struct ListVerbsForModelView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var model: RomanceVerbModel
    @State var verbList = [Verb]()
    @State var show10Verbs = false
    @State var maxVerbCount = 16
    @State var showEnglish = false
    @State var currentLanguage = LanguageType.Spanish
    
    var fontSize = Font.title3
    @State private var patternList = [SpecialPatternStruct]()
    @State private var patternLabelStringList = [String]()
    @State private var patternTenseStringList = [String]()
    @State private var patternTypeStringList = [String]()
    @State private var selected = false
    @State private var currentVerb = Verb()
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Color("BethanyNavalBackground")
            //                .edgesIgnoringSafeArea(.all)
            VStack{
                ExitButtonView()
                VStack(spacing: 20){
                    let gridFixSize = CGFloat(200.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     //                                 GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]
                    
                    Text(languageViewModel.isModelMode() ? "Model: \(languageViewModel.getStudyPackage().lesson)" : "Lesson: \(languageViewModel.getStudyPackage().lesson)").font(.title)
                    
                    Divider().frame(height:2).background(.yellow)
                    
                    HStack{
                        Button{
                            showEnglish.toggle()
                            currentLanguage = showEnglish ? .English : .Spanish
                        } label: {
                            Text(showEnglish ? "Show Spanish" : "Show English")
                        }
                        .frame(width: 200, height: 30)
                        .font(.callout)
                        .padding(2)
                        .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .foregroundColor(.black)
                        .cornerRadius(4)
                        
                    }
                    Text("Current verb list").font(.title2)
                    LazyVGrid(columns: gridItems) {
                        ForEach(verbList, id: \.self){ verb in
                            Button{
                                currentVerb = verb
                                selected.toggle()
                            } label: {
                                Text(verb.getWordAtLanguage(language: currentLanguage))
                            }
                        }
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .padding(20)
                    .background(Color("BethanyNavalBackground"))
                    .foregroundColor(Color("BethanyGreenText"))
                    .font(fontSize)
                    Spacer()
//                        .fullScreenCover(isPresented: $selected, content: {
//                            SimpleVerbConjugation(languageViewModel: languageViewModel, verb: currentVerb, residualPhrase: "", multipleVerbFlag: false)
//                        })
                    
                }
                .onAppear{
                    //                    model = languageViewModel.getCurrentVerbModel()
                    loadVerbList()
                    analyzeModel()
                }

            }
            Spacer()
        }
    }
    
    func analyzeThisVerb(verb: Verb){
        //
    }
    
    func analyzeModel(){
        patternList = languageViewModel.getPatternsForThisModel(verbModel: model)
        patternTenseStringList.removeAll()
        patternLabelStringList.removeAll()
        patternTypeStringList.removeAll()
        
        print(patternList.count)
        for sps in patternList {
            //            if sps.pattern.isOrthoChangingSpanish(){ patternLabelStringList.append("(Spell)") }
            //            if sps.pattern.isIrregularPreteriteSpanish(){ patternLabelStringList.append("(Spell)") }
            //            else if sps.pattern.isStemChangingPresentSpanish(){
            //                patternLabelStringList.append("(Stem)")
            //            }
            //            else if sps.pattern.isStemChangingPreteriteSpanish(){ patternLabelStringList.append("(Stem)")}
            //            else {
            //                patternLabelStringList.append("None")
            //            }
            
            patternTenseStringList.append(sps.tense.rawValue)
            patternTypeStringList.append(sps.pattern.rawValue)
        }
    }
    
    func truncateAndShuffleVerbList(){
        verbList.shuffle()
        let verbCount = verbList.count
        
        if verbCount >= maxVerbCount {
            verbList.removeLast(verbCount-maxVerbCount)
        }
        verbList.shuffle()
    }
    
    func loadVerbList(){
        verbList = languageViewModel.getFilteredVerbs()
        truncateAndShuffleVerbList()
        print("loadVerbList: verbList count = \(verbList.count)")
        for verb in verbList{
            print(verb.spanish)
        }
    }
    
    func getVerbStringAtIndex(_ index: Int)->String{
        verbList[index].getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
    }
    
}
