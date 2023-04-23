//
//  EXPLOREScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 4/22/23.
//

import SwiftUI

struct EXPLOREScreen: View {
    @AppStorage("Explore Page") var explorePage = 8

    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if explorePage == 1{
                EXPLOREScreenView(image: "EXPLORE", title: "Explore", detail: "When you are ready to explore your verbs, click on the Explore button", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if explorePage == 2{
                EXPLOREScreenView(image: "EXPLOREVerbConjugation", title: "Simple Verb Conjugation", detail: "This will take you to the Simple Verb Conjugation exercise." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            
            if explorePage == 3{
                EXPLOREScreenView(image: "EXPLORE Simple Verb Conjugation Detail", title: "Simple Verb Conjugation", detail: "Step through conjugating each verb for each tense.  You can also 'Set tenses'" , bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explorePage == 4{
                EXPLOREScreenView(image: "EXPLOREVerbMorphing", title: "Multi-verb Morphing", detail: "If you are in model mode, you can watch all your verbs conjugate or 'morph' at the same time.  This is not available in lesson mode." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if explorePage == 5{
                EXPLOREScreenView(image: "EXPLORE Multi-verb Morphing Detail", title: "Verb Morph Window", detail: "When you click on the 'Click me' button you start the morphing sequence.  With each click, the verbs for your current model conjugate one step at a time with comments.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explorePage == 6{
                EXPLOREScreenView(image: "EXPLORENormal", title: "Explore Normal", detail: "This exercise will show you how your verb conjugates interactively.  In Lesson Mode, Verbs like Gustar and Auxiliary Verb lessons will active different options here.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if explorePage == 7{
                EXPLOREScreenView(image: "EXPLORE Normal Verbs Detail", title: "Exploring normal verbs", detail: "This window allows you to change tense, person and verb with simple button clicks.  Or change all three with Randomize.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if explorePage <= totalExplorePages{
                        explorePage += 1
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
                                .trim(from: 0, to: CGFloat(explorePage) / CGFloat(totalPages))
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

struct EXPLOREScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("Explore Page") var explorePage = 8
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if explorePage == 1{
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
                            explorePage -= 1
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
                        explorePage = 7
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

var totalExplorePages = 8
