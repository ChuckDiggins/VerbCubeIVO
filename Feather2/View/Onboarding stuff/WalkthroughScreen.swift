//
//  WalkthroughScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 3/6/23.
//

import SwiftUI

struct WalkthroughScreen: View {
    @AppStorage("currentPage") var currentPage = 1
    
//    @State var currentPage = 1
    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if currentPage == 1{
                ScreenView(image: "Feather welcome bird", title: "Learn Verb Conjugation", detail: "Welcome to Verbs of a Feather.  Choose between two modes: Verb Lessons and Verb Models.", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if currentPage == 2{
                ScreenView(image: "Feather welcome crow", title: "Verb Lessons", detail: "A verb lesson is a combination of a set of verbs and one or more tenses.  The first set of lessons is configured to a textbook of Spanish Level 1.", bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if currentPage == 3{
                
                ScreenView(image: "Feather Welcome flying", title: "Verb Models", detail: "Verb Models:  Model-Based Verb Conjugation or MBVC is inspired by Bescherelle. MBVC can teach you how to conjugate 1000s of verbs in Feather's 21 tenses.", bgColor: Color("color3"))
                    .transition(.scale)
            }
            
            if currentPage == 4{
                ScreenView(image: "Feather Welcome reading", title: "SELT", detail: "Select, Explore, Learn and Test - The four steps to learning Spanish verb conjugation. Verb Lessons and Verb Models all follow SELT.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if currentPage == 5{
                ScreenView(image: "Feather Navigation Bar", title: "Wait!  Before you finish this tutorial", detail: "To replay this welcome tutorial and several others, click on the graduation cap on Feather's navigation (top) bar.", bgColor: Color("color4"))
                    .transition(.scale)
            }
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if currentPage <= totalPages{
                        currentPage += 1
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
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
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


struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if currentPage == 1{
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
                            currentPage -= 1
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
                        currentPage = 4
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

// total Pages...
var totalPages = 6

