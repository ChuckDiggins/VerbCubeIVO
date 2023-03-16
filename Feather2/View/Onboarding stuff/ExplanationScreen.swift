//
//  ExplanationScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 3/7/23.
//

import SwiftUI

struct ExplanationScreen1: View {
    @AppStorage("Explanation Page") var explanationPage = 7
    
//    @State var currentPage = 1
    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if explanationPage == 1{
                ExplanationScreenView(image: "Explanation mode", title: "Verbs of a Feather", detail: "First pick which mode you want to run.  Verbs or Verb Model", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if explanationPage == 2{
                ExplanationScreenView(image: "Explanation select lesson", title: "Select lesson", detail: "In Verb Mode, beginners can select from Realidades I.  More advanced students might try Challenging lessons.  \nIn Model Mode, you can select a starting model.  When you finish a verb model, Feather will automatically install the next model." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if explanationPage == 3{
                ExplanationScreenView(image: "Explanation select model", title: "Select verb model", detail: "Every verb belongs to a Verb Model.  Every verb in a Verb Model conjugates identically in any tense.  22 verbs in the current dictionary belong to the Verb Model 'encontrar'.  If you learn how to conjugate 'encontrar', you learn all 22 verbs!", bgColor: Color("color3"))
                    .transition(.scale)
            }
            
            if explanationPage == 4{
                ExplanationScreenView(image: "Explanation explore", title: "Explore", detail: "Explore encourages you to see how your current verb or verb model behaves in each tense.  You only watch.  In Verb Morph, you can actually watch your verbs conjugated one step at a time.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explanationPage == 5{
                ExplanationScreenView(image: "Explanation learn", title: "Learn", detail: "In Learn, you get to play with your verbs.  You can practice your verb conjugation through a series of exercises.  Even though scores are kept in each exercise, scores are not saved.  (Hint:  Subject vs Tense is surprisingly hard)", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explanationPage == 6{
                ExplanationScreenView(image: "Explanation test", title: "Test", detail: "When you feel you are ready to 'Test Out' of your current verb or verb model, take the test.  You can select 'Multiple Choice Test' or 'Fill-in Blanks Test'.  You must answer at least 80% of the random problems correctly.  (Hint:  Multiple choice is easier.)", bgColor: Color("color4"))
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

struct ExplanationScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("Explanation Page") var explanationPage = 7
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if explanationPage == 1{
                    Text("Greetings!  So you want to learn how to conjugate Spanish verbs!")
                        .font(.title)
                        .fontWeight(.semibold)
                        // Letter Spacing...
                        .kerning(1.4)
                }
                else{
                    // Back Button...
                    Button(action: {
                        withAnimation(.easeInOut){
                            explanationPage -= 1
                        }
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut){
                        explanationPage = 7
                    }
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundColor(.black)
            .padding()
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            
            // Change with your Own Thing....
            Text(detail)
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.center)
            
            // Minimum Spacing When Phone is reducing...
            
            Spacer(minLength: 120)
        }
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}

var totalExplanationPages = 7
