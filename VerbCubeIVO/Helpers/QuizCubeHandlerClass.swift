//
//  QuizCubeHandlerClass.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/4/22.
//

import Foundation
import JumpLinguaHelpers
import Dot
import SwiftUI

class QuizCubeHandlerClass : ObservableObject {
//    @ObservedObject var languageEngine: LanguageEngine
    @ObservedObject var languageViewModel: LanguageViewModel
    var vcDimension1 = VerbCubeDimension.Person
    var vcDimension2 = VerbCubeDimension.Verb
    var vcCurrentDimension = VerbCubeDimension.Person
    var currentLanguage = LanguageType.Spanish
    var showStringArray = [[String]]()
    var quizCubeCellInfoArray = [[VerbCubeCellInfo]]()
    var isBlankArray = [[Bool]]()
    var cellDataArray = [[QuizCellData]]()
    private var headerStringList = [String]()
    var firstColumnStringList = [String]()
    var conjStringArrayDimension1 = 0
    var conjStringArrayDimension2 = 0
    var verbCount = 6
    var verticalSwipeDimension = VerbCubeDimension.Person
    var horizontalSwipeDimension = VerbCubeDimension.Person
    var cornerWord = ""
    private var currentShowVerbType = ShowVerbType.NONE
    var verbs = [Verb]()
    var tenses = [Tense.present, .preterite, .imperfect, .future, .conditional]
    var persons = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    var verbIndex = 0
    var diagnosticPrint = false
    
    init(languageViewModel: LanguageViewModel){
        self.languageViewModel = languageViewModel
        currentLanguage = .Spanish
        initializeQuizCube()
    }
    
    func initializeQuizCube(){
        currentLanguage = languageViewModel.getCurrentLanguage()
        setDimensions()
        verbs =  languageViewModel.getQuizCubeBlock()
        tenses = languageViewModel.getQuizTenseList()
        fillCellData()
//        fillQuizCorrectData()
    }
    
    func setDimensions(){
        let result = getVerbCubeDimensions(activeConfig: languageViewModel.getQuizCubeConfiguration())
        vcDimension1 = result.0
        vcDimension2 = result.1
        
        switch vcDimension1 {
        case .Person :
            conjStringArrayDimension1 = persons.count
            if vcDimension2 == .Tense {
                vcCurrentDimension = .Verb
                horizontalSwipeDimension = .Verb
                verticalSwipeDimension = .Verb
                conjStringArrayDimension2 = languageViewModel.getQuizTenseList().count
            }
            else if vcDimension2 == .Verb {
                conjStringArrayDimension2 = languageViewModel.getQuizCubeBlock().count
                vcCurrentDimension = .Tense
                horizontalSwipeDimension = .Tense
                verticalSwipeDimension = .Verb
            }
        case .Tense:
            conjStringArrayDimension1 = languageViewModel.getQuizTenseList().count
            if vcDimension2 == .Person {
                conjStringArrayDimension2 = 6
                vcCurrentDimension = .Verb
                horizontalSwipeDimension = .Verb
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Verb {
                conjStringArrayDimension2 = languageViewModel.getQuizCubeBlock().count
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        case .Verb:
            conjStringArrayDimension1 = languageViewModel.getQuizCubeBlock().count
            if vcDimension2 == .Person {
                conjStringArrayDimension2 = 6
                vcCurrentDimension = .Tense
                horizontalSwipeDimension = .Tense
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Tense {
                conjStringArrayDimension2 = languageViewModel.getQuizTenseList().count
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        }
//        print("setDimensions:  \(conjStringArrayDimension1) x \(conjStringArrayDimension2)")
    }
    
    func getCornerWord()->String{
        cornerWord
    }
    
    func getHeaderStringList()->[String]{
        return headerStringList
    }
    
    func getFirstColumnStringList()->[String]{
        return firstColumnStringList
    }
    
    func getFirstColumnStringValue(i: Int)->String{
        return firstColumnStringList[i]
    }
    
    func getConjugateString(i: Int, j: Int)->String{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
            let str = showStringArray[i][j]
            return str
        }
        return " ... "
    }
    
    func getCellData(i: Int, j: Int)->QuizCellData{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
            return cellDataArray[i][j]
        }
        return QuizCellData()
    }
    
    func getShowVerbType(i: Int, j: Int)->ShowVerbType{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
            return quizCubeCellInfoArray[i][j].showVerbType!
        }
        return .NONE
    }
    
    func getDimension3()->VerbCubeDimension{
        var d3 = VerbCubeDimension.Verb
        if vcDimension1 != .Verb && vcDimension2 != .Verb { d3 = .Verb }
        if vcDimension1 != .Tense && vcDimension2 != .Tense { d3 = .Tense }
        if vcDimension1 != .Person && vcDimension2 != .Person { d3 = .Person }
        return d3
    }
    
    func setShowVerbType(currentVerbType: ShowVerbType ){
        self.currentShowVerbType = currentVerbType
        fillCellData()
    }
    
    func getCurrentShowVerbType()->ShowVerbType{
        currentShowVerbType
    }
    
    func dumpVerbCubeCellInfo(){
        for i in 0 ..< conjStringArrayDimension1 {
            for j in 0 ..< conjStringArrayDimension2 {
                print("dumpVerbCubeCellInfo: quizCubeCellInfoArray[\(i)][\(j)] - verb \(quizCubeCellInfoArray[i][j].verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())), person: \(quizCubeCellInfoArray[i][j].person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)), tense: \(quizCubeCellInfoArray[i][j].tense.rawValue)")
            }
        }
    }
    
    func getVerbCubeCellInfo(i: Int, j: Int)->VerbCubeCellInfo{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
//            print("verbCubeCellInfoArray[\(i)][\(j)] - verb \(quizCubeCellInfoArray[i][j].verb.getWordAtLanguage(language: languageEngine.getCurrentLanguage())), person: \(quizCubeCellInfoArray[i][j].person.getMaleString()), tense: \(quizCubeCellInfoArray[i][j].tense.rawValue)")
            return quizCubeCellInfoArray[i][j]
        }
        return VerbCubeCellInfo()
    }
    
    func fillStringList(inputList: [String], vcd: VerbCubeDimension)->[String] {
        var list = inputList
        list.removeAll()
        switch vcd {
        case .Verb:
            for j in 0..<languageViewModel.getQuizCubeBlock().count {
                list.append(languageViewModel.getQuizCubeBlock()[j].getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))
            }
        case .Tense:
            for j in 0..<languageViewModel.getQuizTenseList().count {list.append(languageViewModel.getQuizTenseList()[j].rawValue)}
        case .Person:
            for j in 0..<persons.count { list.append(persons[j].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3))}
        }
        return list
    }
    
    func fillCornerWord(vcd: VerbCubeDimension)->String {
        var str = ""
        switch vcd {
        case .Verb:
            str = languageViewModel.getQuizCubeVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        case .Tense:
            str = languageViewModel.getQuizCubeTense().rawValue
        case .Person:
            str = languageViewModel.getQuizCubePerson().getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)
        }
        return str
        
    }
    
    func fillIsBlankArray(){
        isBlankArray.removeAll()
        let quizCubeDifficulty = languageViewModel.getQuizLevel()
        var blankCount = 1
        switch quizCubeDifficulty{
        case .easy: blankCount = 1
        case .medium: blankCount = 2
        case .hard: blankCount = 3
        case .max: blankCount = 4
        }
        
        
        isBlankArray = Array(repeating: Array(repeating:false, count : conjStringArrayDimension2), count : conjStringArrayDimension1)
        
//        print("\nfillIsBlankArray: conjStringArrayDimension1=\(conjStringArrayDimension1), conjStringArrayDimension2=\(conjStringArrayDimension2)  ")
//        print(" quizCubeDifficulty = \(quizCubeDifficulty.rawValue), blankCount = \(blankCount)")
        for j in 0 ..< conjStringArrayDimension2 {
            let rowBlank = getBlanksInRow(blankCount: blankCount, cellCount: conjStringArrayDimension1)
            for i in 0 ..< conjStringArrayDimension1 {
                isBlankArray[i][j] = rowBlank[i]
//                print("isBlankArray[\(i)][\(j)] = \(isBlankArray[i][j]) -- rowBlank[\(i)] = \(rowBlank[i])")
            }
        }
  
    }
    
    func getBlanksInRow(blankCount: Int, cellCount: Int)->[Bool]{
        var blankArray = [Bool]()
        var blankCountSoFar = 0
        for _ in 0..<cellCount { blankArray.append(false) }
        
        for _ in 0..<cellCount {
            let randomIndex = Int.random(in: 0..<cellCount)
            if !blankArray[randomIndex] {
                blankArray[randomIndex] = true
                blankCountSoFar += 1
                if blankCountSoFar == blankCount { return blankArray}
            }
        }
        
        return blankArray
    }
    
    func isBlank(i: Int, j: Int)->Bool{
        let quizCubeDifficulty = languageViewModel.getQuizLevel()
        var blankIncrement = 1
        switch quizCubeDifficulty{
        case .easy: blankIncrement = 9
        case .medium: blankIncrement = 7
        case .hard: blankIncrement = 4
        case .max: blankIncrement = 1
        }
        
        let cellNum = i * conjStringArrayDimension1 + j
        if cellNum % blankIncrement == 0 {
            return true
        }

        return false
    }
    
    func turnOnDiagnosticPrint(){
        diagnosticPrint = true
    }
    
    func fillCellData(){
        fillIsBlankArray()
        cellDataArray.removeAll()
        quizCubeCellInfoArray.removeAll()

        let tense = languageViewModel.getQuizCubeTense()
        let verb = languageViewModel.getQuizCubeVerb()
        let person = languageViewModel.getQuizCubePerson()
        var blank = false
        tenses = languageViewModel.getQuizTenseList()
        verbs = languageViewModel.getQuizCubeBlock()
        firstColumnStringList = fillStringList(inputList: firstColumnStringList, vcd: vcDimension1)
        headerStringList = fillStringList(inputList: headerStringList, vcd: vcDimension2)
        
        cornerWord = fillCornerWord(vcd: getDimension3())
        var wordString = ""
        
        cellDataArray = Array(repeating: Array(repeating: QuizCellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
        quizCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
        
        switch vcDimension1 {
        case .Verb:
            switch vcDimension2 {
            case .Verb: break
            case .Tense:  // verb vs tense
                for i in 0..<verbs.count {
                    for j in 0..<tenses.count {
                        let verb = verbs[i]
                        let tense = tenses[j]
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlankArray[i][j]
                        wordString = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
//                        if diagnosticPrint { dumpCell(i:i, j:j) }
                        
                    }
                }
            case .Person:  // verb vs person
                for i in 0..<verbs.count {
                    for j in 0..<persons.count {
                        let verb = verbs[i]
                        let person = persons[j]
                        wordString = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlankArray[i][j]
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
//                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            }
        case .Tense:
            switch vcDimension2 {
            case .Tense: break  //cannot have tense / tense
            case .Person:  // tense vs person
                for i in 0..<tenses.count {
                    for j in 0..<persons.count {
                        let tense = tenses[i]
                        let person = persons[j]
                        wordString =  languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlankArray[i][j]
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
//                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            case .Verb:  //tense vs verb
                for i in 0..<tenses.count {
                    for j in 0..<verbs.count {
                        let tense = tenses[i]
                        let verb = verbs[j]
                        wordString =  languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlankArray[i][j]
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
//                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            }
        case .Person:
            switch vcDimension2 {
            case .Person: break
            case .Tense:  //person vs tense
                for i in 0..<persons.count {
                    for j in 0..<tenses.count {
                        let person = persons[i]
                        let tense = tenses[j]
                        wordString = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlankArray[i][j]
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
//                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            case .Verb:  //person vs verb
                for i in 0..<persons.count {
                    for j in 0..<verbs.count {
                        let person = persons[i]
                        let verb = verbs[j]
                        wordString =  languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlankArray[i][j]
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
//                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            }
//            if diagnosticPrint { dumpVerbCubeCellInfo() }
        }
    }
    
//    func dumpCell(i: Int, j: Int){
//        print("quizCubeCellInfoArray[\(i)][\(j)] - verb \(quizCubeCellInfoArray[i][j].verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())), person: \(quizCubeCellInfoArray[i][j].person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)), tense: \(quizCubeCellInfoArray[i][j].tense.rawValue)")
//        print("cellDataArray[\(i)][\(j)] - cellString \(cellDataArray[i][j].cellString)")
//    }
    
}


