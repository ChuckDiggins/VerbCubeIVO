//
//  MenuViewModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

//class MenuViewModel : ObservableObject{
//    @ObservedObject var languageViewModel: LanguageViewModel
//    var verbCubeIsActive = false
//    
//    @Published var menus: [MenuItem] = [
//        MenuItem(color: .green, icon: "pencil.circle.fill", menuView: AnyView(QuizWrapper()), selected: true),
//        MenuItem(color: .purple, icon: "tray.full", menuView: AnyView(CollectionsWrapper()), selected: true),
//        MenuItem(color: .red, icon: "cube.box.fill", menuView: AnyView(GeneralCubeWrapper()), selected: true),
//        MenuItem(color: .blue, icon: "hare.fill", menuView: AnyView(ExerciseWrapper()), selected: true),
//        MenuItem(color: .orange, icon: "folder.circle.fill", menuView: AnyView(ModelPatternQuizWrapper(languageViewModel: languageViewModel)), selected: true),
////        MenuItem(color: .orange, icon: "folder.circle.fill", menuView: AnyView(WordCollectionListView()), selected: true),
//    ]
//    
//    var selectedMenu: MenuItem {
//        guard let selected = menus.filter({$0.selected}).first else {
//            fatalError("You need to set on of the MenuItems in MenuViewModel as selected: true")
//        }
//        return selected
//    }
//    
//    
//    
//}
//
