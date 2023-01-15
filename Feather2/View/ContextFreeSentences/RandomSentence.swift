////
////  CFSentenceGeneratorRule.swift
////  ContextFree
////
////  Created by Charles Diggins on 5/2/21.
////
//
//import Foundation
//import JumpLinguaHelpers
////handles create templates that will guide
////  in creating sentences of various complexity of random words
//
//
//public enum RandomPhraseType : String{
//    case twoArticles = "Two articles"
//    case articleNoun  = "Article-noun"
//    case subjectPronounVerb = "subject pronoun - verb"
//    case gustarTypeVerbPhrase = "gustar-type phrase"
//    case simpleNounPhrase = "Simple noun phrase"
//    case simplePrepositionPhrase = "Simple prepositional phrase"
//    case simpleVerbPhrase = "Simple verb phrase"
//    case simpleVerbAdverbPhrase = "Simple verb-adverb phrase"
//    case complexNounPhrase = "Complex noun phrase"
//    case simpleClause = "Simple clause"
//    case simpleEnglishClause = "Simple English clause"
//    case simpleAdjectiveRegular = "Simple adjective"
//    case simpleAdjectivePossessive = "Simple possessive adjective"
//    case simpleAdjectiveInterrogative = "Simple interrogative adjective"
//    case simpleAdjectiveDemonstrative = "Simple demonstrative adjective"
//}
//
//public struct RandomSentence {
//    public var m_wsp : WordStringParser!
//    public var m_randomWord : RandomWordLists!
//    public var m_rft = RandomPhraseType.simpleNounPhrase
//    public var m_wordList = [Word]()
//    
//    public init (wsp : WordStringParser, rft:RandomPhraseType){
//        self.m_wsp = wsp
//        self.m_randomWord = RandomWordLists(wsp: m_wsp)
//        self.m_rft = rft
//    }
//    
//    public init(){
//        self.m_wsp = WordStringParser()
//        self.m_randomWord = RandomWordLists(wsp: m_wsp)
//        self.m_rft = RandomPhraseType.simpleNounPhrase
//    }
//    
//    public mutating func setRandomPhraseType(rft: RandomPhraseType){
//        m_rft = rft
//    }
//
//    public  mutating func createRandomAgnosticPhrase(phraseType: RandomPhraseType)->dIndependentAgnosticClause {
//  
////        switch phraseType{
////        case .simpleClause:
////            return createSimpleAgnosticClause()
////        case .simpleEnglishClause:
////            return createSimpleAgnosticEnglishClause()
////        case .subjectPronounVerb:
////            return createAgnosticSubjectPronounVerbClause()
////        case .simpleNounPhrase:
////            return createSimpleNounPhrase()
////        case .simplePrepositionPhrase:
////            return createSimplePrepositionPhrase()
////        case .simpleVerbAdverbPhrase:
////            return createSimpleVerbAdverbPhrase()
////
////        default: return dIndependentAgnosticClause()
////        }
//        //return empty clause
//        let agnosticClause = dIndependentAgnosticClause()
//        let phrase = dPhrase()
//        agnosticClause.appendCluster(cluster: phrase)
//        agnosticClause.setHeadNounAndHeadVerb()
//        return agnosticClause
//    }
//    
//    public mutating func createRandomAgnosticPhrase(clause: dIndependentAgnosticClause, phraseType: RandomPhraseType) {
//        
//        switch phraseType{
//        case .simpleClause:
//            return createSimpleAgnosticClause(clause: clause)
//        case .simpleEnglishClause:
//            return createSimpleAgnosticEnglishClause(clause: clause)
//        case .subjectPronounVerb:
//            return createAgnosticSubjectPronounVerbClause(clause: clause)
//        case .simpleNounPhrase:
//            return createSimpleNounPhrase(clause: clause)
//        case .simplePrepositionPhrase:
//            return createSimplePrepositionPhrase(clause: clause)
//        case .simpleVerbAdverbPhrase:
//            return createSimpleVerbAdverbPhrase(clause: clause)
//        
//        default: break
//        }
//    }
//    
//    
////
//    
//    public mutating func createSimpleAgnosticClause(clause: dIndependentAgnosticClause){
//        var clausePerson = Person.S3
//        let NP1 = dNounPhrase()
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        let nounSingle1 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true)
//        NP1.appendCluster(cluster: nounSingle1)
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        clausePerson = nounSingle1.getPerson()
//        NP1.setPerson(value: nounSingle1.getPerson())
//        NP1.processInfo()
//        
//        let NP2 = dNounPhrase()
//        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        let nounSingle2 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false)
//        NP2.appendCluster(cluster: nounSingle2)
//        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        NP2.setPerson(value: nounSingle2.getPerson())
//        NP2.processInfo()
//        
//        let PP1 = dPrepositionPhrase()
//        PP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .P, isSubject:false))
//        PP1.appendCluster(cluster: NP2)
//        
//        let NP3 = dNounPhrase()
//        NP3.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        let nounSingle3 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false)
//        NP3.appendCluster(cluster: nounSingle3)
//        NP3.setPerson(value: nounSingle3.getPerson())
//        NP3.processInfo()
//        
//        let VP = dVerbPhrase()
//        let vs = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false)
//        VP.appendCluster(cluster: vs )
//        VP.appendCluster(cluster: NP3)
//        VP.appendCluster(cluster: PP1)
////        let clause = dIndependentAgnosticClause()
//        clause.clearClusterList()
//        clause.appendCluster(cluster: NP1)
//        clause.appendCluster(cluster: VP)
//        
//        clause.setPerson(value: clausePerson)
//        clause.setHeadNounAndHeadVerb()
//        clause.processInfo()
//    }
//    
//    
//    public mutating func createSimpleAgnosticEnglishClause(clause: dIndependentAgnosticClause){
//        let NP1 = dNounPhrase()
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//        NP1.setPerson(value: .S3)
//        NP1.processInfo()
//        NP1.dumpClusterInfo(str: "createSimpleEnglishClause: NP1")
//        
//        let NP2 = dNounPhrase()
//        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false))
//        NP2.setPerson(value: .S3)
//        NP2.processInfo()
//        NP2.dumpClusterInfo(str: "createSimpleEnglishClause: NP2")
//        
//        let PP1 = dPrepositionPhrase()
//        PP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .P, isSubject:false))
//        PP1.appendCluster(cluster: NP2)
//        
//        let NP3 = dNounPhrase()
//        NP3.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        NP3.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false))
//        NP3.setPerson(value: .S3)
//        NP3.processInfo()
//        NP3.dumpClusterInfo(str: "createSimpleEnglishClause: NP3")
//        let VP = dVerbPhrase()
//        let vs = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false)
//        VP.appendCluster(cluster: vs )
//        VP.appendCluster(cluster: NP3)
//        VP.appendCluster(cluster: PP1)
////        let clause = dIndependentAgnosticClause()
//        clause.clearClusterList()
//        clause.appendCluster(cluster: NP1)
//        clause.appendCluster(cluster: VP)
//        
//        // should be like "la hombre alto comer el perro de la casa negro"
//        
//        clause.setHeadNounAndHeadVerb()
//        clause.processInfo()
////
////
////        return clause
//    }
//
//    public mutating func createAgnosticSubjectPronounVerbClause(clause: dIndependentAgnosticClause){
//        let NP1 = dNounPhrase()
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .PersPro, isSubject:true))
//        let VP = dVerbPhrase()
//        var single = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false)
//        VP.appendCluster(cluster: single)
////        print("VP = \(VP.getStringAtLanguage(language: .Spanish))")
//        
////        let clause = dIndependentAgnosticClause()
//        clause.clearClusterList()
//        clause.appendCluster(cluster: NP1)
//        clause.appendCluster(cluster: VP)
//        
//        clause.setHeadNounAndHeadVerb()
//        clause.processInfo()
////
////        return clause
//        
//    }
//    
//    public mutating func createSimpleNounPhrase(clause: dIndependentAgnosticClause){
//        let NP1 = dNounPhrase()
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        NP1.processInfo()
////        let clause = dIndependentAgnosticClause()
//        clause.clearClusterList()
//        clause.appendCluster(cluster: NP1)
////        return clause
//    }
//    
//    public mutating func createSimplePrepositionPhrase(clause: dIndependentAgnosticClause){
//        let NP1 = dNounPhrase()
//
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Art, isSubject:false))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        NP1.processInfo()
//
//        let PP1 = dPrepositionPhrase()
//        PP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .P, isSubject:false))
//        PP1.appendCluster(cluster: NP1)
////        let clause = dIndependentAgnosticClause()
//        clause.clearClusterList()
//        clause.appendCluster(cluster: PP1)
//        clause.processInfo()
////        return clause
//    }
//    
//    public mutating func createSimpleVerbAdverbPhrase(clause: dIndependentAgnosticClause){
//        let NP1 = dNounPhrase()
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//        NP1.processInfo()
//        let VP = dVerbPhrase()
//        VP.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false))
//        VP.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adv, isSubject:false))
//        VP.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .C, isSubject:false))
//        VP.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adv, isSubject:false))
//        VP.appendCluster(cluster: NP1)
////        let clause = dIndependentAgnosticClause()
//        clause.clearClusterList()
//        clause.appendCluster(cluster: VP)
//        
//        clause.setHeadNounAndHeadVerb()
//        clause.processInfo()
//        
////        return clause
//    }
//    
////    mutating func createTwoArticles()->dPhrase{
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP1.processInfo()
//    //        return NP1
//    //    }
//    //
//    //    mutating func createArticleNoun()->dPhrase{
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//    //        NP1.processInfo()
//    //        return NP1
//    //    }
//    //
//        
//    //
//        
//    
//    //    mutating func createComplexNounPhrase()->dPhrase{
//    //
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//    //        let single1 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false)
//    //        NP1.appendCluster(cluster: single1)
//    //
//    //
//    //        let NP2 = dNounPhrase()
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false))
//    //        let single2 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false)
//    //        NP2.appendCluster(cluster: single2)
//    //
//    //        let adj1 = single1 as! dAdjectiveSingle
//    //        let adj2 = single2 as! dAdjectiveSingle
//    //        adj1.setState(gender: .feminine, number: .singular)
//    //        adj2.setState(gender: .masculine, number: .plural)
//    //        NP1.processInfo()
//    //        NP2.processInfo()
//    //
//    //        let PP1 = dPrepositionPhrase()
//    //        PP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .P, isSubject:false))
//    //        PP1.appendCluster(cluster: NP2)
//    //
//    //        let NP3 = dNounPhrase()
//    //        NP3.appendCluster(cluster: NP1)
//    //        NP3.appendCluster(cluster: PP1)
//    //
//    //        return NP3
//    //    }
//    //
//    //    mutating func createSimpleVerbPhrase()->dPhrase{
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP1.processInfo()
//    //        let VP = dVerbPhrase()
//    //        VP.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false))
//    //        VP.appendCluster(cluster: NP1)
//    //        return VP
//    //    }
//    //
//        
//    //
//    //    mutating func createSubjectPronounVerbClause()->dIndependentClause{
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .PersPro, isSubject:false))
//    //        let VP = dVerbPhrase()
//    //        VP.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false))
//    //
//    //        let clause = dIndependentClause(language: m_wsp.getLanguage())
//    //        clause.appendCluster(cluster: NP1)
//    //        clause.appendCluster(cluster: VP)
//    //
//    //        clause.setHeadNounAndHeadVerb()
//    //
//    //        return clause
//    //
//    //    }
//    //
//    //    mutating func createSimpleEnglishClause()->dIndependentClause{
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true))
//    //        NP1.setPerson(value: .S3)
//    //        NP1.processInfo()
//    //        NP1.dumpClusterInfo(str: "createSimpleEnglishClause: NP1")
//    //
//    //        let NP2 = dNounPhrase()
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false))
//    //        NP2.setPerson(value: .S3)
//    //        NP2.processInfo()
//    //        NP2.dumpClusterInfo(str: "createSimpleEnglishClause: NP2")
//    //
//    //        let PP1 = dPrepositionPhrase()
//    //        PP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .P, isSubject:false))
//    //        PP1.appendCluster(cluster: NP2)
//    //
//    //        let NP3 = dNounPhrase()
//    //        NP3.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        NP3.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false))
//    //        NP3.setPerson(value: .S3)
//    //        NP3.processInfo()
//    //        NP3.dumpClusterInfo(str: "createSimpleEnglishClause: NP3")
//    //        let VP = dVerbPhrase()
//    //        let vs = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false)
//    //        VP.appendCluster(cluster: vs )
//    //        VP.appendCluster(cluster: NP3)
//    //        VP.appendCluster(cluster: PP1)
//    //        let clause = dIndependentClause(language: m_wsp.getLanguage())
//    //        clause.appendCluster(cluster: NP1)
//    //        clause.appendCluster(cluster: VP)
//    //
//    //        // should be like "la hombre alto comer el perro de la casa negro"
//    //
//    //        clause.setHeadNounAndHeadVerb()
//    //
//    //
//    //        return clause
//    //    }
//    //
//    //
//    //
//    //    mutating func createSimpleClause()->dIndependentClause{
//    //        let NP1 = dNounPhrase()
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        let nounSingle1 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:true)
//    //        NP1.appendCluster(cluster: nounSingle1)
//    //        NP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP1.setPerson(value: nounSingle1.getPerson())
//    //        NP1.processInfo()
//    //
//    //        let NP2 = dNounPhrase()
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        let nounSingle2 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false)
//    //        NP2.appendCluster(cluster: nounSingle2)
//    //        NP2.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Adj, isSubject:false))
//    //        NP2.setPerson(value: nounSingle2.getPerson())
//    //        NP2.processInfo()
//    //
//    //        let PP1 = dPrepositionPhrase()
//    //        PP1.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .P, isSubject:false))
//    //        PP1.appendCluster(cluster: NP2)
//    //
//    //        let NP3 = dNounPhrase()
//    //        NP3.appendCluster(cluster: m_randomWord.getAgnosticRandomWordAsSingle(wordType: .Det, isSubject:false))
//    //        let nounSingle3 = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .N, isSubject:false)
//    //        NP3.appendCluster(cluster: nounSingle3)
//    //        NP3.setPerson(value: nounSingle3.getPerson())
//    //        NP3.processInfo()
//    //
//    //        let VP = dVerbPhrase()
//    //        let vs = m_randomWord.getAgnosticRandomWordAsSingle(wordType: .V, isSubject:false)
//    //        VP.appendCluster(cluster: vs )
//    //        VP.appendCluster(cluster: NP3)
//    //        VP.appendCluster(cluster: PP1)
//    //        let clause = dIndependentClause(language: m_wsp.getLanguage())
//    //        clause.appendCluster(cluster: NP1)
//    //        clause.appendCluster(cluster: VP)
//    //
//    //        // should be like "la hombre alto comer el perro de la casa negro"
//    //
//    //        clause.setHeadNounAndHeadVerb()
//    //
//    //
//    //        return clause
//    //    }
//    
//}
