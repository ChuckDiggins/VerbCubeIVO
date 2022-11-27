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
    @Environment(\.presentationMode) var presentationMode
    @State var model: RomanceVerbModel
    @State var verbList = [Verb]()
    @State var show10Verbs = false
    @State var maxVerbCount = 10
    @State var showEnglish = false
    @State var currentLanguage = LanguageType.Spanish
    
    var fontSize = Font.callout
    @State private var patternList = [SpecialPatternStruct]()
    @State private var patternLabelStringList = [String]()
    @State private var patternTenseStringList = [String]()
    @State private var patternTypeStringList = [String]()
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Color("BethanyNavalBackground")
            //                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(20)
                    })
                    Spacer()
                }
                VStack(spacing: 20){
                    let gridFixSize = CGFloat(200.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     //                                 GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]
                    
                    Text("Model: \(model.modelVerb)").font(.title)
                    VStack(spacing: 5) {
                        if patternTenseStringList.count > 0 {
                            Text("Pattern information:")
                            ForEach( 0..<patternTenseStringList.count, id: \.self){i in
                                HStack{
                                    Text(patternTenseStringList[i])
                                    Text(patternTypeStringList[i])
                                    Text(patternLabelStringList[i])
                                }
                            }
                        }
                    }.background(.yellow)
                        .foregroundColor(.black)
                        .border(.black)
                    Divider().frame(height:2).background(.yellow)
                    
                    HStack{
                        Button{
                            showEnglish.toggle()
                            currentLanguage = showEnglish ? .English : .Spanish
                        } label: {
                            Text(showEnglish ? "Spanish" : "English")
                        }
                        .frame(width: 150, height: 30)
                        .font(.callout)
                        .padding(2)
                        .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .foregroundColor(.black)
                        .cornerRadius(4)
                   
                }
                    LazyVGrid(columns: gridItems, spacing: 5){
                        Section{
                            ForEach(verbList, id: \.self){ verb in
                                Button{
                                    analyzeThisVerb(verb: verb)
                                } label: {
                                    Text(verb.getWordAtLanguage(language: currentLanguage))
                                        .frame(width: 160, height: 30)
                                        .cornerRadius(3)
                                }
                                
                            }
                        } header:{
                            Text("Current verb list").font(.title2)
                        }
                    footer:{
                        Text("\nThese will be your exercise verbs.").font(.callout).bold()
                    }
                        
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .padding(20)
                    .background(Color("BethanyNavalBackground"))
                    .foregroundColor(Color("BethanyGreenText"))
                    .font(fontSize)
                    
                    
                }
                .onAppear{
                    if languageViewModel.getSelectedVerbModelList().count > 0 {
                        model = languageViewModel.getSelectedVerbModelList()[0]
                    }
                    shuffleVerbList()
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
            if sps.pattern.isOrthoChangingSpanish(){ patternLabelStringList.append("(Spell)") }
            if sps.pattern.isIrregularPreteriteSpanish(){ patternLabelStringList.append("(Spell)") }
            else if sps.pattern.isStemChangingPresentSpanish(){ patternLabelStringList.append("(Stem)")}
            else if sps.pattern.isStemChangingPreteriteSpanish(){ patternLabelStringList.append("(Stem)")}
            else {patternLabelStringList.append("")}
            
            patternTenseStringList.append(sps.tense.rawValue)
            patternTypeStringList.append(sps.pattern.rawValue)
        }
    }
    
    func shuffleVerbList(){
        loadVerbList()
        verbList.shuffle()
        var modelVerb = Verb()
        for verb in verbList {
            if verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()) == model.modelVerb {
                modelVerb = verb
            }
        }
        let verbCount = verbList.count

        if verbCount >= maxVerbCount {
            verbList.removeLast(verbCount-maxVerbCount)
        }
        
        //ensure that the model verb is always in the list
        
        var modelVerbFound = false
        for verb in verbList {
            if verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()) == model.modelVerb {
                modelVerbFound = true
                break
            }
        }
        if !modelVerbFound { verbList[0] = modelVerb }
    }
    
    func loadVerbList(){
        verbList = languageViewModel.getFilteredVerbs()
    }
    
    func getVerbStringAtIndex(_ index: Int)->String{
        verbList[index].getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
    }
    
}
