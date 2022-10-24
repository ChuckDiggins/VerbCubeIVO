//
//  LanguageEngineQuizCube.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/5/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
    
    func getQuizVerb(i: Int)->Verb{
        if i < quizCubeVerbList.count && i >= 0 {
            return quizCubeVerbList[i]
        }
        return Verb()
    }
    
    func getQuizVerbs()->[Verb]{
        return quizCubeVerbList
    }
    
    func getQuizCubeBlock()->[Verb]{
        return quizCubeBlock
    }
    
    
    func fillQuizCubeVerbList(){
        quizCubeVerbList.removeAll()
        for verb in filteredVerbList {
            let bVerb = verb.getBVerb()
            if !bVerb.isPhrasalVerb(){
                quizCubeVerbList.append(verb)
                if quizCubeVerbList.count > 11 { break }
            }
        }
        quizCubeVerb = quizCubeVerbList[0]
    }
    
    func fillQuizCubeBlock(){
        quizCubeBlock.removeAll()
        for verb in filteredVerbList {
            let bVerb = verb.getBVerb()
            if !bVerb.isPhrasalVerb(){
                quizCubeBlock.append(verb)
                if quizCubeBlock.count > 4 { break }
            }
        }
    }
    
    func setQuizCubeDifficulty(qcd: QuizCubeDifficulty){
        quizCubeDifficulty = qcd
    }
    
    func setQuizCubeVerb(verb: Verb){
        quizCubeVerb = verb
    }
    
    func getQuizCubeVerb()->Verb{
        return quizCubeVerb
    }
    
    func setQuizCubeTense(tense: Tense){
        quizCubeTense = tense
    }
    
    func getQuizCubeTense()->Tense{
        return quizCubeTense
    }
    
    func setQuizCubePerson(person: Person){
        quizCubePerson = person
    }
    
    func getQuizCubePerson()->Person{
        return quizCubePerson
    }
    
    func getQuizCubeConfiguration()->ActiveVerbCubeConfiguration{
        return quizCubeConfiguration
    }
    
    func setQuizCubeConfiguration(config: ActiveVerbCubeConfiguration ){
        self.quizCubeConfiguration = config
    }
    
    func getQuizTenseList()->[Tense]{
        return quizTenseList
    }
    
    func setQuizTenseList(list: [Tense]){
        quizTenseList = list
    }
    
    func setQuizLevel(quizLevel: QuizCubeDifficulty){
        quizCubeDifficulty = quizLevel
    }
    
    func getQuizLevel()->QuizCubeDifficulty{
        return quizCubeDifficulty
    }
    
}
