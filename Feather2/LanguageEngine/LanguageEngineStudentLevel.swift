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
        personList.shuffle()
        let correctPerson = personList[0]
        personList.shuffle()
        
        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(tense.rawValue), person: \(correctPerson.getMaleString())"
        for person in personList {
            let verbString = createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
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
        
        probStruct.question = "Verb: \(verb.getWordAtLanguage(language: getCurrentLanguage())), tense: \(correctTense.rawValue), person: \(person.getMaleString())"
        
        for tense in localTenseList {
            let verbString = createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
            probStruct.appendAnswer(answer: verbString)
            probStruct.tense = correctTense
            if tense == correctTense {
                probStruct.correctAnswer = verbString
            }
        }
        return probStruct
    }
    
    func fillSimpleFlashCardProblem(){
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
        fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
    }
    
    enum ProblemTypeEnum {
        case Tense, Person
    }
    
    func fillFlashCardsForProblemsOfMixedRandomTenseAndPerson(){
        flashCardMgr.clearAll()
        var tenseList = getTenseList()
        var verbList = getFilteredVerbs()
        verbList.shuffle()
        tenseList.shuffle()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        
        var problemList = [ProblemTypeEnum.Tense, ProblemTypeEnum.Person]
        
        
        var personCount = 0
        var tenseCount = 0
        
        for verb in verbList {
            
            var problemType = problemList.randomElement()!
            switch problemType{
            case .Person:
                personCount += 1
                let targetPerson = personList.randomElement()!
                let ps = createProblemForThisPerson(verb: verb, person: targetPerson)
                flashCardMgr.addFlashCard( fcp: FlashCard(verb: verb, tense: ps.tense, person: targetPerson,
                                                          answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                                          answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                                          answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                                          correctAnswer: ps.correctAnswer, question: ps.question))
            case .Tense:
                tenseCount += 1
                let targetTense = tenseList.randomElement()!
                let ps = createProblemForThisTense(verb: verb, tense: targetTense)
                flashCardMgr.addFlashCard( fcp: FlashCard(verb: verb, tense: targetTense, person: ps.person,
                                                          answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
                                                          answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
                                                          answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
                                                          correctAnswer: ps.correctAnswer, question: ps.question))
           
            }
            
        }
        print("personCount = \(personCount), tenseCount = \(tenseCount)")
    }

//    func fillFlashCardsForProblemsOfRandomTense(){
//        flashCardMgr.clearAll()
//        var tenseList = getTenseList()
//        var verbList = getFilteredVerbs()
//        verbList.shuffle()
//        tenseList.shuffle()
//
//        for verb in verbList {
//            let targetTense = tenseList.randomElement()!
//            let ps = createProblemForThisTense(verb: verb, tense: targetTense)
//            flashCardMgr.addFlashCard( fcp: FlashCard(verb: verb, tense: targetTense, person: ps.person,
//                                                      answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
//                                                      answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
//                                                      answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
//                                                      correctAnswer: ps.correctAnswer, question: ps.question))
//        }
//    }
//
//    func fillFlashCardsForProblemsOfRandomPerson(){
//        flashCardMgr.clearAll()
//        var verbList = getFilteredVerbs()
//        verbList.shuffle()
//        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
//        personList.shuffle()
//
//        for verb in verbList {
//            let targetPerson = personList.randomElement()!
//            let ps = createProblemForThisPerson(verb: verb, person: targetPerson)
//            flashCardMgr.addFlashCard( fcp: FlashCard(verb: verb, tense: ps.tense, person: targetPerson,
//                                                      answer1: ps.getAnswer(index:0), answer2: ps.getAnswer(index:1),
//                                                      answer3: ps.getAnswer(index:2), answer4: ps.getAnswer(index:3),
//                                                      answer5: ps.getAnswer(index:4), answer6: ps.getAnswer(index:5),
//                                                      correctAnswer: ps.correctAnswer, question: ps.question))
//        }
//    }
    
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
    
    func setRegularVerbsAsCombinedModel(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setCriticalVerbsAsCombinedModel(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
   
    func setStudentLevel1001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.present]
    }
    
    func setStudentLevel1002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        
        tenseList = [Tense.present]
    }
    
    func setStudentLevel1003(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present]
    }
    
    func setStudentLevel1004(){
        clearFilteredVerbList()
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.preterite]
    }
    
    func setStudentLevel1005(){
        clearFilteredVerbList()
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.imperfect]
    }
    
    func setStudentLevel1006(){
        clearFilteredVerbList()
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.conditional, .future]
    }
    
    func setStudentLevel2001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel2002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel2003(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel2004(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel3001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.presentSubjunctive, Tense.imperfectSubjunctiveRA, Tense.imperfectSubjunctiveSE]
    }
    
    func setStudentLevel3002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.presentPerfect, Tense.pastPerfectSubjunctiveRA, Tense.pastPerfectSubjunctiveSE]
    }
    
    func setStudentLevel3003(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.imperative]
    }
    
    func setStudentLevel4001(){
        let stemChangingCommonSpanish = [SpecialPatternType.e2i, .e2ie, .i2í, .o2ue, .u2uy, .u2ú,]
       for pattern in stemChangingCommonSpanish{
           currentPatternList.append(pattern)
       }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel4002(){
        currentPatternList.removeAll()
        let orthoChangingCommonSpanish = [SpecialPatternType.a2aig, .c2zc, .c2z, .g2j, .gu2g,]
       for pattern in orthoChangingCommonSpanish{
           currentPatternList.append(pattern)
       }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel4003(){
        currentPatternList.removeAll()
        let stemChangingPreteriteSpanish = [SpecialPatternType.e2i, .o2u, .u2uy]
        for pattern in stemChangingPreteriteSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel4004(){
        currentPatternList.removeAll()
        let stemChangingUncommonSpanish = [SpecialPatternType.e2y, .e2ye, .i2ie, .o2u, .o2hue, .u2ue,]
        for pattern in stemChangingUncommonSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }

    
    func setStudentLevel4005(){
        currentPatternList.removeAll()
        let orthoChangingUncommonSpanish = [SpecialPatternType.cab2quep, .c2g, .c2qu, .c2zg, .ec2ig, .g2gu,
         .gu2gü, .l2lg, .o2oig, .n2ng, .qu2c, .z2c]
        for pattern in orthoChangingUncommonSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }

    func setStudentLevel4006(){
        currentPatternList.removeAll()
        let stemChangingUncommonSpanish = [SpecialPatternType.e2y, .e2ye, .i2ie, .o2u, .o2hue, .u2ue,]
        for pattern in stemChangingUncommonSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }

    
    func setStudentLevel5001(){
        clearFilteredVerbList()
        currentModelListAll.removeAll()
        loadCommonARModels()
        loadCommonERModels()
        loadCommonIRModels()
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
        currentModelListAll = modelListAR
    }
    
    func loadCommonARModels(){
        modelListAR.removeAll()
        modelListAR.append(getModelAtModelWord(modelWord: "airar"))
        modelListAR.append(getModelAtModelWord(modelWord: "encontrar"))
        modelListAR.append(getModelAtModelWord(modelWord: "enraizar"))
        modelListAR.append(getModelAtModelWord(modelWord: "regar"))
        modelListAR.append(getModelAtModelWord(modelWord: "sacar"))
        
        for model in modelListAR {
            appendToFilteredVerbList(verbList: findVerbsOfSameModel(targetID: model.id))
        }
        
    }
    
    func loadCommonERModels(){
        modelListER.removeAll()
        modelListER.append(getModelAtModelWord(modelWord: "parecer"))
        modelListER.append(getModelAtModelWord(modelWord: "defender"))
        modelListER.append(getModelAtModelWord(modelWord: "creer"))
        modelListER.append(getModelAtModelWord(modelWord: "coger"))
        modelListER.append(getModelAtModelWord(modelWord: "cocer"))
        modelListER.append(getModelAtModelWord(modelWord: "volver"))
        modelListER.append(getModelAtModelWord(modelWord: "mover"))
    }
    
    func loadCommonIRModels(){
        modelListIR.removeAll()
        modelListIR.append(getModelAtModelWord(modelWord: "adquirir"))
        modelListIR.append(getModelAtModelWord(modelWord: "dirigir"))
        modelListIR.append(getModelAtModelWord(modelWord: "influir"))
        modelListIR.append(getModelAtModelWord(modelWord: "lucir"))
        modelListIR.append(getModelAtModelWord(modelWord: "pedir"))
        modelListIR.append(getModelAtModelWord(modelWord: "predecir"))
        modelListIR.append(getModelAtModelWord(modelWord: "sentir"))
    }
    
    func setStudentLevel5002(){
        modelListAR.removeAll()
        modelListER.removeAll()
        modelListIR.removeAll()
        currentModelListAll.removeAll()
        modelListAR.append(getModelAtModelWord(modelWord: "dar"))
        modelListAR.append(getModelAtModelWord(modelWord: "estar"))
        modelListER.append(getModelAtModelWord(modelWord: "haber"))
        modelListER.append(getModelAtModelWord(modelWord: "hacer"))
        modelListIR.append(getModelAtModelWord(modelWord: "oír"))
        modelListER.append(getModelAtModelWord(modelWord: "oler"))
        modelListER.append(getModelAtModelWord(modelWord: "raer"))
        modelListIR.append(getModelAtModelWord(modelWord: "salir"))
        modelListER.append(getModelAtModelWord(modelWord: "ser"))
        modelListER.append(getModelAtModelWord(modelWord: "saber"))
        modelListER.append(getModelAtModelWord(modelWord: "tener"))
        modelListIR.append(getModelAtModelWord(modelWord: "venir"))
        modelListER.append(getModelAtModelWord(modelWord: "ver"))
        modelListIR.append(getModelAtModelWord(modelWord: "ir"))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]

        //create composite verb list since each model will only have a few verbs
        clearFilteredVerbList()
        for model in currentModelListAll {
            appendToFilteredVerbList(verbList: findVerbsOfSameModel(targetID: model.id))
        }
        
    }
    
    func setStudentLevel5003(){
        loadUncommonARModels()
        loadUncommonERModels()
        loadUncommonIRModels()
        
        //create  verb list since each model will only have a few verbs
        
        currentModelListAll.removeAll()
        clearFilteredVerbList()
        let model = modelListAR[0]
        appendToFilteredVerbList(verbList: findVerbsOfSameModel(targetID: model.id))

        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    //uncommon verb models
    
    func loadUncommonARModels(){
        modelListAR.removeAll()
        modelListAR.append(getModelAtModelWord(modelWord: "actuar"))
        modelListAR.append(getModelAtModelWord(modelWord: "ahincar"))
        modelListAR.append(getModelAtModelWord(modelWord: "airar"))
        modelListAR.append(getModelAtModelWord(modelWord: "andar"))
        modelListAR.append(getModelAtModelWord(modelWord: "aullar"))
        modelListAR.append(getModelAtModelWord(modelWord: "avergonzar"))
        modelListAR.append(getModelAtModelWord(modelWord: "colgar"))
        modelListAR.append(getModelAtModelWord(modelWord: "desosar"))
        modelListAR.append(getModelAtModelWord(modelWord: "empezar"))
        modelListAR.append(getModelAtModelWord(modelWord: "forzar"))
        modelListAR.append(getModelAtModelWord(modelWord: "guiar"))
        modelListAR.append(getModelAtModelWord(modelWord: "jugar"))
        modelListAR.append(getModelAtModelWord(modelWord: "pagar"))
        modelListAR.append(getModelAtModelWord(modelWord: "trocar"))
    }
    
    func loadUncommonERModels(){
        modelListER.removeAll()
        modelListER.append(getModelAtModelWord(modelWord: "caber"))
        modelListER.append(getModelAtModelWord(modelWord: "caer"))
        modelListER.append(getModelAtModelWord(modelWord: "mecer"))
        modelListER.append(getModelAtModelWord(modelWord: "placer"))
        modelListER.append(getModelAtModelWord(modelWord: "poder"))
        modelListER.append(getModelAtModelWord(modelWord: "querer"))
        modelListER.append(getModelAtModelWord(modelWord: "roer"))
        modelListER.append(getModelAtModelWord(modelWord: "satisfacer"))
        modelListER.append(getModelAtModelWord(modelWord: "tañer"))
        modelListER.append(getModelAtModelWord(modelWord: "traer"))
        modelListER.append(getModelAtModelWord(modelWord: "valer"))
        modelListER.append(getModelAtModelWord(modelWord: "yacer"))
    }
    
    func loadUncommonIRModels(){
        modelListIR.removeAll()
        modelListIR.append(getModelAtModelWord(modelWord: "adquirir"))
        modelListIR.append(getModelAtModelWord(modelWord: "asir"))
        modelListIR.append(getModelAtModelWord(modelWord: "bruñir"))
        modelListIR.append(getModelAtModelWord(modelWord: "decir"))
        modelListIR.append(getModelAtModelWord(modelWord: "delinquir"))
        modelListIR.append(getModelAtModelWord(modelWord: "discernir"))
        modelListIR.append(getModelAtModelWord(modelWord: "dormir"))
        modelListIR.append(getModelAtModelWord(modelWord: "elegir"))
        modelListIR.append(getModelAtModelWord(modelWord: "erguir"))
        modelListIR.append(getModelAtModelWord(modelWord: "pudrir"))
        modelListIR.append(getModelAtModelWord(modelWord: "podrir"))
        modelListIR.append(getModelAtModelWord(modelWord: "prohibir"))
        modelListIR.append(getModelAtModelWord(modelWord: "reñir"))
        modelListIR.append(getModelAtModelWord(modelWord: "reunir"))
        modelListIR.append(getModelAtModelWord(modelWord: "salir"))
        modelListIR.append(getModelAtModelWord(modelWord: "seguir"))
        modelListIR.append(getModelAtModelWord(modelWord: "zurcir"))
    }
    
    func setStudentLevel5004(){
        clearFilteredVerbList()
        filteredVerbList = verbList
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel5005(){
        clearFilteredVerbList()
        filteredVerbList = verbList
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel5006(){
        clearFilteredVerbList()
        filteredVerbList = verbList
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel6001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "atreverse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "referirse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acostarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "irse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sentirse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "darse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "quedarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ponerse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "imaginarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "llamarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacerse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "creerse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "verse", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel6002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "darse con", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel6003(){
    }
    
    func setStudentLevel6004(){
    }
    
    func setStudentLevel6005(){
    }

    func setStudentLevel(level: StudentLevel){
        studentLevel = level
        switch studentLevel {
        case .level1001:
            setStudentLevel1001()
        case .level1002:
            setStudentLevel1002()
        case .level1003:
            setStudentLevel1003()
        case .level1004:
            setStudentLevel1004()
        case .level1005:
            setStudentLevel1005()
        case .level1006:
            setStudentLevel1006()
        case .level2001:
            setStudentLevel2001()
        case .level2002:
            setStudentLevel2002()
        case .level3001:
            setStudentLevel3001()
        case .level3002:
            setStudentLevel3002()
        case .level3003:
            setStudentLevel3003()
        case .level4001:
            setStudentLevel4001()
        case .level4002:
            setStudentLevel4002()
        case .level4003:
            setStudentLevel4003()
        case .level5001:
            setStudentLevel5001()
        case .level5002:
            setStudentLevel5002()
        case .level5003:
            setStudentLevel5003()
        case .level5004:
            setStudentLevel5004()
        case .level6001:
            setStudentLevel6001()
        case .level6002:
            setStudentLevel6002()
        case .level6003:
            setStudentLevel6003()
        case .level6004:
            setStudentLevel6004()
        case .level6005:
            setStudentLevel6005()
        
        case .level2003:
            setStudentLevel2003()
        case .level2004:
            setStudentLevel2004()
        case .level4004:
            setStudentLevel4004()
        case .level4005:
            setStudentLevel4005()
        case .level4006:
            setStudentLevel4006()
        case .level5005:
            setStudentLevel5005()
        case .level5006:
            setStudentLevel5006()
        }
    }
    
    func getStudentLevel()->StudentLevel{
        studentLevel
    }
    
    func setLessonCompleted(sl: StudentLevel){
        studentLevelCompletion.setLessonCompletionMode(sl: sl, lessonCompletionMode: .completed )
        //set all previous lessoms completed
        //set next level lessons open
    }
    
    func setLessonCompletionMode(sl: StudentLevel, lessonCompletionMode: LessonCompletionMode){
        studentLevelCompletion.setLessonCompletionMode(sl: sl, lessonCompletionMode: lessonCompletionMode )
    }
    
    func getLessonCompletionMode(sl: StudentLevel)->LessonCompletionMode{
        studentLevelCompletion.getLessonCompletionMode(sl: sl)
    }
    
}
