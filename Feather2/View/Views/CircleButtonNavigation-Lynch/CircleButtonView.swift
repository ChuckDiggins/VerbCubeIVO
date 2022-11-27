//
//  CircleButtonView.swift
//  Feather2
//
//  Created by Charles Diggins on 11/21/22.
//

import SwiftUI
import JumpLinguaHelpers

struct SelectedNewVerbTypeView: View {
    @Binding var selectedNewVerbModelType : NewVerbModelType
    @Binding var selectedModelString: String
    
    var body: some View {
        VStack{
            if selectedNewVerbModelType == .Regular {
                Text("All regular verbs")
            }
            else if selectedNewVerbModelType == .Critical {
                Text("All critical verbs")
            }
            else { Text("\(selectedModelString)") }
            
        }
        
    }
}
struct CircleView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        NavigationView{
            Spacer()
                NavigationLink(destination: CircleButtonView(languageViewModel:  languageViewModel)){
                    Text("Circle Button View")
                }.modifier(BlueButtonModifier())
            Spacer()
        }
    }
}

struct CircleButtonView: View {
    @State private var isActivated = false
    @ObservedObject var menuVM = MenuViewModel()
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var selectedModelString = "No model yet"
    @State var selectedNewVerbModelType = NewVerbModelType.undefined
    @State var selectedCount = 0
    
    var body: some View {
        ZStack {
            menuVM.selectedMenu.menuView
            ZStack {
                Color.black.opacity(isActivated ? 0.2 : 0.0)
                VStack {
                    
                    
                    Spacer()
                    ZStack{
                        ForEach(0..<menuVM.menus.count, id:\.self) { i in
                            MenuButton(isActivated: self.$isActivated, menuVM: self.menuVM, currentItemIndex: i)
                        }
                        SelectedMenuButton(isActivated: self.$isActivated, menuItem: menuVM.selectedMenu)
                    }
                    if getSelectedNewVerbModelType() != .undefined {
                        HStack{
                            Text("Selected model:")
                            SelectedNewVerbTypeView(selectedNewVerbModelType: $selectedNewVerbModelType, selectedModelString: $selectedModelString)
                        }
                        .frame(width: 300)
                        .frame(height: 35)
                        .border(.red)
                    } else {
                        Text("No verb models selected")
                    }
                }
                .navigationTitle("Verbs of a Feather")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        NavigationLink(destination: FindMyVerbDispatcher(languageViewModel: languageViewModel ))
                        {
                        Label("Find", systemImage: "magnifyingglass")
                        }
                        NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel ))
                        {
                        Label("Settings", systemImage: "gear")
                        }
                    }
                }
                
            }.onAppear{
                selectedCount = languageViewModel.getSelectedVerbModelList().count
                if languageViewModel.getSelectedNewVerbModelType() != .undefined && languageViewModel.getSelectedVerbModelList().count > 0 {
                    selectedModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
                    selectedNewVerbModelType = languageViewModel.getSelectedNewVerbModelType()
                } else {
                    selectedModelString = "No model selected"
                    selectedNewVerbModelType = NewVerbModelType.undefined
                }
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
        .edgesIgnoringSafeArea(isActivated ? .all : .horizontal)
        .animation(.spring())
    }
    
    func getSelectedNewVerbModelType()->NewVerbModelType{
        selectedNewVerbModelType = languageViewModel.getSelectedNewVerbModelType()
        return selectedNewVerbModelType
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(languageViewModel: LanguageViewModel())
    }
}
