//
//  VerbModelManager.swift
//  Feather2
//
//  Created by Charles Diggins on 10/21/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbModelGroup{
    private var verbModelType: NewVerbModelType
    private var language: LanguageType
    private var verbModelList = [RomanceVerbModel]()
    
    init(){
        verbModelType = NewVerbModelType.undefined
        language = .Agnostic
    }
    
    init(verbModelType: NewVerbModelType, language: LanguageType, verbModel: RomanceVerbModel){
        self.verbModelType = verbModelType
        self.language = language
        self.verbModelList.append(verbModel)
    }
    
    init(verbModelType: NewVerbModelType, language: LanguageType, verbModelList: [RomanceVerbModel]){
        self.verbModelType = verbModelType
        self.language = language
        self.verbModelList = verbModelList
    }
    
    func getName()->String{
        return verbModelType.getTypeName()
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
    
    mutating func setVerbModelList(verbModel: [RomanceVerbModel]){
        verbModelList = verbModel
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
        let group = getGroupAtName(name: name)
        return group.getVerbModelListAtVerbEnding(verbEnding: verbEnding)
    }
    
    func getModelListAtSelectedPattern(languageViewModel: LanguageViewModel, inputModelList: [RomanceVerbModel], selectedPattern: SpecialPatternType)->[RomanceVerbModel]{
        var modelList = [RomanceVerbModel]()
        for model in inputModelList {
            var spt = languageViewModel.getPatternForGivenVerbModelTypeForThisVerbModel(verbModel: model, verbType: languageViewModel.getSelectedNewVerbModelType())
            if spt == selectedPattern {
                modelList.append(model)
            }
        }
        return modelList
        
    }
    
    func getModelListAtSelectedVerbModelTypeAndVerbPattern(languageViewModel: LanguageViewModel, inputModelList: [RomanceVerbModel])->[RomanceVerbModel]{
        let selectedPattern = languageViewModel.getSelectedSpecialPatternType()
        let selectedType = languageViewModel.getSelectedNewVerbModelType()
        
        var modelList = [RomanceVerbModel]()
        for model in inputModelList {
        }
        return modelList
    }
    
}
