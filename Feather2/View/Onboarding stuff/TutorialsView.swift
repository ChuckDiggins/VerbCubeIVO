//
//  OnboardingView.swift
//  Feather2
//
//  Created by chuckd on 3/20/23.
//

import SwiftUI

struct TutorialsView: View {
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("Explanation Page") var explanationPage = 7
    @AppStorage("Selection Lesson Page") var selectionLessonPage = 7
    @AppStorage("Selection Model Page") var selectionModelPage = 8
    @AppStorage("Explore Page") var explorePage = 8
    @AppStorage("Learn Page") var learnPage = 7
    @AppStorage("Test Page") var testPage = 6
    
    var body: some View {
        VStack{
            List{
                Button{
                    currentPage = 1
                } label: {
                    Text("Show welcome tutorial")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    explanationPage = 1
                }label: {
                    Text("Show overview tutorial")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    selectionLessonPage = 1
                }label: {
                    Text("Show SELECT lesson tutorial")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    selectionModelPage = 1
                }label: {
                    Text("Show SELECT model tutorial")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    explorePage = 1
                }label: {
                    Text("Show EXPLORE tutorial")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    learnPage = 1
                }label: {
                    Text("Show LEARN tutorial")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    testPage = 1
                }label: {
                    Text("Show TEST tutorial")
                }.modifier(ModelTensePersonButtonModifier())
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialsView()
    }
}
