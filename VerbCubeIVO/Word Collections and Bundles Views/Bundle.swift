//
//  Bundle.swift
//  ContextFree
//
//  Created by Charles Diggins on 2/20/22.
//

import Foundation
import JumpLinguaHelpers

public struct dBundle{
//    var idNum: Int
////    var language : String
//    var teacher : String
//    var bundleName : String
//    var tenseList = [String]()
//    var collectionList = [JSONCollectionStruct]()
//    var phraseList = [JSONNamedLoadedPhrase]()
    public var idNum: Int
    public var teacher: String
    public var bundleName: String
    public var tenseList = [Tense]()
    public var collectionList = [dWordCollection]()
    public var phraseList = [dCluster]()

    public init(){
        self.idNum = 0
        self.teacher = "no teacher"
        self.bundleName = "no name"
    }

    public init(idNum: Int, teacher: String, bundleName: String, tenseList : [Tense], collectionList: [dWordCollection], phraseList: [dCluster]){
        self.idNum = idNum
        self.teacher = teacher
        self.bundleName = bundleName
        self.tenseList = tenseList
        self.phraseList = phraseList
    }

    public func getTeacher()->String{
        return teacher
    }

    func getBundleName()->String{
        return bundleName
    }

    public func getTenseList()->[Tense]{
        return tenseList
    }

    public func getTense(index: Int)->Tense{
        if index >= 0 && index < tenseList.count{
            return tenseList[index]
        }
        return .infinitive
    }

    public func getWordCollectionList()->[dWordCollection]{
        return collectionList
    }
    
    public func getCollectionCount()->Int{
        return collectionList.count
    }

    public func getWordCollection(index: Int)->dWordCollection{
        if index >= 0 && index < collectionList.count{
            return collectionList[index]
        }
        return dWordCollection()
    }


    public mutating func setWordCollectionList(collectionList: [dWordCollection]){
        self.collectionList = collectionList
    }

    
    public func getPhraseList()->[dCluster]{
        return phraseList
    }

    public mutating func setPhraseList(phraseList: [dCluster]){
        self.phraseList = phraseList
    }
    
    public func getPhraseCount()->Int{
        return phraseList.count
    }

    public func getPhrase(index: Int)->dCluster{
        if index >= 0 && index < phraseList.count {
            return phraseList[index]
        }
        return dCluster()
    }


}

