//
//  LanguageEngineViewFilteredVerbs.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageViewModel{
    func clearFilteredVerbList(){
        languageEngine.clearFilteredVerbList()
    }
    
    func resetFilteredVerbs(){
        languageEngine.resetFilteredVerbs()
    }
    
    func setFilteredVerbList(verbList: [Verb]){
        languageEngine.filteredVerbList = verbList
    }
    
    func getFilteredVerbs()->[Verb]{
        languageEngine.getFilteredVerbs()
    }
    
    func setNextFilteredVerb(){
        languageEngine.setNextFilteredVerb()
    }
    
    func setPreviousFilteredVerb(){
        languageEngine.setPreviousFilteredVerb()
    }
    
    func getCurrentFilteredVerb()->Verb{
        languageEngine.getCurrentFilteredVerb()
    }

    func addVerbToFilteredList(verb: Verb){
        languageEngine.addVerbToFilteredList(verb: verb)
    }
    
    func copyWordCollectionToFilteredList(wordCollection: dWordCollection){
        languageEngine.copyWordCollectionToFilteredList(wordCollection: wordCollection)
    }
    
    func getWordCollectionCount(wc: dWordCollection, wordType: WordType)->Int{
        languageEngine.getWordCollectionCount(wc: wc, wordType: wordType)
    }
    
    func getWordCollection(index: Int)->dWordCollection{
        languageEngine.getWordCollection(index: index)
    }
    
    func getWordCollectionList()->[dWordCollection]{
        languageEngine.getWordCollectionList()
    }
}
