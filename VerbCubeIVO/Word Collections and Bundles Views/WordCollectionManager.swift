////
////  WordCollectionManager.swift
////  ContextFree
////
////  Created by Charles Diggins on 2/20/22.
////
//
//import Foundation
//import JumpLinguaHelpers
//
//public struct dWordCollectionManager{
//    private var collectionList = Array<dWordCollection>()
//    
//    public mutating func append(collection: dWordCollection){
//        if !doesExist(collection: collection) {
//            collectionList.append(collection)
//        }
//    }
//    
//    mutating public func setWordCollectionList(wcl : [dWordCollection]){
//        collectionList = wcl
//    }
//    
//    public func getCount()->Int{
//        return collectionList.count
//    }
//    
//    public func getCollectionList()->[dWordCollection]{
//        return collectionList
//    }
//    
//    public func getCollection(index: Int)->dWordCollection{
//        if index < collectionList.count { return collectionList[index]}
//        return dWordCollection()
//    }
//    
//    public func doesExist(collection: dWordCollection)->Bool{
//        for c in collectionList {
//            if collection == c {return true}
//        }
//        return false
//    }
//    
//    public func getCollectionByName(collectionName: String)->dWordCollection{
//        for collection in collectionList{
//            if collection.collectionName == collectionName {return collection}
//        }
//        return dWordCollection()
//    }
//}
