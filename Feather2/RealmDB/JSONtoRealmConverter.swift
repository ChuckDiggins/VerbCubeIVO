//
//  JSONtoRealmConverter.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/21/22.
//

import Foundation
import JumpLinguaHelpers

struct JsonToRealmConverter {
    func jsonWordToRealmWord(jsonWordList: [JSONWord])->[RealmWord]{
        var realmWords = [RealmWord]()
        for word in jsonWordList {
            let newRealmWord = RealmWord(spanish: word.spanish, french: word.french, english: word.english, wordType: RealmWord().getWordType(wordTypeString: word.wordType))
            realmWords.append(newRealmWord)
        }
        return realmWords
    }
}
