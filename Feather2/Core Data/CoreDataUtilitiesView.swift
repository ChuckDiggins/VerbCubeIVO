//
//  CoreDataUtilitiesView.swift
//  Feather2
//
//  Created by Charles Diggins on 10/17/22.
//

import SwiftUI
import JumpLinguaHelpers

struct CoreDataUtilitiesView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var vm : VerbModelEntityCoreData
    @State var currentModelList = [RomanceVerbModel]()
    
    
    var body: some View {
        VStack{
            Button{
                toggleRegularVerbsCompleted()
            } label: {
                Text("Toggle regular verbs' completion")
            }.modifier(ModelTensePersonButtonModifier())
            
            Button{
                toggleSpecialVerbsCompleted()
            } label: {
                Text("Toggle special verbs' completion")
            }.modifier(ModelTensePersonButtonModifier())
            
            Button{
                setAllVerbsAsIncomplete()
            } label: {
                Text("Reset all verbs as not completed")
            }.modifier(ModelTensePersonButtonModifier())
            
        }
        Text("Completed verbs")
        VStack{
            ForEach(currentModelList, id: \.self){ verbModel in
                HStack{
                    Text(verbModel.modelVerb)
                    Button{
                        vm.toggleVerbModelEntityActive(verbModelString: verbModel.modelVerb)
                        fillListOfCurrentModels()
                    } label: {
                        Text(vm.isVerbModelEntityActive(verbModelString: verbModel.modelVerb) ? "active" : "inactive")
                    }.foregroundColor(vm.isVerbModelEntityActive(verbModelString: verbModel.modelVerb) ? .red : .black)
                    
                    Button{
                        vm.toggleVerbModelEntityCompleted(verbModelString: verbModel.modelVerb)
                        fillListOfCurrentModels()
                    } label: {
                        Text(vm.hasVerbModelEntityBeenCompleted(verbModelString: verbModel.modelVerb) ? "completed" : "incomplete")
                    }.foregroundColor(vm.hasVerbModelEntityBeenCompleted(verbModelString: verbModel.modelVerb) ? .red : .black)
                }
            }
        }
//            .onDelete(perform: cmm.deleteModel
        .onAppear{
            print("CoreDataUtilitiesView: verbModelEntityCount = \(vm.getVerbModelEntityCount())")
            fillListOfCurrentModels()
            let model = vm.getVerbModelEntityAtVerbModelString(verbModelString: "ser")
            print("CoreDataUtilitiesView.onAppear: model \(model.modelName ?? "ser")")
        }
    }

    func fillListOfCurrentModels(){
        fillCurrentModelList()
    }
    
//    func reloadVerbModelsAndVerbModelEntities(){
//        vm.clearAllVerbModelEntities()
//        languageViewModel.loadModelVerbEntitesWithModelVerbs()
//        vm.setAllModelEntitiesToIncomplete()
//    }
    
    
    func setAllVerbsAsIncomplete(){
//        vm.setAllModelEntityCompletions(complete: false)
    }
    
    func fillCurrentModelList(){
        currentModelList.removeAll()
        currentModelList.append(getModelAtVerbString(verbModelString: "regularAR"))
        currentModelList.append(getModelAtVerbString(verbModelString:  "regularER"))
        currentModelList.append(getModelAtVerbString(verbModelString: "regularIR"))
        
        currentModelList.append(getModelAtVerbString(verbModelString: "estar"))
        currentModelList.append(getModelAtVerbString(verbModelString: "ser"))
        currentModelList.append(getModelAtVerbString(verbModelString: "hacer"))
        currentModelList.append(getModelAtVerbString(verbModelString: "ir"))
        currentModelList.append(getModelAtVerbString(verbModelString: "haber"))
        currentModelList.append(getModelAtVerbString(verbModelString: "oir"))
    }
    
    func toggleRegularVerbsCompleted(){
        vm.toggleVerbModelEntityCompleted(verbModelString: "regularAR")
        vm.toggleVerbModelEntityCompleted(verbModelString: "regularER")
        vm.toggleVerbModelEntityCompleted(verbModelString: "regularIR")
        fillListOfCurrentModels()
    }
    
    func toggleSpecialVerbsCompleted(){
        vm.toggleVerbModelEntityCompleted(verbModelString: "estar")
        vm.toggleVerbModelEntityCompleted(verbModelString: "ser")
        vm.toggleVerbModelEntityCompleted(verbModelString: "hacer")
        vm.toggleVerbModelEntityCompleted(verbModelString: "ir")
        vm.toggleVerbModelEntityCompleted(verbModelString: "haber")
        vm.toggleVerbModelEntityCompleted(verbModelString: "oir")
        fillListOfCurrentModels()
        
    }
    
    func getModelAtVerbString(verbModelString: String)->RomanceVerbModel{
        for model in languageViewModel.getVerbModels(){
            if model.modelVerb == verbModelString {
                return model
            }
        }
        return RomanceVerbModel()
    }
    
    
}

