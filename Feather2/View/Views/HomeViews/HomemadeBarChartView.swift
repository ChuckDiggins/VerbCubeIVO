//
//  HomemadeBarChartView.swift
//  Feather2
//
//  Created by Charles Diggins on 9/29/22.
//

import SwiftUI
import JumpLinguaHelpers


struct ShowListSection: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm : VerbModelEntityCoreDataManager
    @ObservedObject var homemadeBarChartMgr : HomemadeBarChartManager
    @State var status: VerbModelStatus
     var selectedType : NewVerbModelType
    @State private var selectedModel = RomanceVerbModel()
    @State private var barThickness = CGFloat(25)
    @State private var textLength = CGFloat(90)
    @State private var plotAreaMaxDimension = CGFloat(300)
    
    var body: some View{
        ForEach(homemadeBarChartMgr.getBars()) { bar in
            if getStatusFlag(bar: bar){
                HStack(spacing: 6){
                    Button{
                        setHeaderText(bar: bar)
                        toggleStatusFlag(bar: bar)
                    } label: {
                        Text(getModelName(bar: bar)).font(.caption).frame(width: textLength)
                    }
                    Text(getPatternName(bar.model)).background(.yellow).font(.caption)
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
                }
            }
        }
    }
    
    func toggleStatusFlag(bar: Bar){
        switch status {
        case .Active: return vmecdm.setSelected(verbModelString: getModelName(bar: bar), flag: true)
        case .Selected: return vmecdm.toggleCompleted(verbModelString: getModelName(bar: bar))
        case .Completed: return vmecdm.toggleActive(verbModelString: getModelName(bar: bar))
        }
    }
    
    func getStatusFlag(bar: Bar)->Bool{
        //        dumpVerbModelEntity(bar: bar)
        switch status {
        case .Active: return vmecdm.isActive(verbModelString: getModelName(bar: bar))
        case .Selected: return vmecdm.isSelected(verbModelString: getModelName(bar: bar))
        case .Completed: return vmecdm.isCompleted(verbModelString: getModelName(bar: bar))
        }
    }
    
    func dumpVerbModelEntity(bar: Bar){
        let name = getModelName(bar: bar)
        print("dumpVerbModelEntity: model: \(name), active \(vmecdm.isActive(verbModelString: name)), selected \(vmecdm.isSelected(verbModelString: name)), completed \(vmecdm.isCompleted(verbModelString: name))")
    }
    
    func setHeaderText(bar: Bar){
        homemadeBarChartMgr.selectedModel = bar.model
        homemadeBarChartMgr.modelString = getModelName(bar: bar)
        languageViewModel.setCurrentVerbModel(model: homemadeBarChartMgr.selectedModel)
        print("Homemade selected model = \(languageViewModel.getCurrentVerbModel().modelVerb), verbCount = \(languageViewModel.getFilteredVerbs().count)")
    }
    
    func getPatternName(_ model: RomanceVerbModel)->String{
        let spt = languageViewModel.getPatternForGivenVerbModelTypeForThisVerbModel(verbModel: model, verbType: selectedType)
        return spt.rawValue
    }
    
    
    func getModelName(bar: Bar)->String{
        if bar.model.id == 788 {return "regularIR"}
        if bar.model.id == 5 {return "regularAR"}
        if bar.model.id == 6 {  return "regularER"}
        return bar.model.modelVerb
    }
}


struct HomemadeBarChartView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm : VerbModelEntityCoreDataManager
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
    @State var selectedModels = [VerbModel]()
    @State var completedModels = [VerbModel]()
    
    var body: some View {
        
        GeometryReader{ geometry in
            ScrollView{
                Button{
                    ResetAllVerbModelEntitiesToActive()
                } label: {
                    Text("Reset Verb Entities")
                }
                VStack(alignment: .leading, spacing: 0){
                    Section("Active verbs"){
                        ShowListSection(languageViewModel: languageViewModel, vmecdm: vmecdm, homemadeBarChartMgr: homemadeBarChartMgr, status: .Active, selectedType: selectedNewVerbType)
                    }
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
            
        }
    }
    
    func ResetAllVerbModelEntitiesToActive(){
        vmecdm.resetAllToActive()
    }
    
    func setHeaderText(bar: Bar){
        homemadeBarChartMgr.selectedModel = bar.model
        homemadeBarChartMgr.modelString = getModelName(bar: bar)
        languageViewModel.setCurrentVerbModel(model: homemadeBarChartMgr.selectedModel)
        print("Homemade selected model = \(languageViewModel.getCurrentVerbModel().modelVerb), verbCount = \(languageViewModel.getFilteredVerbs().count)")
    }
    
    
    func getModelName(bar: Bar)->String{
        if bar.model.id == 788 {return "regularIR"}
        if bar.model.id == 5 {return "regularAR"}
        if bar.model.id == 6 {  return "regularER"}
        return bar.model.modelVerb
    }
}



//struct HomemadeBarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomemadeBarChartView()
//    }
//}
