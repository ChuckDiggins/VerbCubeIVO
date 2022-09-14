//
//  WordCollection.swift
//  ContextFree
//
//  Created by Charles Diggins on 2/20/22.
//

import Foundation
import JumpLinguaHelpers

public struct dWordCollection : Equatable {
    let idNum : Int
    let collectionName : String
    var wordList = [Word]()
    public static func == (lhs: dWordCollection, rhs: dWordCollection) -> Bool {
        return
            lhs.collectionName == rhs.collectionName
    }
    
    public init(){
        self.idNum = 0
        self.collectionName = "no name"
    }
    
    public init(idNum: Int, collectionName: String, wordList: [Word]){
        self.idNum = idNum
        self.collectionName = collectionName
        self.wordList = wordList
    }
    
    public init(idNum: Int, collectionName: String){
        self.idNum = idNum
        self.collectionName = collectionName
    }
    
    
    public mutating func appendWord(word: Word){
        wordList.append(word)
    }
    
    public mutating func addWords(words: [Word])->Int{
        for word in words{
            wordList.append(word)
        }
        return wordList.count
    }
    
    public func getWord(index: Int)->Word{
        if index >= 0 && index < wordList.count {
            return wordList[index]
        }
        return Word()
    }
    
    public func getWordCount()->Int{
        return wordList.count
    }
    
    public func getWords()->[Word]{
        return wordList
    }
    
    public func getWords(wordType: WordType)->[Word]{
        var newWordList = [Word]()
        for word in wordList{
            if word.wordType == wordType{
                newWordList.append(word)
            }
        }
        return newWordList
    }
}
