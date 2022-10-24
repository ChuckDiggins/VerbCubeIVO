//////
//////  ActiveVerbListView.swift
//////  VIperSpanish 2
//////
//////  Created by Charles Diggins on 2/17/21.
//////
//
//import SwiftUI
//import JumpLinguaHelpers
//
//struct FilteredVerbListView: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @StateObject var languageEngine: LanguageEngine
//    /*
//    @State private var verbList = [
//        VerbThing(id: 0, name: "estar"),
//        VerbThing(id: 1, name: "conocer" ),
//        VerbThing(id: 2, name:  "empezar" ),
//        VerbThing(id: 3, name:  "bananar" )
//    ]
//    */
//    
//    @State private var verbs = [Verb]()
//    @State private var showModelInfo = false
//    
//    var body: some View {
//        List(languageEngine.getFilteredVerbs(), id:\.self){ verb in
//            HStack{
//                FilteredRowView(languageViewModel: languageViewModel, languageEngine: languageEngine, verb : verb, showModelInfo : $showModelInfo)
//            }
//        }
//        .environment(\.defaultMinListRowHeight, 10)
//        .font(.caption)
//        .onAppear(perform: {
//            verbs.removeAll()
//            print("Filtered verb count: \(languageEngine.getFilteredVerbs().count)")
//            for rv in languageEngine.getFilteredVerbs(){
//                verbs.append(rv)
//            }
//            verbs = verbs.sorted( by: { $0.getWordAtLanguage(language: languageEngine.getCurrentLanguage())
//                < $1.getWordAtLanguage(language: languageEngine.getCurrentLanguage())} )
//            
//        })
//        Button(action: {
//            showModelInfo.toggle()
//        }){
//            Text("Show Verb Model Information")
//        }
//    }
//}
//
//
////struct FilteredVerbListView_Previews: PreviewProvider {
////    static var previews: some View {
////        FilteredVerbListView()
////    }
////}
