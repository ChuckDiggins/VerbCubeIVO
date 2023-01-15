//
//  LanguageEngineStudentLevel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/7/22.
//

import Foundation
import JumpLinguaHelpers

class ProblemStruct {
    var person = Person.S1
    var tense = Tense.present
    var personString = ""
    var answer = [String]()
    var question = ""
    var correctAnswer = ""
    
    func appendAnswer(answer: String){
        self.answer.append(answer)
    }
    
    func getAnswer(index: Int)->String {
        if ( index >= 0 && index < answer.count ){
            return answer[index]
        }
        return ""
    }
    
}
    

extension LanguageEngine{
    
    func incrementStudentCorrectScore(verb: Verb, tense: Tense, person: Person){
        getStudentScoreModel().incrementVerbScore(value: verb, correctScore: 1, wrongScore: 0)
        getStudentScoreModel().incrementTenseScore(value: tense, correctScore: 1, wrongScore: 0)
        getStudentScoreModel().incrementPersonScore(value: person, correctScore: 1, wrongScore: 0)
    }
    
    func incrementStudentWrongScore(verb: Verb, tense: Tense, person: Person){
        getStudentScoreModel().incrementVerbScore(value: verb, correctScore: 0, wrongScore: 1)
        getStudentScoreModel().incrementTenseScore(value: tense, correctScore: 0, wrongScore: 1)
        getStudentScoreModel().incrementPersonScore(value: person, correctScore: 0, wrongScore: 1)
    }
    
    func createProblemForThisTense(verb: Verb, tense: Tense)->ProblemStruct{
        let probStruct = ProblemStruct()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
//        let dependentVerb = findVerbFromString(verbString: "comprar", language: getCurrentLanguage())
        let dependentVerb = Verb()
        let number = Number.singular
        personList.shuffle()
        let correctPerson = personList[0]
        personList.shuffle()
        
        let personString = getPersonString(personIndex: correctPerson.getIndex(), tense: tense, specialVerbType: specialVerbType, verbString: verb.getWordString())
        
        probStruct.personString = personString
        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(tense.rawValue), person: \(personString)"
        
        createAndConjugateAgnosticVerb(verb: verb, tense: tense)
        for person in personList {
//            let verbString = createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
            let verbString = getVerbString(personIndex: person.getIndex(), number: number, tense: tense, specialVerbType: specialVerbType, verbString: verb.getWordString(), dependentVerb: dependentVerb, residualPhrase: "")
            probStruct.appendAnswer(answer: verbString)
            probStruct.person = correctPerson
            if person == correctPerson {
                probStruct.correctAnswer = verbString
            }
        }
        return probStruct
    }
    
    func createProblemForThisPerson(verb: Verb, person: Person)->ProblemStruct{
        let probStruct = ProblemStruct()
        var localTenseList = tenseList
        localTenseList.shuffle()
        let correctTense = tenseList[0]
        localTenseList.shuffle()
        //        let dependentVerb = findVerbFromString(verbString: "comprar", language: getCurrentLanguage())
        let dependentVerb = Verb()
        let number = Number.singular
        
//        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(correctTense.rawValue), person: \(person.getMaleString())"
        
        let personString = getPersonString(personIndex: person.getIndex(), tense: correctTense, specialVerbType: specialVerbType, verbString: verb.getWordString())
        probStruct.personString = personString
        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(correctTense.rawValue), person: \(personString))"
        
        
        for tense in localTenseList {
            createAndConjugateAgnosticVerb(verb: verb, tense: tense)
            let verbString = getVerbString(personIndex: person.getIndex(), number: number, tense: tense, specialVerbType: specialVerbType, verbString: verb.getWordString(), dependentVerb: dependentVerb, residualPhrase: "")
//            let verbString = createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
            probStruct.appendAnswer(answer: verbString)
            probStruct.tense = correctTense
            if tense == correctTense {
                probStruct.correctAnswer = verbString
            }
        }
        return probStruct
    }
    
    enum ProblemTypeEnum {
        case Tense, Person
    }
    
    func fillFilezillaFlashCardsWithProblemsOfMixedRandomTenseAndPerson(maxCount: Int)->[FilezillaCard]{
        var filezillaCardList = [FilezillaCard]()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
        
        
        var personCount = 0
        var tenseCount = 0
        var personString = ""
        var tenseString = ""
        var ps = ProblemStruct()
        
        for _ in 0 ..< maxCount {
            verbList.shuffle()
            var verb = verbList.randomElement()
            
            let problemType = problemList.randomElement()!
            switch problemType{
            case .Person:
                
                personCount += 1
                let targetPerson = personList.randomElement()!
                ps = createProblemForThisPerson(verb: verb!, person: targetPerson)
                personString = ps.personString
                tenseString = ps.tense.rawValue
                if ps.tense == .presentSubjunctive { personString = "que " + personString}
            case .Tense:
                
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                createAndConjugateAgnosticVerb(verb: verb!, tense: targetTense)
                ps = createProblemForThisTense(verb: verb!, tense: targetTense)
                personString = ps.personString
                if targetTense == .presentSubjunctive { personString = "que " + personString}
                tenseString = targetTense.rawValue
            }
            filezillaCardList.append(FilezillaCard(prompt: "\nVerb: \(verb!.getWordAtLanguage(language: getCurrentLanguage())) \n\(tenseString) tense  \n\(personString) ____________ ", answer: ps.correctAnswer))
            
            if verbList.count > maxCount {
                break
            }
            
        }
        
        return filezillaCardList
    }
    
    func fillFlashCardsForProblemsOfCurrentTenseAndRandomPerson(){
        flashCardMgr.clearAll()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
        let maxCardCount = 30
        
        
        var personCount = 0
        var tenseCount = 0
        
        for _ in verbList {
            var randomVerb = verbList.randomElement()!
            let problemType = problemList.randomElement()!
            switch problemType{
            case .Person:
                personCount += 1
                let targetPerson = personList.randomElement()!
                let ps = createProblemForThisPerson(verb: randomVerb, person: targetPerson)
                flashCardMgr.addFlashCard( fcp: FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson, personString: ps.personString,
                                                          answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                                          answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                                          answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                                          correctAnswer: ps.correctAnswer, question: ps.question))
                
            case .Tense:
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                let ps = createProblemForThisTense(verb: randomVerb, tense: targetTense)
                flashCardMgr.addFlashCard( fcp: FlashCard(verb: randomVerb, tense: targetTense, person: ps.person, personString: ps.personString,
                                                          answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                                          answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                                          answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                                          correctAnswer: ps.correctAnswer, question: ps.question))
           
            }
            
        }
        print("personCount = \(personCount), tenseCount = \(tenseCount)")
    }
    
    func fillFlashCardsForProblemsOfMixedRandomTenseAndPerson(){
        flashCardMgr.clearAll()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
        let maxCardCount = 30
        
        
        var personCount = 0
        var tenseCount = 0
        
        verbList.shuffle()
        for i in 0 ..< 10 {
            let randomVerb = verbList.randomElement()!
            var problemType = problemList.randomElement()!
            if tenseList.count < 5 { problemType = .Tense}
            switch problemType{
            case .Person:
                personCount += 1
                let targetPerson = personList.randomElement()!
                let ps = createProblemForThisPerson(verb: randomVerb, person: targetPerson)
                var fcp = FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson,
                                    personString: ps.personString,
                                    answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                    answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                    answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                    correctAnswer: ps.correctAnswer, question: ps.question)
                
                flashCardMgr.addFlashCard( fcp: fcp)
                if i<5 {
                    print("\nFlashCard dump - random person")
                    dumpFlashCard(fcp)
                }
                
            case .Tense:
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                let ps = createProblemForThisTense(verb: randomVerb, tense: targetTense)
                var fcp = FlashCard(verb: randomVerb, tense: targetTense, person: ps.person,
                                    personString: ps.personString,
                                         answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                         answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                         answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                         correctAnswer: ps.correctAnswer, question: ps.question)
                flashCardMgr.addFlashCard( fcp: fcp)
                if i<5 {
                    print("\nFlashCard dump - random tense")
                    dumpFlashCard(fcp)

                }
            }
        }
    }
    
    func dumpFlashCard(_ fcp: FlashCard){
        print("dumpFlashCard")
        print("personString \(fcp.personString)")
        print("verb: \(fcp.verb.getWordAtLanguage(language: getCurrentLanguage())), \(fcp.tense.rawValue), \(fcp.person.rawValue)")
        print("answers: \(fcp.getAnswer(i:0)), \(fcp.getAnswer(i:2)), \(fcp.getAnswer(i:3)), \(fcp.getAnswer(i:4)), \(fcp.getAnswer(i:5))")
        print("question: \(fcp.question), correctAnswer: \(fcp.correctAnswer)")
    }

////    func fillFlashCardsForProblemsOfRandomTense(){
////        flashCardMgr.clearAll()
////        var tenseList = getTenseList()
////        var verbList = getFilteredVerbs()
////        verbList.shuffle()
////        tenseList.shuffle()
////
////        for verb in verbList {
////            let targetTense = tenseList.randomElement()!
////            let ps = createProblemForThisTense(verb: verb, tense: targetTense)
////            flashCardMgr.addFlashCard( fcp: FlashCard(verb: verb, tense: targetTense, person: ps.person,
////                                                      answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
////                                                      answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
////                                                      answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
////                                                      correctAnswer: ps.correctAnswer, question: ps.question))
////        }
////    }
////
////    func fillFlashCardsForProblemsOfRandomPerson(){
////        flashCardMgr.clearAll()
////        var verbList = getFilteredVerbs()
////        verbList.shuffle()
////        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
////        personList.shuffle()
////
////        for verb in verbList {
////            let targetPerson = personList.randomElement()!
////            let ps = createProblemForThisPerson(verb: verb, person: targetPerson)
////            flashCardMgr.addFlashCard( fcp: FlashCard(verb: verb, tense: ps.tense, person: targetPerson,
////                                                      answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
////                                                      answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
////                                                      answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
////                                                      correctAnswer: ps.correctAnswer, question: ps.question))
////        }
////    }
    
    func setNextFlashCard(){
        flashCardMgr.setNextCard()
    }
    
    func getCurrentFlashCard()->FlashCard{
        flashCardMgr.getCurrentCard()
    }
    
    func incrementCorrectScore(){
        flashCardMgr.incrementCorrectScore()
    }
    
    func incrementWrongScore(){
        flashCardMgr.incrementWrongScore()
    }
    
    func resetScores(){
        flashCardMgr.resetScores()
    }
    
    func getWrongScore()->Int{
        flashCardMgr.getWrongScore()
    }
    
    func getCorrectScore()->Int{
        flashCardMgr.getCorrectScore()
    }
    
   
//    func getStudentLevel()->StudentLevel{
//        studentLevel
//    }
//    
//    func setLessonCompleted(sl: StudentLevel){
//        studentLevelCompletion.setLessonCompletionMode(sl: sl, lessonCompletionMode: .completed )
//        //set all previous lessoms completed
//        //set next level lessons open
//    }
//    
//    func setLessonCompletionMode(sl: StudentLevel, lessonCompletionMode: LessonCompletionMode){
//        studentLevelCompletion.setLessonCompletionMode(sl: sl, lessonCompletionMode: lessonCompletionMode )
//    }
//    
//    func getLessonCompletionMode(sl: StudentLevel)->LessonCompletionMode{
//        studentLevelCompletion.getLessonCompletionMode(sl: sl)
//    }
//    
}
