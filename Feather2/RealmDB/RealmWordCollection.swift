//
//  RealmWordCollection.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/22/22.
//

import Foundation
import RealmSwift

class RealmWordCollection : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var collectionName: String
    @Persisted var teacher: String
    @Persisted var words: List<RealmWord> // Embed an array of objects
    
    convenience init(name: String, teacher: String,  words: List<RealmWord>) {
        self.init()
        self.collectionName = name
        self.teacher = teacher
        self.words.append(objectsIn: words)
    }
    
    convenience init(name: String, teacher: String,  word: RealmWord) {
        self.init()
        self.collectionName = name
        self.teacher = teacher
        self.words.append(word)
    }
    
    convenience init(name: String, teacher: String) {
        self.init()
        self.collectionName = name
        self.teacher = teacher
    }
    
    
//    init(name: String, teacher: String){
//        self.init()
//        self.collectionName = name
//        self.teacher = teacher
//    }
    
    func appendRealmWord(rw: RealmWord){
        words.append(rw)
    }
    
    func getWords()->List<RealmWord>{
        return words
    }
}
