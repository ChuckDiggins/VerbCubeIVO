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
            
            ScrollView{
                DisclosureGroupShowMeModelQuizzes().foregroundColor(Color("BethanyGreenText"))
                
                ListVerbModelsView(languageViewModel: languageViewModel)
                TenseButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                PersonTypeButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                
                HStack{
                    VStack{
                        NavigationLink(destination: MixAndMatchView(languageViewModel: languageViewModel))
                        {
                        Image("MixAndMatch")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .border(Color("ChuckText1"))
                        }
                        VStack{
                            Text("Mix and Match")
                        }
                        
                    }
                    VStack{
                        NavigationLink(destination: DragDropVerbSubjectView(languageViewModel: languageViewModel))
                        {
                        Image("DragAndDrop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .border(Color("ChuckText1"))
                        }
                        VStack{
                            Text("Drag and Drop")
                        }
                    }
                }
                HStack{
                    VStack{
                        NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveVerbs))
                        {
                        Image("MCSubjectVerb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .border(Color("ChuckText1"))
                        }
                        VStack{
                            Text("Multiple Choice")
                            Text("Subject vs Verb")
                        }
                    }
                    VStack{
                        NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveTenses))
                        {
                        Image("MCSubjectTense")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .border(Color("ChuckText1"))
                        }
                        VStack{
                            Text("Multiple Choice")
                            Text("Subject vs Tense")
                        }
                    }
                }
 
            }.font(.caption)
            .padding()
            .foregroundColor(Color("BethanyGreenText"))
        }
        
    }
    
    func setCurrentVerb(){
        
    }
}

