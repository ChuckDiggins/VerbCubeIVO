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
            VStack{
                Text("Teach Me A Pattern Verb").font(.title2).foregroundColor(.white)
                VStack{
                    Text("Step 1: Pick a tense").font(.title2)
                    
                    Text("To change the tense, click Tense button.")
                    Button(action: {
                        currentTenseString = languageViewModel.getNextTense().rawValue
                    }){
                        HStack{
                            Text("Tense: \(currentTenseString)")
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                        }
                        .modifier(ModelTensePersonButtonModifier())
                    }
                }   .frame(maxWidth: .infinity)
                    .padding(2)
                
                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Step 2: Pick a verb pattern").font(.title2)
                    Text("To change the pattern, click Button.")
                    NavigationLink(destination: ListPatternsView(languageViewModel: languageViewModel)){
                        HStack{
                            Text("Current pattern: \(currentPatternString)")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                        }.modifier(ModelTensePersonButtonModifier())
                    }.task {
                        currentPatternString = languageViewModel.getCurrentPattern().rawValue
                        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(2)
                
                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Step 3: Pick a verb").font(.title2)
                    Text("To change the verb, click Button.")
                    Button(action: {
                        languageViewModel.setNextFilteredVerb()
                        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
                    }){
                        HStack{
                            Text("Verb: ")
                            Text(currentVerbString)
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                        }.modifier(ModelTensePersonButtonModifier())
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(2)
                
                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Step 4: Pick a practice verb type ").font(.title2)
                    Text("Select dictionary verb or X-verb")
                    
                    VStack{
                        NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: currentVerbString, french: currentVerbString, english: currentVerbString), residualPhrase: "", teachMeMode: .regular))
                        {
                        HStack{
                            Text("Model verb = \(currentVerbString)")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                        }
                        }.modifier(ModelTensePersonButtonModifier())
                        NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: currentVerbString, french: currentVerbString, english: currentVerbString), residualPhrase: "", teachMeMode: .regular))
                        {
                        HStack{
                            Text("X-verb = \(currentVerbString)")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                        }
                        }.modifier(ModelTensePersonButtonModifier())
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .padding(2)
            }
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            Spacer()
        }
    }
}

