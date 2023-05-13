//
//  LanguageEngineVerbToModel.swift
//  Feather2
//
//  Created by Charles Diggins on 12/17/22.
//

import Foundation
import JumpLinguaHelpers

enum FrenchVerbLessons: String, CaseIterable{
    case chapter1A = "French 1A"
    case chapter1B = "French 1B"
    
    public func getChapterDescription()->String{
        switch self{
        case .chapter1A: return "1A: Easy verb, present tense"
        case .chapter1B: return "1B: Harder verbs, more tenses"
        }
    }
}

enum SpanishSpecials: String, CaseIterable{
    
    case specialsAuxGerund = "Auxiliary - Gerund"
    case specialsAuxInfinitives = "Auxiliary - Infinitives"
    case specialsVerbsLikeGustar = "Verbs like Gustar"
    case specialsWeatherTime = "Weather and Time"
    case specials3rdPersonOnly = "3rd Person Only"
    case specialsHaberHay = "Haber - Hay"
    case specialsIdiomsWithHaber = "Verb Idioms - Haber"
    case specialsIdiomsWithHacer = "Verb Idioms - Hacer"
    case specialsIdiomsWithTener = "Verb Idioms - Tener"
    case specialsIdiomsWithDar = "Verb Idioms - Dar"
    case specialsIdiomsOther = "Verb Idioms - Other"
    case specialsReflexivesOnly = "Reflexives - Only"
    case specialsReflexivesBoth = "Reflexives - Both"
  
    public func getChapterDescription()->String{
        switch self{
        case .specialsAuxGerund: return "Auxiliary - Gerund"
        case .specialsAuxInfinitives: return "Auxiliary - Infinitives"
        case .specialsVerbsLikeGustar: return "Verbs like Gustar"
        case .specialsWeatherTime: return "Weather and Time"
        case .specials3rdPersonOnly: return "3rd Person Only"
        case .specialsHaberHay: return "Haber - Hay"
        case .specialsReflexivesOnly: return "Reflexives - Only"
        case .specialsReflexivesBoth: return "Reflexives - Both"
        case .specialsIdiomsWithHaber: return "Verb Idioms - Haber"
        case .specialsIdiomsWithHacer: return "Verb Idioms - Hacer"
        case .specialsIdiomsWithTener: return "Verb Idioms - Tener"
        case .specialsIdiomsWithDar: return "Verb Idioms - Dar"
        case .specialsIdiomsOther: return "Verb Idioms - Other"
        }
    }
}

enum Chuck1Chapters: String, CaseIterable{
    case chuck1A = "Extra 1A"
    case chuck1B = "Extra 1B"
    case chuck1C = "Extra 1C"
    case chuck2A = "Extra 2A"
    case chuck2B = "Extra 2B"
    case chuck3A = "Extra 3A"
    case chuck3B = "Extra 3B"
    case chuck3C = "Extra 3C"
    
    public func getInteger()->String {
        switch self{
        case .chuck1A: return "1A"
        case .chuck1B: return "1B"
        case .chuck1C: return "1C"
        case .chuck2A: return "2A"
        case .chuck2B: return "2B"
        case .chuck3A: return "3A"
        case .chuck3B: return "3B"
        case .chuck3C: return "3C"
        }
    }
    
    public func getChapterDescription()->String{
        switch self{
        case .chuck1A: return "1A: Simple verbs"
        case .chuck1B: return "1B: Auxiliary verbs"
        case .chuck1C: return "1C: Reflexive verbs"
        case .chuck2A: return "2A: Irregular participles"
        case .chuck2B: return "2B: Unusual verbs"
        case .chuck3A: return "3A: Stem-changing"
        case .chuck3B: return "3B: Spell-changing"
        case .chuck3C: return "3C: Irregular"
        }
    }
}



enum Realidades1Chapters: String, CaseIterable{
    case chapter1A = "Chapter 1A"
    case chapter1B = "Chapter 1B"
    case chapter2A = "Chapter 2A"
    case chapter2B = "Chapter 2B"
    case chapter3A = "Chapter 3A"
    case chapter3B = "Chapter 3B"
    case chapter4A = "Chapter 4A"
    case chapter4B = "Chapter 4B"
    case chapter5A = "Chapter 5A"
    case chapter5B = "Chapter 5B"
    case chapter6A = "Chapter 6A"
    case chapter6B = "Chapter 6B"
    case chapter7A = "Chapter 7A"
    case chapter7B = "Chapter 7B"
    case chapter8A = "Chapter 8A"
    case chapter8B = "Chapter 8B"
    case chapter9A = "Chapter 9A"
    case chapter9B = "Chapter 9B"
    case chapter10A = "Chapter 10A"
    case chapter10B = "Chapter 10B"
    
    public func getInteger()->String {
        switch self{
        case .chapter1A: return "1A"
        case .chapter1B: return "1B"
        case .chapter2A: return "2A"
        case .chapter2B: return "2B"
        case .chapter3A: return "3A"
        case .chapter3B: return "3B"
        case .chapter4A: return "4A"
        case .chapter4B: return "4B"
        case .chapter5A: return "5A"
        case .chapter5B: return "5B"
        case .chapter6A: return "6A"
        case .chapter6B: return "6B"
        case .chapter7A: return "7A"
        case .chapter7B: return "7B"
        case .chapter8A: return "8A"
        case .chapter8B: return "8B"
        case .chapter9A: return "9A"
        case .chapter9B: return "9B"
        case .chapter10A: return "10A"
        case .chapter10B: return "10B"
        }
    }
    public func getChapterDescription()->String{
        switch self{
        case .chapter1A: return "1A: ¿Qué te gusta hacer?"
        case .chapter1B: return "1B: ¿Y tú, cómo eres?"
        case .chapter2A: return "2A: Tu día en la escuela"
        case .chapter2B: return "2B: Tu sala de clases"
        case .chapter3A: return "3A: Desayuno o almuerzo"
        case .chapter3B: return "3B: Para mantener la salud"
        case .chapter4A: return "4A: ¿Adónde vas?"
        case .chapter4B: return "4B: ¿Quieres ir conmigo?"
        case .chapter5A: return "5A: Una fiesta de compleaños"
        case .chapter5B: return "5B: ¡Vamos a un restaurante!"
        case .chapter6A: return "6A: En mi dormitorio"
        case .chapter6B: return "6B: ¿Cómo es tu casa?"
        case .chapter7A: return "7A: ¿Quánto cuesta?"
        case .chapter7B: return "7B: ¡Que regalo!"
        case .chapter8A: return "8A: De vacaciones"
        case .chapter8B: return "8B: Ayundando en la comunidad"
        case .chapter9A: return "9A: El cine y la television"
        case .chapter9B: return "9B: La tecnología"
        case .chapter10A: return "10A: Extra auxiliary + infinitives"
        case .chapter10B: return "10B: Extra auxiliary + gerunds"
        }
    }
}

extension LanguageEngine{
    func getV2MGroupManager()->VerbToModelGroupManager{
        return v2MGroupManager
    }
    
    func getV2MGroup()->VerbToModelGroup{
        return v2MGroup
    }
    
    func setV2MGroup(v2MGroup: VerbToModelGroup){
        self.v2MGroup = v2MGroup
    }
    
    func loadAllV2Ms(){
        switch getCurrentLanguage(){
        case .Spanish:
            fillV2MGroupManager(textBook: "Specials" )
            fillV2MGroupManager(textBook: "Spanish I")
    //        fillV2MGroupManager(textBook: "Realidades II" )
    //        fillV2MGroupManager(textBook: "Realidades III" )
            fillV2MGroupManager(textBook: "Extra 1" )
           
        case .French:
            fillV2MGroupManager(textBook: "French 1")
        default:
            break
        }
        
//        fillV2MGroupManager(textBook: "Michelle 1" )
    }
    
    func fillV2MGroupManager(textBook: String){
        switch textBook{
        case "Spanish I":
            loadRealidadesI()
        case "Realidades II":
            loadRealidadesII()
        case "Realidades III":
            loadRealidadesIII()
        case "Extra 1":
            loadChuck1()
        case "Specials":
            loadSpanishSpecials()
        case "French 1":
            loadFrench1()
        default:
            loadChuck1()
        }
    }
    
    func convertV2MGroupToStudyPackage(v2mGroup: VerbToModelGroup)->StudyPackageClass{
        let sp = StudyPackageClass()
        sp.tenseList = v2mGroup.tenseList
        sp.name = v2mGroup.lesson
        sp.chapter = v2mGroup.chapter
        sp.lesson = v2mGroup.lesson
        sp.verbModelStringList = v2mGroup.getModelStringList()
        sp.preferredVerbList = v2mGroup.getVerbList()
        sp.verbCount = sp.preferredVerbList.count
        sp.createdFromVerbToModel = true
        sp.specialVerbType = v2mGroup.specialVerbType
        return sp
    }
    
    func loadFrench1(){
        let v2mGroupFrench1A = VerbToModelGroup(chapter: "French 1A", lesson: "1A: Present, 1 Easy verb",
                                                verbToModelList :
                                                   [VerbToModelStruct("dire")],
                                                  tenseList: [.present],
                                                  specialVerbType: .normal)
               fillAssociatedModelList(v2mGroupFrench1A)
               v2MGroupManager.appendGroup(v2mGroupFrench1A)
        
        let v2mGroupFrench1B = VerbToModelGroup(chapter: "French 1B", lesson: "1B: Harder verbs",
                                                verbToModelList :
                                                   [VerbToModelStruct("rendre"), VerbToModelStruct("tenir"), VerbToModelStruct("penser"), ],
                                                tenseList: [.present, .preterite, .imperfect, .future],
                                                  specialVerbType: .normal)
               fillAssociatedModelList(v2mGroupFrench1B)
               v2MGroupManager.appendGroup(v2mGroupFrench1B)
    }
    
    func loadSpanishSpecials(){
        let v2mGroupSpanishSpecialsGustar = VerbToModelGroup(chapter: "Specials", lesson: "Verbs like gustar",
            verbToModelList :
                [VerbToModelStruct("aburrir"), VerbToModelStruct("doler"), VerbToModelStruct("encantar"), VerbToModelStruct("faltar"),
                 VerbToModelStruct("gustar"),
                 VerbToModelStruct("interesar"), VerbToModelStruct("quedar"), ],
                tenseList: [.present, .preterite, .presentSubjunctive],
                specialVerbType: .verbsLikeGustar)
               fillAssociatedModelList(v2mGroupSpanishSpecialsGustar)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsGustar)
        
        let v2mGroupSpanishSpecialsAuxiliaryGerunds = VerbToModelGroup(chapter: "Specials", lesson: "Auxiliary - Gerunds",
                verbToModelList :
                    [VerbToModelStruct("andar"),
                     VerbToModelStruct("seguir"),
                     VerbToModelStruct("venir"),
                     VerbToModelStruct("verse"),
                     
                     VerbToModelStruct("ir")],
                tenseList: [.present, .preterite, .presentSubjunctive, .presentPerfect],
                specialVerbType: .auxiliaryVerbsGerunds)
               fillAssociatedModelList(v2mGroupSpanishSpecialsAuxiliaryGerunds)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsAuxiliaryGerunds)
        
        let v2mGroupSpanishSpecialsAuxiliaryInfinitives = VerbToModelGroup(chapter: "Specials", lesson: "Auxiliary - Infinitives",
                verbToModelList :
                    [VerbToModelStruct("tener que"),
                     VerbToModelStruct("tener ganas de"),
                     VerbToModelStruct("haber de"),
                     VerbToModelStruct("dar de"),
                     VerbToModelStruct("volver a"),
                     VerbToModelStruct("acabar de"),
                     VerbToModelStruct("quedar sin"),
                     VerbToModelStruct("tener miedo de"),
                     VerbToModelStruct("tener gusto en"),
                     VerbToModelStruct("venir a")],
                tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                specialVerbType: .auxiliaryVerbsInfinitives)
               fillAssociatedModelList(v2mGroupSpanishSpecialsAuxiliaryInfinitives)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsAuxiliaryInfinitives)
        
        
        let v2mGroupSpanishSpecialsWeatherTime = VerbToModelGroup(chapter: "Specials", lesson: "Weather and Time",
                                                                  verbToModelList :
                                                                    [VerbToModelStruct("amanacer"),
                                                                     VerbToModelStruct("anochecer"),
                                                                     VerbToModelStruct("atardecer"),
                                                                     VerbToModelStruct("dar las doce"),
                                                                     VerbToModelStruct("dar la hora"),
                                                                     VerbToModelStruct("helar"),
                                                                     VerbToModelStruct("granizar"),
                                                                     VerbToModelStruct("llover"),
                                                                     VerbToModelStruct("nevar"),
                                                                     VerbToModelStruct("relampaguear"),
                                                                     VerbToModelStruct("tronar"),
                                                                    VerbToModelStruct("tener frio"),
                                                                     VerbToModelStruct("hacer viento"),
                                                                      VerbToModelStruct("hacer buen tiempo"),],
                                                                  
                                                                  tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                specialVerbType: .weatherAndTime)
               fillAssociatedModelList(v2mGroupSpanishSpecialsWeatherTime)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsWeatherTime)

        let v2mGroupSpanishSpecialsThirdPersonOnly = VerbToModelGroup(chapter: "Specials", lesson: "3rd Person Only",
                                                                  verbToModelList :
                                                                    [VerbToModelStruct("acaecer"),
                                                                     VerbToModelStruct("acontecer"),
                                                                     VerbToModelStruct("atañer"),
                                                                     VerbToModelStruct("antonjarse"),
                                                                     VerbToModelStruct("concernir"),
                                                                     VerbToModelStruct("emmpecer"),
                                                                     VerbToModelStruct("obstar"),
                                                                     VerbToModelStruct("ocurrir"), ],
                                                                  tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                                                                    specialVerbType: .ThirdPersonOnly)
               fillAssociatedModelList(v2mGroupSpanishSpecialsThirdPersonOnly)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsThirdPersonOnly)
        
        let v2mGroupSpanishSpecialsHaberHay = VerbToModelGroup(chapter: "Specials", lesson: "Haber - Hay",
                                                                  verbToModelList :
                                                                    [VerbToModelStruct("hay que"),
                                                                     VerbToModelStruct("hay"), ],
                                                               tenseList: [.present, .imperfect, .conditional, .future],
                                                                    specialVerbType: .haberHay)
               fillAssociatedModelList(v2mGroupSpanishSpecialsHaberHay)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsHaberHay)
        
        let v2mGroupSpanishSpecialsVerbIdiomsHaber = VerbToModelGroup(chapter: "Specials", lesson: "Verb Idioms - Haber",
                                                                  verbToModelList :
                                                                    [VerbToModelStruct("haber de partir el inviernes"),
                                                                     VerbToModelStruct("haber de partir el inviernes"),
                                                                     VerbToModelStruct("haber que seguir trajando"),
                                                                     VerbToModelStruct("haber"), ],
                                                                      tenseList: [.present, .imperfect, .conditional, .presentSubjunctive, .presentPerfect],
                                                                      specialVerbType: .haberHay)
               fillAssociatedModelList(v2mGroupSpanishSpecialsVerbIdiomsHaber)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsVerbIdiomsHaber)
        
        let v2mGroupSpanishSpecialsVerbIdiomsHacer = VerbToModelGroup(chapter: "Specials", lesson: "Verb Idioms - Hacer",
                                                                  verbToModelList :
                                                                    [
                                                                     VerbToModelStruct("hacer el favor"),
                                                                     VerbToModelStruct("hacer dos años"),
                                                                     VerbToModelStruct("hacerse falta a"),
                                                                     VerbToModelStruct("hacer un pregunta"), ],
                                                                      tenseList: [.present, .preterite, .imperfect, .conditional, .presentSubjunctive],
                                                                    specialVerbType: .normal)
               fillAssociatedModelList(v2mGroupSpanishSpecialsVerbIdiomsHacer)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsVerbIdiomsHacer)
        
        let v2mGroupSpanishSpecialsVerbIdiomsTener = VerbToModelGroup(chapter: "Specials", lesson: "Verb Idioms - Tener",
                                                                  verbToModelList :
                                                                    [VerbToModelStruct("tener sueño"),
                                                                     VerbToModelStruct("tener cuidado"),
                                                                     VerbToModelStruct("tener razón"),
                                                                     ],
                                                                      tenseList: [.present, .preterite, .imperfect, .conditional, .presentSubjunctive],
                                                                    specialVerbType: .normal)
               fillAssociatedModelList(v2mGroupSpanishSpecialsVerbIdiomsTener)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsVerbIdiomsTener)
        
        let v2mGroupSpanishSpecialsVerbIdiomsDar = VerbToModelGroup(chapter: "Specials", lesson: "Verb Idioms - Dar",
                                                                  verbToModelList :
                                                                    [VerbToModelStruct("dar un paseo"),
                                                                     VerbToModelStruct("dar de comer a los patos"),
                                                                     VerbToModelStruct("darse prisa"),
                                                                     
                                                                     ],
                                                                      tenseList: [.present, .preterite, .imperfect, .conditional, .presentSubjunctive],
                                                                    specialVerbType: .normal)
               fillAssociatedModelList(v2mGroupSpanishSpecialsVerbIdiomsDar)
               v2MGroupManager.appendGroup(v2mGroupSpanishSpecialsVerbIdiomsDar)
        
        let v2mGroupSpanishReflexives = VerbToModelGroup(chapter: "Specials", lesson: "Reflexives",
                verbToModelList :
                    [VerbToModelStruct("casarse"), VerbToModelStruct("tenerse"), VerbToModelStruct("darse prisa"), VerbToModelStruct("darse cuenta de"),],
                tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                specialVerbType: .normal)
               fillAssociatedModelList(v2mGroupSpanishReflexives)
               v2MGroupManager.appendGroup(v2mGroupSpanishReflexives)
        
        let v2mGroupSpanishNonReflexives = VerbToModelGroup(chapter: "Specials", lesson: "Non-Reflexives",
                                         verbToModelList :
                                            [ VerbToModelStruct("aburrir"),
                                              VerbToModelStruct("acercar"),
                                             VerbToModelStruct("caer"),
                                              VerbToModelStruct("encontrar"),
                                             VerbToModelStruct("ir"),
                                              VerbToModelStruct("levantar"),
                                              VerbToModelStruct("llamar"),
                                              VerbToModelStruct("negar"),
                                              VerbToModelStruct("ocupar"),
                                              VerbToModelStruct("perder"),
                                              VerbToModelStruct("referir"),
                                              VerbToModelStruct("retirar"),
                                              VerbToModelStruct("reir"),
                                              VerbToModelStruct("reunir"),
                                              VerbToModelStruct("secar"),
                                              VerbToModelStruct("volver"),
                                              VerbToModelStruct("poner"),
                                              VerbToModelStruct("quedar"),
                                            ],
                                           tenseList: [.present, .preterite, .imperative, .presentSubjunctive, .presentPerfect],
                                           specialVerbType: .reflexive)
        fillAssociatedModelList(v2mGroupSpanishNonReflexives)
        v2MGroupManager.appendGroup(v2mGroupSpanishNonReflexives)
        
    }
    
    func loadChuck1(){
        let v2mGroupChuck1A = VerbToModelGroup(chapter: "Extra 1A", lesson: "Auxiliary - infinitive",
                                         verbToModelList :
                                            [VerbToModelStruct("tener que"), VerbToModelStruct("volver a"), VerbToModelStruct("acabar de"), VerbToModelStruct("quedar sin"), VerbToModelStruct("venir a")],
                                           tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                                           specialVerbType: .auxiliaryVerbsInfinitives)
        fillAssociatedModelList(v2mGroupChuck1A)
        v2MGroupManager.appendGroup(v2mGroupChuck1A)
        
        let v2mGroupChuck1A2 = VerbToModelGroup(chapter: "Extra 1A", lesson: "Auxiliary - gerund",
                                         verbToModelList :
                                            [VerbToModelStruct("andar"), VerbToModelStruct("seguir"), VerbToModelStruct("venir"), VerbToModelStruct("verse"), VerbToModelStruct("ir")],
                                           tenseList: [.present, .preterite, .presentSubjunctive, .presentPerfect],
                                           specialVerbType: .auxiliaryVerbsGerunds)
        fillAssociatedModelList(v2mGroupChuck1A2)
        v2MGroupManager.appendGroup(v2mGroupChuck1A2)
        
        let v2mGroupChuck1A3 = VerbToModelGroup(chapter: "Extra 1A", lesson: "Like gustar",
                                         verbToModelList :
                                            [VerbToModelStruct("aburrir"), VerbToModelStruct("doler"), VerbToModelStruct("encantar"), VerbToModelStruct("faltar"), VerbToModelStruct("interesar"), VerbToModelStruct("quedar"), ],
                                           tenseList: [.present, .preterite, .presentSubjunctive],
                                         specialVerbType: .verbsLikeGustar)
        fillAssociatedModelList(v2mGroupChuck1A3)
        v2MGroupManager.appendGroup(v2mGroupChuck1A3)
        
        let v2mGroupChuck1B = VerbToModelGroup(chapter: "Extra 1B", lesson: "Irregular reflexives",
                                         verbToModelList :
                                            [VerbToModelStruct("irse"), VerbToModelStruct("ir"),
                                             VerbToModelStruct("verse"), VerbToModelStruct("ver"),
                                             VerbToModelStruct("hacerse"), VerbToModelStruct("hacer"), ],
                                           tenseList: [.present, .preterite, .imperative, .presentSubjunctive, .presentPerfect],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck1B)
        v2MGroupManager.appendGroup(v2mGroupChuck1B)
        
        let v2mGroupChuck1B2 = VerbToModelGroup(chapter: "Extra 1B", lesson: "Reflexives",
                                         verbToModelList :
                                            [ VerbToModelStruct("aburrirse"),
                                              VerbToModelStruct("acostarse"),
                                             VerbToModelStruct("enflaquecerse"), VerbToModelStruct("levantarse"),
                                             VerbToModelStruct("atreverse"), VerbToModelStruct("referirse")],
                                           tenseList: [.present, .preterite, .imperative, .presentSubjunctive, .presentPerfect],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck1B2)
        v2MGroupManager.appendGroup(v2mGroupChuck1B2)
        
        let v2mGroupChuck1B3 = VerbToModelGroup(chapter: "Extra 1B", lesson: "Imperative",
                                         verbToModelList :
                                            [VerbToModelStruct("hablar"), VerbToModelStruct("deber"), VerbToModelStruct("vivir"),
                                             VerbToModelStruct("ser"),
                                             VerbToModelStruct("decir"),
                                             VerbToModelStruct("hacer"),
                                             VerbToModelStruct("ir"),
                                             VerbToModelStruct("poner"),
                                             VerbToModelStruct("salir"),
                                             VerbToModelStruct("tener"),
                                             VerbToModelStruct("venir"),
                                             VerbToModelStruct("ver"), ],
                                           tenseList: [.present, .imperative],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck1B3)
        v2MGroupManager.appendGroup(v2mGroupChuck1B3)
        
        let v2mGroupChuck2A1 = VerbToModelGroup(chapter: "Extra 2A", lesson: "Irregular past participles",
                                         verbToModelList :
                                            [
                                                VerbToModelStruct("decir"), VerbToModelStruct("contradecir"),
                                                VerbToModelStruct("bendecir"), VerbToModelStruct("maldecir"),
                                                VerbToModelStruct("leer"), VerbToModelStruct("releer"),
                                                
                                                VerbToModelStruct("escribir"), VerbToModelStruct("abrir"), VerbToModelStruct("descubrir"),VerbToModelStruct("romper"), VerbToModelStruct("morir"), VerbToModelStruct("poner"),
                                             VerbToModelStruct("reponer"), VerbToModelStruct("romper"), VerbToModelStruct("reromper"),
                                             VerbToModelStruct("absolver"),
                                             VerbToModelStruct("deshacer"), VerbToModelStruct("hacer"),
                                             
                                              VerbToModelStruct("reír"), VerbToModelStruct("sonreír"),
                                             VerbToModelStruct("descreer"),
                                            ],
                                           tenseList: [.presentPerfect],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2A1)
        v2MGroupManager.appendGroup(v2mGroupChuck2A1)
        
        let v2mGroupChuck2A2 = VerbToModelGroup(chapter: "Extra 2A", lesson: "Irregular gerunds",
                                         verbToModelList :
                                                [
                                                    VerbToModelStruct("huir"), VerbToModelStruct("reír"),
                                                    VerbToModelStruct("freír"), VerbToModelStruct("oír"),
                                                    VerbToModelStruct("decir"), VerbToModelStruct("dormir"),
                                                    VerbToModelStruct("leer"), VerbToModelStruct("creer"),
                                                    VerbToModelStruct("morir"), VerbToModelStruct("pedir"), VerbToModelStruct("sentir"), VerbToModelStruct("vestir"), VerbToModelStruct("mentir"), VerbToModelStruct("traer"), VerbToModelStruct("caer"), VerbToModelStruct("preferir"), VerbToModelStruct("poder"),
                                                ],
                                           tenseList: [.presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2A2)
        v2MGroupManager.appendGroup(v2mGroupChuck2A2)
        
        let v2mGroupChuck2A3 = VerbToModelGroup(chapter: "Extra 2A", lesson: "Compound tenses", verbToModelList :
                                                [
                                                    VerbToModelStruct("andar"), VerbToModelStruct("seguir"), VerbToModelStruct("venir"), VerbToModelStruct("verse"), VerbToModelStruct("ir")
                                                ],
                                                tenseList: [.presentProgressive, .presentPerfect],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2A3)
        v2MGroupManager.appendGroup(v2mGroupChuck2A3)
        
        let v2mGroupChuck2B = VerbToModelGroup(chapter: "Extra 2B", lesson: "Unusual verbs 1",
                                         verbToModelList :
                                                [
                                                    VerbToModelStruct("traer"),
                                                    VerbToModelStruct("oír"), VerbToModelStruct("reír"), VerbToModelStruct("yacer"), VerbToModelStruct("zurcir"), VerbToModelStruct("tañer"), VerbToModelStruct("roer"), ],
                                               tenseList: [.present, .preterite, .imperative, .presentSubjunctive, .imperfectSubjunctiveRA, .presentPerfect],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2B)
        v2MGroupManager.appendGroup(v2mGroupChuck2B)
        
        let v2mGroupChuck2B1 = VerbToModelGroup(chapter: "Extra 2B", lesson: "Unusual verbs 2",
                                         verbToModelList :
                                                [ VerbToModelStruct("reñir"), VerbToModelStruct("raer"), VerbToModelStruct("podrir"), VerbToModelStruct("oler"), VerbToModelStruct("errar"), VerbToModelStruct("desosar")],
                                                tenseList: [.present, .preterite, .imperfect, .future, .conditional, .imperative, .presentSubjunctive, .imperfectSubjunctiveRA, .presentPerfect, .presentProgressive, ],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2B1)
        v2MGroupManager.appendGroup(v2mGroupChuck2B1)
        
        let v2mGroupChuck2B2 = VerbToModelGroup(chapter: "Extra 2B", lesson: "9 Random verbs 1",
                                         verbToModelList :
                                                [ VerbToModelStruct("animar"), VerbToModelStruct("elegir"),
                                                  VerbToModelStruct("enraizar"),
                                                  VerbToModelStruct("tener que"), VerbToModelStruct("decir"),
                                                  VerbToModelStruct("venir"),
                                                  VerbToModelStruct("satisfacer"),
                                                  VerbToModelStruct("seguir"),
                                                  VerbToModelStruct("poner")],
                                                tenseList: [.present, .preterite, .imperfect, .future, .conditional, .imperative, .presentSubjunctive, .imperfectSubjunctiveRA, .presentPerfect, .presentProgressive, ],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2B2)
        v2MGroupManager.appendGroup(v2mGroupChuck2B2)
        
        let v2mGroupChuck2B3 = VerbToModelGroup(chapter: "Extra 2B", lesson: "More AR, ER, IR verbs",
                                         verbToModelList :
                                            [ VerbToModelStruct("acabar"),
                                              VerbToModelStruct("acariciar"),
                                              VerbToModelStruct("echar"),
                                              VerbToModelStruct("dispersar"),
                                              VerbToModelStruct("comprender"),
                                              VerbToModelStruct("aprender"),
                                              VerbToModelStruct("acometer"),
                                                VerbToModelStruct("sufrir"),
                                              VerbToModelStruct("sonreír"),                                              VerbToModelStruct("jaquir"),
                                              VerbToModelStruct("empedernir"),
                                              VerbToModelStruct("muquir"),
                                              VerbToModelStruct("saducir"),
                                              VerbToModelStruct("percibir"), ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck2B3)
        v2MGroupManager.appendGroup(v2mGroupChuck2B3)
        
        
        let v2mGroupChuck3A1 = VerbToModelGroup(chapter: "Extra 3A", lesson: "Stem-changing a-e",
                                         verbToModelList :
                                            [VerbToModelStruct("avergonzar"), VerbToModelStruct("adquirir"), VerbToModelStruct("aullar"),VerbToModelStruct("cocer"), VerbToModelStruct("colgar"), VerbToModelStruct("decir"),
                                             VerbToModelStruct("defender"), VerbToModelStruct("desosar"), VerbToModelStruct("descernir"),
                                             VerbToModelStruct("dormir"),
                                             VerbToModelStruct("elegir"), VerbToModelStruct("empezar"), VerbToModelStruct("encontrar"),
                                             VerbToModelStruct("enraizar"),VerbToModelStruct("erguir"),VerbToModelStruct("errar"),],
                                                tenseList: [.present, .preterite, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3A1)
        v2MGroupManager.appendGroup(v2mGroupChuck3A1)
        
        let v2mGroupChuck3A2 = VerbToModelGroup(chapter: "Extra 3A", lesson: "Stem-changing f-p",
                                         verbToModelList :
                                            [VerbToModelStruct("forzar"), VerbToModelStruct("guiar"), VerbToModelStruct("influir"),VerbToModelStruct("jugar"), VerbToModelStruct("mover"), VerbToModelStruct("oler"),
                                             VerbToModelStruct("pedir"), VerbToModelStruct("pensar"), VerbToModelStruct("poder"),
                                             VerbToModelStruct("predecir"),
                                             VerbToModelStruct("prohibir")],
                                            tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3A2)
        v2MGroupManager.appendGroup(v2mGroupChuck3A2)
        
        let v2mGroupChuck3A3 = VerbToModelGroup(chapter: "Extra 3A", lesson: "Stem-changing q-z",
                                         verbToModelList :
                                            [VerbToModelStruct("querer"), VerbToModelStruct("regar"),
                                             VerbToModelStruct("reír"), VerbToModelStruct("reñir"), VerbToModelStruct("reunir"), VerbToModelStruct("seguir"), VerbToModelStruct("sentir"),VerbToModelStruct("soler"),VerbToModelStruct("reunir"),VerbToModelStruct("trocar"),VerbToModelStruct("venir"),VerbToModelStruct("volver")],
                                            tenseList: [.present, .preterite, .presentSubjunctive, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3A3)
        v2MGroupManager.appendGroup(v2mGroupChuck3A3)
        
        let v2mGroupChuck3B1 = VerbToModelGroup(chapter: "Extra 3B", lesson: "Spell-changing a-d",
                                         verbToModelList :
                                            [VerbToModelStruct("asir"), VerbToModelStruct("avergonzar"), VerbToModelStruct("averiguar"),VerbToModelStruct("caber"), VerbToModelStruct("caer"), VerbToModelStruct("cocer"),
                                             VerbToModelStruct("coger"), VerbToModelStruct("colgar"), VerbToModelStruct("conocer"),
                                             VerbToModelStruct("creer"),
                                             VerbToModelStruct("dar"), VerbToModelStruct("decir"), VerbToModelStruct("delinquir"), VerbToModelStruct("dirigir"),
                                             VerbToModelStruct("distinguir"),
                                             ],
                                                tenseList: [.present, .preterite, .presentSubjunctive, .imperfectSubjunctiveRA, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3B1)
        v2MGroupManager.appendGroup(v2mGroupChuck3B1)
        
        let v2mGroupChuck3B2 = VerbToModelGroup(chapter: "Extra 3B", lesson: "Spell-changing e-p",
                                         verbToModelList :
                                            [VerbToModelStruct("elegir"), VerbToModelStruct("guiar"), VerbToModelStruct("hacer"),VerbToModelStruct("lucir"), VerbToModelStruct("mecer"), VerbToModelStruct("oír"),
                                             VerbToModelStruct("parecer"), VerbToModelStruct("placer"),
                                             ],
                                            tenseList: [.present, .preterite, .presentSubjunctive, .imperfectSubjunctiveRA, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3B2)
        v2MGroupManager.appendGroup(v2mGroupChuck3B2)
        
        let v2mGroupChuck3B3 = VerbToModelGroup(chapter: "Extra 3B", lesson: "Spell-changing p-z",
                                         verbToModelList :
                                            [ VerbToModelStruct("predecir"),
                                             VerbToModelStruct("producir"),
                                             VerbToModelStruct("salir"), VerbToModelStruct("satisfacer"), VerbToModelStruct("seguir"), VerbToModelStruct("traer"), VerbToModelStruct("valer"), VerbToModelStruct("venir"),
                                             VerbToModelStruct("yacer"), VerbToModelStruct("zurcir"),
                                             ],
                                            tenseList: [.present, .preterite, .presentSubjunctive, .imperfectSubjunctiveRA, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3B3)
        v2MGroupManager.appendGroup(v2mGroupChuck3B3)
        
        let v2mGroupChuck3B4 = VerbToModelGroup(chapter: "Extra 3B", lesson: "Spell-changing a-d",
                                         verbToModelList :
                                            [ VerbToModelStruct("ahincar"),
                                             VerbToModelStruct("andar"),
                                             VerbToModelStruct("avergonzar"), VerbToModelStruct("averiguar"), VerbToModelStruct("caber"), VerbToModelStruct("caer"), VerbToModelStruct("cacer"), VerbToModelStruct("colgar"),
                                             VerbToModelStruct("dar"), VerbToModelStruct("decir"),
                                             ],
                                            tenseList: [.present, .preterite, .presentSubjunctive, .imperfectSubjunctiveRA, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3B4)
        v2MGroupManager.appendGroup(v2mGroupChuck3B4)
        
        let v2mGroupChuck3C1 = VerbToModelGroup(chapter: "Extra 3C", lesson: "Irregular verbs 1",
                                         verbToModelList :
                                            [ VerbToModelStruct("ser"),
                                             VerbToModelStruct("estar"),
                                             VerbToModelStruct("haber"), VerbToModelStruct("tener"), VerbToModelStruct("andar"), VerbToModelStruct("caber"), VerbToModelStruct("caer"), VerbToModelStruct("dar"),
                                             VerbToModelStruct("decir"), VerbToModelStruct("hacer"),
                                              VerbToModelStruct("ir"), VerbToModelStruct("oír"),
                                             ],
                                                tenseList: [.present, .preterite, .imperfect, .future, .presentSubjunctive, .imperfectSubjunctiveRA, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3C1)
        v2MGroupManager.appendGroup(v2mGroupChuck3C1)
        
        let v2mGroupChuck3C2 = VerbToModelGroup(chapter: "Extra 3C", lesson: "Irregular verbs 2",
                                         verbToModelList :
                                            [ VerbToModelStruct("poder"), VerbToModelStruct("poner"),
                                              VerbToModelStruct("predecir"), VerbToModelStruct("producir"),
                                              VerbToModelStruct("querer"), VerbToModelStruct("raer"),
                                              VerbToModelStruct("reír"), VerbToModelStruct("saber"),
                                              VerbToModelStruct("satisfacer"), VerbToModelStruct("traer"),
                                              VerbToModelStruct("venir"), VerbToModelStruct("ver"),
                                             ],
                                            tenseList: [.present, .preterite, .presentSubjunctive, .imperfectSubjunctiveRA, .presentProgressive],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroupChuck3C2)
        v2MGroupManager.appendGroup(v2mGroupChuck3C2)
    }

    func loadMichelle1(){
    }

    func loadRealidadesII(){
    }
    
    func loadRealidadesIII(){
    }
    
    func loadRealidadesI(){
        let v2mGroup1A = VerbToModelGroup(chapter: Realidades1Chapters.chapter1A.rawValue, lesson: "Useful verbs",
                                         verbToModelList :
                                            [VerbToModelStruct("tener"), VerbToModelStruct("estudiar") ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup1A)
        v2MGroupManager.appendGroup(v2mGroup1A)
        
        let v2mGroup1B = VerbToModelGroup(chapter: Realidades1Chapters.chapter1B.rawValue, lesson: "More useful verbs",
                                         verbToModelList :
                                            [VerbToModelStruct("gustar"), VerbToModelStruct("encantar")  ],
                                         tenseList: [.present],
                                          specialVerbType: .verbsLikeGustar)
        fillAssociatedModelList(v2mGroup1B)
        v2MGroupManager.appendGroup(v2mGroup1B)
        
        let v2mGroup2A = VerbToModelGroup(chapter: Realidades1Chapters.chapter2A.rawValue, lesson: "AR verbs",
                                         verbToModelList :
                                            [VerbToModelStruct("hablar"), VerbToModelStruct("bananar"),  ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup2A)
        v2MGroupManager.appendGroup(v2mGroup2A)
    
        let v2mGroup2B = VerbToModelGroup(chapter: Realidades1Chapters.chapter2B.rawValue, lesson: "Estar",
                                         verbToModelList :
                                            [VerbToModelStruct("estar")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup2B)
        v2MGroupManager.appendGroup(v2mGroup2B)
    
        
        let v2mGroup3A = VerbToModelGroup(chapter: Realidades1Chapters.chapter3A.rawValue, lesson: "ER, IR",
                                         verbToModelList :
                                            [VerbToModelStruct("comer"), VerbToModelStruct("beber"), VerbToModelStruct("compartir")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup3A)
        v2MGroupManager.appendGroup(v2mGroup3A)
        
        let v2mGroup3A1 = VerbToModelGroup(chapter: Realidades1Chapters.chapter3A.rawValue, lesson: "AR, ER, IR",
                                         verbToModelList :
                                            [ VerbToModelStruct("hablar"),
                                              VerbToModelStruct("comprar"),
                                                VerbToModelStruct("vivir"),
                                              VerbToModelStruct("beber"),
                                              VerbToModelStruct("compartir"),
                                              VerbToModelStruct("comer"), ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup3A1)
        v2MGroupManager.appendGroup(v2mGroup3A1)
        
        
        let v2mGroup3B = VerbToModelGroup(chapter: Realidades1Chapters.chapter3B.rawValue, lesson: "Ser",
                                         verbToModelList :
                                            [VerbToModelStruct("ser")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup3B)
        v2MGroupManager.appendGroup(v2mGroup3B)
        
        let v2mGroup3B2 = VerbToModelGroup(chapter: Realidades1Chapters.chapter3B.rawValue, lesson: "Health",
                                         verbToModelList :
                                            [VerbToModelStruct("caminar"), VerbToModelStruct("hacer ejercicio"), VerbToModelStruct("levantar pesas") ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup3B2)
        v2MGroupManager.appendGroup(v2mGroup3B2)
        
        let v2mGroup4A = VerbToModelGroup(chapter: Realidades1Chapters.chapter4A.rawValue, lesson: "Ir, Ver",
                                         verbToModelList :
                                            [VerbToModelStruct("ir"), VerbToModelStruct("ver")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup4A)
        v2MGroupManager.appendGroup(v2mGroup4A)
        
        let v2mGroup4A2 = VerbToModelGroup(chapter: Realidades1Chapters.chapter4A.rawValue, lesson: "Quedarse",
                                         verbToModelList :
                                            [VerbToModelStruct("quedarse")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup4A2)
        v2MGroupManager.appendGroup(v2mGroup4A2)
        
        let v2mGroup4B = VerbToModelGroup(chapter: Realidades1Chapters.chapter4B.rawValue, lesson: "Ir phrases",
                                         verbToModelList :
                                            [VerbToModelStruct("ir a"), VerbToModelStruct("ir de")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup4B)
        v2MGroupManager.appendGroup(v2mGroup4B)
        
        let v2mGroup4B2 = VerbToModelGroup(chapter: Realidades1Chapters.chapter4B.rawValue, lesson: "Jugar",
                                         verbToModelList :
                                            [VerbToModelStruct("jugar")],
                                         tenseList: [.present],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup4B2)
        v2MGroupManager.appendGroup(v2mGroup4B2)
        
        let v2mGroup5A = VerbToModelGroup(chapter: Realidades1Chapters.chapter5A.rawValue, lesson: "Tener",
                                         verbToModelList :
                                            [VerbToModelStruct("tener")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup5A)
        v2MGroupManager.appendGroup(v2mGroup5A)
        
        let v2mGroup5A2 = VerbToModelGroup(chapter: "Chapter 5A", lesson: "Important verbs 1",
                                         verbToModelList :
                                            [VerbToModelStruct("abrir"), VerbToModelStruct("celebrar"), VerbToModelStruct("decorar")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup5A2)
        v2MGroupManager.appendGroup(v2mGroup5A2)
        
        let v2mGroup5A3 = VerbToModelGroup(chapter: "Chapter 5A", lesson: "Important verbs 2",
                                         verbToModelList :
                                            [ VerbToModelStruct("hacer un video"), VerbToModelStruct("preparar"), VerbToModelStruct("sacar fotos"), VerbToModelStruct("romper")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup5A3)
        v2MGroupManager.appendGroup(v2mGroup5A3)
        
        let v2mGroup5B = VerbToModelGroup(chapter: "Chapter 5B", lesson: "Venir",
                                         verbToModelList :
                                            [VerbToModelStruct("venir")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup5B)
        v2MGroupManager.appendGroup(v2mGroup5B)
        
        let v2mGroup5B2 = VerbToModelGroup(chapter: "Chapter 5B", lesson: "Me falta",
                                         verbToModelList :
                                            [VerbToModelStruct("faltar")],
                                         tenseList: [.present],
                                           specialVerbType: .verbsLikeGustar)
        fillAssociatedModelList(v2mGroup5B2)
        v2MGroupManager.appendGroup(v2mGroup5B2)
        
        let v2mGroup5B3 = VerbToModelGroup(chapter: "Chapter 5B", lesson: "Quisiera",
                                         verbToModelList :
                                            [VerbToModelStruct("querer")],
                                           tenseList: [.imperfectSubjunctiveRA],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup5B3)
        v2MGroupManager.appendGroup(v2mGroup5B3)
        
        let v2mGroup5B4 = VerbToModelGroup(chapter: "Chapter 5B", lesson: "Traer",
                                         verbToModelList :
                                            [VerbToModelStruct("traer")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup5B4)
        v2MGroupManager.appendGroup(v2mGroup5B4)
        
        let v2mGroup6A = VerbToModelGroup(chapter: "Chapter 6A", lesson: "Stem-changing",
                                         verbToModelList :
                                            [VerbToModelStruct("dormir"), VerbToModelStruct("poder")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup6A)
        v2MGroupManager.appendGroup(v2mGroup6A)
        
        let v2mGroup6B = VerbToModelGroup(chapter: "Chapter 6B", lesson: "Affirmative tú commands",
                                         verbToModelList :
                                            [VerbToModelStruct("hablar"), VerbToModelStruct("leer"), VerbToModelStruct("escribir"), VerbToModelStruct("hacer"), VerbToModelStruct("poner"), ],
                                         tenseList: [.imperative],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup6B)
        v2MGroupManager.appendGroup(v2mGroup6B)
        
        let v2mGroup6B2 = VerbToModelGroup(chapter: "Chapter 6B", lesson: "Present progressive",
                                         verbToModelList :
                                            [VerbToModelStruct("lavar"), VerbToModelStruct("comer"), VerbToModelStruct("escribir"), ],
                                         tenseList: [.presentProgressive],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup6B2)
        v2MGroupManager.appendGroup(v2mGroup6B2)
        
        let v2mGroup6B3 = VerbToModelGroup(chapter: "Chapter 6B", lesson: "Present perfect",
                                         verbToModelList :
                                            [VerbToModelStruct("lavar"), VerbToModelStruct("comer"), VerbToModelStruct("escribir"), ],
                                         tenseList: [.presentPerfect],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup6B3)
        v2MGroupManager.appendGroup(v2mGroup6B3)
        
        let v2mGroup7A = VerbToModelGroup(chapter: "Chapter 7A", lesson: "Shopping",
                                         verbToModelList :
                                            [VerbToModelStruct("buscar"), VerbToModelStruct("comprar"), VerbToModelStruct("entrar la tienda")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup7A)
        v2MGroupManager.appendGroup(v2mGroup7A)
        
        let v2mGroup7A2 = VerbToModelGroup(chapter: "Chapter 7A", lesson: "More stem-changing",
                                         verbToModelList :
                                            [VerbToModelStruct("pensar"), VerbToModelStruct("querer"), VerbToModelStruct("preferir"), VerbToModelStruct("costar"),],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup7A2)
        v2MGroupManager.appendGroup(v2mGroup7A2)
        
        let v2mGroup7B = VerbToModelGroup(chapter: "Chapter 7B", lesson: "Shopping",
                                         verbToModelList :
                                            [VerbToModelStruct("mirar"), VerbToModelStruct("vender"), VerbToModelStruct("pagar por")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup7B)
        v2MGroupManager.appendGroup(v2mGroup7B)
        
        let v2mGroup7B2 = VerbToModelGroup(chapter: "Chapter 7B", lesson: "Preterite, Regular AR",
                                         verbToModelList :
                                            [VerbToModelStruct("comprar")],
                                         tenseList: [.preterite, .present,],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup7B2)
        v2MGroupManager.appendGroup(v2mGroup7B2)
        
        let v2mGroup7B3 = VerbToModelGroup(chapter: "Chapter 7B", lesson: "Preterite, Spell-changing",
                                         verbToModelList :
                                            [VerbToModelStruct("buscar"), VerbToModelStruct("jugar"), VerbToModelStruct("pagar")],
                                         tenseList: [.preterite],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup7B3)
        v2MGroupManager.appendGroup(v2mGroup7B3)
        
        let v2mGroup7B4 = VerbToModelGroup(chapter: "Chapter 7B", lesson: "Preterite, Regular AR, ER, IR",
                                         verbToModelList :
                                            [ VerbToModelStruct("acabar"),
                                              VerbToModelStruct("montar"),
                                              VerbToModelStruct("trabajar"),
                                              VerbToModelStruct("comprender"),
                                              VerbToModelStruct("aprender"),
                                              VerbToModelStruct("acometer"),
                                                VerbToModelStruct("sufrir"),
                                              VerbToModelStruct("empedernir"),
                                              VerbToModelStruct("percibir"), ],
                                                tenseList: [.preterite, .present, ],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup7B4)
        v2MGroupManager.appendGroup(v2mGroup7B4)
        let v2mGroup8A = VerbToModelGroup(chapter: "Chapter 8A", lesson: "Vacation",
                                         verbToModelList :
                                            [VerbToModelStruct("aprender"), VerbToModelStruct("bucear"), VerbToModelStruct("comprar recuerdos"), VerbToModelStruct("descansar"), VerbToModelStruct("montar a caballo"), VerbToModelStruct("pasear en bote"), VerbToModelStruct("tomar el sol"), VerbToModelStruct("visitar") ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup8A)
        v2MGroupManager.appendGroup(v2mGroup8A)
        
        let v2mGroup8A2 = VerbToModelGroup(chapter: "Chapter 8A", lesson: "Preterite, Regular IR/ER",
                                         verbToModelList :
                                            [VerbToModelStruct("aprender"), VerbToModelStruct("salir"),],
                                         tenseList: [.preterite],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup8A2)
        v2MGroupManager.appendGroup(v2mGroup8A2)
        
        let v2mGroup8A3 = VerbToModelGroup(chapter: "Chapter 8A", lesson: "Preterite, verb IR",
                                         verbToModelList :
                                            [VerbToModelStruct("ir")],
                                         tenseList: [.preterite],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup8A3)
        v2MGroupManager.appendGroup(v2mGroup8A3)
        
        let v2mGroup8B = VerbToModelGroup(chapter: "Chapter 8B", lesson: "Recycling",
                                         verbToModelList :
                                            [VerbToModelStruct("llevar"), VerbToModelStruct("reciclar"), VerbToModelStruct("recoger"), VerbToModelStruct("separar") ],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup8B)
        v2MGroupManager.appendGroup(v2mGroup8B)
        
        let v2mGroup8B2 = VerbToModelGroup(chapter: "Chapter 8B", lesson: "Decir",
                                         verbToModelList :
                                            [VerbToModelStruct("decir")],
                                         tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup8B2)
        v2MGroupManager.appendGroup(v2mGroup8B2)
        
        let v2mGroup8B3 = VerbToModelGroup(chapter: "Chapter 8B", lesson: "Preterite, Dar/Hacer",
                                         verbToModelList :
                                            [VerbToModelStruct("dar"), VerbToModelStruct("hacer"), ],
                                         tenseList: [.preterite],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup8B3)
        v2MGroupManager.appendGroup(v2mGroup8B3)
        
        let v2mGroup9A = VerbToModelGroup(chapter: "Chapter 9A", lesson: "TV and Movies",
                                         verbToModelList :
                                            [VerbToModelStruct("aburrir el programa"), VerbToModelStruct("interesar el drama"), ],
                                         tenseList: [.present],
                                         specialVerbType: .verbsLikeGustar)
        fillAssociatedModelList(v2mGroup9A)
        v2MGroupManager.appendGroup(v2mGroup9A)
        
        let v2mGroup9A2 = VerbToModelGroup(chapter: "Chapter 9A", lesson: "Like gustar",
                                         verbToModelList :
                                            [VerbToModelStruct("aburrir"), VerbToModelStruct("doler"), VerbToModelStruct("encantar"), VerbToModelStruct("faltar"), VerbToModelStruct("interesar"), VerbToModelStruct("quedar"), ],
                                           tenseList: [.present, .preterite, .presentSubjunctive],
                                         specialVerbType: .verbsLikeGustar)
        fillAssociatedModelList(v2mGroup9A2)
        v2MGroupManager.appendGroup(v2mGroup9A2)
        
        let v2mGroup9A3 = VerbToModelGroup(chapter: "Chapter 9A", lesson: "Acabar de",
                                         verbToModelList :
                                            [VerbToModelStruct("acabar de")],
                                           tenseList: [.present, .preterite],
                                           specialVerbType: .auxiliaryVerbsInfinitives)
        fillAssociatedModelList(v2mGroup9A3)
        v2MGroupManager.appendGroup(v2mGroup9A3)
        
        let v2mGroup9A4 = VerbToModelGroup(chapter: "Chapter 9A", lesson: "Useful verbs",
                                         verbToModelList :
                                            [VerbToModelStruct("dar"), VerbToModelStruct("durar"), VerbToModelStruct("empezar"), VerbToModelStruct("terminar")],
                                           tenseList: [.present],
                                           specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup9A4)
        v2MGroupManager.appendGroup(v2mGroup9A4)
        
        let v2mGroup9B = VerbToModelGroup(chapter: "Chapter 9B", lesson: "Communication",
                                         verbToModelList :
                                            [VerbToModelStruct("comunicarse"), VerbToModelStruct("bajar"), VerbToModelStruct("buscar"), VerbToModelStruct("estar en linea") ,VerbToModelStruct("grabar un disco"), VerbToModelStruct("navegar en la Red"), ],
                                          tenseList: [.present, .preterite],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup9B)
        v2MGroupManager.appendGroup(v2mGroup9B)
        
        
        let v2mGroup9B2 = VerbToModelGroup(chapter: "Chapter 9B", lesson: "Verb phrases",
                                         verbToModelList :
                                            [ VerbToModelStruct("estar en linea") ,VerbToModelStruct("grabar un disco"), VerbToModelStruct("navegar en la Red"), VerbToModelStruct("visitar salones de chat"), VerbToModelStruct("tener miedo de") ],
                                           tenseList: [.present, .preterite],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup9B2)
        v2MGroupManager.appendGroup(v2mGroup9B2)
        
        let v2mGroup9B3 = VerbToModelGroup(chapter: "Chapter 9B", lesson: "Pedir/Servir",
                                         verbToModelList :
                                            [ VerbToModelStruct("pedir") ,VerbToModelStruct("servir") ],
                                           tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup9B3)
        v2MGroupManager.appendGroup(v2mGroup9B3)
        
        let v2mGroup9B4 = VerbToModelGroup(chapter: "Chapter 9B", lesson: "Saber/Conocer",
                                         verbToModelList :
                                            [ VerbToModelStruct("saber") ,VerbToModelStruct("conocer") ],
                                           tenseList: [.present],
                                         specialVerbType: .normal)
        fillAssociatedModelList(v2mGroup9B4)
        v2MGroupManager.appendGroup(v2mGroup9B4)
    }
    
       
    func dumpV2MGroupManager(){
        for v2mGroup in v2MGroupManager.getV2MGroupList(){
            print("v2mGroup: Book \(v2mGroup.chapter), Lesson: \(v2mGroup.lesson)")
            for v2m in v2mGroup.verbToModelList {
                print("v2m: \(v2m.verb.getWordAtLanguage(language: getCurrentLanguage())), model: \(v2m.model.modelVerb)")
            }
        }
        
    }
    
    func fillAssociatedModelList(_ v2mGroup: VerbToModelGroup){
        let v2MList = v2mGroup.verbToModelList
        for v2m in v2MList {
            v2m.setVerbModel(findModelForThisVerbString(verbWord: v2m.verb.getWordAtLanguage(language: getCurrentLanguage())))
        }
    }

}
    
