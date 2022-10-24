////
////  FilterVerbUtilities.swift
////  VerbCubeIVO
////
////  Created by Charles Diggins on 2/27/22.
////
//
//import Foundation
//import SwiftUI
//import JumpLinguaHelpers
//
//class VerbIDEnding : Identifiable, ObservableObject {
//        var id : Int
//        var name: String
//        var verbEnding : VerbEnding
//        var isSelected: Bool
//        var count = 0
//   
//    init(id: Int, name: String, verbEnding: VerbEnding, isSelected: Bool){
//        self.id = id
//        self.name = name
//        self.verbEnding = verbEnding
//        self.isSelected = isSelected
//    }
//    
//    func getCount()->Int{
//        return count
////    }
//    
//    func setCount(count: Int){
//        self.count = count
//    }
//}
//
//class VerbModelFilter : Identifiable {
//    var id : Int = 0
//    var name: String
//    var verbType: ShowVerbType
//    var color: Color
//    var isSelected: Bool = false
//    var count = 0
//    
//    
//    init(id: Int, name: String, verbType: ShowVerbType, color: Color){
//        self.id = id
//        self.name = name
//        self.verbType = verbType
//        self.color = color
//    }
//    
//    func getCount()->Int{
//        return count
//    }
//    
//    func setCount(count: Int){
//        self.count = count
//    }
//}
//
//var verbEndings: [VerbIDEnding] = [VerbIDEnding(id: 0, name: "AR verbs", verbEnding: .AR, isSelected: true),
//                                   VerbIDEnding(id: 1, name: "ER verbs", verbEnding: .ER, isSelected: true),
//                                   VerbIDEnding(id: 2, name: "IR verbs", verbEnding: .IR, isSelected: true),
//                                   VerbIDEnding(id: 3, name: "RE verbs", verbEnding: .RE, isSelected: true),
//                                   VerbIDEnding(id: 4, name: "OIR verbs", verbEnding: .OIR, isSelected: true),
//                                   VerbIDEnding(id: 5, name: "accented IR verbs (ír)", verbEnding: .accentIR, isSelected: true),
//                                   VerbIDEnding(id: 6, name: "umlaut IR verbs (ïr)", verbEnding: .umlautIR, isSelected: true),
//                                        ]
//
//var verbFilters: [VerbModelFilter] = [VerbModelFilter(id: 0, name: "Stem-changing", verbType: .STEM, color: Color("StemColor")),
//                                      VerbModelFilter(id: 1, name: "Ortho-changing", verbType: .ORTHO, color: Color("OrthoColor")),
//                                VerbModelFilter(id: 2, name: "Irregular", verbType: .IRREG, color: Color("IrregColor")),
//                                VerbModelFilter(id: 3, name: "Special", verbType: .SPECIAL, color: Color("SpecialColor")),
//                                  VerbModelFilter(id: 4, name: "Reflexive", verbType: .REFLEXIVE, color: Color("ReflexiveColor"))
//                                        ]
//
//func getVerbIDEndings()->[VerbIDEnding]{
//    return verbEndings
//}
//
//func getVerbFilters()->[VerbModelFilter]{
//    return verbFilters
//}
//
//func initializeVerbEndings(languageEngine: LanguageEngine){
//    var newVerbs = [Verb]()
//    for ending in verbEndings {
//        newVerbs = languageEngine.getVerbsOfSelectedEnding(verbEnding : ending.verbEnding)
//        ending.count = newVerbs.count
//        ending.isSelected = true
//    }
//}
//
//func fillVerbEndingCounts(languageEngine: LanguageEngine){
//    var newVerbs = [Verb]()
//    for ending in verbEndings {
//        newVerbs = languageEngine.getVerbsOfSelectedEnding(verbEnding : ending.verbEnding)
//        ending.count = newVerbs.count
//    }
//}
//
//func initializeVerbFilters(languageEngine: LanguageEngine){
//    for showVerbType in verbFilters {
//        showVerbType.count = languageEngine.countVerbsOfSelectedType(showVerbType : showVerbType.verbType)
//        showVerbType.isSelected = false
//    }
//}
//     
//func fillVerbFilterCounts(languageEngine: LanguageEngine){
//    for showVerbType in verbFilters {
//        showVerbType.count = languageEngine.countVerbsOfSelectedType(showVerbType : showVerbType.verbType)
//    }
//}
//    
//                   
//func fillFilteredVerbs(languageEngine: LanguageEngine, verbEndings: [VerbIDEnding], verbFilters : [VerbModelFilter]) {
//
//    languageEngine.clearFilteredVerbList()
//    var newVerbs = [Verb]()
//    var tempVerbs = [Verb]()
//    
//    //set general flag is any verb filters are active
//   
//    var filtersOn = false
//    for filter in verbFilters {
//        if filter.isSelected { filtersOn = true }
//    }
//
//    for ending in verbEndings {
//        print("fillFilteredVerbs: \(ending.name) isSelected \(ending.isSelected)")
//    }
//    
//    var bAddThis = true
//    for ending in verbEndings {
//        if ending.isSelected {
//            newVerbs = languageEngine.getVerbsOfSelectedEnding(verbEnding : ending.verbEnding)
//            for verb in newVerbs {
//                bAddThis = true
//                if ( filtersOn ){
//                    bAddThis = false
//                    for filter in verbFilters {
//                        if ( filter.isSelected ){
//                            if filter.id == 0 && languageEngine.isVerbType(verb: verb, verbType: ShowVerbType.STEM) {
//                                bAddThis = true
//                            }
//                            if filter.id == 1 && languageEngine.isVerbType(verb: verb, verbType: ShowVerbType.ORTHO)  {
//                                bAddThis = true
//                            }
//                            if filter.id == 2 && languageEngine.isVerbType(verb: verb, verbType: ShowVerbType.IRREG) {
//                                bAddThis = true
//                            }
//                            if filter.id == 3 && languageEngine.isVerbType(verb: verb, verbType: ShowVerbType.SPECIAL) {
//                                bAddThis = true
//                            }
//                            if filter.id == 4 &&  languageEngine.isVerbType(verb: verb, verbType: ShowVerbType.REFLEXIVE) {
//                                bAddThis = true
//                            }
//                        }
//                    }
//                }
//                if ( bAddThis ){
//                    tempVerbs.append(verb)
//                }
//            }
//
//        }
//    }
//    
//    if ( tempVerbs.count > 5 ){
//        languageEngine.setFilteredVerbList(verbList: tempVerbs)
//        languageEngine.fillVerbCubeLists()
//        languageEngine.setPreviousCubeBlockVerbs()
//        languageEngine.fillQuizCubeVerbList()
//        languageEngine.fillQuizCubeBlock()
//    }
//    print("fillFilteredVerbs: filtered verb count = \(languageEngine.getFilteredVerbs().count)")
//}
