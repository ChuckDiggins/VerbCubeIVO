//
//  TeachMeThisVerb.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/6/22.
//

import SwiftUI

import JumpLinguaHelpers

struct TeachMeThisVerb: View {
    @ObservedObject var languageViewModel: LanguageViewModel

    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
                VStack{
                    Text("Teach me this verb")
                        .font(.title2)
                        .foregroundColor(.white)
                    TenseButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                    PersonTypeButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                    Text("Select an exercise:")
                        .font(.title3)
                        .foregroundColor(Color("BethanyGreenText"))
                    
                    //                NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                    //                    Text("Analyze User Verb")
                    //                }.modifier(NavLinkModifier())
                    HStack{
                        VStack{
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: "comprar", french: "acheter", english: "buy"), residualPhrase: "", teachMeMode: .model))
                            {
                            Image("SimpleVerbConjugation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(.white)
                            }
                            Text("Simple Verb Conjugation").font(.caption)
                        }
                        VStack{
                            NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                                Image("VerbMorphing")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 200)
                                    .border(.white)
                            }
                            Text("Verb Morphing").font(.caption)
                        }
                    }
                }.background(Color("BethanyNavalBackground"))
            .padding()
            .foregroundColor(Color("BethanyGreenText"))
            Spacer()
        }
    }
    
    func setCurrentVerb(){
        
    }
}


