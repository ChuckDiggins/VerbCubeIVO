//
//  EXPLOREScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 4/22/23.
//

import SwiftUI

struct TESTScreen: View {
    @AppStorage("Test Page") var testPage = 6

    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if testPage == 1{
                TESTScreenView(image: "TEST", title: "Test", detail: "When you think you know how to conjugate the verbs in your current lesson or verb model, click on Test!", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if testPage == 2{
                TESTScreenView(image: "TESTMultiple", title: "Multiple Choice", detail: "You can choose between 'Multiple Choice Test'or 'Fill-in Blanks Test'.  Not surprisingly, Fill-in Blanks is harder." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if testPage == 3{
                TESTScreenView(image: "TEST Multiple Choice Detail", title: "Multiple choice", detail: "You are randomly presented with your verbs and tenses and subject pronouns.  You must answer 80% of at least 6 correct.  When you succeed, you will be congratulated and the next lesson or verb model will be selected for you.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if testPage == 4{
                TESTScreenView(image: "TESTFillInBlanks", title: "Fill-in the blanks", detail: "Click this for the Fill-in Blanks test.", bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            
            if testPage == 5{
                TESTScreenView(image: "TEST Fill-in Blanks Detail", title: "Fill-in the blanks", detail: "You are randomly presented with your verbs and tenses and subject pronouns.  You must answer 80% of at least 6 correct.  When you succeed, you will be congratulated and the next lesson or verb model will be selected for you.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if testPage <= totalTestPages{
                        testPage += 1
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
                                .trim(from: 0, to: CGFloat(testPage) / CGFloat(totalPages))
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

struct TESTScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("Test Page") var testPage = 6
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if testPage == 1{
                    Text("Welcome to Feather Explore!")
                        .font(.title)
                        .fontWeight(.semibold)
                        // Letter Spacing...
                        .kerning(1.4)
                }
                else{
                    // Back Button...
                    Button(action: {
                        withAnimation(.easeInOut){
                            testPage -= 1
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
                        testPage = 6
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

var totalTestPages = 6

