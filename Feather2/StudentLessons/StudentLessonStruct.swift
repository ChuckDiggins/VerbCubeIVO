//
//  StudentLessonStruct.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/22/22.
//

import SwiftUI
import JumpLinguaHelpers

enum StudentLessonLevelEnum : String {
    case Beginnner, Intermediate, Advanced, SuperAdvanced
}

struct StudentLessonManager{
    @ObservedObject var languageViewModel: LanguageViewModel
    var studentName = "John"
    
    func createBeginnerLesson1()->StudentLessonStruct{

        var verbList = [Verb]()
        var tenseList = [Tense]()
         
        verbList.append(languageViewModel.findVerbFromString(verbString: "comprar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "vender", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "vivir", language: languageViewModel.getCurrentLanguage()))
        tenseList.append(Tense.present)
        
        return StudentLessonStruct(verbList: verbList, tenseList: tenseList)
    }
    
    func createBeginnerLesson2()->StudentLessonStruct{
        var verbList = [Verb]()
        var tenseList = [Tense]()
         
        verbList.append(languageViewModel.findVerbFromString(verbString: "estar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "ser", language: languageViewModel.getCurrentLanguage()))
        
        verbList.append(languageViewModel.findVerbFromString(verbString: "amar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "buscar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "comprar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "hablar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "pagar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "trabajar", language: languageViewModel.getCurrentLanguage()))
        
        verbList.append(languageViewModel.findVerbFromString(verbString: "aprender", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "comer", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "comprender", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "creer", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "romper", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "vender", language: languageViewModel.getCurrentLanguage()))
        
        verbList.append(languageViewModel.findVerbFromString(verbString: "abrir", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "decidir", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "escribir", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "recibir", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "sufrir", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "vivir", language: languageViewModel.getCurrentLanguage()))
        tenseList.append(Tense.present)
        
        return StudentLessonStruct(verbList: verbList, tenseList: tenseList)
    }
    
    func createBeginnerLesson3()->StudentLessonStruct{
        var verbList = [Verb]()
        var tenseList = [Tense]()
        
        verbList.append(languageViewModel.findVerbFromString(verbString: "estar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "ser", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "ir", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "hacer", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "tener", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "dar", language: languageViewModel.getCurrentLanguage()))
        verbList.append(languageViewModel.findVerbFromString(verbString: "oir", language: languageViewModel.getCurrentLanguage()))
        
        return StudentLessonStruct(verbList: verbList, tenseList: tenseList)
    }
}
    
struct StudentLessonStruct{
   
    var studentLessonLevel = StudentLessonLevelEnum.Beginnner
    var verbList : [Verb]
    var tenseList : [Tense]
    var isCompleted = false
    
    
}
