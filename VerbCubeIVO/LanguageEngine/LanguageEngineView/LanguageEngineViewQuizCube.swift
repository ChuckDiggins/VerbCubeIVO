//
//  LanguageEngineViewQuizCube.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import Foundation

import JumpLinguaHelpers

extension LanguageViewModel{
    func getQuizVerb(i: Int)->Verb{
        languageEngine.getQuizVerb(i: i)
    }
    
    func getQuizVerbs()->[Verb]{
        languageEngine.getQuizVerbs()
    }
    
    func getQuizCubeBlock()->[Verb]{
        languageEngine.getQuizCubeBlock()
    }
    
    func fillQuizCubeVerbList(){
        languageEngine.fillQuizCubeVerbList()
    }
    
    func fillQuizCubeBlock(){
        languageEngine.fillQuizCubeBlock()
    }
    
    func setQuizCubeDifficulty(qcd: QuizCubeDifficulty){
        languageEngine.setQuizCubeDifficulty(qcd:qcd)
    }
    
    func setQuizCubeVerb(verb: Verb){
        languageEngine.setQuizCubeVerb(verb: verb)
    }
    
    func getQuizCubeVerb()->Verb{
        languageEngine.getQuizCubeVerb()
    }
    
    func setQuizCubeTense(tense: Tense){
        languageEngine.setQuizCubeTense(tense: tense)
    }
    
    func getQuizCubeTense()->Tense{
        languageEngine.getQuizCubeTense()
    }
    
    func setQuizCubePerson(person: Person){
        languageEngine.setQuizCubePerson(person: person)
    }
    
    func getQuizCubePerson()->Person{
        languageEngine.getQuizCubePerson()
    }
    
    func getQuizCubeConfiguration()->ActiveVerbCubeConfiguration{
        languageEngine.getQuizCubeConfiguration()
    }
    
    func setQuizCubeConfiguration(config: ActiveVerbCubeConfiguration ){
        languageEngine.setQuizCubeConfiguration(config: config )
    }
    
    func getQuizTenseList()->[Tense]{
        languageEngine.getQuizTenseList()
    }
    
    func setQuizTenseList(list: [Tense]){
        languageEngine.setQuizTenseList(list: list)
    }
    
    func setQuizLevel(quizLevel: QuizCubeDifficulty){
        languageEngine.setQuizLevel(quizLevel: quizLevel)
    }
    
    func getQuizLevel()->QuizCubeDifficulty{
        languageEngine.getQuizLevel()
    }
    
    
}

