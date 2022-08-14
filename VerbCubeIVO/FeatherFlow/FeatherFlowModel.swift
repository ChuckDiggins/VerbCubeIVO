//
//  FFPage1.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/1/22.
//

import SwiftUI
import JumpLinguaHelpers

enum FeatherFlowMode : String {
    case Model, Pattern, SingleVerb
}

struct FeatherFlowModel: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Spanish
    @State var currentLanguageStr = "Agnostic"
    @State var currentModelString = ""
    
    var body: some  View{
        ZStack{
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            VStack {
                
                DisclosureGroupMain()
                Spacer()
                Text("Page 1:  Selected the verb model you wish to work on.").foregroundColor(.yellow)
                Spacer()
                VStack{
                    Text("Language: \(languageViewModel.getCurrentLanguage().rawValue)")
                    Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
                    
                    
                }.background(.yellow)
                    .padding()
                
                NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                    HStack{
                        Text("Verb model:")
                        Text(currentModelString)
                        Spacer()
                        Image(systemName: "rectangle.and.hand.point.up.left.filled")
                    }
                    .frame(width: 350, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }.task {
                    setCurrentVerb()
                }
                Text("(Click to change model)")
                    .background(Color.black)
                    .foregroundColor(.orange)
                Spacer()
                NavigationLink(destination: FeatherFlowTensePage(languageViewModel: languageViewModel)) {
                    Text("Next Page (Tense)")
                        .frame(width: 350, height: 30)
                        .font(.callout)
                        .padding(2)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
            }
            .onAppear{
                currentLanguageStr = languageViewModel.getCurrentLanguage().rawValue
                languageViewModel.setFeatherFlowMode(mode: .Model)
                setCurrentVerb()
            }
           
            
        }
       
    }
    
    func setCurrentVerb(){
        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
    }
}

struct FeatherFlowTensePage: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentTenseString = ""
    
    var body: some View {
        ZStack{
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
           
            
            VStack{
                DisclosureGroupMain()
                Spacer()
                Text("Page 2:  Selected the tense you wish to work on.").foregroundColor(.yellow)
                Spacer()
                VStack{
                    Text("Language: \(languageViewModel.getCurrentLanguage().rawValue)")
                    Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
                    
                }.background(.yellow)
                    .padding()
                Spacer()
                Button(action: {
                    currentTenseString = languageViewModel.getNextTense().rawValue
                }){
                    Text("Tense: \(currentTenseString)")
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
                Text("(Click to change tense)")
                    .background(Color.black)
                    .foregroundColor(.orange)
                Spacer()
                NavigationLink(destination: FeatherFlowModelLearnView(languageViewModel: languageViewModel)) {
                    Text("Next Page (Learn Model-Based Verbs)")
                        .frame(width: 350, height: 30)
                        .font(.callout)
                        .padding(2)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
            }
            .onAppear{
                currentTenseString = languageViewModel.getCurrentTense().rawValue
            }
        }
    }
    
}
   
struct FeatherFlowModelLearnView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentVerbString = ""
    
    var body: some View {
        
        ZStack{
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            VStack{
                DisclosureGroupMain()
                Spacer()
                Text("Page 3:  Selected the model learning exercise.").foregroundColor(.yellow)
                Spacer()
                VStack{
                    Text("Language: \(languageViewModel.getCurrentLanguage().rawValue)")
                    Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
                    
                }.background(.yellow)
                    .padding()
                NavigationLink(destination: FeatherVerbMorphView(languageViewModel: languageViewModel)){
                    Text("Conjugate Verbs with Same Model")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                    Text("Verb Morphing")
                }.modifier(NavLinkModifier())
                Spacer()
                
                Spacer()
                NavigationLink(destination: ScrollViewVC(languageViewModel: languageViewModel)) {
                    Text("Exit this FeatherFlow")
                        .frame(width: 350, height: 30)
                        .font(.callout)
                        .padding(2)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
            }
        }
    }
}

struct SingleVerbPage: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentVerbString = ""
    
    var body: some View {
        
        ZStack{
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
            NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                HStack{
                    Text("Show me ")
                    Text("\(languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))").bold()
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
            }
        }
        .onAppear{
            languageViewModel.setFeatherFlowMode(mode: .SingleVerb)
        }
    }
    
    func setCurrentVerb(){
        
    }
}
       




