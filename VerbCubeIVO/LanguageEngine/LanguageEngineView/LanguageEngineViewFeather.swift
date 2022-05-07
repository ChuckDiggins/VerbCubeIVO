//
//  LanguageEngineViewFeather.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/26/22.
//

import Foundation

import JumpLinguaHelpers

extension LanguageViewModel{
    func findVerbsOfDifferentModel(modelID: Int, inputVerbList: [Verb])->[Verb]{
        return languageEngine.findVerbsOfDifferentModel(modelID: modelID, inputVerbList: inputVerbList)
    }
    
    func findVerbsFromSameModel(verb: Verb)->[Verb]{
        return languageEngine.findVerbsFromSameModel(verb: verb)
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
    
    func conjugateAsRegularVerb(verb: Verb, tense: Tense, person: Person)->String{
        return languageEngine.conjugateAsRegularVerb(verb: verb, tense: tense, person: person)
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
