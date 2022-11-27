//
//  VerbModelStatusWrapper.swift
//  Feather2
//
//  Created by Charles Diggins on 11/27/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbModelStatusWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @State var selectedModelCount = 0
    @State var completedModelCount = 0
    @State var totalModelCount = 0
    @State var coreSelectedModelCount = 0
    @State var coreCompletedModelCount = 0
    @State var coreTotalModelCount = 0
    @State var totalVerbCount = 0
    @State var completedVerbCount = 0
    @State var selectedVerbCount = 0
    @State var activeVerbCount = 0
    
    @State var regularCompleteCount = 0
    @State var criticalCompleteCount = 0
    @State var stemCompleteCount = 0
    @State var spellCompleteCount = 0
    @State var irregularCompleteCount = 0
    @State var regularIncompleteCount = 0
    @State var criticalIncompleteCount = 0
    @State var stemIncompleteCount = 0
    @State var spellIncompleteCount = 0
    @State var irregularIncompleteCount = 0
    @State var selectedNewVerbModelType = NewVerbModelType.undefined
    @State var showSheet = false
    @State private var showStatusString = ""
    @State private var isLoading = true
    
    @State var displayMode = StatusDisplayMode.verbs
    
    @State var displayModeList = [ StatusDisplayMode.verbs, .models, .types1, .types2]
    var body: some View {
        VStack{
            VStack{

                if totalVerbCount > 0 {
                    
                    Picker("Select model type", selection: $displayMode){
                        ForEach(displayModeList, id:\.self){Text($0.getName())}
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if displayMode == .verbs {
                        VerbChartView(verbCounts : [
                            VerbCount(name: "active", count: activeVerbCount),
                            VerbCount(name: "selected", count: selectedVerbCount),
                            VerbCount(name: "completed", count: completedVerbCount),
                        ])
                    }else if displayMode == .models{
                        VerbChartView(verbCounts : [
                            VerbCount(name: "active", count: totalModelCount-selectedModelCount-completedModelCount),
                            VerbCount(name: "selected", count: selectedModelCount),
                            VerbCount(name: "completed", count: completedModelCount),
                        ])
                    }else if displayMode == .types1 {
                        VerbChartView(verbCounts : [
                            VerbCount(name: "regular", count: regularCompleteCount),
                            VerbCount(name: "critical", count: criticalCompleteCount),
                            VerbCount(name: "stem", count: stemCompleteCount),
                            VerbCount(name: "spell", count: spellCompleteCount),
                            VerbCount(name: "irregular", count: irregularCompleteCount),
                        ])
                    }
                    else {
                        VerbChart2View(verbCounts : [
                            VerbCountType2(name: "regular", count1: regularCompleteCount, count2: regularIncompleteCount),
                            VerbCountType2(name: "critical", count1: criticalCompleteCount, count2: criticalIncompleteCount),
                            VerbCountType2(name: "stem", count1: stemCompleteCount, count2: stemIncompleteCount),
                            VerbCountType2(name: "spell", count1: spellCompleteCount, count2: spellIncompleteCount),
                            VerbCountType2(name: "irregular", count1: irregularCompleteCount, count2: irregularIncompleteCount),
                        ])
                        .chartOverlay { proxy in
                            GeometryReader { nthGeoItem in
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .onTapGesture { value in
                                        let x = value.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                                        let statusString: String? = proxy.value(atX: x)
                                        if let statusString {
                                            showStatusString = statusString
                                            showStatusString = "\(statusString)"
                                            print("\(showStatusString), \(statusString)")
                                            showSheet.toggle()
                                        }
                                    }
                            }
                        }
                    }
                    if isLoading {
                        ZStack{
                            Color(.systemBackground).ignoresSafeArea()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .scaleEffect(3)
                        }
                    }
                }
                //                    .navigationTitle("\(displayMode.getName())")
                
                //            Button{
                //                setAllSelectedToCompleted()
                //            } label: {
                //                Text("Set all selected to completed")
                //            }.modifier(NavLinkModifier())
//                Button{
//                    setAllToActive()
//                } label: {
//                    Text("Reset all to active")
//                }.modifier(BlueButtonModifier())
//
                
            }.onAppear{
                totalVerbCount = languageViewModel.getVerbList().count
                languageViewModel.computeCompletedVerbCountsForAllNewVerbModelTypes()
                computeCounts()
            }
            .fullScreenCover(isPresented: $showSheet, content: {
                ShowVerbModelStatus(showStringStatus: showStatusString)
            })
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            .font(.headline)
            .padding()
        }
    }
    
    func computeCounts(){
        isLoading = true
        reconcileLanguageViewModelWithCoreData()
        
        totalModelCount = languageViewModel.getVerbModels().count
        coreTotalModelCount = vmecdm.vm.getVerbModelEntityCount()
        coreSelectedModelCount = vmecdm.vm.getSelectedModelEntityCount()
        coreCompletedModelCount = vmecdm.vm.getCompletedVerbModelEntityList().count
        
        //combine this logic for computing complete and incomplete
        
        
        
        
        
        
        
        
        
        regularCompleteCount = languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .Regular)
        regularIncompleteCount = languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .Regular)
        print("regular: complete: \(regularCompleteCount), incomplete: \(regularIncompleteCount)")
        
        criticalCompleteCount = languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .Critical)
        criticalIncompleteCount = languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .Critical)
        print("critical: complete: \(criticalCompleteCount), incomplete: \(criticalIncompleteCount)")
        
        stemCompleteCount = languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .StemChanging1) +
                            languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .StemChanging2)
        stemIncompleteCount = languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .StemChanging1) +
                            languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .StemChanging2)
        print("stem: complete: \(stemCompleteCount), incomplete: \(stemIncompleteCount)")
        
        spellCompleteCount = languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .SpellChanging1) +
                            languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .SpellChanging1)
        spellIncompleteCount = languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .SpellChanging1) +
                            languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .SpellChanging1)
        print("spell: complete: \(spellCompleteCount), incomplete: \(spellIncompleteCount)")
        
        irregularCompleteCount = languageViewModel.computeCompletedVerbCountByNewVerbModelType(newVerbModelType: .Irregular)
        irregularIncompleteCount = languageViewModel.computeIncompletedVerbCountByNewVerbModelType(newVerbModelType: .Irregular)
        print("irregular: complete: \(irregularCompleteCount), incomplete: \(irregularIncompleteCount)")
        isLoading = false
    }
    
    func reconcileLanguageViewModelWithCoreData(){
        var tempModelList = [RomanceVerbModel]()
        var tempVerbList = [Verb]()
        completedVerbCount = 0
        for veString in vmecdm.vm.getCompletedVerbModelEntityList(){
            var verbModel = languageViewModel.getModelAtModelWord(modelWord: veString)
            tempModelList.append(verbModel)
            tempVerbList = languageViewModel.findVerbsOfSameModel(targetID: verbModel.id)
            completedVerbCount += tempVerbList.count
        }
        completedModelCount = tempModelList.count
        languageViewModel.setCompletedVerbModelList(vml: tempModelList)
        
        tempModelList = [RomanceVerbModel]()
        tempVerbList = [Verb]()
        selectedVerbCount = 0
        for veString in vmecdm.vm.getSelectedVerbModelEntityStringList(){
            var verbModel = languageViewModel.getModelAtModelWord(modelWord: veString)
            tempModelList.append(verbModel)
            tempVerbList = languageViewModel.findVerbsOfSameModel(targetID: verbModel.id)
            selectedModelCount = selectedModelCount + tempVerbList.count
            selectedVerbCount += tempVerbList.count
        }
        selectedModelCount = tempModelList.count
        languageViewModel.setSelectedVerbModelList(vml: tempModelList)
        activeVerbCount = totalVerbCount - selectedVerbCount - completedVerbCount
    }
    
    func setAllSelectedToCompleted(){
        languageViewModel.setCoreAndModelSelectedToComplete()
//        vmecdm.setAllSelectedToCompleted()
//        var completedModelList = [RomanceVerbModel]()
//        for veString in vmecdm.vm.getCompletedVerbModelEntityList(){
//            completedModelList.append(languageViewModel.getModelAtModelWord(modelWord: veString))
//        }
//        languageViewModel.setCompletedVerbModelList(vml: completedModelList)
//        languageViewModel.setSelectedNewVerbModelType(selectedType: .undefined)
//        languageViewModel.setSelectedVerbModelList(vml: [RomanceVerbModel]())
        computeCounts()
    }
    
    func setAllToActive(){
        vmecdm.resetAllToActive()
        languageViewModel.restoreSelectedVerbs()
        computeCounts()
    }
}

struct VerbModelStatusWrapper_Previews: PreviewProvider {
    static var previews: some View {
        VerbModelStatusWrapper()
    }
}

struct ShowVerbModelStatus: View{
    @Environment(\.presentationMode) var presentationMode
    var showStringStatus : String
    var body: some View {
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
                Text("Model: \(showStringStatus)").font(.title).foregroundColor(.white).background(.black)
                Spacer()
            }
        }.onAppear{
            print("showStringStatus = \(showStringStatus)")
        }
    }
}
