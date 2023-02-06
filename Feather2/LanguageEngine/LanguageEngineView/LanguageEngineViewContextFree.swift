//
//  LanguageEngineViewContextFree.swift
//  Feather2
//
//  Created by Charles Diggins on 12/31/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageViewModel{
    func getRandomAgnosticSentence(clause: dIndependentAgnosticClause, fpt: FeatherPhraseType){
        languageEngine.getRandomAgnosticSentence(clause: clause, fpt: fpt)
    }
    
    func resetFeatherSentenceHandler(){
        languageEngine.resetFeatherSentenceHandler()
    }
}
