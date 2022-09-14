//
//  ListModelsView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/2/22.
//

import SwiftUI
import JumpLinguaHelpers

struct ModelPatternStruct {
    var id = 0
    var name = ""
    var count = 0
    init(id: Int, name: String, count: Int){
        self.id = id
        self.name = name
        self.count = count
    }
}

struct ListModelsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @State var currentVerbEnding = VerbEnding.ER
    @State var currentVerbEndingString = "Current ending = ER"
    @State private var currentLanguage = LanguageType.Spanish
    @State var modelStructList = [ModelPatternStruct]()
    @State private var rvmList = [RomanceVerbModel]()
    var backgroundColor = Color.yellow
    var foregroundColor = Color.black
    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            ScrollView{
                Button{
                    changeVerbEnding()
                    currentVerbEndingString = "Current ending = \(currentVerbEnding.rawValue)"
                } label: {
                    Text(currentVerbEndingString)
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                } .modifier(ModelTensePersonButtonModifier())
                
                let gridFixSize = CGFloat(200.0)
                let gridItems = [GridItem(.fixed(gridFixSize)),
                                 GridItem(.fixed(gridFixSize))]
                
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach (0..<modelStructList.count, id: \.self){ i in
                        if modelStructList[i].count > 0 {
                            Button{
                                selectedModel(index: i)
                            } label: {
                                HStack{
                                    Text(modelStructList[i].name)
                                    Text(": \(modelStructList[i].count)")
                                }
                            }
                        }
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .cornerRadius(8)
                    .font(fontSize)
                }
                .foregroundColor(Color("BethanyGreenText"))
                    .background(Color("BethanyNavalBackground"))
            }.onAppear{
                loadVerbModels()
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerbEndingString = "Current ending = \(currentVerbEnding.rawValue)"
            }
        }
    }
    
    func selectedModel(index: Int){
        let verbList = languageViewModel.findVerbsOfSameModel(targetID: modelStructList[index].id)
        languageViewModel.setFilteredVerbList(verbList: verbList)
        languageViewModel.initializeStudentScoreModel()
        dismiss()
    }
    
    func changeVerbEnding(){
        switch languageViewModel.getCurrentLanguage() {
        case .Spanish:
        switch currentVerbEnding {
        case .AR:
            currentVerbEnding = .ER
        case .ER:
            currentVerbEnding = .IR
        case .IR:
            currentVerbEnding = .AR
        default:
            currentVerbEnding = .ER
        }
        case .French:
        switch currentVerbEnding {
        case .ER:
            currentVerbEnding = .IR
        case .IR:
            currentVerbEnding = .RE
        case .RE:
            currentVerbEnding = .ER
        default:
            currentVerbEnding = .RE
        }
        default:
            break
        }
        
        loadVerbModels()
    }
    
    func loadVerbModels(){
        let verbEndingModelList = languageViewModel.getModelsWithVerbEnding(verbEnding: currentVerbEnding)
        modelStructList.removeAll()
        for model in verbEndingModelList {
            let verbList = languageViewModel.findVerbsOfSameModel(targetID: model.id)
            modelStructList.append(ModelPatternStruct(id: model.id, name: model.modelVerb, count: verbList.count))
        }
    }
    
}
struct ListModelsView_Previews: PreviewProvider {
    static var previews: some View {
        ListModelsView(languageViewModel: LanguageViewModel(language: .Spanish))
    }
}
