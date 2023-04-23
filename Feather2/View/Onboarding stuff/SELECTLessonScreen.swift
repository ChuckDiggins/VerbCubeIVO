//
//  SelectionScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 4/22/23.
//

import SwiftUI

struct SELECTLessonScreen: View {
    @AppStorage("Selection Lesson Page") var selectionLessonPage = 7

    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if selectionLessonPage == 1{
                SELECTLessonScreenView(image: "SelectLessonMode", title: "Verbs of a Feather", detail: "Depending you select Lesson Mode or Model Mode, your options will differ.  All the following exercises described below are for Lesson Mode.  Click on Lesson Mode.", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if selectionLessonPage == 2{
                SELECTLessonScreenView(image: "SELECTRealidades", title: "Select lesson", detail: "Scroll right to see the option to SELECT Spanish I.  Click on the Spanish I button." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            
            if selectionLessonPage == 3{
                SELECTLessonScreenView(image: "VerbLessonWindow1", title: "Select lesson", detail: "If you click Challenging Lessons, you see a list of lessons.  A lesson consists of a title, some verbs and some tenses.  Easier lessons start with simple verbs and easy tenses.  Harder lessons have more verbs and harder verbs and more tenses.  Select 'Simple Verbs'.  At the bottom, click on the purple Install button." , bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if selectionLessonPage == 4{
                SELECTLessonScreenView(image: "SELECTChallengingLessons", title: "Select challenging lesson", detail: "Scroll right again to SELECT Challenging Lessons." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if selectionLessonPage == 5{
                SELECTLessonScreenView(image: "VerbListWindow1", title: "Verb List", detail: "To see to verbs in your current lesson, scroll right and click on Show Current Verbs", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if selectionLessonPage == 6{
                SELECTLessonScreenView(image: "EXPLORE", title: "Continue", detail: "You are now ready for EXPLORE, LEARN, and TEST.  All exercises will pertain to your current verbs and tenses.  Scroll down to Explore", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if selectionLessonPage <= totalSelectLessonPages{
                        selectionLessonPage += 1
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
                                .trim(from: 0, to: CGFloat(selectionLessonPage) / CGFloat(totalPages))
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

struct SELECTLessonScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("Selection Lesson Page") var selectionLessonPage = 7
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if selectionLessonPage == 1{
                    Text("Welcome to Lesson-Based Verb Conjugation!")
                        .font(.title)
                        .fontWeight(.semibold)
                        // Letter Spacing...
                        .kerning(1.4)
                }
                else{
                    // Back Button...
                    Button(action: {
                        withAnimation(.easeInOut){
                            selectionLessonPage -= 1
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
                        selectionLessonPage = 7
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

var totalSelectLessonPages = 7
