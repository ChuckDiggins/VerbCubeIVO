//
//  LanguageEngineViewVerbsToModel.swift
//  Feather2
//
//  Created by Charles Diggins on 12/17/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageViewModel{
    func setToVerbModelMode(){
        languageEngine.setToVerbModelMode()
        
    }
    
    func setVerbOrModelMode(_ verbOrModelModeString: String){
        languageEngine.setVerbOrModelMode(verbOrModelModeString)
    }
    
    func setToVerbMode(){
        languageEngine.setToVerbMode()
    }
    
    func setToVerbMode(_ chapterString: String, _ lessonString: String){
        languageEngine.setToVerbMode(chapterString, lessonString)
    }
    
    func setStudyPackageTo(_ chapterString: String, _ lessonString: String){
        languageEngine.setStudyPackageTo(chapterString, lessonString)
    }
    
    func setVerbModelTo(_ verbModel: RomanceVerbModel){
        languageEngine.setVerbModelTo(verbModel)
    }
    
    
    func getV2MGroupManager()->VerbToModelGroupManager{
        languageEngine.v2MGroupManager
    }
    
    func getV2MGroup()->VerbToModelGroup{
        languageEngine.v2MGroup
    }
    
    func setV2MGroup(v2MGroup: VerbToModelGroup){
        languageEngine.setV2MGroup(v2MGroup: v2MGroup)
    }
 
    func convertV2MGroupToStudyPackage(v2MGroup: VerbToModelGroup)->StudyPackageClass{
        languageEngine.convertV2MGroupToStudyPackage(v2mGroup: v2MGroup)
    }
    
    func processVerbModel(vm: RomanceVerbModel){
        languageEngine.processVerbModel(currentModel: vm)
    }
    
    func trimFilteredVerbList(_ maxCount : Int = 16){
        languageEngine.trimFilteredVerbList(maxCount)
    }
    
}
