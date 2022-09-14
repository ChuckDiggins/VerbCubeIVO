//
//  TeachMeNavigationStackView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/5/22.
//

import SwiftUI
import JumpLinguaHelpers

enum TeachMeMode : String {
    case Model, Pattern, SingleVerb
}

struct TeachMeNavigationStackView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Spanish
    @State var currentLanguageStr = "Agnostic"
    @State var currentModelString = ""
    @State var path = NavigationPath()
    @State var currentIndex = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink(FeatherModel.model.name, value: FeatherModel.model)
                NavigationLink(FeatherPattern.pattern.name, value: FeatherPattern.pattern)
            }
            .navigationTitle("Teach Me Verb Models")
            .navigationDestination(for: FeatherModel.self) { model in
                TeachMeModelView2(languageViewModel: languageViewModel, model: model){ nextModel in
                    NavigationLink(value: nextModel) {
                        Text("Next \(nextModel.rawValue)")
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(for: FeatherPattern.self) { pattern in
                TeachMePatternView(languageViewModel: languageViewModel, pattern: pattern){ nextPattern in
                    NavigationLink(value: nextPattern) {
                        Text("Next \(nextPattern.rawValue)")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    func next() {
        currentIndex += 1
        let count = FeatherModel.all.count
        if currentIndex > count {
            currentIndex = 0
        }
        path.append( FeatherModel.all[currentIndex])
    }
    
    func back() {
        currentIndex -= 1
        let count = FeatherModel.all.count
        if currentIndex < 0 {
            currentIndex = count - 1
        }
        path.append( FeatherModel.all[currentIndex])
    }
    }
    
//    struct PointfreeNavigationStackView_Previews: PreviewProvider {
//        static var previews: some View {
//            TeachMeNavigationStackView()
//        }
//    }
    
    
    
struct SelectTenseView: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentTenseString = ""
    
    var body: some View {
        VStack{
            VStack{
                Text("Language: \(languageViewModel.getCurrentLanguage().rawValue)")
                Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
            }.background(.yellow)
                .padding()
            
            Button(action: {
                currentTenseString = languageViewModel.getNextTense().rawValue
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }.frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
        }
        Spacer()
    }
}

//                                                                          get this from Preferences
struct SelectPersonsView: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentTenseString = ""
    
    var body: some View {
        VStack{
            VStack{
                Text("Language: \(languageViewModel.getCurrentLanguage().rawValue)")
                Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
            }.background(.yellow)
                .padding()
            
            Button(action: {
                currentTenseString = languageViewModel.getNextTense().rawValue
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }.frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
        }
        Spacer()
    }
}



