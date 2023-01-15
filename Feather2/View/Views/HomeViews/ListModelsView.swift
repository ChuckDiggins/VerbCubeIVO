//
//  ListModelsView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/2/22.
//

import SwiftUI
import JumpLinguaHelpers

class MPSModel :   ObservableObject{
    @Published var  mpsList : [ModelPatternStruct]?
    var verbEnding = VerbEnding.AR
    
    func setup(_ mpsList: [ModelPatternStruct]){
        self.mpsList = mpsList
    }
    
    func set(_ mpsModel: MPSModel){
        self.mpsList = mpsModel.mpsList
    }
}

struct ModelPatternStruct : Identifiable {
//    static func == (lhs: ModelPatternStruct, rhs: ModelPatternStruct) -> Bool {
//        lhs.model.modelVerb == rhs.model.modelVerb
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(model.modelVerb)
//    }
//
    var id = 0
    var model = RomanceVerbModel()
    var count = 0
    var completed = false
    
    init(id: Int, model: RomanceVerbModel, count: Int, completed: Bool = false){
        self.id = id
        self.model = model
        self.count = count
        self.completed = completed
    }
}

struct ListModelsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @State var currentVerbEnding = VerbEnding.ER
    @State var currentVerbEndingString = "Current ending = ER"
//    @State var currentModelVerbType = VerbModelType.undefined
    @State var currentModelVerbTypeString = "regular"
    @State private var currentLanguage = LanguageType.Spanish
    @State  private var modelDictionary: [String: Int] = [:]
    
    @State var modelStructList = [ModelPatternStruct]()
    @State private var rvmList = [RomanceVerbModel]()
    var backgroundColor = Color.yellow
    var foregroundColor = Color.black
    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                Button{
                    changeVerbEnding()
                    currentVerbEndingString = "Current ending = \(currentVerbEnding.rawValue)"
                } label: {
                    Text(currentVerbEndingString)
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                } .modifier(ModelTensePersonButtonModifier())
                
                PlotModelStructs(modelStructList: modelStructList)

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
    
//    func changeModelVerbType(){
//        switch currentModelVerbType {
//        case .regular: currentModelVerbType = .critical
//        case .critical: currentModelVerbType = .special
//        case .special: currentModelVerbType = .importantAR
//        case .importantAR: currentModelVerbType = .oneOff
//        case .oneOff: currentModelVerbType = .regular
//        }
//        currentModelVerbTypeString = currentModelVerbType.rawValue
//        loadVerbModels()
//    }
//
    func loadVerbModels(){
        let verbEndingModelList = languageViewModel.getModelsWithVerbEnding(verbEnding: currentVerbEnding)
        modelStructList.removeAll()
        
        for model in verbEndingModelList {
            let verbList = languageViewModel.findVerbsOfSameModel(targetID: model.id)
            modelDictionary.updateValue(verbList.count, forKey: model.modelVerb)
        }
        let sortInfo = modelDictionary.sorted(by: { $0.value > $1.value } )
        
        sortInfo.forEach {key, value in
//          print(key)
            for model in verbEndingModelList {
                if model.modelVerb == "\(key)" {
                    modelStructList.append(ModelPatternStruct(id: model.id, model: model, count: value))
                    break
                }
            }
        }
        
    }
    
}
struct ListModelsView_Previews: PreviewProvider {
    static var previews: some View {
        ListModelsView(languageViewModel: LanguageViewModel(language: .Spanish))
    }
}

struct PlotModelStructs: View {
   
    @State var modelStructList : [ModelPatternStruct]
    var fontSize = Font.callout
    
    var body: some View {
        let gridFixSize = CGFloat(200.0)
        let gridItems = [GridItem(.fixed(gridFixSize)),
                         GridItem(.fixed(gridFixSize))]
    
        LazyVGrid(columns: gridItems, spacing: 5){
            ForEach (0..<modelStructList.count, id: \.self){ i in
                if modelStructList[i].count > 0
                {
                Button{
                    //                                selectedModel(index: i)
                } label: {
                    HStack{
                        Text(modelStructList[i].model.modelVerb)
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
    }
}

struct PlotModelVerbs: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @State var modelStructList : [ModelPatternStruct]
    var fontSize = Font.callout
    
    var body: some View {
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
                            Text(modelStructList[i].model.modelVerb)
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
    }
    func selectedModel(index: Int){
        let verbList = languageViewModel.findVerbsOfSameModel(targetID: modelStructList[index].id)
        languageViewModel.setFilteredVerbList(verbList: verbList)
        languageViewModel.initializeStudentScoreModel()
        dismiss()
    }
}

struct ListSortedModelsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    @State var currentVerbEnding = VerbEnding.ER
    @State var currentVerbEndingString = "Current ending = ER"
    @State private var currentLanguage = LanguageType.Spanish
    @State  private var modelDictionary: [String: Int] = [:]
    
    @State var modelStructList = [ModelPatternStruct]()
    @State private var rvmList = [RomanceVerbModel]()
   
    @State var modelVerbTypeString = "regular"
    
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
                
                PlotModelVerbs(languageViewModel: languageViewModel, modelStructList: modelStructList)
            }.onAppear{
                loadVerbModels()
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerbEndingString = "Current ending = \(currentVerbEnding.rawValue)"
            }
        }
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
            modelDictionary.updateValue(verbList.count, forKey: model.modelVerb)
        }
        let sortInfo = modelDictionary.sorted(by: { $0.value > $1.value } )
        
        sortInfo.forEach {key, value in
          print(key)
            for model in verbEndingModelList {
                if model.modelVerb == "\(key)" {
                    modelStructList.append(ModelPatternStruct(id: model.id, model: model, count: value))
                    break
                }
            }
        }
        
    }
    
    
}
