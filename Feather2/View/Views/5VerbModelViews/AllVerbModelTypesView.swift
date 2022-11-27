//
//  ActiveSelectedCompletedRegularVerbView.swift
//  Feather2
//
//  Created by Charles Diggins on 10/26/22.
//

import SwiftUI
import JumpLinguaHelpers

struct SelectedTypeView: View {
    var selectedNewVerbModelType : NewVerbModelType
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

struct NewVerbTypePicker: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Binding var selectedNewVerbModelType : NewVerbModelType
    @State var newVerbTypeList = [NewVerbModelType]()
    var function: () -> Void
    var body: some View{
        let gridFixSize = CGFloat(200.0)
        let gridItems = [GridItem(.fixed(gridFixSize)),
                         GridItem(.fixed(gridFixSize)),
                        ]
        
        LazyVGrid(columns: gridItems, spacing: 5){
            ForEach (newVerbTypeList, id:\.self){ type in
                Button{
                    languageViewModel.setSelectedNewVerbModelType(selectedType: type)
                    function()
                } label: {
                    Text(type.getTypeName())
                        .foregroundColor(type == languageViewModel.getSelectedNewVerbModelType() ? .red : Color("BethanyGreenText"))
                        .font(.caption)
                }
            }
        }
        .onAppear{
            switch selectedNewVerbModelType {
            case .Regular, .Critical:
                newVerbTypeList = [NewVerbModelType]()
            case .Irregular:
                newVerbTypeList = NewVerbModelType.irregularSpanishVerbModelTypeList
            case .StemChanging1,.StemChanging2:
                newVerbTypeList = NewVerbModelType.stemChangingSpanishVerbModelTypeList
            case .SpellChanging1, .SpellChanging2:
                newVerbTypeList = NewVerbModelType.spellChangingSpanishVerbModelTypeList
            case .undefined:
                newVerbTypeList = [NewVerbModelType]()
            }
        }
    }
}

struct SpecialPatternTypePicker: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Binding var selectedSpecialPatternType : SpecialPatternType
    var function: () -> Void

    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
            VStack{
                
                Text("Pattern List").font(.callout).foregroundColor(Color("ChuckText1"))
                
                VStack{
                    let gridFixSize = CGFloat(100.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]
                    
                    LazyVGrid(columns: gridItems, spacing: 5){
                        ForEach (languageViewModel.getCurrentSpecialPatternTypeList(), id:\.self){ pattern in
                            Button{
                                languageViewModel.setSelectedSpecialPatternType(selectedPattern: pattern)
                                function()
                            } label: {
                                Text(pattern.rawValue)
                                    .foregroundColor(pattern == languageViewModel.getSelectedSpecialPatternType() ? .red : Color("BethanyGreenText"))
                            }
                        }
                    }
                }
            }
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30, maxHeight: 150)
        .cornerRadius(8)
        .font(fontSize)
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
    }
}

struct AllVerbModelTypesView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCount: Int
    @State var selectedNewVerbModelType: NewVerbModelType
    @State var selectedSpecialPatternType = SpecialPatternType.e2ie
    @Binding var selectedModelString : String
    @State var selectedVerbModel = RomanceVerbModel()
    @State var selectedVerbEnding = VerbEnding.ALL
    @ObservedObject var homemadeBarChartMgr = HomemadeBarChartManager()
    @State private var currentLanguage = LanguageType.Spanish
    @State private var patternRelatedBarList = [Bar]()
    
    var body: some View {
        VStack(spacing: 3) {
            HStack{
                Text("Select: ")
                Button{
                    languageViewModel.setCurrentVerbModel(model: homemadeBarChartMgr.selectedModel)
                    fillSelectedModelsAndFindTheirVerbs()
                    selectedModelString = homemadeBarChartMgr.selectedModel.modelVerb
                    print("Select button: selectedType \(selectedNewVerbModelType.getTypeName()): model \(selectedModelString)")
                    dismiss()
                } label: {
                    if selectedNewVerbModelType == .Regular {
                        Text("All regular verbs")
                    }
                    else if selectedNewVerbModelType == .Critical {
                        Text("All critical verbs")
                    }
                    else { Text("\(homemadeBarChartMgr.selectedModel.modelVerb)") }
                }.modifier(NeumorphicTextfieldModifier())
            }
            if selectedNewVerbModelType != .Regular && selectedNewVerbModelType != .Critical {
                NewVerbTypePicker(languageViewModel: languageViewModel, selectedNewVerbModelType: $selectedNewVerbModelType, function: fillSpecialPatternTypeList)
                Divider().frame(height:2).background(.yellow)
                if languageViewModel.getCurrentSpecialPatternTypeList().count>0 {
                    SpecialPatternTypePicker(languageViewModel: languageViewModel, selectedSpecialPatternType: $selectedSpecialPatternType, function: fillVerbListForSelectedPatternType)
                    Divider().frame(height:2).background(.yellow)
                    GeneralVerbBarChartView(languageViewModel: languageViewModel, homemadeBarChartMgr: homemadeBarChartMgr, selectedNewVerbType: $selectedNewVerbModelType, selectedVerbEnding: $selectedVerbEnding)
                }
            }
        }.onAppear{
//            selectedNewVerbModelType = languageViewModel.getSelectedNewVerbModelType()
            switch selectedNewVerbModelType {
            case .Regular, .Critical:
                fillSelectedModelsAndFindTheirVerbs()
//                dismiss()
            case .StemChanging1:
                languageViewModel.setSelectedNewVerbModelType(selectedType: selectedNewVerbModelType)
                selectedSpecialPatternType = .o2ue
                languageViewModel.setSelectedSpecialPatternType(selectedPattern: selectedSpecialPatternType)
                selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
                fillSpecialPatternTypeList()
            case .SpellChanging1:
                languageViewModel.setSelectedNewVerbModelType(selectedType: selectedNewVerbModelType)
                selectedSpecialPatternType = .a2aig
                languageViewModel.setSelectedSpecialPatternType(selectedPattern: selectedSpecialPatternType)
                selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
                fillSpecialPatternTypeList()
            case .Irregular:
                languageViewModel.setSelectedNewVerbModelType(selectedType: selectedNewVerbModelType)
                selectedSpecialPatternType = .i_pret
                languageViewModel.setSelectedSpecialPatternType(selectedPattern: selectedSpecialPatternType)
                selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
                fillSpecialPatternTypeList()
            default:
                selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
                fillSpecialPatternTypeList()
            }
        }
        
        .onDisappear{
            _ = languageViewModel.computeVerbsExistForAll3Endings()
            languageViewModel.fillVerbCubeAndQuizCubeLists()
        }
        
    }
    
    func dumpPatternList(){
        print("dumpPatternList")
        for p in languageViewModel.getCurrentSpecialPatternTypeList() {
            print(p.rawValue)
        }
    }
    func fillVerbListForSelectedPatternType(){
        selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
        let mpsList = getModelPatternStructListAtSelectedTypeSelectedPatternAndSelectedEnding()
        homemadeBarChartMgr.createBarList(mpsList: mpsList, maxCount: 100)
    }
    
    func fillSpecialPatternTypeList(){
        var patternList = [SpecialPatternType]()
        
        switch languageViewModel.getSelectedNewVerbModelType() {
        case .StemChanging1: patternList = SpecialPatternType.stemChangingSpanish1
        case .StemChanging2: patternList = SpecialPatternType.stemChangingSpanish2
        case .SpellChanging1: patternList = SpecialPatternType.spellChangingSpanish1
        case .SpellChanging2: patternList = SpecialPatternType.spellChangingSpanish2
        case .Irregular: patternList = SpecialPatternType.irregPreteriteSpanish
        default: break
        }
        languageViewModel.setCurrentSpecialPatternTypeList(patternList: patternList)
        setSelectedSpecialPatternType(patternList: patternList)
        
        selectedNewVerbModelType = languageViewModel.getSelectedNewVerbModelType()
        selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
        
        createBarListForPatternType()
    }
    
    func setSelectedSpecialPatternType(patternList: [SpecialPatternType]){
        languageViewModel.setSelectedSpecialPatternType(selectedPattern: patternList[0])
        for pattern in patternList {
            let verbs = languageViewModel.getVerbsForPatternGroup(patternType: pattern)
            if verbs.count > 0 {
                languageViewModel.setSelectedSpecialPatternType(selectedPattern: pattern)
                break
            }
        }
    }
    
    func createBarListForPatternType(){
        let mpsList = getModelPatternStructListAtSelectedTypeAndEnding()
        homemadeBarChartMgr.createBarList(mpsList: mpsList, maxCount: 100)
        patternRelatedBarList.removeAll()
        for bar in homemadeBarChartMgr.getBars(){
            let spt = languageViewModel.getPatternForGivenVerbModelTypeForThisVerbModel(verbModel: bar.model, verbType: languageViewModel.getSelectedNewVerbModelType())
            if spt == languageViewModel.getSelectedSpecialPatternType(){
                patternRelatedBarList.append(bar)
            }
        }
        homemadeBarChartMgr.setBarList(barList: patternRelatedBarList)
    }
    
    func fillSelectedModelsAndFindTheirVerbs(){
        vmecdm.setAllSelected(flag: false)
        languageViewModel.setSelectedNewVerbModelType(selectedType: selectedNewVerbModelType)
        switch selectedNewVerbModelType{
        case .Regular:
            vmecdm.setSelected(verbModelString: "regularAR", flag: true)
            vmecdm.setSelected(verbModelString: "regularER", flag: true)
            vmecdm.setSelected(verbModelString: "regularIR", flag: true)
            languageViewModel.fillSelectedVerbModelListAndPutAssociatedVerbsinFilteredVerbList(maxVerbCountPerModel:5)
        case .Critical:
            vmecdm.setSelected(verbModelString: "estar", flag: true)
            vmecdm.setSelected(verbModelString: "ser", flag: true)
            vmecdm.setSelected(verbModelString: "haber", flag: true)
            vmecdm.setSelected(verbModelString: "hacer", flag: true)
            vmecdm.setSelected(verbModelString: "oír", flag: true)
            vmecdm.setSelected(verbModelString: "ir", flag: true)
            vmecdm.setSelected(verbModelString: "ver", flag: true)
            vmecdm.setSelected(verbModelString: "saber", flag: true)
            vmecdm.setSelected(verbModelString: "reír", flag: true)
            languageViewModel.fillSelectedVerbModelListAndPutAssociatedVerbsinFilteredVerbList(maxVerbCountPerModel:10)
        case .StemChanging1, .StemChanging2, .Irregular, .SpellChanging1, .SpellChanging2:
            let currentVerbModel = languageViewModel.getCurrentVerbModel()
            vmecdm.setSelected(verbModelString: currentVerbModel.modelVerb, flag: true)
            languageViewModel.fillSelectedVerbModelListAndPutAssociatedVerbsinFilteredVerbList(maxVerbCountPerModel:10)
        default:
            break
        }
        selectedCount = languageViewModel.getSelectedVerbModelList().count
        languageViewModel.initializeStudentScoreModel()
    }
    
    func getModelPatternStructListAtSelectedTypeAndEnding()->[ModelPatternStruct]{
        selectedNewVerbModelType = languageViewModel.getSelectedNewVerbModelType()
        let selectedNewVerbModelTypeString = selectedNewVerbModelType.getTypeName()
        let currentModelList = languageViewModel.getVerbModelGroupManager().getVerbModelSublistAtVerbEnding(modelName: selectedNewVerbModelTypeString, verbEnding: selectedVerbEnding)
        
        for model in currentModelList{
            print(model.modelVerb)
        }
        return VerbAndModelSublistUtilities().getModelPatternStructListSortedByTheirVerbCount(languageViewModel: languageViewModel, inputModelList: currentModelList)
    }
    
    func getModelPatternStructListAtSelectedTypeSelectedPatternAndSelectedEnding()->[ModelPatternStruct]{
        var currentModelList = languageViewModel.getVerbModelGroupManager().getVerbModelSublistAtVerbEnding(modelName: selectedNewVerbModelType.getTypeName(), verbEnding: selectedVerbEnding)
        currentModelList = languageViewModel.getVerbModelGroupManager().getModelListAtSelectedPattern(languageViewModel: languageViewModel, inputModelList: currentModelList, selectedPattern: languageViewModel.getSelectedSpecialPatternType() )
        return VerbAndModelSublistUtilities().getModelPatternStructListSortedByTheirVerbCount(languageViewModel: languageViewModel, inputModelList: currentModelList)
    }
    
    
}

//extension AllVerbModelTypesView {
//    private var showCurrentVerbModel: some View {
//        Text("Model group: \(selectedNewVerbType.getTypeName())")
//    }
//}

struct GeneralVerbBarChartView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var homemadeBarChartMgr : HomemadeBarChartManager
    
    @Binding var selectedNewVerbType : NewVerbModelType
    @Binding var selectedVerbEnding : VerbEnding
    
    @State private var headerText = "Info"
    @State private var headerText2 = ""
    @State private var isHorizontal = false
    @State private var barThickness = CGFloat(25)
    @State private var textLength = CGFloat(90)
    @State private var plotAreaMaxDimension = CGFloat(300)
    @State private var isTestMode = false
    
    @State private var selectedModel = RomanceVerbModel()
    @State var showSheet = false
    
    @State var activeModels = [VerbModel]()
    
    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    ShowVerbModelListSection(languageViewModel: languageViewModel, homemadeBarChartMgr: homemadeBarChartMgr, selectedNewVerbType: $selectedNewVerbType, selectedSpecialPatternType: languageViewModel.getSelectedSpecialPatternType())
                    Spacer()
                } .padding(.horizontal, 5)
            }
            .fullScreenCover(isPresented: $showSheet, content: {
                ListVerbsForModelView(languageViewModel: languageViewModel, model: selectedModel)
            })
            .background(Color("BethanyNavalBackground"))
            .foregroundColor(Color("BethanyGreenText"))
            .frame(width: geometry.size.width, alignment: .leading)
            .padding(2)
            .cornerRadius(6)
        }.onAppear{
            languageViewModel.setSelectedNewVerbModelType(selectedType: selectedNewVerbType)
        }
        //        .onChange(of: selectedType){
        //
        //        }
    }
    
    
    func setHeaderText(bar: Bar){
        homemadeBarChartMgr.selectedModel = bar.model
        homemadeBarChartMgr.modelString = getModelName(bar: bar)
        languageViewModel.setCurrentVerbModel(model: homemadeBarChartMgr.selectedModel)
//        print("Homemade selected model = \(languageViewModel.getCurrentVerbModel().modelVerb), verbCount = \(languageViewModel.getFilteredVerbs().count)")
    }
    
    func getModelName(bar: Bar)->String{
        if bar.model.id == 788 {return "regularIR"}
        if bar.model.id == 5 {return "regularAR"}
        if bar.model.id == 6 {  return "regularER"}
        return bar.model.modelVerb
    }
}


struct ShowVerbModelListSection: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var homemadeBarChartMgr : HomemadeBarChartManager
    @Binding var selectedNewVerbType : NewVerbModelType
    @State var selectedSpecialPatternType : SpecialPatternType
    @State private var selectedModel = RomanceVerbModel()
    
    @State private var selectedModelString = "Selected model"
    @State private var barThickness = CGFloat(25)
    @State private var textLength = CGFloat(90)
    @State private var plotAreaMaxDimension = CGFloat(300)
    
    @State private var modelPattern = ""
    @State var showSheet = false
    
    var body: some View{
        VStack{
            Text("Model List").font(.callout).foregroundColor(Color("ChuckText1"))
            ForEach(homemadeBarChartMgr.getBars()) { bar in
                HStack(spacing: 6){
                    Button{
                        setHeaderText(bar: bar)
                        showSheet.toggle()
                    } label: {
                        Text(getModelName(bar: bar)).frame(width: textLength)
                            .foregroundColor(bar.status == .Completed ? .red : Color("BethanyGreenText") )
                    }
                    Text(getPatternName(bar.model))
                    ZStack {
                        Rectangle()
                            .foregroundColor(bar.color)
                            .frame(width: Double(bar.count), height: barThickness, alignment: .leading)
                            .cornerRadius(4)
                            .opacity(selectedModel.id == bar.model.id ? 0.5 : 1.0)
                            .onTapGesture{
                                setHeaderText(bar: bar)
                            }
                    }
                    Text("\(Int(bar.count))").font(.caption)
                    Spacer()
                    if languageViewModel.isCompleted(verbModel: bar.model) { Text("✅")}
                }
            }
            
        }
        .onAppear{
            selectedSpecialPatternType = languageViewModel.getSelectedSpecialPatternType()
            
        }
        .fullScreenCover(isPresented: $showSheet, content: {
            ListVerbsForModelView(languageViewModel: languageViewModel, model: selectedModel)
        })
    }
    
    
    func getPatternName(_ model: RomanceVerbModel)->String{
        let spt = languageViewModel.getPatternForGivenVerbModelTypeForThisVerbModel(verbModel: model, verbType: selectedNewVerbType)
        return spt.rawValue
    }
    
    
    func setHeaderText(bar: Bar){
        homemadeBarChartMgr.selectedModel = bar.model
        homemadeBarChartMgr.modelString = getModelName(bar: bar)
        selectedModel = bar.model
        languageViewModel.setCurrentVerbModel(model: homemadeBarChartMgr.selectedModel)
        if languageViewModel.isCompleted(verbModel: selectedModel) { Text("✅")}
    }
    
    func getModelName(bar: Bar)->String{
        if bar.model.id == 788 {return "regularIR"}
        if bar.model.id == 5 {return "regularAR"}
        if bar.model.id == 6 {  return "regularER"}
        return bar.model.modelVerb
    }
    
    
}


