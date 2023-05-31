//
//  ReflexiveVerb.swift
//  Feather2
//
//  Created by Charles Diggins on 5/15/23.
//

import SwiftUI
import Combine
import JumpLinguaHelpers


var nonreflexiveVerbStringList = [
    "ir",
    "aburrir",
    "acercar",
    "caer",
    "encontrar",
    "levantar",
    "llamar",
    "negar",
    "ocupar",
    "perder",
    "referir",
    "retirar",
    "reunir",
    "secar",
    "volver",
    "poner",
    "quedar"]

var reciprocalVerbStringList = [
    
    "abrazar",
    "amar",
    "animar",
    "ayudar",
    "besar",
    "conocer",
    "despedir",
    "enojar",
    "entender",
    "escribir",
    "hablar",
    "lastimar",
    "matar",
    "mirar",
    "odiar",
    "pelear",
    "prometer",
    "reír",
    "sonreír",
    "sorprender",
    "ver" ]


var reflexiveOnlyVerbStringList = ["arrepentirse",
                                   "atenerse",
                                   "aterirse",
                                   "atreverse",
                                   "comedirse",
                                   "desayunarse",
                                   "quejarse",
                                   ]

var normalReflexiveVerbStringList = ["abandonar",
                               "acalorar",
                               "acordar",
                               "acostar",
                               "acostumbar",
                               "adaptar",
                               "adelantar",
                               "afeitar",
                               "agachar",
                               "alegrar",
                               "apoderar",
                               "aprovechar",
                               "asustar",
                               "avergonzar",
                               "averiar",
                               "bañar",
                               "broncear",
                               "burlar",
                               "calentar",
                               "callar",
                               "calmar",
                               "cansar",
                               "casar",
                               "comunicar",
                               "criar",
                               "cuidar",
                               "dar",
                               "decidir",
                               "decidar",
                               "desarrolar",
                               "despertar",
                               "desvestir",
                               "disculpar",
                               "divertir",
                               "divorciar",
                               "dormir",
                               "duchar",
                               "echar",
                               "emborrachar",
                               "enamorar",
                               "enfadar",
                               "enfermar",
                               "enflaquecer",
                               "enojar",
                               "enriquecer",
                               "ensuciar",
                               "entender",
                               "enterar",
                               "entusiasmar",
                               "enterar",
                               "envejecer",
                               "erguir",
                               "fiar",
                               "fijar",
                               "interesar",
                               "juntar",
                               "lavar",
                               "marchar",
                               "mojar",
                               "mover",
                               "mudar",
                               "olvidar",
                               "oponer",
                               "parecer",
                               "pasear",
                               "peinar",
                               "preguntar",
                               "preocupar",
                               "preparar",
                               "quebrar",
                               "quemar",
                               "registrar",
                               "revolver",
                               "sentar",
                               "sentir",
                               "terminar",
                               "vestir",
                               "zambullir",
]

enum ReflexiveType :  String {
    case NonReflexive,
         OnlyReflexive,
         NormalReflexive,
         Reciprocal
    
    public func getString()->String {
        switch self{
        case .NonReflexive:  return "Non-reflexive v Reflexive"
        case .OnlyReflexive:  return "Only reflexive"
        case .NormalReflexive: return "Normal reflexive"
        case .Reciprocal: return "Reciprocal verbs"
        }
    }
}

struct FeatherVerbPair
{
    let primaryVerb : Verb
    var secondaryVerb : Verb
    
    init( _ p: Verb, _ s: Verb){
        primaryVerb = p
        secondaryVerb = s
    }
}

class ReflexiveVerbManager : ObservableObject {
    var reflexiveList = [FeatherVerbPair]()
    var onlyReflexiveList = [FeatherVerbPair]()
    var normalReflexiveList = [FeatherVerbPair]()
    var reciprocalList = [FeatherVerbPair]()
    
    func getReflexivePairList(_ type: ReflexiveType)->[FeatherVerbPair]{
        switch type {
        case .NonReflexive:
            return reflexiveList
        case .OnlyReflexive:
            return onlyReflexiveList
        case .NormalReflexive:
            return normalReflexiveList
        case .Reciprocal:
            return reciprocalList
        }
    }
    
    func getMatchingVerb(_ type: ReflexiveType, _ verbStr: String)->Verb{
        var firstVerb = Verb()
        switch type {
        case .NonReflexive:
            for vp in reflexiveList{
                firstVerb = vp.primaryVerb
            }
        case .OnlyReflexive:
            for vp in onlyReflexiveList{
                firstVerb = vp.primaryVerb
                
            }
        case .NormalReflexive:
            for vp in normalReflexiveList{
                firstVerb = vp.primaryVerb
                
            }
        case .Reciprocal:
            for vp in reciprocalList{
                firstVerb = vp.primaryVerb
                
            }
        }
        return firstVerb
    }
}
