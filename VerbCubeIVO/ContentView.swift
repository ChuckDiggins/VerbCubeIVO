//
//  ContentView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @State var isVerbCubeActive = false
   
    var body: some View {
        NavigationView {
            List {
//                NavigationLink(destination: VerbCubeDispatcher()){
//                    Text("Verb Cube Dispatcher")
//                }.frame(width: 200, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.green)
//                    .cornerRadius(10)

//                Text("\(languageViewModel.getCurrentLanguage())")
//                NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person)), isActive: $isVerbCubeActive){
//                    Text("Verb Cube")
//                }.frame(width: 200, height: 50)
//                .padding(.leading, 10)
//                .background(Color.orange)
//                .cornerRadius(10)
//                
//////
//                
////
//                NavigationLink(destination: WordCollectionScreen(languageViewModel: languageViewModel)){
//                    Text("Word collections")
//                }.frame(width: 200, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.orange)
//                    .cornerRadius(10)
//
//
//                NavigationLink(destination: VerbSelectionViewLazy(languageEngine: languageViewModel.getLanguageEngine())){
//                    Text("LAZY Verb selection view")
//                }.frame(width: 200, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.orange)
//                    .cornerRadius(10)
////
//                NavigationLink(destination: VerbMorphView()){
//                                    Text("Verb Morph View")
//                                }.frame(width: 200, height: 50)
//                                .padding(.leading, 10)
//                                .background(Color.orange)
//                                .cornerRadius(10)
////
//                NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
//                                    Text("Analyze User Verb")
//                                }.frame(width: 200, height: 50)
//                                .padding(.leading, 10)
//                                .background(Color.orange)
//                                .cornerRadius(10)
//////
//                NavigationLink(destination: LanguagePreferencesTenseView(languageViewModel: languageViewModel)){
//                                    Text("Preferences")
//                                }.frame(width: 200, height: 50)
//                                .padding(.leading, 10)
//                                .background(Color.orange)
//                                .cornerRadius(10)
////
//

            }.navigationTitle("Verb cubes")
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear{
//                    isVerbCubeActive = true
                }
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}