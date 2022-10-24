//
//  FlashCardManager.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/17/22.
//

import Foundation
import JumpLinguaHelpers

class FlashCard: ObservableObject {
    var verb : Verb
    var tense : Tense
    var person : Person
    
    var answer = [String]()
    var correctAnswer : String
    @Published var question: String
    
    init(){
        self.verb = Verb()
        self.tense = Tense.present
        self.person = Person.S1
        
        for i in 0..<5 {
            answer.append( "answer \(i)" )
        }
        self.correctAnswer = ""
        self.question = ""
    }
    
    init(verb: Verb, tense: Tense, person: Person,
        answer1: String, answer2: String, answer3: String,
         answer4: String, answer5: String, answer6: String,
         correctAnswer: String, question: String){
        self.verb = verb
        self.tense = tense
        self.person = person
        answer.append(answer1)
        answer.append(answer2)
        answer.append(answer3)
        answer.append(answer4)
        if answer5.count > 0 { answer.append(answer5) }
        if answer6.count > 0 { answer.append(answer6) }
        self.correctAnswer = correctAnswer
        self.question = "Conjugate \(verb.getWordAtLanguage(language: .Spanish)) for \(person.getMaleString()) in \(tense.rawValue) tense" //Spanish for now
    }
     
    func getVerbTensePerson()->(Verb, Tense, Person){
        return (verb, tense, person)
    }
    
    func isCorrectAnswer(ans: String)->Bool{
        if ans == correctAnswer { return true}
        return false
    }
    
    func getAnswerCount()->Int{
        answer.count
    }
    
    func getAnswer(i: Int)->String {
        if i >= 0 && i < answer.count {
            return answer[i]
        }
        return ""
    }
}

class FlashCardManager {
    var flashCardList = [FlashCard]()
    var currentCardIndex = 0
    var wrongScore = 0
    var correctScore = 0
    
    @Published var currentCard = FlashCard()
    
    func clearAll(){
        flashCardList.removeAll()
    }
    
    func incrementCorrectScore(){
        correctScore += 1
    }
    
    func incrementWrongScore(){
        wrongScore += 1
    }
    
    func resetScores(){
        correctScore = 0
        wrongScore = 0
    }
    
    func  getCorrectScore()->Int{
        correctScore
    }
    
    func  getWrongScore()->Int{
        wrongScore
    }
    
    func addFlashCard(fcp : FlashCard){
        flashCardList.append(fcp)
        currentCardIndex = flashCardList.count - 1
        currentCard = flashCardList[currentCardIndex]
    }
    
    func getCurrentCard()->FlashCard{
        currentCard
    }
    
    func setCurrentCard(index: Int){
        if index >= 0 && index < flashCardList.count {
            currentCardIndex = index
        }
        currentCard = flashCardList[currentCardIndex]
    }
    
    func setNextCard(){
        currentCardIndex += 1
        if currentCardIndex >= flashCardList.count {
            currentCardIndex = 0
        }
        currentCard = flashCardList[currentCardIndex]
    }
    
    func getNextCard()->FlashCard{
        setNextCard()
        return currentCard
    }
}
