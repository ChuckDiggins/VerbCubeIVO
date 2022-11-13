//
//  SwiftUIView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/6/22.
//

import SwiftUI
import JumpLinguaHelpers

struct TeachMeModelBasedVerbConjugation: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
     var windowsForegroundColor = Color.black

    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                Text("Teach me a verb model")
                    .font(.title2)
                    .foregroundColor(.white)
                ListVerbModelsView(languageViewModel: languageViewModel)
                TenseButtonView(languageViewModel: languageViewModel, function: dummy)
                PersonTypeButtonView(languageViewModel: languageViewModel, function: dummy)
                    
                Text("Select an exercise:")
                    .font(.title3)
                    .padding()
                VStack{
                    HStack{
                        VStack{
                            NavigationLink(destination: MultiVerbMorphView(languageViewModel: languageViewModel)){
                                Image("MultipleVerbMorphing")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 200)
                                    .border(.white)
                            }
                            Text("Multi-Verb Morphing")
                        }
                        VStack{
                            NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                                Image("VerbMorphing")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 200)
                                    .border(.white)
                            }
                            Text("Verb Morphing")
                        }
                        VStack{
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentVerb(), residualPhrase: "", teachMeMode: .model))
                            {
                            Image("SimpleVerbConjugation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(.white)
                            }
                            Text("Simple Conjugation")
                        }
                    }
                    HStack{
                        VStack{
                            NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                                Image("VerbCubeHorz")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 100)
                                    .border(.white)
                            }
                            Text("Verb Cube")
                            Text("(Show horizontal)").bold()
                        }
                        VStack{
                            NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel))
                            {
                            Image("RightAndWrong")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(.white)
                            }
                            Text("Right and Wrong")
                        }
                        
                    }
                }.font(.caption)
            }.background(.yellow.opacity(0.1))
            .padding()
            .foregroundColor(Color("BethanyGreenText"))
        }
//        .background(Color("BethanyNavalBackground"))
        
        Spacer()
        
    }
    func dummy(){
        
    }
}

