//
//  QuizCubeDirectorView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/6/22.
//

import SwiftUI

import JumpLinguaHelpers

struct QuizCubeDirectorView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var alertToggle = true
    @State var isActive = true
    
        var body: some View {
            
            let maxHeight : CGFloat = 100
            Text("The Quiz Cube").font(.largeTitle).bold()
                Text("6 Dimensions of Conjugation").font(.headline).bold()
                VStack {
                    HStack{
                        NavigationLink(destination: QuizCubeView2(languageViewModel: languageViewModel, qchc: QuizCubeHandlerClass(languageViewModel: languageViewModel), useCellAlert: alertToggle ), isActive: $isActive){
                            VStack{
                                Text("1")
                                Text("Person v Verb").bold()
                                Text("Variable: Tense")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.red)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                            VStack{
                                Text("2")
                                Text("Verb v Person").bold()
                                Text("Variable: Tense")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.red)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                    }
                    
                    HStack{
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Tense))){
                            VStack{
                                Text("3")
                                Text("Verb v Tense").bold()
                                Text("Variable: Person")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.blue)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Tense, d2: .Verb))){
                            VStack{
                                Text("4")
                                Text("Tense v Verb").bold()
                                Text("Variable: Person")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.blue)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                        
                    }
                    HStack{
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Tense, d2: .Person))){
                        VStack{
                            Text("5")
                            Text("Tense v Person").bold()
                            Text("Variable: Verb")
                        }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Person, d2: .Tense))){
                        VStack{
                            Text("6")
                            Text("Person v Tense").bold()
                            Text("Variable: Verb")
                        }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                //}.navigationTitle("The VerbCube")
                }.font(.caption)
            Spacer()
        }
    }

