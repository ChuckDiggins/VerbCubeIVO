//
//  LanguageEngineViewVerbCube.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageViewModel{
    
    func fillVerbCubeLists(){
        languageEngine.fillVerbCubeLists()
    }
    
    func getVerbCubeVerb(index: Int)->Verb{
        languageEngine.getVerbCubeVerb(index: index)
    }
    
    func setNextVerbCubeVerb(){
        languageEngine.setNextVerbCubeVerb()
    }
    
    func setPreviousVerbCubeVerb(){
        languageEngine.setPreviousVerbCubeVerb()
    }
    
    func getCurrentVerbCubeVerb()->Verb{
        languageEngine.getCurrentVerbCubeVerb()
    }
    
    func setPreviousCubeBlockVerbs(){
        languageEngine.setPreviousCubeBlockVerbs()
    }
    
    func setNextVerbCubeBlockVerbs(){
        languageEngine.setNextVerbCubeBlockVerbs()
    }
    
    
    func getVerbCubeBlock()->[Verb]{
        languageEngine.getVerbCubeBlock()
    }
    
    func getVerbCubeBlockVerb(i: Int)->Verb{
        languageEngine.getVerbCubeBlockVerb(i: i)
    }

}
