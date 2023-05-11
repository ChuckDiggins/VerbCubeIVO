//
//  ExerciseDataManager.swift
//  PersistenceTest
//
//  Created by Charles Diggins on 1/30/23.
//

import SwiftUI

enum ExerciseMode : String, Hashable, CaseIterable, Identifiable{
    case Select
    case Explore
    case Learn
    case Test
    case SelectModel
    var id: String{
        self.rawValue
    }
    
}

struct ExerciseData : Identifiable {
    
    var id : Int
    var image : String
    var studentLevel : String   //beginner, intermediate, advanced
    var title : String
    var details : String
    var active: Bool
}


struct ExerciseDataManager{
    let exerciseMode : ExerciseMode
    let specialVerbType : SpecialVerbType
    let verbOrModelMode : LessonModelSpecialsMode
    let hasSimpleTenses : Bool
    var idNum = 0
    
    init(_ vomMode: LessonModelSpecialsMode, _ em : ExerciseMode, _ svt: SpecialVerbType, _ hasSimpleTenses: Bool){
        verbOrModelMode = vomMode
        exerciseMode = em
        specialVerbType = svt
        self.hasSimpleTenses = hasSimpleTenses
        
        loadData(svt: specialVerbType)
        //        print("Initializing ExerciseDataManager - \(exerciseMode.rawValue) mode, special verb type \(specialVerbType.rawValue)")
    }
    
    var dataArray = [ExerciseData]()
    
    func getExerciseMode()->ExerciseMode{
        return exerciseMode
    }
    
    mutating func setArray(_ ed: [ExerciseData]){
        dataArray = ed
    }
    
    func getArray()->[ExerciseData]{
        dataArray
    }
    
    func getActiveArray()->[ExerciseData]{
        var activeArray = [ExerciseData]()
        for d in dataArray{
            if d.active { activeArray.append(d)}
        }
        return activeArray
    }
    
    mutating func append(ed : ExerciseData){
        dataArray.append(ed)
    }
    
    
    func getActive(_ index: Int)->ExerciseData{
        let ar = getActiveArray()
        if index >= 0 && index < ar.count {
            return ar[index]
        }
        else {
            return ar[0]
        }
    }
    
    func get(_ index: Int)->ExerciseData{
        if index >= 0 && index < dataArray.count {
            return dataArray[index]
        }
        else {
            return dataArray[0]
        }
    }
    
    mutating func deactivate(_ index: Int){
        if index >= 0 && index < dataArray.count {
            dataArray[index].active = false
        }
    }
    
    mutating func loadData(svt: SpecialVerbType){
        switch exerciseMode{
        case .Select: loadSelectImages(verbOrModelMode: verbOrModelMode)
        case .Explore: loadExploreImages(svt: svt)
        case .Learn: loadLearnImages(svt: svt)
        case .Test:  loadTestImages()
        case .SelectModel: loadSelectImages(verbOrModelMode: verbOrModelMode)
        }
    }
    
    mutating func loadSelectImages(verbOrModelMode: LessonModelSpecialsMode){
        switch verbOrModelMode {
        case .lessonMode:
            let data = [
                ExerciseData(id: 0, image: "SELECTRealidades", studentLevel: "Beginner", title: "Spanish I Textbook", details: "Realidades 1 is a common text book used for first level Spanish.  Each exercise combines the verbs and tenses associated with a chapter section in Realidades.", active: true),
                
                ExerciseData(id: 1, image: "SELECTChallengingLessons", studentLevel: "Beginner", title: "Challenging Lessons", details: "Advanced lessons are a collection of verb/tenses to help you master verb conjugation", active: true),
                
                ExerciseData(id: 2, image: "SELECTShowCurrentVerbs", studentLevel: "All levels", title: "Show Current Verbs", details: "Current verbs are the verbs that are active for learning.", active: true)
            ]
            setArray(data)
        case .modelMode:
            let data = [
                ExerciseData(id: 0, image: "SELECTVerbModelList", studentLevel: "Intermediate", title: "Verb Model List", details: "Verb Models are a powerful way to learn how to conjugate ANY Spanish verb in any tense.", active: true),
                
                ExerciseData(id: 1, image: "SELECTVerbModels", studentLevel: "All levels", title: "Verb Models", details: "Verb Models are a powerful way to learn how to conjugate ANY Spanish verb in any tense.  This shows you one verb model at a time with each of its associated verbs.", active: true),
                
                ExerciseData(id: 2, image: "SELECTShowCurrentVerbs", studentLevel: "All levels", title: "Show Current Verbs", details: "Current verbs are the verbs that are active for learning.", active: true)
                ]
            setArray(data)
                
        case .specialsMode:
            let data = [
                ExerciseData(id: 0, image: "SELECTOptionsEggs", studentLevel: "Intermediate", title: "Extras", details: "These specials feature more advanced topics.", active: true),
                
                ExerciseData(id: 1, image: "SELECTShowCurrentVerbs", studentLevel: "All levels", title: "Show Current Verbs", details: "Current verbs are the verbs that are active for learning.", active: true)
            ]
            setArray(data)
        }
    }
    
    mutating func loadExploreImages(svt: SpecialVerbType){
        var idNum = 0
        var data = [ExerciseData]()
        
        switch svt{
        case .verbsLikeGustar:
            data = [
                ExerciseData(id: 0, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                
                ExerciseData(id: 1, image: "EXPLOREGustar", studentLevel: "Beginner", title: "Explore Verbs Like Gustar", details: "Verbs like gustar conjugate in the indirect sense.  Instead of 'I like ice cream', verbs like gustar conjugate more like 'ice cream is pleasing to me'", active: true)
            ]
        case .auxiliaryVerbsInfinitives:
            data = [
                ExerciseData(id: 0, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                
                ExerciseData(id: 1, image: "EXPLOREVerbMorphing", studentLevel: "All levels", title: "Verb Morphing", details: "Watch your verbs conjugated step-by-step.", active: true),
                
                ExerciseData(id: 2, image: "EXPLOREAuxiliary", studentLevel: "Beginner", title: "Explore Auxiliary Verbs", details: "Auxiliary verbs are used to create progressive and perfect tenses.  They are also combined with infinitives to create verb phrases, such as 'querer venir con'", active: true)
            ]
        case .auxiliaryVerbsGerunds:
            data = [
                ExerciseData(id: 0, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                
                ExerciseData(id: 1, image: "EXPLOREVerbMorphing", studentLevel: "All levels", title: "Verb Morphing", details: "Watch your verbs conjugated step-by-step.", active: true),
                
                ExerciseData(id: 2, image: "EXPLOREAuxiliary", studentLevel: "Beginner", title: "Explore Auxiliary Verbs", details: "Auxiliary verbs are used to create progressive and perfect tenses.  They are also combined with infinitives to create verb phrases, such as 'querer venir con'", active: true)
            ]
        default:
            if hasSimpleTenses{
                data = [
                    
                    ExerciseData(id: 0, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                    
                    ExerciseData(id: 1, image: "EXPLOREVerbMorphing", studentLevel: "All levels", title: "Verb Morphing", details: "Watch your verbs conjugated step-by-step.", active: true),
                    
                    ExerciseData(id: 2, image: "EXPLORENormal", studentLevel: "All levels", title: "Explore Normal Verbs", details: "Almost all Spanish verbs are 'normal'.  This means they follow the simple pattern of Subject-Verb.  This includes reflexive verbs and verb phrases.  Thus, 'darse con' is a normal verb.", active: true),
                    
                    ExerciseData(id: 3, image: "EXPLORE3Verbs", studentLevel: "Beginner", title: "3 Verbs View", details: "If your active verb list contains AR, ER and IR verbs, you can look at them together in 3 Verbs View.", active: true),
                    
                    ExerciseData(id: 4, image: "EXPLOREVerbCube", studentLevel: "Intermediate", title: "Verb Cube", details: "The Verb Cube allows you to look at your active verb list in 3-dimensions: Verb, Tense, and Person.", active: true),
                    
                    ExerciseData(id: 5, image: "EXPLORERightWrong", studentLevel: "All levels", title: "Right and Wrong", details: "Right and Wrong shows you the correct way a verb is conjugated next to the regular conjugation.  If they are different, the subject turns red.", active: true)
                    
                ]
            } else {
                data = [
                    
                    ExerciseData(id: 0, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                    
                    ExerciseData(id: 1, image: "EXPLOREVerbMorphing", studentLevel: "All levels", title: "Verb Morphing", details: "Watch your verbs conjugated step-by-step.", active: true),
                    
                    ExerciseData(id: 2, image: "EXPLORENormal", studentLevel: "All levels", title: "Explore Normal Verbs", details: "Almost all Spanish verbs are 'normal'.  This means they follow the simple pattern of Subject-Verb.  This includes reflexive verbs and verb phrases.  Thus, 'darse con' is a normal verb.", active: true),
                    
                    ExerciseData(id: 3, image: "EXPLORE3Verbs", studentLevel: "Beginner", title: "3 Verbs View", details: "If your active verb list contains AR, ER and IR verbs, you can look at them together in 3 Verbs View.", active: true),
                    
                    ExerciseData(id: 4, image: "EXPLORERightWrong", studentLevel: "All levels", title: "Right and Wrong", details: "Right and Wrong shows you the correct way a verb is conjugated next to the regular conjugation.  If they are different, the subject turns red.", active: true),
                    
                ]
            }
        }//switch svt
        setArray(data)
    }
    
    
    mutating func loadExploreImagesA(svt: SpecialVerbType){
        var idNum = 0
        var data = [ExerciseData]()
        
        if hasSimpleTenses{
            data = [
                ExerciseData(id: 0, image: "EXPLORE3Verbs", studentLevel: "Beginner", title: "3 Verbs View", details: "If your active verb list contains AR, ER and IR verbs, you can look at them together in 3 Verbs View.", active: true),
                
                ExerciseData(id: 1, image: "EXPLOREVerbCube", studentLevel: "Intermediate", title: "Verb Cube", details: "The Verb Cube allows you to look at your active verb list in 3-dimensions: Verb, Tense, and Person.", active: true),
                
                ExerciseData(id: 2, image: "EXPLORERightWrong", studentLevel: "All levels", title: "Right and Wrong", details: "Right and Wrong shows you the correct way a verb is conjugated next to the regular conjugation.  If they are different, the subject turns red.", active: true),
                
                ExerciseData(id: 3, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                
                ExerciseData(id: 4, image: "EXPLOREVerbMorphing", studentLevel: "All levels", title: "Verb Morphing", details: "Watch your verbs conjugated step-by-step.", active: true),
            ]
            idNum = 5
        } else {
            data = [
                ExerciseData(id: 0, image: "EXPLORE3Verbs", studentLevel: "Beginner", title: "3 Verbs View", details: "If your active verb list contains AR, ER and IR verbs, you can look at them together in 3 Verbs View.", active: true),
                
                ExerciseData(id: 1, image: "EXPLORERightWrong", studentLevel: "All levels", title: "Right and Wrong", details: "Right and Wrong shows you the correct way a verb is conjugated next to the regular conjugation.  If they are different, the subject turns red.", active: true),
                
                ExerciseData(id: 2, image: "EXPLOREVerbConjugation", studentLevel: "All levels", title: "Verb Conjugation", details: "This is the basic conjugation window for looking at your verbs, one at a time.  One tense at a time.  You can also go to the 'Show me this verb' and see conjugation one step at a time.", active: true),
                
                ExerciseData(id: 3, image: "EXPLOREVerbMorphing", studentLevel: "All levels", title: "Verb Morphing", details: "Watch your verbs conjugated step-by-step.", active: true),
            ]
            idNum = 4
        }
        switch svt{
        case .verbsLikeGustar: data.append(
            ExerciseData(id: idNum, image: "EXPLOREGustar", studentLevel: "Beginner", title: "Explore Verbs Like Gustar", details: "Verbs like gustar conjugate in the indirect sense.  Instead of 'I like ice cream', verbs like gustar conjugate more like 'ice cream is pleasing to me'", active: true)
        )
        case .auxiliaryVerbsInfinitives: data.append(
            ExerciseData(id: idNum, image: "EXPLOREAuxiliary", studentLevel: "Beginner", title: "Explore Auxiliary Verbs", details: "Auxiliary verbs are used to create progressive and perfect tenses.  They are also combined with infinitives to create verb phrases, such as 'querer venir con'", active: true)
        )
        default: data.append(
            ExerciseData(id: idNum, image: "EXPLORENormal", studentLevel: "All levels", title: "Explore Normal Verbs", details: "Almost all Spanish verbs are 'normal'.  This means they follow the simple pattern of Subject-Verb.  This includes reflexive verbs and verb phrases.  Thus, 'darse con' is a normal verb.", active: true)
        )
        } //end of switch
        setArray(data)
    }
    
    mutating func loadLearnImages(svt: SpecialVerbType){
        var data = [ExerciseData]()
        if hasSimpleTenses && svt == SpecialVerbType.normal {
            data = [
                ExerciseData(id: 0, image: "LEARNMixAndMatch", studentLevel: "Beginner", title: "Mix and Match", details: "Mix and Match is an exercise for interactively combining a random set of subjects with the correct verb forms for a given tense.", active: true),
                
                ExerciseData(id: 1, image: "LEARNDragAndDrop", studentLevel: "Intermediate", title: "Drag and Drop", details: "In Drag and Drop you drag the correct conjugated verb form from the box below onto the correct subject in the box above.", active: true),
                
                ExerciseData(id: 2, image: "LEARNSubjectVerb", studentLevel: "All levels", title: "Subject vs Verb", details: "You are presented with a subject, such as 'nosotros'.  To the right are words or phrases showing all the conjugated forms for the current tense.", active: true),
                
                ExerciseData(id: 3, image: "LEARNSubjectTense", studentLevel: "All levels", title: "Subject vs Tense", details: "You are presented with a subject, such as 'ellos'.  To the right are words or phrases showing all the conjugated forms for 'ellos' in all of the simple tenses.", active: true),
                
                ExerciseData(id: 4, image: "LEARNFlashCards", studentLevel: "Beginner", title: "Flash Cards", details: "Timed exercise.  Your current verbs and tenses are presented to you randomly one phrase at a time.  If you know the answer, push the card to the right.  To see the answer, click on the card.  If you don't know the answer, push the card to the left.", active: true)
            ]
        } else {
            data = [
                ExerciseData(id: 0, image: "LEARNMixAndMatch", studentLevel: "Beginner", title: "Mix and Match", details: "Mix and Match is an exercise for interactively combining a random set of subjects with the correct verb forms for a given tense.", active: true),
                
                ExerciseData(id: 1, image: "LEARNSubjectVerb", studentLevel: "All levels", title: "Subject vs Verb", details: "You are presented with a subject, such as 'nosotros'.  To the right are words or phrases showing all the conjugated forms for the current tense.", active: true),
                
                ExerciseData(id: 2, image: "LEARNSubjectTense", studentLevel: "All levels", title: "Subject vs Tense", details: "You are presented with a subject, such as 'ellos'.  To the right are words or phrases showing all the conjugated forms for 'ellos' in all of the simple tenses.", active: true),
                
                ExerciseData(id: 3, image: "LEARNFlashCards", studentLevel: "Beginner", title: "Flash Cards", details: "Timed exercise.  Your current verbs and tenses are presented to you randomly one phrase at a time.  If you know the answer, push the card to the right.  To see the answer, click on the card.  If you don't know the answer, push the card to the left.", active: true)
            ]
        }
    
    setArray(data)
}

mutating func loadTestImages(){
    let data = [
        ExerciseData(id: 1, image: "TESTMultiple", studentLevel: "Beginner", title: "Multiple Choice Test", details: "You must push a button with the correct answer for each.  Answer 8 out of 10 correctly to pass.", active: true),
        
        ExerciseData(id: 2, image: "TESTFillInBlanks", studentLevel: "Intermediate", title: "Fill-in Blanks Test", details: "You must type in the correct answer for each problem.  Answer 8 out of 10 correctly to pass.", active: true),
    ]
    setArray(data)
}
}

