//
//  LanguageEngineIdioms.swift
//  Feather2
//
//  Created by Charles Diggins on 5/26/23.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
    func getVerbIdiomManager()->VerbIdiomManager{
        verbIdiomManager
    }
    
//    func fillVerbIdiomLists(){
//        fillHaberHayPairList(strList: idiomHaberHayList)
//        fillHaberPairList(strList: idiomHaberList)
//        fillHacerPairList(strList: idiomHacerList)
//        fillTenerPairList(strList: idiomTenerList)
//        fillDarPairList(strList: idiomDarList)
//
//    }
    
    func fillVerbIdiomLists(){
        SpanishIdiomType.allCases.forEach {idiomType in
            fillIdiomVerbList(idiomType)
        }
    }
    
    func fillIdiomVerbList(_ idiomType: SpanishIdiomType){
        var strList = [(String,String)]()
        switch idiomType{
        case .Hay: strList = idiomHaberHayList
        case .Haber: strList = idiomHaberList
        case .Hacer: strList = idiomHacerList
        case .Tener: strList = idiomTenerList
        case .Dar: strList = idiomDarList
        case .Echar: strList = idiomEcharList
        case .Poner: strList = idiomPonerList
        case .Misc1: strList = idiomMisc1List
        case .Misc2: strList = idiomMisc2List
        }
        for str in strList {
            verbIdiomManager.append(idiomType, Verb(spanish: str.0, french: "", english: str.1))
        }
    }
    
    
}
