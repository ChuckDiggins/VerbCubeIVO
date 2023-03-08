//
//  ExplanationScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 3/7/23.
//

import SwiftUI

struct ExplanationScreen: View {
    @AppStorage("Explanation Page") var explanationPage = 7
    
//    @State var currentPage = 1
    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if explanationPage == 1{
                ScreenView(image: "Explanation overview", title: "Verbs of a Feather", detail: "First pick which mode you want to run.  Verbs or Verb Model", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if explanationPage == 2{
                ScreenView(image: "Explanation Select", title: "Select", detail: "In Verb Mode, beginners can select from Realidades I.  More advanced students might try Challenging lessons.  \nIn Model Mode, you can select a starting model.  When you finish a verb model, Feather will automatically install the next model." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if explanationPage == 3{
                
                ScreenView(image: "Explanation Verb Model", title: "Verb Model", detail: "Every verb belongs to a Verb Model.  Every verb in a Verb Model conjugates identically in any tense.  22 verbs in the current dictionary belong to the Verb Model 'encontrar'.  If you learn how to conjugate 'encontrar', you learn all 22 verbs!", bgColor: Color("color3"))
                    .transition(.scale)
            }
            
            if explanationPage == 4{
                ScreenView(image: "Explanation Explore", title: "Explore", detail: "Explore encourages you to see how your current verb or verb model behaves in each tense.  You only watch.  In Verb Morph, you can actually watch your verbs conjugated one step at a time.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explanationPage == 5{
                ScreenView(image: "Explanation Learn", title: "Learn", detail: "In Learn, you get to play with your verbs.  You can practice your verb conjugation through a series of exercises.  Even though scores are kept in each exercise, scores are not saved.  (Hint:  Subject vs Tense is surprisingly hard)", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explanationPage == 6{
                ScreenView(image: "Explanation Test", title: "Test", detail: "When you feel you are ready to 'Test Out' of your current verb or verb model, take the test.  You can select 'Multiple Choice Test' or 'Fill-in Blanks Test'.  You must answer at least 80% of the random problems correctly.  (Hint:  Multiple choice is easier.)", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if explanationPage <= totalExplanationPages{
                        explanationPage += 1
                    }
                }
            }, label: {
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                // Circlular Slider...
                    .overlay(
                    
                        ZStack{
                            
                            Circle()
                                .stroke(Color.black.opacity(0.04),lineWidth: 4)
                                
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(explanationPage) / CGFloat(totalPages))
                                .stroke(Color.white,lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom,20)
            
            ,alignment: .bottom
        )
    }
}
var totalExplanationPages = 7
