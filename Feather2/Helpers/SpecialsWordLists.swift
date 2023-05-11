//
//  SpecialsWordLists.swift
//  Feather2
//
//  Created by Charles Diggins on 5/7/23.
//

import Foundation
import JumpLinguaHelpers

struct ObjectStruct {
    var objectString : String
    var objectNumber : Number
    var objectGender : Gender
}

var nullDirectObject = ObjectStruct(objectString: "", objectNumber: .singular, objectGender: .either)
var directObjectList = [ObjectStruct(objectString: "la cosa", objectNumber: .singular, objectGender: .feminine),
                      ObjectStruct(objectString: "las cosas", objectNumber: .plural, objectGender: .feminine),
                      ObjectStruct(objectString: "el libro", objectNumber: .singular, objectGender: .masculine),
                      ObjectStruct(objectString: "los libros", objectNumber: .plural, objectGender: .masculine),
                      ObjectStruct(objectString: "comer", objectNumber: .singular, objectGender: .masculine),]

var gerundList = ["bailando", "comiendo", "hablando", "viniendo", "visitando", "llegando"]

var infinitiveList = ["bailar", "comer", "hablar", "venir", "visitar", "empezar"]


func getRandomDirectObject()->ObjectStruct{
    let i = Int.random(in: 0 ..< directObjectList.count)
//    directObjectList.shuffle()
    return directObjectList[i]
}

func getVerbFromRandomInfinitives()->Verb{
    let verb  = Verb(spanish: getRandomInfinitive(), french: "", english: "")
    return verb
}
func getRandomInfinitive()->String{
    let i = Int.random(in: 0 ..< infinitiveList.count)
//    infinitiveList.shuffle()
    return infinitiveList[i]
}

func getRandomGerund()->String{
    let i = Int.random(in: 0 ..< gerundList.count)
//    gerundList.shuffle()
    return " " + gerundList[i]
}

