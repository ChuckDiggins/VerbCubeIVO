////
////  FilteredRowView.swift
////  VIperSpanish 2
////
////  Created by Charles Diggins on 2/17/21.
////
//
//import SwiftUI
//import JumpLinguaHelpers
//
//struct FilteredRowView: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @StateObject var languageEngine: LanguageEngine
//    var verb : Verb
//    @Binding var showModelInfo : Bool
//    var bRomanceVerb = BRomanceVerb()
//    
//    static let colors: [String: Color] = [  "stm": .yellow,  //stem changing
//                                          "ort": .green, //ortho changing
//                                          "irr": .blue,  //irregular
//                                          "spc": .purple,  //special
//                                          "psv": .blue, //passive
//                                          "rfl": .orange, //Reflexive
//                                          "cls": .pink  //phrasal
//                                        ]
//
//    var properties = [Bool] ()
//    
//    var body: some View {
//        HStack {
//            Text(verb.getWordAtLanguage(language: languageEngine.getCurrentLanguage()))
//            Spacer()
//            HStack{
//                ForEach(languageEngine.getRomanceVerb(verb: verb).restrictions, id: \.self){
//                    restriction in Text(restriction)
//                    //.font(.caption)
//                        .font(.system(size:6.0))
//                        .fontWeight(.black)
//                        .padding(3)
//                        .background(Self.colors[restriction, default: .black])
//                        .clipShape(Circle())
//                        .foregroundColor(.black)
//                }
//            }
//            NavigationLink(destination: AnalyzeFilteredVerbView(languageViewModel: languageViewModel, verb: verb, residualPhrase: "", teachMeMode: .model)){
////                    EmptyView()
//                if ( showModelInfo){
//                    HStack{
//                        Text("Model #\(languageEngine.getRomanceVerb(verb: verb).getBescherelleInfo()), ").foregroundColor(.red)
//                        //                        Text(verb.bVerbModel.modelVerb).foregroundColor(.red)
//                    }
//                }
//            }.buttonStyle(PlainButtonStyle())
//            
//            
//        }
//        .font(.caption)
//        .onAppear {
//        }
//    }
//}
//
////struct FilteredRowView_Previews: PreviewProvider {
////    static var previews: some View {
////        FilteredRowView(verb: Verb(), showModelInfo: true)
////    }
////}
