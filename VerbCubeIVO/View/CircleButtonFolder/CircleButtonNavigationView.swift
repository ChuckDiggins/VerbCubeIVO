//
//  CircleButtonNavigationView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

//struct CircleButtonNavigationView: View {
//    @EnvironmentObject var appState: AppState
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//    @State private var isActivated = false
//    @ObservedObject var menuVM = MenuViewModel()
//    @State private var scale: CGFloat = 1
//    
//    
//    var body: some View {
////        NavigationView {
//            ZStack {
//                menuVM.selectedMenu.menuView
//                ZStack {
//                    Color.black.opacity(isActivated ? 0.2 : 0.0)
//                    VStack {
//                        Spacer()
//                        ZStack{
//                            ForEach(0..<menuVM.menus.count, id: \.self) { i in
//                                MenuButton(isActivated: self.$isActivated, menuVM: self.menuVM, currentItemIndex: i)
//                            }
//                            SelectedMenuButton(isActivated: self.$isActivated, menuItem: menuVM.selectedMenu)
//                        }
//                    }
//                }
//            }
//            .edgesIgnoringSafeArea(isActivated ? .all : .trailing)
//            .animation(.spring(), value: scale)
//            .navigationBarItems(leading: Button(action : {
//                            appState.hasOnboarded = false
//                            self.mode.wrappedValue.dismiss()
//                
//                        }){
//                            Image(systemName: "arrow.left")
//                        })
//           
////        }
////        .navigationViewStyle(StackNavigationViewStyle())
//        
//    }
//}
//
//struct CircleButtonNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleButtonNavigationView()
//    }
//}
