//
//  RandomFeatherWordLists.swift
//  Feather2
//
//  Created by Charles Diggins on 12/31/22.
//

import Foundation
import JumpLinguaHelpers

struct RandomFeatherWordLists  {
    var id = UUID()
    static func == (lhs: RandomFeatherWordLists, rhs: RandomFeatherWordLists) -> Bool {
        return lhs.m_language == rhs.m_language
    }
    
    var m_wsp : WordStringParser?
    var languageEngine: LanguageEngine
    var m_language = LanguageType.Spanish
    var m_subjects = Array<Word>()
    
    var m_nouns = Array<Word>()
    var m_objects = Array<Word>()
    
    var m_adverbs = Array<Word>()
    var m_conjunctions = Array<Word>()
    var m_determiners = Array<Word>()
    var m_adjectives = Array<Word>()
    var m_prepositions = Array<Word>()
    var m_pronouns = Array<Word>()
    var sentenceData = Array<SentenceData>()
    var m_verbs = Array<Verb>()
    
    init(languageEngine: LanguageEngine){
        self.languageEngine = languageEngine
        m_wsp = languageEngine.m_wsp
        m_language = languageEngine.getCurrentLanguage()
        createListOfAgnosticSubjects()
        createListOfAgnosticObjects()
        createListOfAgnosticDeterminers()
        createListOfAgnosticAdjectives()
        createListOfAgnosticAdverbs()
        createListOfAgnosticConjunctions()
        createListOfAgnosticPrepositions()
        createListOfAgnosticPronouns()
        createListOfAgnosticVerbs()
    }
    
    mutating func createListOfAgnosticAdjectives(){
        m_adjectives.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .adjective) {
            m_adjectives.append( m_wsp!.getAgnosticWordFromDictionary(wordType:.adjective, index: i))
        }
    }
    
    mutating func createListOfAgnosticAdverbs(){
        m_adverbs.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .adverb) {
            let w = m_wsp!.getAgnosticWordFromDictionary(wordType:.adverb, index: i)
            let adv = w as! Adverb
            if (adv.type == .manner || adv.type == .time){
                m_adverbs.append(w)
            }
        }
    }
    
    mutating func createListOfAgnosticConjunctions(){
        m_conjunctions.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .conjunction) {
            let w = m_wsp!.getAgnosticWordFromDictionary(wordType:.conjunction, index: i)
            let conj = w as! Conjunction
            if (conj.type == .and){
                m_conjunctions.append(w)
            }
        }
    }
    

    mutating func createListOfAgnosticDeterminers(){
        m_determiners.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .determiner) {
            let w = m_wsp!.getAgnosticWordFromDictionary(wordType:.determiner, index: i)
            let det = w as! Determiner
            if (det.type == .interrogative || det.type == .partative){continue}
            m_determiners.append(det)
        }
    }
    
    mutating func createListOfAgnosticSubjects(){
        m_subjects.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .noun) {
            //get language-converted noun from dictionary
            let w = m_wsp!.getAgnosticWordFromDictionary(wordType:.noun, index: i)
//            let noun = w as! Noun
//            if (noun.nounType == .person || noun.nounType == .animal ) {m_subjects.append(w)}
            m_subjects.append(w)
        }
    }
    
    mutating func createListOfAgnosticObjects(){
        m_objects.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .noun) {
            //get language-converted noun from dictionary
            let w = m_wsp!.getAgnosticWordFromDictionary(wordType:.noun, index: i)
//            let noun = w as! Noun
//            if (noun.nounType == .plant || noun.nounType == .thing || noun.nounType == .place){m_objects.append(noun) }
            m_objects.append(w)
        }
    }
    
    mutating func createListOfAgnosticPronouns(){
        m_pronouns.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .pronoun) {
            m_pronouns.append(m_wsp!.getAgnosticWordFromDictionary(wordType:.pronoun,  index: i))
        }
    }
 
    mutating func createListOfAgnosticVerbs(){
        for verb in languageEngine.getFilteredVerbs(){
            m_verbs.append(verb)
        }
    }
    
    mutating func createListOfAgnosticPrepositions(){
        m_prepositions.removeAll()
        for i in 0 ..< m_wsp!.getWordCount(wordType: .preposition) {
            //get language-converted noun from dictionary
            m_prepositions.append(m_wsp!.getAgnosticWordFromDictionary(wordType:.preposition,  index: i))
        }
    }


   

    func getAgnosticRandomWordAsSingle(wordType : ContextFreeSymbol, isSubject:Bool)->dSingle{
        var word = Word()
        var i = 0
        var single = dSingle()
        
        switch wordType{
        
        case .AMB:
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            i = Int.random(in: 0 ..< m_determiners.count)
            word = m_determiners[i]
            wsd.word = word
            wsd.articleType = .definite
            var number = Int.random(in: 1 ..< 3)
            if ( number == 1 ) { wsd.gender = .masculine}
            else {wsd.gender = .feminine}
            wsd.gender = .masculine
            number = Int.random(in: 1 ..< 3)
            if ( number == 1 ) { wsd.number = .singular}
            else {wsd.number = .plural}
            wsd.wordType = .Art
            //create a new instance of this article
            if wsd.language == .Spanish {
                let newArt = SpanishArticle()
                single = dArticleSingle(word: newArt, data: wsd)
            }
            else if wsd.language == .French {
                let newArt = FrenchArticle()
                single = dArticleSingle(word: newArt, data: wsd)
            }
            else if wsd.language == .English {
                let newArt = EnglishArticle(word: word.word, def: "", type: .definite)
                single = dArticleSingle(word: newArt, data: wsd)
            }
        case .Det:
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            i = Int.random(in: 0 ..< m_determiners.count)
            word = m_determiners[i]
            let det = word as! Determiner
            wsd.word = word
            wsd.determinerType = det.type
            //gender and number will be reconciled to their associated noun, but set them anyway
            var number = Int.random(in: 1 ..< 3)
            if ( number == 1 ) { wsd.gender = .masculine}
            else {wsd.gender = .feminine}
            wsd.gender = .masculine
            number = Int.random(in: 1 ..< 3)
            if ( number == 1 ) { wsd.number = .singular}
            else {wsd.number = .plural}
            
            wsd.wordType = .Det
            single = dDeterminerSingle(word: word, data: wsd)
        case .Adj:
            i = Int.random(in: 0 ..< m_adjectives.count)
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            word = m_adjectives[i]
            let adj = word as! Adjective
            wsd.word = word
            wsd.adjectiveType = adj.type
            wsd.wordType = .Adj
            single = dAdjectiveSingle(word: word, data: wsd)
        case .Adv:
            i = Int.random(in: 0 ..< m_adverbs.count)
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            word = m_adverbs[i]
            let adv = word as! Adverb
            wsd.word = word
            wsd.adverbType = adv.type
            wsd.wordType = .Adv
            single = dAdverbSingle(word: word, data: wsd)
        case .C:
            i = Int.random(in: 0 ..< m_conjunctions.count)
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            word = m_conjunctions[i]
            let conj = word as! Conjunction
            wsd.word = word
            wsd.conjunctionType = conj.type
            wsd.wordType = .C
            single = dConjunctionSingle(word: word, data: wsd)
        case .P:
            i = Int.random(in: 0 ..< m_prepositions.count)
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            word = m_prepositions[i]
            wsd.word = word
            let prep = word as! Preposition
            wsd.prepositionType = prep.type
            wsd.wordType = .P
            single = dPrepositionSingle(word: word, data: wsd)
        case .N:
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            if isSubject {
                i = Int.random(in: 0 ..< m_subjects.count)
                word = m_subjects[i]
            }else{
                i = Int.random(in: 0 ..< m_objects.count)
                word = m_objects[i]
            }

            let number = Int.random(in: 1 ..< 3)
            
            if ( number == 1 ) {
                wsd.number = .singular
                wsd.person = .S3
            }
            else {
                wsd.number = .plural
                wsd.person = .P3
            }
            
            wsd.word = word
            let noun = word as! Noun
            wsd.gender = noun.spanishGender
            wsd.nounType = noun.nounType
            
            
            wsd.wordType = .N
            single = dNounSingle(word: word, data: wsd)
            let ns = single as! dNounSingle
            ns.setIsSubject(flag: isSubject)
        case .PersPro:
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            if isSubject {
                for i in 0 ..< m_pronouns.count{
                    word = m_pronouns[i]
                    wsd.word = word
                    let pronoun = word as! Pronoun
                    wsd.pronounType = pronoun.type
                    if pronoun.type == .SUBJECT {
                        let personIndex = Int.random(in: 0 ..< 6)
                        wsd.person = Person.all[personIndex]
                        let genderIndex = Int.random(in: 0 ..< 2)
                        wsd.gender = Gender.all[genderIndex]
                        wsd.wordType = .PersPro
                        wsd.isSubject = isSubject
                        return dPersonalPronounSingle(word: word, data: wsd)
                    }
                }
            }
            else   //This logic is not worked out
            {
                for i in 0 ..< m_pronouns.count{
                    word = m_pronouns[i]
                    wsd.word = word
                    let pronoun = word as! Pronoun
                    wsd.pronounType = pronoun.type
                    if pronoun.type == .DIRECT_OBJECT {
                        let personIndex = Int.random(in: 0 ..< 6)
                        wsd.person = Person.all[personIndex]
                        let genderIndex = Int.random(in: 0 ..< 2)
                        wsd.gender = Gender.all[genderIndex]
                        wsd.wordType = .PersPro
                        wsd.isSubject = isSubject
                        return dPersonalPronounSingle(word: word, data: wsd)
                    }
                }
            }
        case .V:
            let wsd = WordStateData()
            wsd.language = m_wsp!.getLanguage()
            i = Int.random(in: 0 ..< m_verbs.count)
            let verb = m_verbs[i]
            wsd.word = word
            wsd.wordType = .V
            wsd.verbIsReflexive = false
            single = dVerbSingle(word: verb, data: wsd)
        default:
            break
        }
        
//        let singleWord = single.getClusterWord().word
//        print("getAgnosticRandomWordAsSingle: singleWord = \(singleWord)")
        return single
    }
    

}
