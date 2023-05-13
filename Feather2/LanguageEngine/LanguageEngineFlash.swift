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
    var residualPhrase = ""
    
    func appendAnswer(answer: String){
        self.answer.append(answer)
    }
    
    func getAnswer(index: Int)->String {
        if ( index >= 0 && index < answer.count ){
            return answer[index]
        }
        return ""
    }
    
    func getResidualPhrase()->String{
        residualPhrase
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
    
    func createProblemForThisTense(verb: Verb, tense: Tense, isMultipleChoiceProblem: Bool)->ProblemStruct{
        let probStruct = ProblemStruct()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
//        let dependentVerb = findVerbFromString(verbString: "comprar", language: getCurrentLanguage())
        let dependentVerb = Verb()
        var number = Number.singular
        personList.shuffle()
        let correctPerson = personList[0]
        personList.shuffle()
        
        let personString = getPersonString(personIndex: correctPerson.getIndex(), tense: tense, specialVerbType: specialVerbType, verbString: verb.getWordString())
        
        probStruct.personString = personString
        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(tense.rawValue), person: \(personString)"
        let dos = getDirectObjectStruct(specialVerbType: specialVerbType)
        let directObjectString = dos.objectString
        number = dos.objectNumber
        let gerundString = getGerundString(specialVerbType: specialVerbType)
        let infinitiveString = getInfinitiveString(specialVerbType: specialVerbType)
        
        createAndConjugateAgnosticVerb(verb: verb, tense: tense)
        for person in personList {
//            let verbString = createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
            var verbString = getVerbString(personIndex: person.getIndex(), number: number, tense: tense, specialVerbType: specialVerbType, verbString: verb.getWordString(), dependentVerb: dependentVerb, residualPhrase: "")
//            verbString = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: verbString)
            //only add extras if this is multiple choice
            //don't want this for fill-in the blanks
            if isMultipleChoiceProblem {
                switch specialVerbType{
                case .verbsLikeGustar:
                    verbString += directObjectString
                    probStruct.residualPhrase = directObjectString
                case .auxiliaryVerbsGerunds:
                    verbString += gerundString
                    probStruct.residualPhrase = gerundString
                case .auxiliaryVerbsInfinitives:
                    verbString += infinitiveString
                    probStruct.residualPhrase = infinitiveString
                default: break
                }
            }
            verbString = VerbUtilities().removeExtraBlanks(verbString: verbString)
            probStruct.appendAnswer(answer: verbString)
            probStruct.person = correctPerson
            if person == correctPerson {
                probStruct.correctAnswer = verbString
            }
        }
        return probStruct
    }
    
    
    //not happy with shuffle
    
    func createProblemForThisPerson(verb: Verb, person: Person, isMultipleChoiceProblem: Bool)->ProblemStruct{
        let probStruct = ProblemStruct()
        
        if tenseList.count == 0 {
            tenseList.append(.present)
        }
        
        let correctTense = tenseList.randomElement()
        
        //        let dependentVerb = findVerbFromString(verbString: "comprar", language: getCurrentLanguage())
        let dependentVerb = Verb()
        var number = Number.singular
        
//        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(correctTense.rawValue), person: \(person.getMaleString())"
        
        let personString = getPersonString(personIndex: person.getIndex(), tense: correctTense ?? .present, specialVerbType: specialVerbType, verbString: verb.getWordString())
        probStruct.personString = personString
        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(correctTense?.rawValue ?? Tense.present.rawValue), person: \(personString))"
        
        let localTenseList = tenseList.shuffled()
        let dos = getDirectObjectStruct(specialVerbType: specialVerbType)
        let directObjectString = dos.objectString
        number = dos.objectNumber
        let gerundString = getGerundString(specialVerbType: specialVerbType)
        let infinitiveString = getInfinitiveString(specialVerbType: specialVerbType)
        
        for tense in localTenseList {
            createAndConjugateAgnosticVerb(verb: verb, tense: tense)
            var verbString = getVerbString(personIndex: person.getIndex(), number: number, tense: tense, specialVerbType: specialVerbType, verbString: verb.getWordString(), dependentVerb: dependentVerb, residualPhrase: "")
            //only add extras if this is multiple choice
            //don't want this for fill-in the blanksif isMultipleChoiceProblem {
            if isMultipleChoiceProblem {
                switch specialVerbType{
                case .verbsLikeGustar:
                    verbString += directObjectString
                    probStruct.residualPhrase = directObjectString
                case .auxiliaryVerbsGerunds:
                    verbString += gerundString
                    probStruct.residualPhrase = gerundString
                case .auxiliaryVerbsInfinitives:
                    verbString += infinitiveString
                    probStruct.residualPhrase = infinitiveString
                default: break
                }
            }
            verbString = VerbUtilities().removeExtraBlanks(verbString: verbString)
            probStruct.appendAnswer(answer: verbString)
            probStruct.tense = correctTense ?? Tense.present
            if tense == correctTense {
                probStruct.correctAnswer = verbString
            }
        }
        return probStruct
    }
    
    enum ProblemTypeEnum {
        case Tense, Person
    }
    
    func fillFilezillaFlashCards(maxCount: Int)->[FilezillaCard]{
        switch getSpecialVerbType(){
        case .normal, .verbsLikeGustar, .auxiliaryVerbsGerunds, .auxiliaryVerbsInfinitives:
            return fillFilezillaFlashCardsWithProblemsOfMixedRandomTenseAndPerson(maxCount: maxCount)
        default:
            return fillFilezillaFlashCardsForDefectiveVerb(maxCount: maxCount)
        }
    }
    func fillFilezillaFlashCardsForDefectiveVerb(maxCount: Int)->[FilezillaCard]{
        var filezillaCardList = [FilezillaCard]()
        var tenseList = getTenseList()
        var personList = [Person.S3, .P3]
        
        personList.shuffle()
        var person = personList[0]
        if getSpecialVerbType() == .weatherAndTime { person = .S3 }
        var ps = ProblemStruct()
        for _ in 0 ..< maxCount {
            verbList.shuffle()
            let verb = filteredVerbList.randomElement()
            ps = createProblemForThisPerson(verb: verb!, person: person, isMultipleChoiceProblem: true)
            if getSpecialVerbType() == .weatherAndTime {
                filezillaCardList.append(FilezillaCard(prompt: "\nVerb: \(verb!.getWordAtLanguage(language: getCurrentLanguage())) \(ps.residualPhrase)  \n\(ps.tense.rawValue) tense", answer: ps.correctAnswer))
            } else {
                filezillaCardList.append(FilezillaCard(prompt: "\nVerb: \(verb!.getWordAtLanguage(language: getCurrentLanguage())) \(ps.residualPhrase)  \n\(ps.tense.rawValue) tense \n\(ps.personString) ____________ ", answer: ps.correctAnswer))
            }
            if filezillaCardList.count > maxCount {
                break
            }
        }
        return filezillaCardList
    }
    
    func fillFilezillaFlashCardsWithProblemsOfMixedRandomTenseAndPerson(maxCount: Int)->[FilezillaCard]{
        var filezillaCardList = [FilezillaCard]()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
//        verbList.shuffle()
        tenseList.shuffle()
        let personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
        var personCount = 0
        var tenseCount = 0
        var personString = ""
        var tenseString = ""
        var ps = ProblemStruct()

        for _ in 0 ..< maxCount {
            verbList.shuffle()
            let verb = verbList.randomElement()
            let problemType = problemList.randomElement()!
            switch problemType{
            case .Person:
                personCount += 1
                let targetPerson = personList.randomElement()!
                ps = createProblemForThisPerson(verb: verb!, person: targetPerson, isMultipleChoiceProblem: true)
                personString = ps.personString
                tenseString = ps.tense.rawValue
            case .Tense:
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                ps = createProblemForThisTense(verb: verb!, tense: targetTense, isMultipleChoiceProblem: true)
                personString = ps.personString
                tenseString = targetTense.rawValue
            }
        
            filezillaCardList.append(FilezillaCard(prompt: "\nVerb: \(verb!.getWordAtLanguage(language: getCurrentLanguage())) \(ps.residualPhrase)  \n\(tenseString) tense  \n\(personString) ____________ ", answer: ps.correctAnswer))
            
            if filezillaCardList.count > maxCount {
                break
            }
        }
        
        return filezillaCardList
    }
    
    func fillFlashCardsForProblemsOfCurrentTenseAndRandomPerson(isMultipleChoiceProblem: Bool){
        flashCardMgr.clearAll()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
        var personCount = 0
        var tenseCount = 0
//        let dos = getDirectObjectStruct(specialVerbType: getSpecialVerbType())
//        let directObjectString = dos.objectString
//        var number = dos.objectNumber
//        var gerundString = getGerundString(specialVerbType: getSpecialVerbType())
//        var infinitiveString = getInfinitiveString(specialVerbType: getSpecialVerbType())
        
        for _ in verbList {
            var randomVerb = verbList.randomElement()!
            let problemType = problemList.randomElement()!
            switch problemType{
            case .Person:
                personCount += 1
                let targetPerson = personList.randomElement()!
                let ps = createProblemForThisPerson(verb: randomVerb, person: targetPerson, isMultipleChoiceProblem: isMultipleChoiceProblem)
                flashCardMgr.addFlashCard( fcp: FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson, personString: ps.personString,
                                                          answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                                          answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                                          answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                                          correctAnswer: ps.correctAnswer, question: ps.question))
                
            case .Tense:
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                let ps = createProblemForThisTense(verb: randomVerb, tense: targetTense, isMultipleChoiceProblem: isMultipleChoiceProblem)
                flashCardMgr.addFlashCard( fcp: FlashCard(verb: randomVerb, tense: targetTense, person: ps.person, personString: ps.personString,
                                                          answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                                          answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                                          answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                                          correctAnswer: ps.correctAnswer, question: ps.question))
           
            }
            
        }
        print("personCount = \(personCount), tenseCount = \(tenseCount)")
    }
    
    func fillSingleFlashCard(isMultipleChoiceProblem: Bool)->FlashCard{
        switch getSpecialVerbType(){
        case .normal, .verbsLikeGustar, .auxiliaryVerbsGerunds, .auxiliaryVerbsInfinitives:
            return fillSingleFlashCardForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: isMultipleChoiceProblem)
        default:
            return fillSingleFlashCardForDefectiveVerb(isMultipleChoiceProblem: isMultipleChoiceProblem)
        }
    }
    
    func fillSingleFlashCardForDefectiveVerb(isMultipleChoiceProblem: Bool)->FlashCard{
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S3, .P3]
        personList.shuffle()
        var person = personList[0]
        if getSpecialVerbType() == .weatherAndTime { person = .S3 }
        
        var personCount = 0
        var tenseCount = 0
        var fcp = FlashCard()
        let randomVerb = verbList.randomElement()!
        let targetPerson = personList.randomElement()!
        let ps = createProblemForThisPerson(verb: randomVerb, person: targetPerson, isMultipleChoiceProblem: isMultipleChoiceProblem)
        
        
        if getSpecialVerbType() == .weatherAndTime {
            fcp = FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson,
                            personString: "",
                            answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                            answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                            answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                            correctAnswer: ps.correctAnswer, question: ps.question)
        } else {
            fcp = FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson,
                            personString: ps.personString,
                            answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                            answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                            answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                            correctAnswer: ps.correctAnswer, question: ps.question)
        }
            
        return fcp
    }
    

    func fillSingleFlashCardForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: Bool)->FlashCard{
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
   
        var personCount = 0
        var tenseCount = 0
        
        verbList.shuffle()
        var fcp = FlashCard()
        let randomVerb = verbList.randomElement()!
        var problemType = problemList.randomElement()!
        if tenseList.count < 5 { problemType = .Tense}
        switch problemType{
        case .Person:
            personCount += 1
            let targetPerson = personList.randomElement()!
            let ps = createProblemForThisPerson(verb: randomVerb, person: targetPerson, isMultipleChoiceProblem: isMultipleChoiceProblem)
            fcp = FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson,
                                personString: ps.personString,
                                answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                correctAnswer: ps.correctAnswer, question: ps.question)
            
        case .Tense:
            tenseCount += 1
            let targetTense = tenseList.randomElement()!
            let ps = createProblemForThisTense(verb: randomVerb, tense: targetTense, isMultipleChoiceProblem: isMultipleChoiceProblem)
            fcp = FlashCard(verb: randomVerb, tense: targetTense, person: ps.person,
                                personString: ps.personString,
                                answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                correctAnswer: ps.correctAnswer, question: ps.question)
        }
        return fcp
    }
    
    func fillFlashCardsForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: Bool){
        flashCardMgr.clearAll()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        let problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
   
        var personCount = 0
        var tenseCount = 0
        
        verbList.shuffle()
        for _ in 0 ..< 10 {
            let randomVerb = verbList.randomElement()!
            var problemType = problemList.randomElement()!
            if tenseList.count < 5 { problemType = .Tense}
            switch problemType{
            case .Person:
                personCount += 1
                let targetPerson = personList.randomElement()!
                let ps = createProblemForThisPerson(verb: randomVerb, person: targetPerson, isMultipleChoiceProblem: isMultipleChoiceProblem)
                var fcp = FlashCard(verb: randomVerb, tense: ps.tense, person: targetPerson,
                                    personString: ps.personString,
                                    answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                    answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                    answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                    correctAnswer: ps.correctAnswer, question: ps.question)
                
                flashCardMgr.addFlashCard( fcp: fcp)
//                if i<5 {
//                    print("\nFlashCard dump - random person")
//                    dumpFlashCard(fcp)
//                }
                
            case .Tense:
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                let ps = createProblemForThisTense(verb: randomVerb, tense: targetTense, isMultipleChoiceProblem: isMultipleChoiceProblem)
                var fcp = FlashCard(verb: randomVerb, tense: targetTense, person: ps.person,
                                    personString: ps.personString,
                                         answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                         answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                         answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                         correctAnswer: ps.correctAnswer, question: ps.question)
                flashCardMgr.addFlashCard( fcp: fcp)
//                if i<5 {
//                    print("\nFlashCard dump - random tense")
//                    dumpFlashCard(fcp)
//                }
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
