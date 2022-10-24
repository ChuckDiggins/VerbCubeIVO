//
//  VerbModelEntityCoreDataManager.swift
//  Feather2
//
//  Created by Charles Diggins on 10/20/22.
//

import Foundation

class VerbModelEntityCoreDataManager: ObservableObject{
    @Published var vm : VerbModelEntityCoreData
    @Published var savedModels = [VerbModelEntity]()

    init(){
        vm = VerbModelEntityCoreData()
        savedModels = vm.savedVerbModelEnties
    }

    func resetAllToActive(){
        vm.setAllVerbModelEntitiesToActive()
    }
    
    func toggleActive(verbModelString: String){
        vm.toggleVerbModelEntityActive(verbModelString: verbModelString)
        savedModels = vm.savedVerbModelEnties
    }

    func isActive(verbModelString: String)->Bool{
        return vm.isVerbModelEntityActive(verbModelString: verbModelString)
    }
    
    func toggleSelected(verbModelString: String){
        vm.toggleVerbModelEntitySelected(verbModelString: verbModelString)
        savedModels = vm.savedVerbModelEnties
    }

    func isSelected(verbModelString: String)->Bool{
        return vm.isVerbModelEntitySelected(verbModelString: verbModelString)
    }
    
    
    func toggleCompleted(verbModelString: String){
        vm.toggleVerbModelEntityCompleted(verbModelString: verbModelString)
        savedModels = vm.savedVerbModelEnties
    }

    func isCompleted(verbModelString: String)->Bool{
        return vm.hasVerbModelEntityBeenCompleted(verbModelString: verbModelString)
    }
    
    func clearModelEntities(){
        vm.clearAllVerbModelEntities()
        savedModels = vm.savedVerbModelEnties
    }
    
    func saveData(){
        vm.saveData()
    }
    
}

