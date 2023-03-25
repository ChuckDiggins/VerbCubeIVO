//
//  OnboardingView.swift
//  Feather2
//
//  Created by chuckd on 3/20/23.
//

import SwiftUI

struct OnboardingViews: View {
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("Explanation Page") var explanationPage = 7
    @AppStorage("Explore Page") var explorePage = 7
    @AppStorage("Learn Page") var learnPage = 7
    @AppStorage("Test Page") var testPage = 7
    
    var body: some View {
        VStack{
            List{
                Button{
                    currentPage = 1
                } label: {
                    Text("Show onboarding sequence")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    explanationPage = 1
                }label: {
                    Text("Show explanation sequence")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    explorePage = 1
                }label: {
                    Text("Explore sequence")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    learnPage = 1
                }label: {
                    Text("Learn sequence")
                }.modifier(ModelTensePersonButtonModifier())
                
                Button{
                    testPage = 1
                }label: {
                    Text("Test sequence")
                }.modifier(ModelTensePersonButtonModifier())
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViews()
    }
}
