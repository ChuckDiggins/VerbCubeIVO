//
//  LanguageEngineFiltered.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/8/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
    func clearFilteredVerbList(){
        filteredVerbList.removeAll()
        currentFilteredVerbIndex = 0
    }
    
    func resetFilteredVerbs(){
        filteredVerbList = verbList
        currentFilteredVerbIndex = 0
    }
    
    func setFilteredVerbList(verbList: [Verb]){
        filteredVerbList = verbList
        currentFilteredVerbIndex = 0
    }
    
    func getFilteredVerbs()->[Verb]{
        return filteredVerbList
    }
    
    func setNextFilteredVerb(){
        currentFilteredVerbIndex += 1
        if currentFilteredVerbIndex >= filteredVerbList.count {
            currentFilteredVerbIndex = 0 }
    }
    
    func setPreviousFilteredVerb(){
        currentFilteredVerbIndex -= 1
        if currentFilteredVerbIndex < 0 {
            currentFilteredVerbIndex = filteredVerbList.count - 1}
    }
    
    func getCurrentFilteredVerb()->Verb{
        return filteredVerbList[currentFilteredVerbIndex]
    }
    
    func addVerbToFilteredList(verb: Verb){
        filteredVerbList.append(verb)
    }
    
    func copyWordCollectionToFilteredList(wordCollection: dWordCollection){
        let words = wordCollection.getWords(wordType: .verb)
        if words.count > 4 {
            clearFilteredVerbList()
            for word in words{
                let verb = Verb(spanish: word.spanish, french: word.french, english: word.english)
                addVerbToFilteredList(verb: verb)
            }
        }
    }
    
    func getWordCollectionCount(wc: dWordCollection, wordType: WordType)->Int{
        return wc.getWords(wordType: .verb).count
    }
    
    func getWordCollection(index: Int)->dWordCollection{
        return lessonBundlePhraseCollectionManager.wordCollectionManager.getCollection(index: index)
    }
    
    func getWordCollectionList()->[dWordCollection]{
        let wcManager = lessonBundlePhraseCollectionManager.wordCollectionManager
        let wcList = wcManager.getCollectionList()
        return wcList
    }
    
    func createWordCollection(verbList: [Verb], collectionName: String){
        var wcManager = lessonBundlePhraseCollectionManager.wordCollectionManager
        wcManager.append(collection: dWordCollection(collectionName: collectionName, wordList: verbList))
        print("word collection: <\(collectionName)> created with word count: \(verbList.count)")
    }
    
    
}

