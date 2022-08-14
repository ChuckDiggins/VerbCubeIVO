//
//  TeachMeTheBasics.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/8/22.
//

import SwiftUI
import JumpLinguaHelpers

enum  TeachMeVerbType : String {
    case AR, ER, IR
}



struct TeachMeARegularVerb: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var teachMeVerbType = TeachMeVerbType.AR
    @State var currentTenseString = "Present"
    @State var xverbAR = "xxxyyar"
    @State var xverbER = "xxxyyer"
    @State var xverbIR = "xxxyyir"
    var instructionFont = Font.caption
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                Text("Teach Me A Regular Verb").font(.title2).foregroundColor(Color("ChuckText1"))
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
                    .foregroundColor(Color("BethanyGreenText"))
                    .padding(3)
                
                Divider().frame(height:1).background(.white)
                
                VStack{
                    Text("Step 2: Pick a verb ending").font(.title2)
                    Text("To change the ending, click Button.")
                    HStack{
                        Button{
                            teachMeVerbType = .AR
                        } label: {
                            HStack{
                                Circle()
                                    .fill(teachMeVerbType == .AR ? .red : Color("BethanyPurpleButtons"))
                                    .frame(width: teachMeVerbType == .AR  ? 20 : 15, height: teachMeVerbType == .AR  ? 20 : 25)
                                    .shadow(radius: 5)
                                Text("AR")
                                    .frame(width: 50, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color("BethanyPurpleButtons"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .shadow(radius: 3)
                            }
                        }
                        .padding()
                        Button{
                            teachMeVerbType = .ER
                        } label: {
                            HStack{
                                Circle()
                                    .fill(teachMeVerbType == .ER ? .red : Color("BethanyPurpleButtons"))
                                    .frame(width: teachMeVerbType == .ER  ? 20 : 15, height: teachMeVerbType == .ER  ? 20 : 15)
                                    .shadow(radius: 5)
                                Text("ER")
                                    .frame(width: 50, height: 30)
                                    .background(Color("BethanyPurpleButtons"))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .shadow(radius: 3)
                            }
                        }
                        
                        .padding()
                        Button{
                            teachMeVerbType = .IR
                        } label: {
                            HStack{
                                Circle()
                                    .fill(teachMeVerbType == .IR ? .red : Color("BethanyPurpleButtons"))
                                    .frame(width: teachMeVerbType == .IR  ? 20 : 15, height: teachMeVerbType == .IR  ? 20 : 15)
                                    .shadow(radius: 5)
                                Text("IR")
                                    .frame(width: 50, height: 30)
                                    .background(Color("BethanyPurpleButtons"))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .shadow(radius: 3)
                            }
                        }
                        .padding()
                    }.border(Color("ChuckText1"))
                    
//                    Text("Changing the ending changes the practice verb in Step 3.")
//                        .bold()
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("BethanyGreenText"))
                .padding(3)
                Divider().frame(height:1).background(.white)
                VStack{
                    Text("Step 3: Pick a practice verb type ").font(.title2)
                    
                    Text("Select regular verb or X-verb")
                    
                    switch teachMeVerbType{
                    case .AR:
                        VStack{
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: "comprar", french: "acheter", english: "buy"), residualPhrase: "", teachMeMode: .regular))
                            {
                            HStack{
                                Text("Regular verb: comprar")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                            }.modifier(ModelTensePersonButtonModifier())
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: xverbAR, french: "", english: ""), residualPhrase: "", teachMeMode: .regular))
                            {
                            HStack{
                                Text("X-verb:  xxxyyyar")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                            }.modifier(ModelTensePersonButtonModifier())
                        }
                        .padding()
                    case .ER:
                        VStack{
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: "vender", french: "", english: ""), residualPhrase: "", teachMeMode: .regular))
                            {
                            HStack{
                                Text("Regular verb: vender")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                            }.modifier(ModelTensePersonButtonModifier())
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: xverbAR, french: "", english: ""), residualPhrase: "", teachMeMode: .regular))
                            {
                            HStack{
                                Text("X-verb:  xxxyzer")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                            }.modifier(ModelTensePersonButtonModifier())
                            
                        }
                        .padding()
                    case .IR:
                        VStack{
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: "vivir", french: "", english: ""), residualPhrase: "", teachMeMode: .regular))
                            {
                            HStack{
                                Text("Regular verb:  vivir")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                            }.modifier(ModelTensePersonButtonModifier())
                            
                            NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: xverbIR, french: "", english: ""), residualPhrase: "", teachMeMode: .regular))
                            {
                            HStack{
                                Text("X-verb:  xxxyzir")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                            }.modifier(ModelTensePersonButtonModifier())
                            
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("BethanyGreenText"))
                .padding(3)
            }
            Spacer()
        } .animation(.easeIn)
    }
       
}

//struct TeachMeTheSpanishVerbBasics_Previews: PreviewProvider {
//    static var previews: some View {
////        TeachMeTheSpanishVerbBasics(languageViewModel: LanguageViewModel(language: .Agnostic))
//        TeachMeTheSpanishVerbBasics()
//    }
//}
