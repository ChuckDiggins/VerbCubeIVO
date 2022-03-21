//
//  VerbCubeCellInfo.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/22/22.
//

import Foundation
import SwiftUI
import JumpLinguaHelpers
import Dot

struct VerbCubeCellInfo {
    var verb: Verb
    var tense: Tense
    var person: Person
    var showVerbType = ShowVerbType(rawValue: "")
    var showVerbColor = Color.white
    
    init(){
        verb = Verb()
        tense = Tense.infinitive
        person = .S1
        showVerbType = .NONE
    }
    
    mutating func setConjugationInfo(verb: Verb, tense: Tense, person: Person){
        self.verb = verb
        self.tense = tense
        self.person = person
    }
    
    mutating func setShowVerbType(showVerbType: ShowVerbType){
        showVerbColor = getComputedBackgroundColor(showVerbType: showVerbType)
    }
    
    func getBackgroundColor()->Color{
        return getComputedBackgroundColor(showVerbType: showVerbType!)
    }
}

func getComputedBackgroundColor(showVerbType: ShowVerbType)->Color{
    switch showVerbType{
    case .NONE: return .white
    case .STEM: return .yellow
    case .ORTHO: return .green
    case .IRREG: return .blue
    case .REFLEXIVE: return .purple
    case .SPECIAL: return .orange
    case .PHRASAL: return .white
    }
}
