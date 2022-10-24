//
//  TeachMeAPatternVerb.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/13/22.
//

import SwiftUI

import JumpLinguaHelpers

struct TeachMeAPatternVerb: View {
    @ObservedObject var languageViewModel: LanguageViewModel

    @State var currentTenseString = "Present"
    @State var currentPatternString = "xxx"
    @State var currentVerbString = "xxx"
    @State var currentXVerbString = "xxxeguirse"
    
    var instructionFont = Font.caption
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            ScrollView{
//                DisclosureGroupTeachMeAPatternVerb()
//                VStack{
//                    Text("Step 1: Pick a tense").font(.title2)
//
//                    Text("To change the tense, click Tense button.")
//                    Button(action: {
//                        currentTenseString = languageViewModel.getNextTense().rawValue
//                    }){
//                        HStack{
//                            Text("Tense: \(currentTenseString)")
//                            Spacer()
//                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
//                        }
//                        .modifier(ModelTensePersonButtonModifier())
//                    }
//                }   .frame(maxWidth: .infinity)
//                    .padding(2)
//
//                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Step 1: Pick a verb pattern").font(.title2)
                    Text("To change the pattern, click Button.")
//                    NavigationLink(destination: ListPatternsView(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Current pattern: \(currentPatternString)")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }.modifier(ModelTensePersonButtonModifier())
//                    }.task {
//                        currentPatternString = languageViewModel.getCurrentPattern().rawValue
//                        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//                    }
                }
                .frame(maxWidth: .infinity)
                .padding(2)
                
                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Step 2: Pick a verb").font(.title2)
                    Text("To change the verb, click Button.")
                    Button(action: {
                        languageViewModel.setNextFilteredVerb()
                        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
                    }){
                        HStack{
                            Text("Verb: ")
                            if languageViewModel.getCurrentPattern() == .none {
                                Text("")
                            }
                            else {
                                Text(currentVerbString)
                            }
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                        }.modifier(ModelTensePersonButtonModifier())
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(2)
                
                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Conjugate your verb").font(.title2)
                    
                    VStack{
                        NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: currentVerbString, french: currentVerbString, english: currentVerbString), residualPhrase: "", teachMeMode: .pattern))
                        {
                        HStack{
                            Text("Model verb = \(currentVerbString)")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                        }
                        }.modifier(ModelTensePersonButtonModifier())
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .padding(2)
            }.onAppear{    
                let verbList = languageViewModel.getVerbsForPatternGroup(patternType:languageViewModel.getCurrentPattern())
                languageViewModel.setFilteredVerbList(verbList: verbList)
                currentPatternString = languageViewModel.getCurrentPattern().rawValue
                currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
            }
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            Spacer()
        }
    }
}

