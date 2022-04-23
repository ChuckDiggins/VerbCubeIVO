//
//  RealmWord.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/21/22.
//

import Foundation
import RealmSwift

class RealmWord : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var spanish: String
    @Persisted var french: String
    @Persisted var english: String
    @Persisted var wordType:  WordType
//    @Persisted(originProperty: "realmWords") var wordCollection: LinkingObjects<RealmWordCollection>
    
    enum WordType: Int, PersistableEnum {
        case adjective
        case adverb
        case article
        case conjunction
        case determiner
        case noun
        case preposition
        case pronoun
        case properNoun
        case verb
        case unknown
        
        var text: String {
            switch self{
            case .adjective: return "adjective"
            case .adverb: return "adverb"
            case .article: return "article"
            case .conjunction: return "conjunction"
            case .determiner: return "determiner"
            case .noun: return "noun"
            case .preposition: return "preposition"
            case .pronoun: return "pronoun"
            case .properNoun: return "properNoun"
            case .verb: return "verb"
            case .unknown: return "unknown"
            }
        }
    }
    
    convenience init(spanish: String, french: String, english: String, wordType: WordType) {
        self.init()
        self.spanish = spanish
        self.french = french
        self.english = english
        self.wordType = wordType
    }
    
    public func getWordType(wordTypeString : String)->WordType {
        switch wordTypeString{
        case "adjective": return .adjective
        case "adverb": return .adverb
        case "article": return .article
        case "determiner": return .determiner
        case "conjunction": return .conjunction
        case "noun": return .noun
        case "pronoun": return .pronoun
        case "properNoun": return .properNoun
        case "verb": return .verb
        default: return .unknown
        }
    }
}



