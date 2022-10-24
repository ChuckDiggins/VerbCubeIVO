//
//  StudentScoreModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/28/22.
//

import Foundation
import JumpLinguaHelpers

class StudentScore {
    var correctScore : Int = 0
    var wrongScore : Int = 0
    init(){
        self.correctScore = 0
        self.wrongScore = 0
    }
}

class VerbScore : StudentScore {
    var value : Verb = Verb()
    init(verb: Verb){
        self.value = verb
        super.init()
    }
}

class TenseScore : StudentScore{
    var value : Tense = .present
    init(tense: Tense){
        self.value = tense
        super.init()
    }
}

class PersonScore : StudentScore{
    var value : Person = .S1
    init(person: Person){
        self.value = person
        super.init()
    }
}

class ModelScore : StudentScore{
    var value = RomanceVerbModel()
    init(model: RomanceVerbModel){
        self.value = model
        super.init()
    }
}

class PatternScore : StudentScore{
    var value = SpecialPatternType.none
    init(pattern: SpecialPatternType){
        self.value = pattern
        super.init()
    }
}

enum StudentScoreEnum : String {
    case verb = "Verbs"
    case tense = "Tenses"
    case person = "Persons"
    case model = "Models"
    case pattern = "Patterns"
}

class StudentScoreModel {
    
    var verbScoreList = [VerbScore]()
    var tenseScoreList = [TenseScore]()
    var personScoreList = [PersonScore]()
    var modelScoreList = [ModelScore]()
    var patternScoreList = [PatternScore]()
    
    func getVerbScores()->[VerbScore]{
        verbScoreList
    }
    
    func getTenseScores()->[TenseScore]{
        tenseScoreList
    }
    
    func getPersonScores()->[PersonScore]{
        personScoreList
    }
    
    func getModelScores()->[ModelScore]{
        modelScoreList
    }
    
    func getPatternScores()->[PatternScore]{
        patternScoreList
    }
    
    func getScores(studentScoreEnum: StudentScoreEnum)->[StudentScore]{
        switch studentScoreEnum {
        case .verb:  return verbScoreList
        case .tense: return tenseScoreList
        case .person: return personScoreList
        case .model: return modelScoreList
        case .pattern: return patternScoreList
        }
    }
    
    func clearAllScores(){
        verbScoreList.removeAll()
        tenseScoreList.removeAll()
        personScoreList.removeAll()
        modelScoreList.removeAll()
        patternScoreList.removeAll()
    }
   func createStudentScoreModels(verbList: [Verb], tenseList: [Tense], personList: [Person],
                                           modelList: [RomanceVerbModel], patternList: [SpecialPatternType]){
       clearAllScores()
        for v in verbList{ verbScoreList.append(VerbScore(verb: v)) }
        for t in tenseList{ tenseScoreList.append(TenseScore(tense: t)) }
        for p in personList{ personScoreList.append(PersonScore(person: p)) }
        for m in modelList{  modelScoreList.append(ModelScore(model: m))  }
        for p in patternList{  patternScoreList.append(PatternScore(pattern: p))  }
    }
    
    func createStudentScoreModels(verbList: [Verb], tenseList: [Tense], personList: [Person]){
        clearAllScores()
         for v in verbList{ verbScoreList.append(VerbScore(verb: v))}
         for t in tenseList{ tenseScoreList.append(TenseScore(tense: t))}
         for p in personList{ personScoreList.append(PersonScore(person: p))}
     }
     
    
    func resetAllScores(){
        for v in verbScoreList {
            v.wrongScore = 0
            v.correctScore = 0
        }
        for t in tenseScoreList {
            t.wrongScore = 0
            t.correctScore = 0
        }
        for p in personScoreList {
            p.wrongScore = 0
            p.correctScore = 0
        }
        for m in modelScoreList {
            m.wrongScore = 0
            m.correctScore = 0
        }
        for p in patternScoreList {
            p.wrongScore = 0
            p.correctScore = 0
        }
    }
    
    func getVerbScores(value: Verb)->(Int, Int){
        for v in verbScoreList {
            if v.value == value {
                return (v.correctScore, v.wrongScore)
            }
        }
        return (0,0)
    }
    
    func getTenseScores(value: Tense)->(Int, Int){
        for v in tenseScoreList {
            if v.value == value {
                return (v.correctScore, v.wrongScore)
            }
        }
        return (0,0)
    }
    
    func getPersonScores(value: Person)->(Int, Int){
        for v in personScoreList {
            if v.value == value {
                return (v.correctScore, v.wrongScore)
            }
        }
        return (0,0)
    }
    
    func incrementVerbScore(value: Verb, correctScore: Int, wrongScore: Int)
    {
    for v in verbScoreList {
        if v.value == value {
            v.correctScore += correctScore
            v.wrongScore += wrongScore
        }
    }
    }
    
    func incrementTenseScore(value: Tense, correctScore: Int, wrongScore: Int)
    {
    for v in tenseScoreList {
        if v.value == value {
            v.correctScore += correctScore
            v.wrongScore += wrongScore
        }
    }
    }

    
    func incrementPersonScore(value: Person, correctScore: Int, wrongScore: Int)
    {
    for v in personScoreList {
        if v.value == value {
            v.correctScore += correctScore
            v.wrongScore += wrongScore
        }
    }
    }
    
    func incrementModelScore(value: RomanceVerbModel, correctScore: Int, wrongScore: Int)
    {
    for v in modelScoreList {
        if v.value.id == value.id {
            v.correctScore += correctScore
            v.wrongScore += wrongScore
        }
    }
    }
    
    func incrementPatternScore(value: SpecialPatternType, correctScore: Int, wrongScore: Int)
    {
    for v in patternScoreList {
        if v.value == value {
            v.correctScore += correctScore
            v.wrongScore += wrongScore
        }
    }
    }
    
}
