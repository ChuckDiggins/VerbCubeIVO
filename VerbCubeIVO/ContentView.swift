//
//  ContentView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageEngine: LanguageEngine

    var body: some View {
        NavigationView {
            List {
                Text("\(languageEngine.getCurrentLanguage())")
                NavigationLink(destination: VerbCubeView(vccsh: VerbCubeConjugatedStringHandlerStruct(languageEngine: languageEngine))){
                    Text("JumpLingua Verb Cube")
                }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)
                
//                NavigationLink(destination: VerbCubeView2(vccsh: VerbCubeHandlerClass(languageEngine: languageEngine, d1: .Person, d2: .Verb))){
//                    Text("JumpLingua Verb Cube 2")
//                }.frame(width: 200, height: 50)
//                .padding(.leading, 10)
//                .background(Color.orange)
//                .cornerRadius(10)
//                
                NavigationLink(destination: QuizCubeOptionsView2()){
                    Text("JumpLingua Quiz Cube")
                }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)
                
//                NavigationLink(destination: QuizCubeView(vccsh: QuizCubeConjugatedStringHandlerStruct(languageEngine: languageEngine))){
//                    Text("JumpLingua Quiz Cube")
//                }.frame(width: 200, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.orange)
//                    .cornerRadius(10)

//                NavigationLink(destination: FilteredVerbListView()){
//                    Text("Filtered Verb List")
//                }.frame(width: 200, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.orange)
//                    .cornerRadius(10)

                NavigationLink(destination: VerbSelectionView()){
                    Text("Verb selection view")
                }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)



            }.navigationTitle("Verb cubes")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
