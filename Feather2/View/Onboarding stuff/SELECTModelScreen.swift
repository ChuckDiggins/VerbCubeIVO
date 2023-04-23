//
//  SELECTModelScreen.swift
//  Feather2
//
//  Created by Charles Diggins on 4/22/23.
//

import Foundation
import SwiftUI

struct SELECTModelScreen: View {
    @AppStorage("Selection Model Page") var selectionModelPage = 8

    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if selectionModelPage == 1{
                SELECTModelScreenView(image: "SelectModelMode", title: "Verb Models", detail: "Click on Model Mode.  Then click on the Verb Models image to enter the select model sequence", bgColor: Color("color1"))
                    .transition(.scale)
            }
            
            if selectionModelPage == 2{
                SELECTModelScreenView(image: "SELECTVerbModelList", title: "Select model list", detail: "Scroll right to see Verb Model List." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if selectionModelPage == 3{
                SELECTModelScreenView(image: "VerbModelWindow1", title: "Verb model list detail", detail: "This shows you a list of Verb Models in a sequential order similar to Bescherelle.  Each name is followed by its verb count in the Feather dictionary.  You also see which models have been completed, and which model is selected. Click on a verb model to select it." , bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            if selectionModelPage == 4{
                SELECTModelScreenView(image: "SELECTVerbModels", title: "Select model list 2", detail: "Scroll right to see Verb Model List." , bgColor: Color("color2"))
                    .transition(.scale)
            }
            
            if selectionModelPage == 5{
                SELECTModelScreenView(image: "VerbModelWindow2", title: "Verb model list detail", detail: "This shows you more detailed information on each verb model.  Plus, you can conjugate the model verb to see its behavior.  You can search in the top text window.  Press the purple install button to select the model." , bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            
            if selectionModelPage == 6{
                SELECTModelScreenView(image: "SELECTShowCurrentVerbs", title: "Verb list", detail: "Scroll right to see up to 16 verbs for the current verb model.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
            
            if selectionModelPage == 7{
                SELECTModelScreenView(image: "VerbListWindow1", title: "Verb list", detail: "Scroll right to see up to 16 verbs for the current verb model.", bgColor: Color("color4"))
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if selectionModelPage <= totalSelectModelPages{
                        selectionModelPage += 1
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
                                .trim(from: 0, to: CGFloat(selectionModelPage) / CGFloat(totalPages))
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

struct SELECTModelScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("Selection Model Page") var selectionModelPage = 8
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if selectionModelPage == 1{
                    Text("Welcome to Model-Based Verb Conjugation!")
                        .font(.title)
                        .fontWeight(.semibold)
                        // Letter Spacing...
                        .kerning(1.4)
                }
                else{
                    // Back Button...
                    Button(action: {
                        withAnimation(.easeInOut){
                            selectionModelPage -= 1
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
                        selectionModelPage = 7
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

var totalSelectModelPages = 8
