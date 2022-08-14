//
//  ShowMeModelQuizzes.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/7/22.
//

import SwiftUI

struct ShowMeModelQuizzes: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                ListVerbModelsView(languageViewModel: languageViewModel)
                TenseButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                PersonTypeButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                VStack{
                    Text("Show me model quizzes")
                        .font(.title2)
                        .foregroundColor(Color("ChuckText1"))
                    
                    Text("Select a quiz:").font(.title)
                        .font(.title3)
                    
                    HStack{
                        VStack{
                            NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveVerbs))
                            {
                            Image("MCSubjectVerb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Multiple Choice")
                                Text("Subject vs Verb")
                            }.font(.caption)
                        }
                        VStack{
                            NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveTenses))
                            {
                            Image("MCSubjectTense")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Multiple Choice")
                                Text("Subject vs Tense")
                            }.font(.caption)
                        }
                        VStack{
                            NavigationLink(destination: MixAndMatchView(languageViewModel: languageViewModel))
                            {
                            Image("MixAndMatch")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .border(Color("ChuckText1"))
                            }
                            Text("Mix and Match").font(.caption)
                        }
                        
                    }
                }
                .padding()
                .foregroundColor(Color("BethanyGreenText"))
            }
        }
        
    }
    
    func setCurrentVerb(){
        
    }
}

