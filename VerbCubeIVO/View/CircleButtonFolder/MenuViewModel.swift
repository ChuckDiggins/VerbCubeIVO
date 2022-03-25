//
//  MenuViewModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

class MenuViewModel : ObservableObject{
    var verbCubeIsActive = false
    
    @Published var menus: [MenuItem] = [
        MenuItem(color: .green, icon: "person.fill", menuView: AnyView(UserSelectionWrapper()), selected: true),
        MenuItem(color: .purple, icon: "tray.full", menuView: AnyView(CollectionsWrapper()), selected: true),
        MenuItem(color: .red, icon: "cube.box.fill", menuView: AnyView(GeneralCubeWrapper()), selected: true),
        MenuItem(color: .blue, icon: "hare.fill", menuView: AnyView(ExerciseWrapper()), selected: true),
        MenuItem(color: .orange, icon: "folder.circle.fill", menuView: AnyView(DataToRealmView()), selected: true),
    ]
    
    var selectedMenu: MenuItem {
        guard let selected = menus.filter({$0.selected}).first else {
            fatalError("You need to set on of the MenuItems in MenuViewModel as selected: true")
        }
        return selected
    }
    
    
    
}

