//
//  VerbModelListView.swift
//  Feather2
//
//  Created by Charles Diggins on 12/6/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbModelListView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager

//    @State  private var modelDictionary: [String: Int] = [:]
    @State var selectedCount = 0
    @State var modelName = "No name"
    @State var showSheet = false
    @State var selectedModel = RomanceVerbModel()
    @AppStorage("VerbOrModelMode") var verbOrModelMode = "NA"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "nada 2"
    @State private var inProgress = false
    @State private var orderedVerbModelList = [RomanceVerbModel]()
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                ExitButtonView()
                Text("Current model: \(currentVerbModelString)")
//                Button{
//                    ShowDictionaryVerbCounts()
//                } label: {
//                    Text("Compute dictionary verb counts.")
//                }
                ScrollView{
                    LazyVStack{
                        ForEach(orderedVerbModelList, id: \.self){ vm in
                            Button{
                                selectedModel = vm
                                languageViewModel.setTemporaryVerbModel(verbModel: vm)
                                showSheet.toggle()
                            } label: {
                                HStack{
                                    Text("\(vm.id)")
                                    Text("\(vm.modelVerb) \(languageViewModel.findVerbsOfSameModel(targetID: vm.id).count)")
                                    Spacer()
                                    if languageViewModel.isCompleted(verbModel: vm) { Text("✅")}
                                }.foregroundColor(vmecdm.isSelected(verbModelString:vm.modelVerb) ? Color("ChuckText1") : Color("BethanyGreenText"))
                            }
                            
                        }
                    }
                    if inProgress {
                        ProgressView()
                    }
                }.fullScreenCover(isPresented: $showSheet, content: {
                    ListVerbsForModelView(languageViewModel: languageViewModel, vmecdm: vmecdm, verbModel: selectedModel, showSelectButton: true)
                })
            }
            
        }.onAppear{
            inProgress.toggle()
            ShowDictionaryVerbCounts()
//            getModelName()
            vmecdm.setSelected(verbModelString: languageViewModel.getCurrentVerbModel().modelVerb, flag: true)
            inProgress.toggle()
            print("VerbModelListView: currentVerbModelString = \(currentVerbModelString)")
        } .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
    }
    
    func ShowDictionaryVerbCounts(){
        orderedVerbModelList = languageViewModel.getOrderedVerbModelList()
    }
    
    
    func getModelName(){
        var vmCount = 0

        let list = languageViewModel.getSelectedVerbModelList()
        selectedCount = list.count
        for vm in list {
            if vm.modelVerb == "regularAR" ||  vm.modelVerb == "regularER" || vm.modelVerb == "regularIR" {
                vmCount = vmCount + 1
            }
        }
        if vmCount == 3 {
            modelName = "Regular Verbs"
        }
        else {
            modelName = languageViewModel.getCurrentVerbModel().modelVerb
        }
    }
//
    func getIdNum(id: Int)->Int{
        var idNum = 0
        idNum = id
        if id == 788 { idNum = 7 }
        
        return idNum
    }
    
//    func sortModelList(){
//        verbModelList.removeAll()
//
//        for vm in languageViewModel.getVerbModels() {
//
//            modelDictionary.updateValue(vm.id, forKey: vm.modelVerb)
//        }
//        let sortInfo = modelDictionary.sorted(by: { $0.value < $1.value } )
//
//        sortInfo.forEach {key, value in
//            for vm in languageViewModel.getVerbModels()  {
//                if vm.modelVerb == "\(key)" {
//                    verbModelList.append(vm)
//                    break
//                }
//            }
//        }
//    }
}

//struct VerbModelListView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerbModelListView()
//    }
//}
