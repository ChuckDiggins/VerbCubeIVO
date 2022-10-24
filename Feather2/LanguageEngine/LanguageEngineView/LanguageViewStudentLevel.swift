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
    
    func setStudentLevel(level: StudentLevel){
        languageEngine.setStudentLevel(level: level)
    }
    
    func getStudentLevel()->StudentLevel{
        languageEngine.getStudentLevel()
    }
    
    func setLessonCompletionMode(sl: StudentLevel, lessonCompletionMode: LessonCompletionMode){
        languageEngine.setLessonCompletionMode(sl: sl, lessonCompletionMode: lessonCompletionMode)
    }
    
    func getLessonCompletionMode(sl: StudentLevel)->LessonCompletionMode{
        languageEngine.getLessonCompletionMode(sl: sl)
    }
    
    func setNextFlashCard(){
        languageEngine.setNextFlashCard()
    }
    
    func fillFlashCardsForProblemsOfMixedRandomTenseAndPerson(){
        languageEngine.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
    }
//    func fillFlashCardsForProblemsOfRandomTense(){
//        languageEngine.fillFlashCardsForProblemsOfRandomTense()
//    }
//    
//    func fillFlashCardsForProblemsOfRandomPerson(){
//        languageEngine.fillFlashCardsForProblemsOfRandomPerson()
//    }
    
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
