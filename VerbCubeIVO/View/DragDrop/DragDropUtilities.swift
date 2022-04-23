//
//  DragDropUtilities.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/1/22.
//

import SwiftUI
import JumpLinguaHelpers

struct DragDrop2Word: Identifiable, Hashable, Equatable{
    var id = UUID().uuidString
    var valueFrom: String
    var valueTo: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 15
    var isShowing: Bool = false
    var isMatched: Bool = false
}

var subjectList = ["yo", "tú", "usted", "nosotros", "ellos", "ellas", "vosotros", "él", "ella", "ustedes"]
var verbWordList = ["doy", "das", "da", "damos", "dan", "dan", "dais", "da", "da", "dan"]
func fillNewDragDropWords()->[DragDrop2Word]{
    var newWords = [DragDrop2Word]()
    for i in 0 ..< subjectList.count {
        newWords.append(DragDrop2Word(valueFrom: subjectList[i], valueTo: verbWordList[i]))
    }
    return newWords
}

func createWordMatchDar()->[DragDrop2Word]{
    return [
        DragDrop2Word(valueFrom: "yo", valueTo: "doy"),
        DragDrop2Word(valueFrom: "ustedes", valueTo: "dan"),
        DragDrop2Word(valueFrom: "tú", valueTo: "das"),
        DragDrop2Word(valueFrom: "usted", valueTo: "da"),
        DragDrop2Word(valueFrom: "nosotros", valueTo: "damos"),
        DragDrop2Word(valueFrom: "ellos", valueTo: "dan"),
        DragDrop2Word(valueFrom: "ellas", valueTo: "dan"),
        DragDrop2Word(valueFrom: "vosotros", valueTo: "dais"),
        DragDrop2Word(valueFrom: "él", valueTo: "da"),
        DragDrop2Word(valueFrom: "ella", valueTo: "da"),
        ]
}
var wordMatchDar: [DragDrop2Word] = [
    DragDrop2Word(valueFrom: "yo", valueTo: "doy"),
    DragDrop2Word(valueFrom: "ustedes", valueTo: "dan"),
    DragDrop2Word(valueFrom: "tú", valueTo: "das"),
    DragDrop2Word(valueFrom: "usted", valueTo: "da"),
    DragDrop2Word(valueFrom: "nosotros", valueTo: "damos"),
    DragDrop2Word(valueFrom: "ellos", valueTo: "dan"),
    DragDrop2Word(valueFrom: "ellas", valueTo: "dan"),
    DragDrop2Word(valueFrom: "vosotros", valueTo: "dais"),
    DragDrop2Word(valueFrom: "él", valueTo: "da"),
    DragDrop2Word(valueFrom: "ella", valueTo: "da"),
    ]

var wordMatch: [DragDrop2Word] = [
    DragDrop2Word(valueFrom: "yo", valueTo: "tengo"),
    DragDrop2Word(valueFrom: "ustedes", valueTo: "tienen"),
    DragDrop2Word(valueFrom: "tú", valueTo: "tienes"),
    DragDrop2Word(valueFrom: "usted", valueTo: "tiene"),
    DragDrop2Word(valueFrom: "nosotros", valueTo: "tenemos"),
    DragDrop2Word(valueFrom: "ellos", valueTo: "tienen"),
    DragDrop2Word(valueFrom: "ellas", valueTo: "tienen"),
    DragDrop2Word(valueFrom: "vosotros", valueTo: "tenéis"),
    DragDrop2Word(valueFrom: "él", valueTo: "tiene"),
    DragDrop2Word(valueFrom: "ella", valueTo: "tiene"),
    ]

public func replaceAccentWithDoubleLetter(characterArray: String)->String
{
    var ss = ""
     
    for c in characterArray
    {
        let newC = isSpecialCharacter(input: c)
    //if newC is different, then it is a non-special version of the input
    //   é -> e
    //   ü -> u
    
        if ( newC != c )
        {
            ss += String(newC)
            ss += String(newC)
        }
        else {
            ss += String(c)
        }
    }
    
    return ss
}

public func isSpecialCharacter(input: Character)->Character {
    if ( input == "á" || input == "à" ) { return "a" }
    if ( input == "é" || input == "è"  || input == "ê" ) { return "e"}
    if ( input == "í" || input == "î"  ) { return "i"}
    if ( input == "ó" ) { return "o"}
    if ( input == "ú" || input == "ü" ) { return "u"}
    if ( input == "ñ" ) {return "n"}
    if ( input == "ç" ) {return "c"}
    return input
}
//


