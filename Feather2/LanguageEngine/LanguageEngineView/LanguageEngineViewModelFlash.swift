//
//  LanguageViewStudentLevel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/7/22.
//

import Foundation

import JumpLinguaHelpers

extension LanguageViewModel{
    
    func incrementStudentCorrectScore(verb: Verb, tense: Tense, person: Person){
        languageEngine.incrementStudentCorrectScore(verb: verb, tense: tense, person: person)
    }
    
    func incrementStudentWrongScore(verb: Verb, tense: Tense, person: Person){
        languageEngine.incrementStudentWrongScore(verb: verb, tense: tense, person: person)
    }
    
    func setNextFlashCard(){
        languageEngine.setNextFlashCard()
    }
    
    func fillFilezillaFlashCardsWithProblemsOfMixedRandomTenseAndPerson(maxCount: Int)->[FilezillaCard]{
        languageEngine.fillFilezillaFlashCardsWithProblemsOfMixedRandomTenseAndPerson(maxCount:maxCount)
    }
    
    func fillFlashCardsForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: Bool){
        languageEngine.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: isMultipleChoiceProblem)
    }

    func fillSingleFlashCardForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: Bool)->FlashCard{
        languageEngine.fillSingleFlashCardForProblemsOfMixedRandomTenseAndPerson(isMultipleChoiceProblem: isMultipleChoiceProblem)
    }


    func getCurrentFlashCard()->FlashCard{
        languageEngine.getCurrentFlashCard()
    }
    
    func incrementCorrectScore(){
        languageEngine.incrementCorrectScore()
    }
    
    func incrementWrongScore(){
        languageEngine.incrementWrongScore()
    }
    
    func resetScores(){
        languageEngine.resetScores()
    }
    
    func getWrongScore()->Int{
        languageEngine.getWrongScore()
    }
    
    func getCorrectScore()->Int{
        languageEngine.getCorrectScore()
    }
    
}
