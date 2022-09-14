//
//  HomePreferencesButtonView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/2/22.
//

import SwiftUI

struct PreferencesButtonView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        HStack{
            Spacer()
            NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel)){
                Image(systemName: "globe")
            }
        }
    }
}

