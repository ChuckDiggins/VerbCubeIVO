////
////  TeachMeModelVerbs.swift
////  VerbCubeIVO
////
////  Created by Charles Diggins on 8/9/22.
////
//
//import SwiftUI
//import JumpLinguaHelpers
//
//struct TeachMeAModelVerb: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//
//    @State var currentTenseString = "Present"
//    @State var currentModelString = "xxx"
//    @State var currentVerbString = "xxx"
//    @State var currentXVerbString = "xxxeguirse"
//    
//    var instructionFont = Font.caption
//    
//    var body: some View {
//        ZStack{
//            Color("BethanyNavalBackground")
//                .ignoresSafeArea()
//            ScrollView{
//                DisclosureGroupTeachMeAModelVerb()
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
//                
//                VStack{
//                    Text("Step 2: Pick a verb model").font(.title2)
//                    Text("To change the model, click Button.")
//                    NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
//                        HStack{
//                            Text("Current model: \(currentModelString)")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }.modifier(ModelTensePersonButtonModifier())
//                    }.task {
//                        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleModelVerb()
//                        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(2)
//                
//                Divider().frame(height:1).background(.white)
//                
//                VStack{
//                    Text("Step 3: Pick a verb").font(.title2)
//                    Text("To change the verb, click Button.")
//                    Button(action: {
//                        languageViewModel.setNextFilteredVerb()
//                        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//                    }){
//                        HStack{
//                            Text("Verb: ")
//                            Text(currentVerbString)
//                            Spacer()
//                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
//                        }.modifier(ModelTensePersonButtonModifier())
//                    }
//                    
//                }
//                .frame(maxWidth: .infinity)
//                .padding(2)
//                
//                Divider().frame(height:1).background(.white)
//                
//                VStack{
//                    Text("Step 4: Conjugate your verb").font(.title2)
//                    VStack{
//                        NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentFilteredVerb(), residualPhrase: "", multipleVerbFlag: true))
//                        {
//                        HStack{
//                            Text("Model verb = \(currentVerbString)")
//                            Spacer()
//                            Image(systemName: "chevron.right").foregroundColor(.yellow)
//                        }
//                        }.modifier(ModelTensePersonButtonModifier())
//                    }
//                    .padding()
//                }
//                .frame(maxWidth: .infinity)
//                .padding(2)
//            }
//            .foregroundColor(Color("BethanyGreenText"))
//            .background(Color("BethanyNavalBackground"))
//            Spacer()
//        }
//    }
//}
//
