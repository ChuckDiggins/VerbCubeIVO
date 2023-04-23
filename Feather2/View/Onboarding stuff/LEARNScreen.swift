//
//  EXPLOREScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 4/22/23.
//

import SwiftUI

struct LEARNScreen: View {
    @AppStorage("Learn Page") var learnPage = 8

    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if learnPage == 1{
                LEARNScreenView(image: "LEARN", title: "Learn", detail: "When you are ready to interact with your verbs, click on the Learn button", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if learnPage == 2{
                LEARNScreenView(image: "LEARNMixAndMatch", title: "Mix and Match", detail: "Click this to be quizzed on your verbs and tenses presented as random problems." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            
            if learnPage == 3{
                LEARNScreenView(image: "LEARN Mix and Match Detail", title: "Mix and Match", detail: "Match the subject on the left with the correct verb form on the right." , bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if learnPage == 4{
                LEARNScreenView(image: "LEARNDragAndDrop", title: "Drop and Drag", detail: "This highly interactive game works with male and female, formal and informal subject pronouns." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if learnPage == 5{
                LEARNScreenView(image: "LEARN Drag and Drop Detail", title: "Drag and Drop", detail: "Inspired by DuolingoTM, you drag a conjugated from from the bottom section onto its correct subject pronoun above", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if learnPage == 6{
                LEARNScreenView(image: "LEARNSubjectTense", title: "Subject Tense", detail: "This is very similar to Subject vs Verb exercise, except Subject vs Tense is much harder.  Try it.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if learnPage == 7{
                LEARNScreenView(image: "LEARN Subject vs Tense Detail", title: "Subject Tense", detail: "The exercise randomly picks one of your verbs and picks a subject.  You choose from six possible conjugated verbs each in a different tense.  Pay close attention to correct Tense!", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if learnPage <= totalLearnPages{
                        learnPage += 1
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
                                .trim(from: 0, to: CGFloat(learnPage) / CGFloat(totalPages))
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

struct LEARNScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("Learn Page") var learnPage = 8
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if learnPage == 1{
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
                            learnPage -= 1
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
                        learnPage = 7
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

var totalLearnPages = 8

