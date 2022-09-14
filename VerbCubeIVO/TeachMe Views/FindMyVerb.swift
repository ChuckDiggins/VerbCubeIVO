//
//  FindMyVerb.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/7/22.
//

import SwiftUI

struct FindMyVerb: View {
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
                            Image("FindMyVerbModel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameHeight)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find Verb Model")
                            }
                        }
                       
                        VStack{
                            NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .pattern))
                            {
                            Image("FindMyVerbPattern")
                                .resizable()
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameHeight)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Find Verb Pattern")
                            }
                        }
                    }.font(.caption)
                    HStack{
                        VStack{
                            NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel))
                            {
                            Image("FindMyVerbAnalyze")
                                .resizable()
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameHeight)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
                                Text("Analyze My Verb")
                            }
                        }
                        VStack{
                            NavigationLink(destination: UnconjugateView(languageViewModel: languageViewModel))
                            {
                            Image("FindMyVerbUnconjugate")
                                .resizable()
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameHeight)
                                .border(Color("ChuckText1"))
                            }
                            VStack{
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

