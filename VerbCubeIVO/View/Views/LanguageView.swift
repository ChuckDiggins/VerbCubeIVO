//
//  LanguageView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import SwiftUI
import JumpLinguaHelpers

struct LanguageView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    
    var body: some View {
        VStack{
            Button(action: {
                currentLanguage = .Spanish
                languageViewModel.setLanguage(language: currentLanguage)
            }){
                HStack{
                    Text("🇪🇸")
                    Text("Spanish")
                }
            }.font(currentLanguage == .Spanish ? .title : .system(size: 20) )
                .foregroundColor(currentLanguage == .Spanish ? Color.red : Color.orange)
            
            Button(action: {
                currentLanguage = .French
                languageViewModel.setLanguage(language: currentLanguage)
            }){
                HStack{
                    Text("🇫🇷")
                    Text("French")
                }
            }.font(currentLanguage == .French ? .title : .system(size: 20) )
                .foregroundColor(currentLanguage == .French ? Color.red : Color.orange)
            
            Button(action: {
                currentLanguage = .English
                languageViewModel.setLanguage(language: currentLanguage)
            }){
                HStack{
                    Text("🇬🇧")
                    Text("English")
                }
            }.font(currentLanguage == .English ? .title : .system(size: 20) )
                .foregroundColor(currentLanguage == .English ? Color.red : Color.orange)
        }.onAppear{
            currentLanguage = languageViewModel.getCurrentLanguage()
        }
    }
}

//
//struct LanguageView_Previews: PreviewProvider {
//    static var previews: some View {
//        LanguageView()
//    }
//}
