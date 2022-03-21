//
//  CircleButtonNavigationView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

struct CircleButtonNavigationView: View {
    @State private var isActivated = false
    @ObservedObject var menuVM = MenuViewModel()
    
    var body: some View {
        NavigationView {
        ZStack {
            menuVM.selectedMenu.menuView
            ZStack {
                Color.black.opacity(isActivated ? 0.2 : 0.0)
                VStack {
                    Spacer()
                    ZStack{
                        ForEach(0..<menuVM.menus.count) { i in
                            MenuButton(isActivated: self.$isActivated, menuVM: self.menuVM, currentItemIndex: i)
                        }
                        SelectedMenuButton(isActivated: self.$isActivated, menuItem: menuVM.selectedMenu)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(isActivated ? .all : .trailing)
        .animation(.spring())
        }
        
    }
}

struct CircleButtonNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonNavigationView()
    }
}
