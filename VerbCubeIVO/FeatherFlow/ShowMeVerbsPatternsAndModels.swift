//
//  ShowMeVerbsPatternsAndModels.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/7/22.
//

import SwiftUI

struct ShowMeVerbsPatternsAndModels: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                VStack{
                    Text("Verbs, Patterns and Models").font(.title2)
                        .foregroundColor(Color("ChuckText1"))
                    Text("Select an exercise:")
                        .font(.title2)
                    HStack{
                        VStack{
                            NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern))
                            {
                            Image("VPM_ModelsForPattern")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find models with this pattern")
                            }
                        }
                        VStack{
                            NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsBelongingToModel))
                            {
                            Image("VPM_VerbsInModel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find verbs in a model")
                            }
                        }
                        VStack{
                            NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelForGivenVerb))
                            {
                            Image("VPM_ModelForGivenVerb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find model for this verb")
                            }
                        }
                    }
                    HStack{
                        VStack{
                            NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveSameModelAsVerb))
                            {
                            Image("VPM_VerbsForSameModel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find verbs for verb's model")
                            }
                        }
                        VStack{
                            NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveGivenPattern))
                            {
                            Image("VPM_VerbsWithSamePattern")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find verbs with this pattern")
                            }
                        }
                        VStack{
                            NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsWithSamePatternAsVerb))
                            {
                            Image("VPM_VerbsForPattern")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find verbs with same pattern")
                            }
                        }
                        
                    }
                }.font(.caption)
            }
                .padding()
                .foregroundColor(Color("BethanyGreenText"))
        }
    }
}


