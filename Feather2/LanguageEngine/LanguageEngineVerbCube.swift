//
//  LanguageEngineCube.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/4/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
    
    func fillVerbCubeLists(){
        verbCubeList.removeAll()
        for verb in filteredVerbList {
            let bVerb = verb.getBVerb()
            if !bVerb.isPhrasalVerb(){
                verbCubeList.append(verb)
            }
        }
        verbBlockCount = min(6, verbCubeList.count)
        startingVerbCubeListIndex = 0
        verbCubeVerbIndex = 0
        print("fillVerbCubeLists: filteredVerbList count = \(filteredVerbList.count), verbCubeList count = \(verbCubeList.count)")
    }
    
    func getVerbCubeVerb(index: Int)->Verb{
        if index <= 0 && index < verbCubeList.count { return verbCubeList[index] }
        return verbCubeList[0]
    }
    
    func setNextVerbCubeVerb(){
        verbCubeVerbIndex += 1
        
        if (verbCubeVerbIndex >= verbCubeList.count ){
            verbCubeVerbIndex = 0
        }
    }
    
    func setPreviousVerbCubeVerb(){
        verbCubeVerbIndex -= 1
        
        if (verbCubeVerbIndex < 0 ){
            verbCubeVerbIndex = verbCubeList.count - 1
        }
    }
    
    func getCurrentVerbCubeVerb()->Verb{
        return verbCubeList[verbCubeVerbIndex]
    }
    
    func setPreviousCubeBlockVerbs(){
        verbCubeBlock.removeAll()
        startingVerbCubeListIndex = startingVerbCubeListIndex - verbBlockCount
        if (startingVerbCubeListIndex < 0 ){
            startingVerbCubeListIndex = 0
        }
        for i in 0 ..< verbBlockCount {
            verbCubeBlock.append (verbCubeList[startingVerbCubeListIndex + i])
        }
    }
    
    func setNextVerbCubeBlockVerbs(){
        verbCubeBlock.removeAll()
        startingVerbCubeListIndex = startingVerbCubeListIndex + verbBlockCount
        if (startingVerbCubeListIndex+verbBlockCount >= verbCubeList.count ){
//            startingVerbCubeListIndex = verbCubeList.count - verbBlockCount - 1
            startingVerbCubeListIndex = verbCubeList.count - verbBlockCount
        }
        if startingVerbCubeListIndex < 0 { startingVerbCubeListIndex = 0 }
        for i in 0 ..< verbBlockCount {
            verbCubeBlock.append (verbCubeList[startingVerbCubeListIndex + i])
        }
    }
    
    
    func getVerbCubeBlock()->[Verb]{
        return verbCubeBlock
    }
    
    
    
    
    func getVerbCubeBlockVerb(i: Int)->Verb{
        if i >= 0 && i < verbCubeBlock.count {
            return verbCubeBlock[i]
        }
        return Verb()
    }
    
    
    
    
}


