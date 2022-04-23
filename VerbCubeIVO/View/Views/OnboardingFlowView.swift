//
//  OnboardingFlowView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/17/22.
//

import SwiftUI
import JumpLinguaHelpers

struct OnboardingFlowView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageViewModel: LanguageViewModel
    
    
    var body: some View {
        ZStack{
            TabView{
                Button{
                    appState.hasOnboarded = true
                } label: {
                    Label("Start", systemImage: "play.fill")
                }
                .tabItem{
                    Label("Start", systemImage: "play.fill")
                }
                
                LanguageView(languageViewModel: languageViewModel)
                    .tabItem{
                        Label("Languages", systemImage: "flag.fill")
                    }
                
                TenseSelectionView(languageViewModel: languageViewModel)
                    .tabItem{
                        Label("Tenses", systemImage: "wind")
                    }      
            }
//            .tabViewStyle(.page)
//            .indexViewStyle(
//                .page(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingFlowView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlowView()
    }
}


