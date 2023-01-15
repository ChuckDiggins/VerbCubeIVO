//
//  MenuViewModel.swift
//  Feather2
//
//  Created by Charles Diggins on 11/21/22.
//

import Foundation

import SwiftUI

class MenuViewModel : ObservableObject{
    @Published var menus: [MenuItem] = [
        MenuItem(color: .red, icon: "filemenu.and.selection", menuView: AnyView(ModelSelectionWrapper()), selected: true, symbol: "🪶"),
        MenuItem(color: .green, icon: "eye.fill", menuView: AnyView(VerbSeeWrapper()), selected: true, symbol: "👁️"),
        MenuItem(color: .blue, icon: "person.fill", menuView: AnyView(VerbLearnWrapper()), selected: true, symbol: "🎓"),
        MenuItem(color: .orange, icon: "pencil.line", menuView: AnyView(VerbTestWrapper()), selected: true, symbol: "📝"),
        MenuItem(color: .purple, icon: "chart.bar", menuView: AnyView(VerbModelStatusWrapper()), selected: true, symbol: "📊"),
    ]
    
    var selectedMenu: MenuItem {
        guard let selected = menus.filter({$0.selected}).first else {
            fatalError("You need to set on of the MenuItems in MenuViewModel as selected: true")
        }
        return selected
    }

}
