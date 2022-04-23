//
//  LanguagePreferencesTenseView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import SwiftUI

struct LanguagePreferencesTenseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var body: some View {
        HStack{
//            NavigationLink(
//                destination: LanguageView(),
//                label: {
//                    Image(systemName: "flag.circle.fill")
//                })
//                .accentColor(.red)
//                .padding(10)
//            Spacer()
            NavigationLink(
                destination: PreferencesView(),
                label: {
                    Image(systemName: "gearshape.fill")
                })
                .accentColor(.purple)
                .padding(10)
            Spacer()
           
            
        }.background(Color.yellow)
            .padding(2)
        
    }
}

