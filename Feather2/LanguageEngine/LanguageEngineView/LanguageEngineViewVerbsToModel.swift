//
//  LanguageEngineViewVerbsToModel.swift
//  Feather2
//
//  Created by Charles Diggins on 12/17/22.
//

import Foundation

extension LanguageViewModel{
    
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
}
