//
//  LanguageEngineViewFeather.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/26/22.
//

import Foundation

import JumpLinguaHelpers

extension LanguageViewModel{
    
    func getCurrentVerbModel()->RomanceVerbModel{
        languageEngine.getCurrentVerbModel()
    }
    
    func setCurrentVerbModel(model: RomanceVerbModel){
        languageEngine.setCurrentVerbModel(model: model)
    }

    func getCurrentRandomVerb()->Verb{
        return languageEngine.getCurrentRandomVerb()
    }
    
    func getRandomEnglishVerbs(maxCount: Int)->[Verb]{
        languageEngine.getRandomEnglishVerbs(maxCount: maxCount)
    }
    
    func setVerbsForCurrentVerbModel(modelID: Int){
        languageEngine.setVerbsForCurrentVerbModel(modelID: modelID)
    }
    
    func findModelForThisVerbString(verbWord: String)->RomanceVerbModel{
        return languageEngine.findModelForThisVerbString(verbWord: verbWord)
    }
    
    func findVerbsOfDifferentModel(modelID: Int, inputVerbList: [Verb])->[Verb]{
        return languageEngine.findVerbsOfDifferentModel(modelID: modelID, inputVerbList: inputVerbList)
    }
    
    func findVerbsFromSameModel(verb: Verb)->[Verb]{
        return languageEngine.findVerbsFromSameModel(verb: verb)
    }
    
    func setCurrentPattern(pattern: SpecialPatternType){
        languageEngine.setCurrentPattern(pattern: pattern)
    }
    
    func getCurrentPattern()->SpecialPatternType{
        languageEngine.getCurrentPattern()
    }
    
    func getPatternsForVerb(verb: Verb, tense: Tense)->[SpecialPatternStruct]{
        return languageEngine.getPatternsForVerb(verb: verb, tense: tense)
    }
    
    func findVerbsFromSamePatternsAsVerb(verb: Verb, tense: Tense)->[Verb]{
        return languageEngine.findVerbsFromSamePatternsAsVerb(verb: verb, tense: tense)
    }
    
    func findVerbsOfSameModel(modelID: Int, inputVerbList: [Verb])->[Verb]{
        return languageEngine.findVerbsOfSameModel(modelID: modelID, inputVerbList: inputVerbList)
    }
    
    func findVerbsOfSameModel(targetID: Int)->[Verb]{
        return languageEngine.findVerbsOfSameModel(targetID: targetID)
    }
    
    func getModelStringAtTensePerson(bVerb: BRomanceVerb, tense: Tense, person: Person)->(String, String){
        return languageEngine.getModelStringAtTensePerson(bVerb: bVerb, tense: tense, person: person)
    }
    
    //SpecialPatternType is the enum
    //SpecialPatternStruct comprises tense and SpecialPatternType
    
    func getPatternsForThisModel(verbModel: RomanceVerbModel)->[SpecialPatternStruct]{
        languageEngine.getPatternsForThisModel(verbModel: verbModel)
    }
    
    func getVerbsForPatternGroup(patternType: SpecialPatternType)->[Verb]{
        return languageEngine.getVerbsForPatternGroup(patternType: patternType)
    }
    
    func getVerbsOfPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[Verb]{
        return languageEngine.getVerbsOfPattern(verbList: verbList, thisPattern: thisPattern)
    }
    
    func getVerbsOfDifferentPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[Verb]{
        return languageEngine.getVerbsOfDifferentPattern(verbList: verbList, thisPattern: thisPattern)
    }
    
    func getModelsOfPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[RomanceVerbModel]{
        return languageEngine.getModelsOfPattern(verbList: verbList, thisPattern: thisPattern)
    }
    
    func getModelIdsOfPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[Int]{
        return languageEngine.getModelIdsOfPattern(verbList: verbList, thisPattern:thisPattern)
    }
    
    func getModelsWithVerbEnding(verbEnding: VerbEnding)->[RomanceVerbModel]{
        return languageEngine.getModelsWithVerbEnding(verbEnding: verbEnding)
    }
    
    func getModelsWithSameVerbEndingInModelList(verbEnding: VerbEnding, modelList: [RomanceVerbModel])->[RomanceVerbModel]{
        return languageEngine.getModelsWithSameVerbEndingInModelList(verbEnding: verbEnding, modelList: modelList)
    }
    
    func conjugateAsRegularVerb(verb: Verb, tense: Tense, person: Person, isReflexive: Bool, residPhrase: String)->String{
        return languageEngine.conjugateAsRegularVerb(verb: verb, tense: tense, person: person, isReflexive: isReflexive, residPhrase: residPhrase)
    }
    
    func conjugateAsRegularVerbWithThisVerbEnding(verbEnding: VerbEnding, verb: Verb, tense: Tense, person: Person)->String{
        return languageEngine.conjugateAsRegularVerbWithThisVerbEnding(verbEnding: verbEnding, verb: verb, tense: tense, person: person)
    }
    
    func getVerbModelsWithVerbEnding(verbEnding: VerbEnding)->[RomanceVerbModel]{
        return languageEngine.getVerbModelsWithVerbEnding(verbEnding:verbEnding)
    }
    
    func getCommonVerbModelList()->[RomanceVerbModel]{
        return languageEngine.getCommonVerbModelList()
    }
    
    func getRegularVerbModelList()->[RomanceVerbModel]{
        return languageEngine.getRegularVerbModelList()
        
    }
}
