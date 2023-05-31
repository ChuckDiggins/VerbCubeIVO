//
//  LanguageEngineReflexive.swift
//  Feather2
//
//  Created by Charles Diggins on 5/16/23.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
    func getReflexiveVerbManager()->ReflexiveVerbManager{
        reflexiveVerbManager
    }
    
    func fillReflexiveVerbLists(){
        fillNonReflexivePairList(strList: nonreflexiveVerbStringList, reflexiveVerbManager: reflexiveVerbManager)
        fillReciprocalPairList(strList: reciprocalVerbStringList, reflexiveVerbManager: reflexiveVerbManager)
        fillNormalReflexivePairList(strList: normalReflexiveVerbStringList, reflexiveVerbManager: reflexiveVerbManager)
        fillReflexiveOnlyPairList(strList: reflexiveOnlyVerbStringList, reflexiveVerbManager: reflexiveVerbManager)
    }
    
    func fillNonReflexivePairList(strList: [String], reflexiveVerbManager: ReflexiveVerbManager){
        for str in strList {
            let verb = findVerbFromString(verbString: str, language: getCurrentLanguage())
            if verb.word.count > 0 {
                var reflStr = str + "se"
                let reflVerb = findVerbFromString(verbString: reflStr, language: getCurrentLanguage())
                if reflVerb.word.count > 0 {
                    reflexiveVerbManager.reflexiveList.append(FeatherVerbPair(verb, reflVerb))
                }
            }
        }
    }
    
    func fillReciprocalPairList(strList: [String], reflexiveVerbManager: ReflexiveVerbManager){
        for str in strList {
            let verb = findVerbFromString(verbString: str, language: getCurrentLanguage())
            if verb.word.count > 0 {
                var recipStr = str + "se"
                var recipVerb = findVerbFromString(verbString: recipStr, language: getCurrentLanguage())
                //if ref
                if recipVerb.word.count > 0 {
                    reflexiveVerbManager.reciprocalList.append(FeatherVerbPair(verb, recipVerb))
                } else {
                    recipStr = verb.spanish + "se"
                    let englishStr = verb.english + " each other"
                    recipVerb = Verb(spanish: recipStr, french: "",  english: englishStr)
                    reflexiveVerbManager.reciprocalList.append(FeatherVerbPair(verb, recipVerb))
                }
            }
        }
    }
    
    func fillNormalReflexivePairList(strList: [String], reflexiveVerbManager: ReflexiveVerbManager){
        for str in strList {
            let verb = findVerbFromString(verbString: str, language: getCurrentLanguage())
            if verb.word.count > 0 {
                var reflStr = str + "se"
                let reflVerb = findVerbFromString(verbString: reflStr, language: getCurrentLanguage())
                if reflVerb.word.count > 0 {
                    reflexiveVerbManager.normalReflexiveList.append(FeatherVerbPair(verb, reflVerb))
                }
            }
        }
    }
    
    func fillReflexiveOnlyPairList(strList: [String], reflexiveVerbManager: ReflexiveVerbManager){
        let nullVerb = Verb()
        for str in strList {
            let verb = findVerbFromString(verbString: str, language: getCurrentLanguage())
            if verb.word.count > 0 {
                reflexiveVerbManager.onlyReflexiveList.append(FeatherVerbPair(nullVerb, verb))
            }
        }
    }
    
}
