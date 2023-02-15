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
    @AppStorage("V2MChapter") var currentV2mChapter = "nada 2"
    @AppStorage("V2MLesson") var currentV2mLesson = "nada 3"
    @State private var inProgress = false
    @State private var orderedVerbModelList = [RomanceVerbModel]()
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                ExitButtonView()
                Text("Current model: \(modelName)")
//                Button{
//                    ShowDictionaryVerbCounts()
//                } label: {
//                    Text("Compute dictionary verb counts.")
//                }
                ScrollView{
                    LazyVStack{
                        ForEach(orderedVerbModelList, id: \.self){ vm in
                            Button{
//                                languageViewModel.processVerbModel(vm)
                                processVerbModel(vm)
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
                    ListVerbsForModelView(languageViewModel: languageViewModel, model: selectedModel)
                })
            }
            
        }.onAppear{
            inProgress.toggle()
            ShowDictionaryVerbCounts()
//            sortModelList()
            getModelName()
            inProgress.toggle()
        } .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
    }
    
    func ShowDictionaryVerbCounts(){
        orderedVerbModelList = languageViewModel.getOrderedVerbModelList()
    }
    
    func processVerbModel(_ vm: RomanceVerbModel){
        var vcount = 0
        for verb in languageViewModel.findVerbsOfSameModel(targetID: vm.id){
            vcount += 1
            print("processVerbModel - verb: \(vcount). \(verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage() ))")
        }
        languageViewModel.computeSelectedVerbModels()
        languageViewModel.computeCompletedVerbModels()
        
        selectedModel = vm
        showSheet.toggle()
        vmecdm.setAllSelected(flag: false)
        languageViewModel.setCurrentVerbModel(model: vm)
        vmecdm.setSelected(verbModelString: vm.modelVerb, flag: true)
        getModelName()
        //create an study package
        var verbModelList = [RomanceVerbModel]()
        verbModelList.append(selectedModel)
        var verbModelStringList = [String]()
        verbModelStringList.append(selectedModel.modelVerb)
        let sp = StudyPackageClass(name: modelName, verbModelStringList: verbModelStringList,
                                   tenseList: [.present, .preterite, .imperfect, .conditional],
                                   chapter: "Verb model", lesson: selectedModel.modelVerb)
        sp.preferredVerbList = languageViewModel.findVerbsOfSameModel(targetID: selectedModel.id)
        currentV2mChapter = sp.chapter
        currentV2mLesson = sp.lesson
        languageViewModel.setStudyPackage(sp: sp)
        languageViewModel.setVerbOrModelMode(mode: .modelMode)
        languageViewModel.resetFeatherSentenceHandler()
        languageViewModel.fillVerbCubeAndQuizCubeLists()
        languageViewModel.trimFilteredVerbList(16)
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
        if vmCount == 3 { modelName = "Regular Verbs"}
        else {
            modelName = list[0].modelVerb
        }
        modelName = languageViewModel.getStudyPackage().name
    }
    
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
