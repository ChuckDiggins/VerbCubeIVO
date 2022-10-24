//
//  HomemadeBarChartView.swift
//  Feather2
//
//  Created by Charles Diggins on 9/29/22.
//

import SwiftUI
import JumpLinguaHelpers

class HomemadeBarChartManager : ObservableObject {
    @Published var homemadeBars : [Bar]
    @Published var selectedModel = RomanceVerbModel()
    @Published var modelString =  "critical"
    
    init(){
        homemadeBars = [Bar]()
    }
    
    func clearBars(){
        homemadeBars.removeAll()
    }
    
    func createBarList(mpsList : [ModelPatternStruct], maxCount: Int){
        homemadeBars.removeAll()
        for mps in mpsList {
            let bar = Bar(model: mps.model, count: mps.count, color: .green, status: .Active)
            homemadeBars.append(bar)
            if homemadeBars.count >= maxCount { break }
        }
    }
    
    func addBar(model: RomanceVerbModel, count: Int, color: Color, status: VerbModelStatus){
        let bar = Bar(model: model, count: count, color: color,  status: status)
        homemadeBars.append(bar)
    }
    
    func append(_ bar: Bar){
        homemadeBars.append(bar)
    }
    
    func getBars()->[Bar]{
//        print("HomemadeBarChartManager: getBars: count \(homemadeBars.count)")
        return homemadeBars
    }
    
    func setStatus(modelString: String, status: VerbModelStatus){
        for index in 0 ..< homemadeBars.count{
            if homemadeBars[index].model.modelVerb == modelString{
                homemadeBars[index].status = status
                return
            }
                
        }
    }


    func getBarCount()->Int{
        return homemadeBars.count
    }
}

enum VerbModelStatus : String {
    case Active
    case Selected
    case Completed
}

struct Bar: Identifiable {
    let id = UUID()
    var model : RomanceVerbModel
    var count: Int
    var color: Color
    var status: VerbModelStatus
}

struct ShowListSection: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm : VerbModelEntityCoreDataManager
    @ObservedObject var homemadeBarChartMgr : HomemadeBarChartManager
    @State var status: VerbModelStatus
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
                    Text("\(Int(bar.count))").foregroundColor(.black).font(.caption)
                    Spacer()
                }
            }
        }.foregroundColor(.black)
    }
    
    func toggleStatusFlag(bar: Bar){
        switch status {
        case .Active: return vmecdm.toggleSelected(verbModelString: getModelName(bar: bar))
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
    
    @Binding var selectedType : VerbModelType
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
                            ShowListSection(languageViewModel: languageViewModel, vmecdm: vmecdm, homemadeBarChartMgr: homemadeBarChartMgr, status: .Active)
                        }
                        Section("Selected verbs"){
                            ShowListSection(languageViewModel: languageViewModel, vmecdm: vmecdm, homemadeBarChartMgr: homemadeBarChartMgr, status: .Selected)
                        }
                        Section("Completed verbs"){
                            ShowListSection(languageViewModel: languageViewModel, vmecdm: vmecdm, homemadeBarChartMgr: homemadeBarChartMgr, status: .Completed)
                        }
                        Spacer()
                } .padding(.horizontal, 5)
            }
            .fullScreenCover(isPresented: $showSheet, content: {
                ListVerbsForModelView(languageViewModel: languageViewModel, model: selectedModel)
            })
            .frame(width: geometry.size.width, alignment: .leading)
            .padding(2)
            .background(.thinMaterial)
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

struct ListVerbsForModelView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var model: RomanceVerbModel
    @State var verbList = [Verb]()
    @State var show10Verbs = false
    @State var maxVerbCount = 12
    var fontSize = Font.callout
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Color.red
            //                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(20)
                    })
                    Spacer()
                }
                VStack(spacing: 20){
                    let gridFixSize = CGFloat(200.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     //                                 GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]
                    
                    Button{
                        shuffleVerbList()
                    } label: {
                        Text("Shuffle")
                        Spacer()
                        Image(systemName: "rectangle.and.hand.point.up.left.filled")
                    }
                    .frame(width: 150, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                    LazyVGrid(columns: gridItems, spacing: 5){
                        Section{
                            ForEach(0..<verbList.count, id: \.self){ index in
                                Text(getVerbStringAtIndex(index))
                                    .frame(width: 160, height: 30)
                                    .cornerRadius(3)
                                    .border(Color("BethanyGreenText"))
                            }
                        } header:{
                            Text("Random verb list for \(model.modelVerb) model").font(.title2)
                        }
                    footer:{
                        Text("\nIf you keep this model, these will be your exercise verbs.").font(.title3).bold()
                    }
                        
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .padding(20)
                    .background(Color("BethanyNavalBackground"))
                    .foregroundColor(Color("BethanyGreenText"))
                    .font(fontSize)
                    
                    
                }
                .onAppear{
                    model = languageViewModel.getCurrentVerbModel()
                    shuffleVerbList()
                }
            }
            Spacer()
        }
    }
    
    func shuffleVerbList(){
        loadVerbList()
        verbList.shuffle()
        let verbCount = verbList.count
        if verbCount > maxVerbCount {
            verbList.removeLast(verbCount-maxVerbCount)
        }
    }
    
    func loadVerbList(){
        verbList = languageViewModel.getFilteredVerbs()
        //        print("ListVerbsForModelView: \(model.modelVerb): verb count = \(verbList.count)")
    }
    
    func getVerbStringAtIndex(_ index: Int)->String{
        verbList[index].getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
    }
    
}


//struct HomemadeBarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomemadeBarChartView()
//    }
//}
