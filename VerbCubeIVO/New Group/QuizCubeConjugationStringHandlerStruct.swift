//
//  QuizCubeConjugationStringHandlerStruct.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/23/22.
//

import Foundation
import JumpLinguaHelpers
import Dot
import SwiftUI

struct QuizCubeConjugatedStringHandlerStruct {
    @ObservedObject var languageEngine: LanguageEngine
//    @ObservedObject var quizCubeWatcher: QuizCubeWatcher
    
    var vcDimension1 = VerbCubeDimension.Person
    var vcDimension2 = VerbCubeDimension.Verb
    var vcCurrentDimension = VerbCubeDimension.Person
    var currentLanguage = LanguageType.Spanish
    var showStringArray = [[String]]()
    var quizCubeCellInfoArray = [[VerbCubeCellInfo]]()
    var cellDataArray = [[QuizCellData]]()
    var headerStringList = [String]()
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
    
    init(languageEngine: LanguageEngine){
        self.languageEngine = languageEngine
//        self.quizCubeWatcher = quizCubeWatcher
        currentLanguage = .Spanish
        initializeQuizCube()
    }
    
    mutating func initializeQuizCube(){
        currentLanguage = languageEngine.getCurrentLanguage()
        setDimensions()
        verbs =  languageEngine.getQuizVerbs()
        tenses = languageEngine.getQuizTenseList()
        fillCellData()
//        fillQuizCorrectData()
    }
    
    mutating func setDimensions(){
        let result = getVerbCubeDimensions(activeConfig: languageEngine.getQuizCubeConfiguration())
        vcDimension1 = result.0
        vcDimension2 = result.1
        
        switch vcDimension1 {
        case .Person :
            conjStringArrayDimension1 = persons.count
            if vcDimension2 == .Tense {
                vcCurrentDimension = .Verb
                horizontalSwipeDimension = .Verb
                verticalSwipeDimension = .Verb
                conjStringArrayDimension2 = languageEngine.getQuizTenseList().count
            }
            else if vcDimension2 == .Verb {
                conjStringArrayDimension2 = languageEngine.getQuizVerbs().count
                vcCurrentDimension = .Tense
                horizontalSwipeDimension = .Tense
                verticalSwipeDimension = .Verb
            }
        case .Tense:
            conjStringArrayDimension1 = languageEngine.getQuizTenseList().count
            if vcDimension2 == .Person {
                conjStringArrayDimension2 = 6
                vcCurrentDimension = .Verb
                horizontalSwipeDimension = .Verb
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Verb {
                conjStringArrayDimension2 = languageEngine.getQuizVerbs().count
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        case .Verb:
            conjStringArrayDimension1 = languageEngine.getQuizVerbs().count
            if vcDimension2 == .Person {
                conjStringArrayDimension2 = 6
                vcCurrentDimension = .Tense
                horizontalSwipeDimension = .Tense
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Tense {
                conjStringArrayDimension2 = languageEngine.getQuizTenseList().count
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        }
//        print("setDimensions:  \(conjStringArrayDimension1) x \(conjStringArrayDimension2)")
    }
    
    //should not need these to be set, but for the sake of completeness I added this function
    mutating  func setPersons(persons : [Person]){
        self.persons = persons
    }
    

    func dumpConjugateStringArray(){
        print("\ndumpConjugateStringArray: \(vcDimension1) by \(vcDimension2)")
        switch vcCurrentDimension {
        case .Verb: print("Current verb: \(languageEngine.getQuizCubeVerb().getWordStringAtLanguage(language: currentLanguage))")
        case .Person: print("Current person: \(languageEngine.getQuizCubePerson().rawValue)")
        case .Tense: print("Current tense: \(languageEngine.getQuizCubeTense().rawValue)")
        }
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
    
    mutating func setShowVerbType(currentVerbType: ShowVerbType ){
        self.currentShowVerbType = currentVerbType
        fillCellData()
    }
    
    mutating func getCurrentShowVerbType()->ShowVerbType{
        currentShowVerbType
    }
    
    func dumpVerbCubeCellInfo(){
        for i in 0 ..< conjStringArrayDimension1 {
            for j in 0 ..< conjStringArrayDimension2 {
                print("dumpVerbCubeCellInfo: quizCubeCellInfoArray[\(i)][\(j)] - verb \(quizCubeCellInfoArray[i][j].verb.getWordAtLanguage(language: languageEngine.getCurrentLanguage())), person: \(quizCubeCellInfoArray[i][j].person.getMaleString()), tense: \(quizCubeCellInfoArray[i][j].tense.rawValue)")
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
            for j in 0..<languageEngine.getQuizVerbs().count {
                list.append(languageEngine.getQuizVerbs()[j].getWordAtLanguage(language: languageEngine.getCurrentLanguage()))
            }
        case .Tense:
            for j in 0..<languageEngine.getQuizTenseList().count {list.append(languageEngine.getQuizTenseList()[j].rawValue)}
        case .Person:
            for j in 0..<persons.count { list.append(persons[j].getMaleString())}
        }
        return list
    }
    
    func fillCornerWord(vcd: VerbCubeDimension)->String {
        var str = ""
        switch vcd {
        case .Verb:
            str = languageEngine.getQuizCubeVerb().getWordAtLanguage(language: languageEngine.getCurrentLanguage())
        case .Tense:
            str = languageEngine.getQuizCubeTense().rawValue
        case .Person:
            str = languageEngine.getQuizCubePerson().getMaleString()
        }
        return str
        
    }
    
    mutating func isBlank(blankIncrement: Int, i: Int, j: Int)->Bool{
        let cellNum = i * conjStringArrayDimension1 + j
        if cellNum % blankIncrement == 0 {
            return true
        }

        return false
    }
    
    mutating func turnOnDiagnosticPrint(){
        diagnosticPrint = true
    }
    
    
//    mutating func fillQuizCorrectData(){
//        var diagnosticPrint = true
//        var blank = false
//        quizCubeWatcher.quizCubeCorrectBuffer = Array(repeating: Array(repeating: true, count : conjStringArrayDimension2), count : conjStringArrayDimension1)
//        quizCubeWatcher.setQuizCorrectBufferDimensions(d1: conjStringArrayDimension1, d2: conjStringArrayDimension2)
//        let quizCubeDifficulty = languageEngine.getQuizLevel()
//        var blankIncrement = 1
//        switch quizCubeDifficulty{
//        case .easy: blankIncrement = 9
//        case .medium: blankIncrement = 7
//        case .hard: blankIncrement = 4
//        case .max: blankIncrement = 1
//        }
//
//        switch vcDimension1 {
//        case .Verb:
//            switch vcDimension2 {
//            case .Verb: break
//            case .Tense:  // verb vs tense
//                for i in 0..<verbs.count {
//                    for j in 0..<tenses.count {
//                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
//                        if blank { quizCubeWatcher.quizCubeCorrectBuffer[i][j] = false }
//                        if diagnosticPrint { dumpCorrect(i:i, j:j) }
//                    }
//                }
//            case .Person:  // verb vs person
//                for i in 0..<verbs.count {
//                    for j in 0..<persons.count {
//                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
//                        if blank { quizCubeWatcher.quizCubeCorrectBuffer[i][j] = false  }
//                        if diagnosticPrint { dumpCorrect(i:i, j:j) }
//                    }
//                }
//            }
//        case .Tense:
//            switch vcDimension2 {
//            case .Tense: break  //cannot have tense / tense
//            case .Person:  // tense vs person
//                for i in 0..<tenses.count {
//                    for j in 0..<persons.count {
//                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
//                        if blank {
//                            quizCubeWatcher.quizCubeCorrectBuffer[i][j] = false
//                        }
//                    }
//                }
//            case .Verb:  //tense vs verb
//                for i in 0..<tenses.count {
//                    for j in 0..<verbs.count {
//                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
//                        if blank { quizCubeWatcher.quizCubeCorrectBuffer[i][j] = false }
//                        if diagnosticPrint { dumpCorrect(i:i, j:j) }
//                    }
//                }
//            }
//        case .Person:
//            switch vcDimension2 {
//            case .Person: break
//            case .Tense:  //person vs tense
//                for i in 0..<persons.count {
//                    for j in 0..<tenses.count {
//                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
//                        if blank { quizCubeWatcher.quizCubeCorrectBuffer[i][j] = false }
//                        if diagnosticPrint { dumpCorrect(i:i, j:j) }
//                    }
//                }
//            case .Verb:  //person vs verb
//                for i in 0..<persons.count {
//                    for j in 0..<verbs.count {
//                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
//                        if blank { quizCubeWatcher.quizCubeCorrectBuffer[i][j] = false }
//                        if diagnosticPrint { dumpCorrect(i:i, j:j) }
//                    }
//                }
//            }
//        }
//    }
    
    mutating func fillCellData(){
//        turnOnDiagnosticPrint()
        let quizCubeDifficulty = languageEngine.getQuizLevel()
        var blankIncrement = 1
        switch quizCubeDifficulty{
        case .easy: blankIncrement = 9
        case .medium: blankIncrement = 7
        case .hard: blankIncrement = 4
        case .max: blankIncrement = 1
        }
        
        cellDataArray.removeAll()
        quizCubeCellInfoArray.removeAll()

        let tense = languageEngine.getQuizCubeTense()
        let verb = languageEngine.getQuizCubeVerb()
        let person = languageEngine.getQuizCubePerson()
        var blank = false
        tenses = languageEngine.getQuizTenseList()
        verbs = languageEngine.getQuizVerbs()
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
                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
                        if diagnosticPrint { dumpCell(i:i, j:j) }
                        
                    }
                }
            case .Person:  // verb vs person
                for i in 0..<verbs.count {
                    for j in 0..<persons.count {
                        let verb = verbs[i]
                        let person = persons[j]
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
                        if diagnosticPrint { dumpCell(i:i, j:j) }
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
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            case .Verb:  //tense vs verb
                for i in 0..<tenses.count {
                    for j in 0..<verbs.count {
                        let tense = tenses[i]
                        let verb = verbs[j]
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
                        if diagnosticPrint { dumpCell(i:i, j:j) }
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
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            case .Verb:  //person vs verb
                for i in 0..<persons.count {
                    for j in 0..<verbs.count {
                        let person = persons[i]
                        let verb = verbs[j]
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tense, person: person)
                        quizCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        blank = isBlank(blankIncrement: blankIncrement, i:i, j:j)
                        cellDataArray[i][j] = QuizCellData(i: i, j: j, cellString: wordString, isBlank: blank)
                        if diagnosticPrint { dumpCell(i:i, j:j) }
                    }
                }
            }
//            if diagnosticPrint { dumpVerbCubeCellInfo() }
        }
    }
    
    func dumpCell(i: Int, j: Int){
        print("quizCubeCellInfoArray[\(i)][\(j)] - verb \(quizCubeCellInfoArray[i][j].verb.getWordAtLanguage(language: languageEngine.getCurrentLanguage())), person: \(quizCubeCellInfoArray[i][j].person.getMaleString()), tense: \(quizCubeCellInfoArray[i][j].tense.rawValue)")
        print("cellDataArray[\(i)][\(j)] - cellString \(cellDataArray[i][j].cellString)")
    }
    
//    func dumpCorrect(i: Int, j: Int){
//        print("quizCubeWatcher[\(i)][\(j)] - correct \(quizCubeWatcher.getQuizCorrectAt(i: i, j: j))")
//    }
    
}
