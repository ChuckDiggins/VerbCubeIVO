////
////  VerbSelectionViewLazy.swift
////  VerbCubeIVO
////
////  Created by Charles Diggins on 3/5/22.
////
//
//import SwiftUI
//import JumpLinguaHelpers
//
//
//
//struct VerbSelectionViewLazy: View {
//    @StateObject var languageEngine: LanguageEngine
////    @State var languageEngine = LanguageEngine()
//    @ObservedObject var languageViewModel: LanguageViewModel
//
//    @Environment(\.dismiss) private var dismiss
//    
//    @State var verbIDEnding = [VerbIDEnding]()
//    @State var verbFilters = [VerbModelFilter]()
//    @State var verbEndingCount = [Int]()
//
//    @State var categoryIndex = 0
//    @State var showSheet = false
//
//    var body: some View {
////        NavigationView {
//        VStack{
//                Button(action: {
//                    dismiss()
//                }){
//                    Text("Done").padding(.vertical).padding(.horizontal, 25).foregroundColor(.white)
//                }
//            let gridFixSize = CGFloat(100.0)
//            let gridItems = [GridItem(.fixed(gridFixSize)),
//                                         GridItem(.fixed(gridFixSize)),
////                                         GridItem(.fixed(gridFixSize)),
//                                         GridItem(.fixed(gridFixSize))]
//            
//            let filterGridItems = [GridItem(.flexible()),
//                                   GridItem(.flexible())]
//            
//            LazyVGrid(columns: gridItems, spacing: 5){
//                ForEach(0..<verbIDEnding.count, id:\.self){ index in
//                    //don't show the button if there aren't any verbs with this ending
//                    if verbEndings[index].count > 0 {
//                        VerbIDButton(verbEndings: verbIDEnding, index: index,
//                                     backgroundColor: verbEndings[index].isSelected ? .yellow : .gray, foregroundColor: .black, fontSize: Font.subheadline, function: showFilteredVerbs) 
//                    }
//                }
//            }
//
//            NavigationLink(destination: FilteredVerbListView(languageViewModel: languageViewModel, languageEngine: languageEngine)){
//                HStack{
//                    Text("Language: \(languageEngine.getCurrentLanguage().rawValue)")
//                    Spacer()
//                    Text("Filtered verb list:")
//                    Text("\(languageEngine.getFilteredVerbs().count) active verbs")
//                    Divider()
//                    Image(systemSymbol: .magnifyingglass).foregroundColor(.red).padding()
//                }
//            }.frame(width: .infinity, height: 50)
//            .padding(.leading, 10)
//            .cornerRadius(10)
//
//            
//            Text("Filtered by:")
//            
//            LazyVGrid(columns: filterGridItems, spacing: 5){
//                ForEach(0..<verbFilters.count, id:\.self){ index in
//                    VerbFilterButton(verbFilters: verbFilters, index: index,
//                                 backgroundColor: verbFilters[index].color, foregroundColor: .black, fontSize: Font.subheadline, function: showFilteredVerbs)
//                }
//            }
//            Spacer()
//        }//VStack
////
////        .navigationTitle("Verb stuff")
////        .font(.footnote)
////        }
//        .onAppear() {
//            verbIDEnding = getVerbIDEndings()
//            verbFilters = getVerbFilters()
//            
//            print("LazyVerbSelection: language = \(languageEngine.getCurrentLanguage().rawValue)")
//            initializeVerbEndings(languageEngine: languageEngine)
//            initializeVerbFilters(languageEngine: languageEngine)
//            
////            fillVerbEndingCounts(languageEngine: languageEngine)
////            fillVerbFilterCounts(languageEngine: languageEngine)
////            fillFilteredVerbs(languageEngine: languageEngine, verbEndings : verbIDEnding, verbFilters : verbFilters)
//            languageEngine.resetFilteredVerbs()
//        }
//    }
//
//    func showFilteredVerbs(verbEndings: [VerbIDEnding]){
//        fillFilteredVerbs(languageEngine: languageEngine, verbEndings: verbIDEnding, verbFilters : verbFilters)
//    }
//       
//    func showFilteredVerbs(verbFilters: [VerbModelFilter]){
//        fillFilteredVerbs(languageEngine: languageEngine, verbEndings: verbIDEnding, verbFilters : verbFilters)
//    }
//      
//    
//
//}//VerbSelectionView
//
//
//
//struct VerbIDButton: View {
//    @State var verbEndings: [VerbIDEnding]
//    var index : Int
//    var backgroundColor: Color
//    var foregroundColor: Color
//    var fontSize : Font
//    
//    var function: (_ verbEndings: [VerbIDEnding]) -> Void
//    
//    var body: some View {
//        Button(action: {
//            verbEndings[index].isSelected.toggle()
//            print("VerbEndings [\(index)] = \(verbEndings[index].isSelected)")
//            function(verbEndings)
//        }){
//            Text(verbEndings[index].name)
//        }
//        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
//        .background(backgroundColor)
//        .foregroundColor(foregroundColor)
//        .cornerRadius(8)
//        .font(fontSize)
//        
//    }
//}
//
//struct VerbFilterButton: View {
//    @State var verbFilters: [VerbModelFilter]
//    var index : Int
//    var backgroundColor: Color
//    var foregroundColor: Color
//    var fontSize : Font
//    
//    var function: (_ verbFilters: [VerbModelFilter]) -> Void
//    
//    var body: some View {
//        Button(action: {
//            verbFilters[index].isSelected.toggle()
////            print("VerbFilter [\(index)] = \(verbFilters[index].isSelected)")
//            function(verbFilters)
//        }){
//            HStack{
//                Text(verbFilters[index].name)
//                Spacer()
//                Image(systemSymbol: verbFilters[index].isSelected ? .circleFill : .circle)
//            }
//        }
//        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
//        .background(backgroundColor)
//        .foregroundColor(foregroundColor)
//        .cornerRadius(8)
//        .font(fontSize)
//        
//    }
//}
//
