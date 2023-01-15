//
//  LanguageEngineContextFree.swift
//  Feather2
//
//  Created by Charles Diggins on 12/31/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
    func getRandomAgnosticSentence(clause: dIndependentAgnosticClause, fpt: FeatherPhraseType){
        m_randomSentence.createRandomAgnosticPhrase(clause: clause, phraseType: fpt)
    }
    
    func resetFeatherSentenceHandler(){
        m_randomSentence = FeatherSentenceHandler(languageEngine: self, fpt: .subjectPronounVerb)
    }
}
