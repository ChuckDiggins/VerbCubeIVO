//
//  StudentLevel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/5/22.
//

import SwiftUI

//learning level vs student level

//There are 6 learning levels: 1-6
//Each learning level comprises 2 or more student levels
//For example, learning level 5 contains 5001, 5002, 5003, 5004



enum StudentLevel : Int, CaseIterable {
    case level1001 = 1001
    case level1002 = 1002
    case level1003 = 1003
    case level1004 = 1004
    case level1005 = 1005
    case level1006 = 1006
    
    case level2001 = 2001
    case level2002 = 2002
    case level2003 = 2003
    case level2004 = 2004

    case level3001 = 3001
    case level3002 = 3002
    case level3003 = 3003
    
    case level4001 = 4001
    case level4002 = 4002
    case level4003 = 4003
    case level4004 = 4004
    case level4005 = 4005
    case level4006 = 4006
    
    case level5001 = 5001
    case level5002 = 5002
    case level5003 = 5003
    case level5004 = 5004
    case level5005 = 5005
    case level5006 = 5006
    
    case level6001 = 6001
    case level6002 = 6002
    case level6003 = 6003
    case level6004 = 6004
    case level6005 = 6005
    
    public func getEnumString()->String{
        switch self {
        case .level1001: return "Present tense, 3 regular verbs"
        case .level1002: return "Present tense, 5x3 regular verbs"
        case .level1003: return "Present tense, special verbs"
        case .level1004: return "Preterite tense, 3 regular verbs"
        case .level1005: return "Imperfect tense, 3 regular verbs"
        case .level1006: return "Conditional and future tenses, 3 regular verbs"
            
        case .level2001: return "5 basic tenses, 5x3 regular verbs"  //verb cubes, multiple morph
        case .level2002: return "5 basic tenses, special verbs"  //verb cubes, multiple morph
        case .level2003: return "Not available"  //verb cubes, multiple morph
        case .level2004: return "Not available"  //verb cubes, multiple morph
        
        case .level3001: return "Subjunctive tense"
        case .level3002: return "Compound tenses"
        case .level3003: return "Commands"

        case .level4001: return "Common stem-changing verbs - present tense"  //verb cubes, multiple morph, right/wrong
        case .level4002: return "Spell-changing verbs"       //verb cubes, multiple morph, right/wrong
        case .level4003: return "Common stem-changing verbs - preterite tense"  //verb cubes, multiple morph, right/wrong
        case .level4004: return "Uncommon stem-changing verbs"  //verb cubes, multiple morph, right/wrong
        case .level4005: return "Not available"  //verb cubes, multiple morph, right/wrong
        case .level4006: return "Not available"  //verb cubes, multiple morph, right/wrong
            
        case .level5001: return "Common verb models"  //verb cubes, multiple morph, right/wrong
        case .level5002: return "One-of-a-kind verb models"
        case .level5003: return "Uncommon verb models"  //verb cubes, multiple morph, right/wrong
        case .level5004: return "XVerbs"              //verb cubes, multiple morph, right/wrong
        case .level5005: return "Not available"              //verb cubes, multiple morph, right/wrong
        case .level5006: return "Not available"              //verb cubes, multiple morph, right/wrong
            
        case .level6001: return "Reflexive verbs"
        case .level6002: return "Verb phrases"
        case .level6003: return "Negatives"
        case .level6004: return "Auxiliary verbs"
        case .level6005: return "Verbs like gustar"
        }
    }
    
    public func getLessonObjectives()->(String, String){
        switch self {
        case .level1001: return ("Learn how to conjugate 3 regular verbs in the present tense.", "One AR, one ER and one IR verb.")
        case .level1002: return ("Learn how to conjugate 15 regular verbs in the present tense.", "5 AR, 5 ER, AND 5 IR verbs.")
        case .level1003: return ("Learn how to conjugate special verbs in the present tense.", "These are very important and very irregular verbs.")
        case .level1004: return ("Learn how to conjugate 3 regular verbs in the preterite tense.", "One AR, one ER and one IR verb.")
        case .level1005: return ("Learn how to conjugate 3 regular verbs in the imperfect tense.", "One AR, one ER and one IR verb.")
        case .level1006: return ("Learn how to conjugate 3 regular verbs in the future and conditional tenses.", "One AR, one ER and one IR verb.")
            
        case .level2001: return ("Learn how to conjugate 15 regular verbs in the basic tenses.", "")
        case .level2002: return ("Learn how to conjugate special verbs in the basic tenses.", "")
        case .level2003: return ("Not available", "Not available")
        case .level2004: return ("Not available", "Not available")
        
        case .level3001: return ("Learn how to conjugate in the present subjunctive tense.", "")
        case .level3002: return ("Compound tenses have two part verbs.", "For examples: I have eaten, I am running.")
        case .level3003: return ("Commands are also called the imperative tense.", "For examples: go now, shut up.")

        case .level4001: return ("Many Spanish verbs are stem-changing in the present tense.", "A common stem-change is from 'o' to 'ue'.")
        case .level4002: return ("Many Spanish verbs are spell-changing.", "")
        case .level4003: return ("Many Spanish verbs are stem-changing.", "")
        case .level4004: return ("Not available", "Not available")
        case .level4005: return ("Not available", "Not available")
        case .level4006: return ("Not available", "Not available")
            
        case .level5001: return ("Verb models are a powerful and efficient way to learn Spanish verb conjugation.", "All verbs for a given model conjugate identically for all tenses, all persons.")
        case .level5002: return ("Some verb models are one-of-a-kind.", "For example, the verb ser has no other verbs like it")
        case .level5003: return ("Some verb models are unusual.", "For example, the verb xxx has no other verbs like it.")
        case .level5004: return ("X-verbs are made up verbs", "X-verbs, such as XXXEGUIR, can be very useful for learning verb models.")
        case .level5005: return ("Not available", "Not available")
        case .level5006: return ("Not available", "Not available")
            
        case .level6001: return ("Learn how to conjugate reflexive verbs.", "")
        case .level6002: return ("Learn how to conjugate verb phrases.", "For example: darse con.")
        case .level6003: return ("Learn how to conjugate verb phrases in the negative.", "For example: I am going -> I am not going.")
        case .level6004: return ("Auxiliary verbs can be combined with other verbs to create a compound verb.", "For example: I want to eat.")
        case .level6005: return ("Verbs like gustar conjugate \"backwards\".", "For example: Instead of \"I like food\", we say \"Food is pleasing to me.\"")
        }
    }
    
    public func getLessonLevel()->Int{
        switch self {
        case .level1001, .level1002, .level1003, .level1004, .level1005, .level1006: return 1
        case .level2001, .level2002, .level2003, .level2004 : return 2
        case .level3001, .level3002, .level3003: return 3
        case .level4001, .level4002, .level4003, .level4004, .level4005, .level4006: return 4
        case .level5001, .level5002, .level5003, .level5004, .level5005, .level5006: return 5
        case .level6001, .level6002, .level6003, .level6004, .level6005: return 6
        }
    }
    
    //present tense - regular and special verbs
    static var level1 =
    [StudentLevel.level1001, .level1002, .level1003, .level1004, .level1005, .level1006]
    
    //5 tenses - regular and special verbs
    static var level2 =
    [StudentLevel.level2001, .level2002, .level2003, .level2004 ]
    
    //other tenses  - regular and special verbs
    static var level3 =
    [StudentLevel.level3001, .level3002, .level3003]
    
    //patterns - open tenses
    static var level4 =
    [StudentLevel.level4001, .level4002, .level4003, .level4004, .level4005, .level4006]
    
    //models - open tenses
    static var level5 =
    [StudentLevel.level5001, .level5002, .level5003, .level5004, .level5005, .level5006]
    
    //extras - open tenses
    static var level6 =
    [StudentLevel.level6001, .level6002, .level6003, .level6004, .level6005]
    
    
}

enum LessonCompletionMode {
    case closed
    case open
    case completed
    
    func getImage()->Image{
        switch self{
        case .closed: return Image(systemName: "square.split.diagonal.2x2")
        case .open: return Image(systemName: "square")
        case .completed: return Image(systemName: "checkmark.square")
        }
    }
}

struct StudentLevelCompletion {
    private var lessonCompletionMode = [LessonCompletionMode]()
    init(){
        for _ in StudentLevel.allCases {
            lessonCompletionMode.append(.closed)
        }
    }
    
    init(mode: LessonCompletionMode){
        for _ in StudentLevel.allCases {
            lessonCompletionMode.append(mode)
        }
    }
    
    mutating func setLessonCompletionMode(sl: StudentLevel, lessonCompletionMode: LessonCompletionMode) {
        //if completion mode is .open, then set all completion modes in this learning level to .open
        //if completion mode is .complete, then set all completion modes in this learning level and all lesser levels to .completed
        //if completion mode is .closed, then set all completion modes in this learning level and all greater levels to .closed
        let learningLevel = getLearningLevel(studentLevel: sl)
        for _ in StudentLevel.level1 {
            self.lessonCompletionMode[getIndex(sl: sl)] = lessonCompletionMode
        }
    }
    
    func getIndex(sl: StudentLevel)->Int{
        switch sl{
        case .level1001:
            return 0
        case .level1002:
            return 1
        case .level1003:
            return 2
        case .level1004:
            return 3
        case .level1005:
            return 4
        case .level1006:
            return 5
        case .level2001:
            return 6
        case .level2002:
            return 7
        case .level2003:
            return 8
        case .level2004:
            return 9
        case .level3001:
            return 10
        case .level3002:
            return 11
        case .level3003:
            return 12
        case .level4001:
            return 13
        case .level4002:
            return 14
        case .level4003:
            return 15
        case .level4004:
            return 16
        case .level4005:
            return 17
        case .level4006:
            return 18
        case .level5001:
            return 19
        case .level5002:
            return 20
        case .level5003:
            return 21
        case .level5004:
            return 22
        case .level5005:
            return 23
        case .level5006:
            return 24
        case .level6001:
            return 25
        case .level6002:
            return 26
        case .level6003:
            return 27
        case .level6004:
            return 28
        case .level6005:
            return 29
        }
    }
    
    func getLessonCompletionMode(level: Int)->LessonCompletionMode {
        if level >= 0 && level < lessonCompletionMode.count {
            return lessonCompletionMode[level]
        }
        return .closed
    }
    
    
    func getLessonCompletionMode(sl: StudentLevel)->LessonCompletionMode {
        return getLessonCompletionMode(level: getIndex(sl: sl))
    }
    
}

func getLearningObjective(level: Int)->String{
    switch level{
    case 1: return "Present tense: regular and special verbs"
    case 2: return "5 regular tenses: regular and special verbs"
    case 3: return "Other tenses: regular and special verbs"
    case 4: return "Stem-changing and spell-changing verbs"
    case 5: return "Model-based verb conjugation"
    case 6: return "Extras"
    default: return "No group description for level: \(level)"
    }
}

func getStudentLevelsAt(level: Int)->[StudentLevel]{
    switch level{
    case 1: return [StudentLevel.level1001, .level1002, .level1003]
    case 2: return  [StudentLevel.level2001, .level2002]
    case 3: return  [StudentLevel.level3001, .level3002, .level3003]
    case 4: return  [StudentLevel.level4001, .level4002, .level4003]
    case 5: return  [StudentLevel.level5001, .level5002, .level5003, .level5004]
    default: return  [StudentLevel.level6001, .level6002, .level6003, .level6004, .level6005]
    }
}

func getLearningLevel(studentLevel: StudentLevel)->Int{
    
    return studentLevel.rawValue / 1000
}
