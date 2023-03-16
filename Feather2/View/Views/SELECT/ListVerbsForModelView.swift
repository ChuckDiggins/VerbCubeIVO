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
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @State var verbModel = RomanceVerbModel()
    @State var showSelectButton = false
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    @State var verbList = [Verb]()
    @State var show10Verbs = false
    @State var maxVerbCount = 16
    @State var showEnglish = false
    @State var currentLanguage = LanguageType.Spanish
    @State var selectedCount = 0
    @State var modelName = "No name"
    @AppStorage("VerbOrModelMode") var verbOrModelMode = "Verbs"
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 1A"
    @AppStorage("V2MLesson") var currentV2mLesson = "Useful verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "ser"
    
    
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
                        
                        if languageViewModel.isModelMode() {
                            Text("Model: \(currentVerbModelString)").font(.title2)
                        }
                        else {
                            VStack{
                                Text("Chapter: \(currentV2mChapter)")
                                Text("Lesson: \(currentV2mLesson)")
                            }.font(.title2)
                        }

                        Divider().frame(height:2).background(.yellow)
                    
                        if showSelectButton {
                            HStack{
                                Button{
//                                    languageViewModel.selectThisVerbModel(verbModel: verbModel)
                                    languageViewModel.setVerbModelTo(verbModel)
                                    router.reset()
                                    dismiss()
                                } label: {
                                    Text("¿Install: \(verbModel.modelVerb)?")
//                                    if verbModel.id > 0 {
//                                        Text("¿Install: \(verbModel.modelVerb)?")
//                                    }else{
//                                        Text("¿Install: \(languageViewModel.getTemporaryVerbModel().modelVerb)?")
//                                    }
                                }.tint(.purple)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.roundedRectangle(radius:5))
                                .controlSize(.regular)
                                .foregroundColor(.yellow)
                            }
                            HStack{
                                Text("Verb list for")
                                if verbModel.id > 0 {
                                    Text("\(verbModel.modelVerb)")
                                }else{
                                    Text("\(languageViewModel.getTemporaryVerbModel().modelVerb)")
                                }
                            }.font(.title)
                        } else {
                                Text("Verb List")
                        }
                        
                        
                                                    
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
                    if languageViewModel.isModelMode() {
                        if showSelectButton{
                            verbModel = languageViewModel.getTemporaryVerbModel()
                            verbList = languageViewModel.findVerbsOfSameModel(targetID: verbModel.id)
                            truncateAndShuffleVerbList()
                        } else {
                            verbModel = languageViewModel.getCurrentVerbModel()
                            verbList = languageViewModel.getFilteredVerbs()
                        }
                    } else {
                        verbList = languageViewModel.getStudyPackage().preferredVerbList
                    }
                    
//                    analyzeModel()
                }
                
            }
            Spacer()
        }
    }
    
    func analyzeModel(){
        patternList = languageViewModel.getPatternsForThisModel(verbModel: verbModel)
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
        if languageViewModel.isModelMode() {
            verbList = languageViewModel.findVerbsOfSameModel(targetID: verbModel.id)
            verbList = languageViewModel.getFilteredVerbs()
        } else {
            var sp = languageViewModel.getStudyPackage()
            verbList = sp.preferredVerbList
        }
        
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
