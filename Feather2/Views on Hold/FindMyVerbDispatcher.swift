//
//  FindMyVerb.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/7/22.
//

import SwiftUI

struct FindMyVerbDispatcher: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var frameWidth = CGFloat(150)
    var frameHeight = CGFloat(250)
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)

            ScrollView{
//                DisclosureGroupFindMyVerb()
                VStack{
                    
                    HStack{
                        VStack{
                            NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .model))
                            {
                            Text("Find Verb Model")
                            }
                        }
                       
                        VStack{
                            NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .pattern))
                            {
                            Text("Find Verb Pattern")
                            }
                        }
                    }.font(.caption)
                    HStack{
                        VStack{
                            NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel))
                            {
                            Text("Analyze My Verb")
                            }
                        }
                        VStack{
                            NavigationLink(destination: UnconjugateView(languageViewModel: languageViewModel))
                            {
                            Text("Unconjugate")
                            }
                            
                        }
                        
                    }.font(.caption)
                }
                    .padding()
                    .foregroundColor(Color("ChuckText1"))
            }
        }
    }
}

