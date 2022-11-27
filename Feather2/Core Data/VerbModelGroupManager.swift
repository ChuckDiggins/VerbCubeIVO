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
    private var isSelected = false
    private var isCompleted = false
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
    
    mutating func setIsCompleted(_ flag: Bool=true){
        self.isCompleted = flag
    }
    
    mutating func setIsSelected(_ flag: Bool=true){
        self.isSelected = flag
    }
    
    func completed()->Bool{
        isCompleted
    }
    
    func selected()->Bool{
        isSelected
    }
    
    func getVerbModelType()->NewVerbModelType{
        return verbModelType
    }
    
    func getVerbModelList()->[RomanceVerbModel]{
        return verbModelList
    }
    
    func getName()->String{
        return verbModelType.getTypeName()
    }
    func getVerbModelCount()->Int{
        verbModelList.count
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
    
    func getVerbModelSublistAtVerbEnding(verbEnding: VerbEnding)->[RomanceVerbModel]{
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
    
    func getGroupAtName(modelName: String)->VerbModelGroup{
        for vmg in verbModelGroupList {
            if modelName == vmg.getName() { return vmg }
        }
        return nullGroup
    }
    
    func getList()->[VerbModelGroup]{
        return verbModelGroupList
    }
    
    func getSelectedVerbModelGroup()->[VerbModelGroup]{
        var selectedList = [VerbModelGroup]()
        for vmg in getList(){
            if vmg.selected() {selectedList.append(vmg)}
        }
        return selectedList
    }
    
    func getCompletedVerbModelGroup()->[VerbModelGroup]{
        var completedList = [VerbModelGroup]()
        for vmg in getList(){
            if vmg.completed() {completedList.append(vmg)}
        }
        return completedList
    }
    
    func getVerbModelSublistAtVerbEnding(modelName: String, verbEnding: VerbEnding)->[RomanceVerbModel]{
        let group = getGroupAtName(modelName: modelName)
        return group.getVerbModelSublistAtVerbEnding(verbEnding: verbEnding)
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
    
    func getVerbModelList(newVerbType: NewVerbModelType)->[RomanceVerbModel]{
        for vmg in verbModelGroupList{
            if vmg.getVerbModelType() == newVerbType {
                return vmg.getVerbModelList()
            }
        }
        return [RomanceVerbModel]()
    }
}
