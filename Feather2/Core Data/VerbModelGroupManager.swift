//
//  VerbModelManager.swift
//  Feather2
//
//  Created by Charles Diggins on 10/21/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbModelGroup{
    private var verbModelType: VerbModelType
    private var language: LanguageType
    private var verbModelList = [RomanceVerbModel]()
    
    init(){
        verbModelType = VerbModelType.undefined
        language = .Agnostic
    }
    
    init(verbModelType: VerbModelType, language: LanguageType, verbModel: RomanceVerbModel){
        self.verbModelType = verbModelType
        self.language = language
        self.verbModelList.append(verbModel)
    }
    
    init(verbModelType: VerbModelType, language: LanguageType, verbModelList: [RomanceVerbModel]){
        self.verbModelType = verbModelType
        self.language = language
        self.verbModelList = verbModelList
    }
    
    func getName()->String{
        return verbModelType.rawValue
    }
    func getVerbModelCount()->Int{
        verbModelList.count
    }
    
    func getVerbModelList()->[RomanceVerbModel]{
        verbModelList
    }
    
    func verbModelExists(verbModel: RomanceVerbModel)->Bool{
        for vm in verbModelList{
            if vm.modelVerb == verbModel.modelVerb { return true}
        }
        return false
    }
    
    //only append unique model
    mutating func appendVerbModel(verbModel: RomanceVerbModel){
        if !verbModelExists(verbModel: verbModel){
            verbModelList.append(verbModel)
        }
    }
    
    func getVerbModelListAtVerbEnding(verbEnding: VerbEnding)->[RomanceVerbModel]{
        let vamslu = VerbAndModelSublistUtilities()
//        dumpVerbModelList()
        return vamslu.getModelSublistAtVerbEnding(inputModelList: verbModelList, verbEnding: verbEnding)
    }
    
    func dumpVerbModelList(){
        print("VerbModelGroup: dumpVerbModelList:")
        for model in verbModelList {
            print("model verb \(model.modelVerb), \(model.id)")
        }
    }
    
    func findVerbModelAtVerbString(verbModelString: String)->RomanceVerbModel{
        for vm in verbModelList {
            if vm.modelVerb == verbModelString { return vm}
        }
        return RomanceVerbModel()
    }
    
}

struct VerbModelGroupManager{
    var verbModelGroupList = [VerbModelGroup]()
    var nullGroup = VerbModelGroup()
        
    mutating func appendGroup(verbModelGroup: VerbModelGroup){
        verbModelGroupList.append(verbModelGroup)
    }
    
    func getGroupAtName(name: String)->VerbModelGroup{
        for vmg in verbModelGroupList {
            if name == vmg.getName() { return vmg }
        }
        return nullGroup
    }
    
    func getList()->[VerbModelGroup]{
        return verbModelGroupList
    }
    
    func getVerbModelListAtVerbEnding(name: String, verbEnding: VerbEnding)->[RomanceVerbModel]{
        var group = getGroupAtName(name: name)
        return group.getVerbModelListAtVerbEnding(verbEnding: verbEnding)
    }
    
}
