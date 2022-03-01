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

class VerbCubeCellInfo : ObservableObject{
    var verb: Verb
    var tense: Tense
    var person: Person
    @Published var showVerbType = ShowVerbType(rawValue: "")
    @Published var showVerbColor = Color.white
    
    init(){
        verb = Verb()
        tense = Tense.infinitive
        person = .S1
        showVerbType = .NONE
    }
    
    func setConjugationInfo(verb: Verb, tense: Tense, person: Person){
        self.verb = verb
        self.tense = tense
        self.person = person
    }
    
    func setShowVerbType(showVerbType: ShowVerbType){
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
    case .SPECIAL: return .orange
    }
}
