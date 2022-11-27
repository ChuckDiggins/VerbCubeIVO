//
//  NavStackRouter.swift
//  Feather2
//
//  Created by Charles Diggins on 11/19/22.
//

import SwiftUI

class Router : ObservableObject{
    @Published var path = NavigationPath()
    
    func reset(){
        path = NavigationPath()
    }
}

