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
                ExplanationScreenView(image: "Explanation mode", title: "Verbs of a Feather", detail: "First pick your preferred mode:  Lesson mode or Model mode", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if explanationPage == 2{
                ExplanationScreenView(image: "Explanation select lesson", title: "Select lesson", detail: "In Lesson Mode, beginners can SELECT from Spanish I or Challenging Lessons.  \nIn Model Mode, you can select a starting model.  When you finish a verb model, Feather will automatically install the next model." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if explanationPage == 3{
                ExplanationScreenView(image: "Explanation select model", title: "Select verb model", detail: "SELECT a Verb Model.  Every verb in a Verb Model conjugates identically in any tense.  22 verbs in the current dictionary belong to the Verb Model 'encontrar'.  If you learn how to conjugate 'encontrar', you learn all 22 verbs!", bgColor: Color("color3"))
                    .transition(.scale)
            }
            
            if explanationPage == 4{
                ExplanationScreenView(image: "Explanation explore", title: "Explore", detail: "EXPLORE how your the verbs in your selected lesson or model behave in each tense.  You get to watch.  Explore exercises show you all your verbs in any tense.  In Verb Morph, for example, you can actually watch your verbs conjugated one step at a time.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explanationPage == 5{
                ExplanationScreenView(image: "Explanation learn", title: "Learn", detail: "In LEARN, you practice conjugating your verbs in a series of exercises.  But don't worry, scores are not retained between exercises.  Scores are only to help you look for trouble verbs and tenses.  (Hint:  Subject vs Tense is surprisingly hard)", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explanationPage == 6{
                ExplanationScreenView(image: "Explanation test", title: "Test", detail: "When you feel you are ready to TEST your knowledge of the current lesson or verb model, take a test!  Select 'Multiple Choice Test' or 'Fill-in Blanks Test'.  You can switch between the two.  Answer at least 80% of the random problems correctly.  (Hint:  Multiple choice is easier.)", bgColor: Color("color4"))
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
                    Text("Welcome to the general Feather overview!")
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
