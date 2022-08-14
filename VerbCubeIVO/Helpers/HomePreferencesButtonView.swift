//
//  HomePreferencesButtonView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/2/22.
//

import SwiftUI

struct HomePreferencesButtonView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        HStack{
            NavigationLink(destination: ScrollViewVC(languageViewModel: languageViewModel)){
                Image(systemName: "house.fill")}
            Spacer()
            NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel)){
                Image(systemName: "globe")}
        }
    }
}

