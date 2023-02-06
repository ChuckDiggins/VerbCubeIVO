////
////  NavigationStackView.swift
////  Feather2
////
////  Created by Charles Diggins on 11/20/22.
////
//
//import SwiftUI
//import JumpLinguaHelpers
//
//
//enum Wrapper: String, Hashable, CaseIterable {
//    case See, Learn, Test, Circle
//    
//    var name: String{
//        self.rawValue
//    }
//}
//
//struct NavigationStackView: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
//    @State private var path: [Wrapper] = []
//    
//    @State var selectedTab: Int = 0
//    @State var currentLanguage = LanguageType.Spanish
//    @State var selectedCount = 0
//    @State var selectedModelString = ""
//    @State var showTest = false
//    
//    var body: some  View{
//        ZStack{
//            Color("BethanyNavalBackground")
//                .ignoresSafeArea()
//            
//            NavigationStack(path: $path){
//                if languageViewModel.getSelectedNewVerbModelType() != .undefined {
//                    SelectedTypeView(selectedNewVerbModelType: languageViewModel.getSelectedNewVerbModelType(), selectedModelString: $selectedModelString)
//                    Text("\(languageViewModel.getFilteredVerbs().count) active verbs")
//                }
//                else {
//                    NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount,
//                                        selectedNewVerbModelType: languageViewModel.getSelectedNewVerbModelType(),selectedModelString: $selectedModelString ))
//                    {
//                    Text("Select New Verb Model")
//                    }.modifier(BlueButtonModifier())
//                }
//                
//                if languageViewModel.getSelectedVerbModelList().count>0 {
//                    List{
//                        NavigationLink(Wrapper.See.name, value: Wrapper.See)
//                        NavigationLink(Wrapper.Learn.name, value: Wrapper.Learn)
//                        NavigationLink(Wrapper.Test.name, value: Wrapper.Test)
//                        NavigationLink(Wrapper.Circle.name, value: Wrapper.Circle)
//                    }
//
//                    .navigationTitle("Verbs of a Feather")
//                    .navigationDestination(for: Wrapper.self) {wrapper in
//                        switch wrapper {
//                        case .See: VerbSeeWrapper()
//                        case .Learn: VerbLearnWrapper()
//                        case .Test: VerbTestWrapper()
//                        case .Circle: CircleButtonView(languageViewModel: languageViewModel, selectedNewVerbModelType: .Regular)
//                        }
//                    }
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarLeading){
//                            Button{
//                                goBack()
//                            } label: {
//                                Image(systemName: "chevron.left")
//                            }
//                        }
//                        ToolbarItemGroup(placement: .navigationBarTrailing){
//                            NavigationLink(destination: FindMyVerbDispatcher(languageViewModel: languageViewModel ))
//                            {
//                            Label("Find", systemImage: "magnifyingglass")
//                            }
//                            NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel ))
//                            {
//                            Label("Settings", systemImage: "gear")
//                            }
//                        }
//
//                    }
//                }
//            }
//            
//            .accentColor(.green)
//            .foregroundColor(Color("BethanyGreenText"))
//            .background(Color("BethanyNavalBackground"))
//            .font(.headline)
//            .onAppear{
//                path = [Wrapper]()
//                selectedCount = languageViewModel.getSelectedVerbModelList().count
//                if languageViewModel.getSelectedNewVerbModelType() != .undefined && languageViewModel.getSelectedVerbModelList().count > 0 {
//                    selectedModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
//                } else {
//                    selectedModelString = "No model selected"
//                }
//                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
//                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//                UINavigationController.attemptRotationToDeviceOrientation()
//                //                UINavigationController.setNeedsUpdateOfSupportedInterfaceOrientations()
//            }
////            .onChange(of: selectedNewVerbModelType){
////                fillSpecialPatternTypeList()
////            }
//            
//
//        }
//    }
//    
//    func goBack(){
//        _ = path.popLast()
//    }
//}
//
////struct NavigationStackView_Previews: PreviewProvider {
////    static var previews: some View {
////        NavigationStackView()
////    }
////}
