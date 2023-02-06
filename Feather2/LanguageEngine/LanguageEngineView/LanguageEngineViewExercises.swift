//
//  LanguageEngineExercises.swift
//  Feather2
//
//  Created by Charles Diggins on 2/2/23.
//

import Foundation

import Foundation
import JumpLinguaHelpers

extension LanguageViewModel{
    
    func setCurrentExerciseMode(mode: ExerciseMode){
        languageEngine.currentExerciseMode = mode
    }
    
    func setCurrentExerciseIndex(index: Int){
        languageEngine.currentExerciseIndex = index
    }
    
    func getCurrentExerciseMode()->ExerciseMode{
        languageEngine.currentExerciseMode
    }
    
    func getCurrentExerciseIndex()->Int{
        languageEngine.currentExerciseIndex
    }
    
    func setCurrentExercise(exercise: ExerciseData){
        languageEngine.currentExercise = exercise
    }
    
    func getCurrentExercise()->ExerciseData{
        languageEngine.currentExercise
    }
}
