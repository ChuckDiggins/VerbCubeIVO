//
//  ActiveVerbCubeConfiguration.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/23/22.
//

import Foundation

enum ActiveVerbCubeConfiguration  {
    case PersonTense, TensePerson, VerbPerson, PersonVerb, VerbTense, TenseVerb, None
    
    static var configAll = [ActiveVerbCubeConfiguration.PersonTense, .TensePerson, .VerbPerson, .PersonVerb, .VerbTense, .TenseVerb]
    
    public func getString()->String {
        switch self {
        case .PersonTense: return "Person v Tense"
        case .TensePerson: return "Tense v Person"
        case .VerbPerson: return "Verb v Person"
        case .PersonVerb: return "Person v Verb"
        case .VerbTense: return "Verb v Tense"
        case .TenseVerb: return "Tense v Verb"
        case .None: return "Person v Tense"
        }
    }
}

func getActiveVerbCubeConfiguration(vc1: VerbCubeDimension, vc2: VerbCubeDimension)->ActiveVerbCubeConfiguration{
    switch vc1{
    case .Verb:
        switch vc2{
        case .Verb:
            return .None
        case .Tense:
            return .VerbTense
        case .Person:
            return .VerbPerson
        }
        
    case .Tense:
        switch vc2{
        case .Verb:
            return .TenseVerb
        case .Tense:
            return .None
        case .Person:
            return .TensePerson
        }
    case .Person:
        switch vc2{
        case .Verb:
            return .PersonVerb
        case .Tense:
            return .PersonTense
        case .Person:
            return .None
        }
    }
}

func getVerbCubeDimensions(activeConfig: ActiveVerbCubeConfiguration)->(VerbCubeDimension, VerbCubeDimension){
    var d1 = VerbCubeDimension.Verb
    var d2 = VerbCubeDimension.Verb
    
    switch activeConfig{
    case .PersonTense:
        d1 = VerbCubeDimension.Person
        d2 = VerbCubeDimension.Tense
    case .TensePerson:
        d1 = VerbCubeDimension.Tense
        d2 = VerbCubeDimension.Person
    case .VerbPerson:
        d1 = VerbCubeDimension.Verb
        d2 = VerbCubeDimension.Person
    case .PersonVerb:
        d1 = VerbCubeDimension.Person
        d2 = VerbCubeDimension.Verb
    case .VerbTense:
        d1 = VerbCubeDimension.Verb
        d2 = VerbCubeDimension.Tense
    case .TenseVerb:
        d1 = VerbCubeDimension.Tense
        d2 = VerbCubeDimension.Verb
    case .None:
       break
    }
    return (d1, d2)
}
