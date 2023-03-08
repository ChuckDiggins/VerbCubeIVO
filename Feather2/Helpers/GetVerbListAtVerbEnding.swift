//
//  GetVerbListAtVerbEnding.swift
//  Feather2
//
//  Created by Charles Diggins on 10/21/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbAndModelSublistUtilities{
    func getModelSublistAtVerbEnding(inputModelList: [RomanceVerbModel], ending: VerbEnding, language: LanguageType)->[RomanceVerbModel]{
        var modelSublist = [RomanceVerbModel]()
        
        for model in inputModelList {
            if VerbUtilities().determineVerbEnding(verbWord: model.modelVerb) == ending {
                modelSublist.append(model)
            }
        }
        return modelSublist
    }
    
    
    func getSublistAtVerbEnding(inputVerbList: [Verb], ending: VerbEnding, language: LanguageType)->[Verb]{
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
