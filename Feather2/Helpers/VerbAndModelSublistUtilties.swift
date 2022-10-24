//
//  GetVerbListAtVerbEnding.swift
//  Feather2
//
//  Created by Charles Diggins on 10/21/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbAndModelSublistUtilities{
    func getModelSublistAtVerbEnding(inputModelList: [RomanceVerbModel], verbEnding: VerbEnding)->[RomanceVerbModel]{
        var modelSublist = [RomanceVerbModel]()
        if verbEnding == .ALL {
            modelSublist = inputModelList
        }
        else {
            for model in inputModelList {
                if VerbUtilities().determineVerbEnding(verbWord: model.modelVerb) == verbEnding {
                    modelSublist.append(model)
                }
            }
        }
        return modelSublist
    }
    
    func getModelPatternStructListSortedByTheirVerbCount(languageViewModel: LanguageViewModel, inputModelList: [RomanceVerbModel])->[ModelPatternStruct]{
        var modelDictionary: [String: Int] = [:]
        
        for model in inputModelList {
            let verbList = languageViewModel.findVerbsOfSameModel(targetID: model.id)
            modelDictionary.updateValue(verbList.count, forKey: model.modelVerb)
        }
        let sortInfo = modelDictionary.sorted(by: { $0.value > $1.value } )
        
        var modelPatternStructList = [ModelPatternStruct]()
        sortInfo.forEach {key, value in
            for model in inputModelList {
                if model.modelVerb == "\(key)" {
                    modelPatternStructList.append(ModelPatternStruct(id: model.id, model: model, count: value, completed: false))
                    break
                }
            }
        }
        return modelPatternStructList
    }
    
    func getVerbSublistAtVerbEnding(inputVerbList: [Verb], ending: VerbEnding, language: LanguageType)->[Verb]{
        var verbSublist = [Verb]()
        
        for verb in inputVerbList {
            var isNew = true
            if getRomanceVerbEnding(verb: verb, language: language) == ending {
                for subVerb in verbSublist {
                    if subVerb == verb {
                        isNew = false
                    }
                }
                if isNew { verbSublist.append(verb) }
            }
        }
        //if verb ending is .IR, look for accented ir ending also: oír, for example
        
        if ending == .IR {
            for verb in inputVerbList {
                var isNew = true
                if getRomanceVerbEnding(verb: verb, language: language) == .accentIR {
                    for subVerb in verbSublist {
                        if subVerb == verb {
                            isNew = false
                        }
                    }
                    if isNew { verbSublist.append(verb) }
                    
                }
            }
        }
        return verbSublist
    }
    
    func getRomanceVerbEnding(verb: Verb, language: LanguageType)->VerbEnding{
        let vu = VerbUtilities()
        switch language {
        case .Spanish:
            let verbWord = verb.getWordAtLanguage(language: language)
            let result = vu.analyzeSpanishWordPhrase(testString: verbWord)
            return result.1
        case .French:
            let verbWord = verb.getWordAtLanguage(language: language)
            let result = vu.analyzeFrenchWordPhrase(phraseString: verbWord)
            return result.1
        default:
            return VerbEnding.none
        }
    }
}
