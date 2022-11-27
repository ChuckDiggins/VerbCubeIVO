//
//  MenuItem.swift
//  Feather2
//
//  Created by Charles Diggins on 11/21/22.
//

import SwiftUI

struct MenuItem {
    let id = UUID()
    let color: Color
    let icon: String
    let menuView: AnyView
    var selected: Bool
    let symbol : String
}

