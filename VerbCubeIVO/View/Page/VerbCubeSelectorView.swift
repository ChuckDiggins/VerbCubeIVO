//
//  VerbCubeSelectorView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/22/22.
//

import SwiftUI

struct VerbCubeSelectorView: View {
    @EnvironmentObject var languageEngine: LanguageEngine
    var body: some View {
        
        //NavigationView {
//            LanguagePreferencesTenseView()
        Text("The Verb Cube").font(.largeTitle).bold()
//            VStack {
//                HStack{
//                    NavigationLink(destination: VerbCubeView(vccsh: VerbCubeConjugatedStringHandlerStruct(languageEngine: languageEngine, d1: .Person, d2: .Tense))){
//                        Text("The Verb Cube")
//                    }.frame(width: 200, height: 50)
//                        .padding(.leading, 10)
//                        .background(Color.orange)
//                        .cornerRadius(10)
//                    
//                    NavigationLink(destination: QuizCubeOptionsView2()){
//                        Text("Quiz Cube Options")
//                    }.frame(width: 200, height: 50)
//                        .padding(.leading, 10)
//                        .background(Color.orange)
//                        .cornerRadius(10)
//                    
//                    NavigationLink(destination: QuizCubeView(vccsh: QuizCubeConjugatedStringHandlerStruct(languageEngine: languageEngine, d1: .Person, d2: .Tense))){
//                        Text("The Quiz Cube")
//                    }.frame(width: 200, height: 50)
//                        .padding(.leading, 10)
//                        .background(Color.orange)
//                        .cornerRadius(10)
//                    
//                }
//            }
    }
}

struct VerbCubeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        VerbCubeSelectorView()
    }
}
