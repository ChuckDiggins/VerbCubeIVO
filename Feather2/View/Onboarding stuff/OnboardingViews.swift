////
////  OnboardingView.swift
////  Feather2
////
////  Created by chuckd on 3/20/23.
////
//
//import SwiftUI
//
//struct OnboardingViews: View {
//    @AppStorage("currentPage") var currentPage = 1
//    @AppStorage("Explanation Page") var explanationPage = 7
//    @AppStorage("Selection Page") var selectionPage = 7
//    @AppStorage("Explore Page") var explorePage = 8
//    @AppStorage("Learn Page") var learnPage = 7
//    @AppStorage("Test Page") var testPage = 7
//    
//    var body: some View {
//        VStack{
//            List{
//                Button{
//                    currentPage = 1
//                } label: {
//                    Text("Show onboarding sequence")
//                }.modifier(ModelTensePersonButtonModifier())
//                
//                Button{
//                    explanationPage = 1
//                }label: {
//                    Text("Show explanation sequence")
//                }.modifier(ModelTensePersonButtonModifier())
//                
//                Button{
//                    selectionPage = 1
//                }label: {
//                    Text("SELECT sequence")
//                }.modifier(ModelTensePersonButtonModifier())
//                
//                Button{
//                    explorePage = 1
//                }label: {
//                    Text("EXPLORE sequence")
//                }.modifier(ModelTensePersonButtonModifier())
//                
//                Button{
//                    learnPage = 1
//                }label: {
//                    Text("LEARN sequence")
//                }.modifier(ModelTensePersonButtonModifier())
//                
//                Button{
//                    testPage = 1
//                }label: {
//                    Text("TEST sequence")
//                }.modifier(ModelTensePersonButtonModifier())
//            }
//        }
//    }
//}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingViews()
//    }
//}
