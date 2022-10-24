//
//  LanguageEngineBehavioral.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/15/22.
//

import Foundation
import JumpLinguaHelpers


extension LanguageEngine{
    
    func getBehavioralVerbModel()->BehavioralVerbModel{
        return behavioralVerbModel
    }
    
    func setBehaviorType(bt: BehaviorType){
        behaviorType = bt
        behaviorVerbList = behavioralVerbModel.getVerbs(language: getCurrentLanguage(), bt: behaviorType)
        behavioralVerbIndex = 0
    }
    
    func getCurrentBehavioralVerb()->Verb{
        return behaviorVerbList[behavioralVerbIndex]
    }
    
    func getBehavioralVerbCount()->Int{
        behaviorVerbList.count
    }
    
    func setNextBehavioralVerb(){
        behavioralVerbIndex += 1
        if behavioralVerbIndex > getBehavioralVerbCount()-1 {
            behavioralVerbIndex = 0
        }
    }
    
    func setPreviousBehavioralVerb(){
        behavioralVerbIndex -= 1
        if behavioralVerbIndex < 0 {
            behavioralVerbIndex = getBehavioralVerbCount()-1
        }
    }
    
    func isAuxiliary(verb: Verb)->(Bool, Tense){
        behavioralVerbModel.isAuxiliary(language: getCurrentLanguage(), verb: verb)
    }
    
}
    
