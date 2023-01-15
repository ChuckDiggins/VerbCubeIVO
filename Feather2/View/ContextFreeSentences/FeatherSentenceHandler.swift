//
//  FeatherSentenceHandler.swift
//  Feather2
//
//  Created by Charles Diggins on 12/31/22.
//

import Foundation
import JumpLinguaHelpers

//handles create templates that will guide
//  in creating sentences of various complexity of random words

enum FeatherPhraseType : String{
    case subjectPronounVerb = "subject pronoun - verb"
    case subjectPronounVerbLikeGustar = "subject pronoun - verb like gustar"
}

struct FeatherSentenceHandler {
    var languageEngine: LanguageEngine
    var m_wsp : WordStringParser!
    var m_randomWord : RandomFeatherWordLists!
    var m_fpt = FeatherPhraseType.subjectPronounVerb
    var m_wordList = [Word]()
    
    init (languageEngine: LanguageEngine, fpt:FeatherPhraseType){
        self.languageEngine = languageEngine
        self.m_wsp = languageEngine.m_wsp
        self.m_randomWord = RandomFeatherWordLists(languageEngine: languageEngine)
        self.m_fpt = fpt
    }
    
    mutating func setRandomPhraseType(fpt: FeatherPhraseType){
        m_fpt = fpt
    }
    
    mutating func createRandomAgnosticPhrase(clause: dIndependentAgnosticClause, phraseType: FeatherPhraseType) {
        switch phraseType{
        case .subjectPronounVerb:
            return createAgnosticSubjectPronounVerbClause(clause: clause)
        default: break
        }
    }
    
    public mutating func createAgnosticSubjectPronounVerbClause(clause: dIndependentAgnosticClause){
        let NP1 = dNounPhrase()
        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .PersPro, isSubject:true))
        let VP = dVerbPhrase()
        var single = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false)
        VP.appendCluster(cluster: single)
        clause.clearClusterList()
        clause.appendCluster(cluster: NP1)
        clause.appendCluster(cluster: VP)
        
        clause.setHeadNounAndHeadVerb()
        clause.processInfo()
    }
    
}

