//
//  LanguageViewStudentLevel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/7/22.
//

import Foundation

import JumpLinguaHelpers

extension LanguageViewModel{
    
    func setStudentLevel(level: StudentLevel){
        languageEngine.setStudentLevel(level: level)
    }
    
    func getStudentLevel()->StudentLevel{
        languageEngine.getStudentLevel()
    }
    
//    func fillLevel1VerbLists(){
//        languageEngine.fillLevel1VerbLists()
//    }
//
//    func getLevel1VerbList(index: Int)->[Verb]{
//        languageEngine.getLevel1VerbList(index: index)
//    }
//    
    func setLessonCompletionMode(sl: StudentLevel, lessonCompletionMode: LessonCompletionMode){
        languageEngine.setLessonCompletionMode(sl: sl, lessonCompletionMode: lessonCompletionMode)
    }
    
    func getLessonCompletionMode(sl: StudentLevel)->LessonCompletionMode{
        languageEngine.getLessonCompletionMode(sl: sl)
    }
    
}
