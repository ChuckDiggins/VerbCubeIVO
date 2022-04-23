//
//  VerbCubeConjugationStringHandler.swift
//  VerbCubeConjugationStringHandler
//
//  Created by Charles Diggins on 2/16/22.
//

import Foundation
import JumpLinguaHelpers
import Dot
import SwiftUI

struct VerbCubeConjugatedStringHandlerStruct {
//    @ObservedObject var languageEngine: LanguageEngine
    @ObservedObject var languageViewModel: LanguageViewModel
    
    var vcDimension1 = VerbCubeDimension.Person
    var vcDimension2 = VerbCubeDimension.Tense
    
    var vcCurrentDimension = VerbCubeDimension.Person
    var showStringArray = [[String]]()
    var verbCubeCellInfoArray = [[VerbCubeCellInfo]]()
    var cellDataArray = [[CellData]]()
    var answerStringArray = [[String]]()
    var colorArray = [[Color]]()
    var headerStringList = [String]()
    var firstColumnStringList = [String]()
    var conjStringArrayDimension1 = 0
    var conjStringArrayDimension2 = 0
    var currentTense = Tense.present
    var currentPerson = Person.P1
//    var currentVerb = Verb()
    var verbCount = 6
    var verticalSwipeDimension = VerbCubeDimension.Person
    var horizontalSwipeDimension = VerbCubeDimension.Person
    var cornerWord = ""
    private var currentShowVerbType = ShowVerbType.NONE
    var tenses = [Tense]()
    var persons = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    var diagnosticPrint = false
    var verbCubeWidth : Int = 660
    
//    init(languageEngine: LanguageEngine ){
//        self.languageViewModel = languageViewModel
//        currentLanguage = languageViewModel.getCurrentLanguage()
//        initializeVerbCube()
//    }
//    
    init(languageViewModel: LanguageViewModel, d1:  VerbCubeDimension, d2: VerbCubeDimension){
        self.languageViewModel = languageViewModel
        vcDimension1 = d1
        vcDimension2 = d2
        initializeVerbCube()
    }
    
    mutating func initializeVerbCube(){
        setDimensions()
        setTenses(tenses: languageViewModel.getQuizTenseList())
        fillCellData()
    }
    
    mutating func setDimensions(){
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
                conjStringArrayDimension2 = languageViewModel.getQuizVerbs().count
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
                conjStringArrayDimension2 = languageViewModel.getQuizVerbs().count
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        case .Verb:
            conjStringArrayDimension1 = languageViewModel.getQuizVerbs().count
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
    
    }
    
    func getColumnWidth() -> CGFloat {
        return CGFloat(verbCubeWidth/getHeaderStringList().count)
    }
    
    mutating  func setTenses(tenses : [Tense]){
        self.tenses = tenses
    }
    
    //should not need these to be set, but for the sake of completeness I added this function
    mutating  func setPersons(persons : [Person]){
        self.persons = persons
    }
    
    mutating  func setCurrentPerson(person : Person){
        self.currentPerson = person
    }
    
    mutating func setCurrentTense(tense : Tense){
        self.currentTense = tense
    }
    
    func dumpConjugateStringArray(){
        print("\ndumpConjugateStringArray: \(vcDimension1) by \(vcDimension2)")
        switch vcCurrentDimension {
        case .Verb: print("Current verb: \(languageViewModel.getCurrentVerbCubeVerb().getWordStringAtLanguage(language: languageViewModel.getCurrentLanguage()))")
        case .Person: print("Current person: \(currentPerson.rawValue)")
        case .Tense: print("Current tense: \(currentTense.rawValue)")
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
    
    func getCellData(i: Int, j: Int)->CellData{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
            return cellDataArray[i][j]
        }
        return CellData()
    }
    
    func getShowVerbType(i: Int, j: Int)->ShowVerbType{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
            return verbCubeCellInfoArray[i][j].showVerbType!
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
    
    func getVerbCubeCellInfo(i: Int, j: Int)->VerbCubeCellInfo{
        if  i < conjStringArrayDimension1  && j < conjStringArrayDimension2 {
            return verbCubeCellInfoArray[i][j]
        }
        return VerbCubeCellInfo()
    }
      
    func fillStringList(inputList: [String], vcd: VerbCubeDimension)->[String] {
        var list = inputList
        list.removeAll()
        switch vcd {
        case .Verb:
            for j in 0..<languageViewModel.getVerbCubeBlock().count {
                list.append(languageViewModel.getVerbCubeBlockVerb(i:j).getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))
            }
        case .Tense:
            for j in 0..<tenses.count {list.append(tenses[j].rawValue)}
        case .Person:
            for j in 0..<persons.count { list.append(persons[j].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3))}
        }
        return list
    }
    
     func fillCornerWord(vcd: VerbCubeDimension)->String {
        var str = ""
        switch vcd {
        case .Verb:
            str = languageViewModel.getCurrentVerbCubeVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        case .Tense:
            str = currentTense.rawValue
        case .Person:
            str = currentPerson.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)
        }
        return str
        
    }
    
    mutating func setDiagnosticPrint(flag: Bool){
        diagnosticPrint = flag
    }
    
    func printDiagnostic(i: Int, j: Int){
        if diagnosticPrint {
            print("CellDataArray[\(i)][\(j)] - cellString \(cellDataArray[i][j].cellString))")
        }
    }
    
    mutating func fillCellData(){
        cellDataArray.removeAll()
        verbCubeCellInfoArray.removeAll()
        setDiagnosticPrint(flag: false)
        
        let tense = currentTense
        let verb = languageViewModel.getCurrentVerbCubeVerb()
        let person = currentPerson
        
        firstColumnStringList = fillStringList(inputList: firstColumnStringList, vcd: vcDimension1)
        headerStringList = fillStringList(inputList: headerStringList, vcd: vcDimension2)
        
        cornerWord = fillCornerWord(vcd: getDimension3())
        var wordString = ""
        var cellColor = Color.white
        var colorCellCount = 0
        
        switch vcDimension1 {
        case .Verb:
            switch vcDimension2 {
            case .Verb: break
            case .Tense:  // verb vs tense
                conjStringArrayDimension1 = languageViewModel.getVerbCubeBlock().count
                conjStringArrayDimension2 = tenses.count
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<languageViewModel.getVerbCubeBlock().count {
                    for j in 0..<tenses.count {
                        cellColor = Color.white
                        wordString = languageViewModel.createAndConjugateAgnosticVerb(verb: languageViewModel.getVerbCubeBlockVerb(i:i), tense: tenses[j], person: person)
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageViewModel.getVerbCubeBlockVerb(i:i), tense: tenses[j], person: person)
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageViewModel.isVerbType(verb: languageViewModel.getVerbCubeBlockVerb(i:i), tense: tenses[j], person: person, verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                        printDiagnostic(i: i, j: j)
                        
                    }
                }
            case .Person:  // verb vs person
                conjStringArrayDimension1 = languageViewModel.getVerbCubeBlock().count
                conjStringArrayDimension2 = persons.count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<languageViewModel.getVerbCubeBlock().count {
                    for j in 0..<persons.count {
                        cellColor = Color.white
                        wordString = languageViewModel.createAndConjugateAgnosticVerb(verb: languageViewModel.getVerbCubeBlock()[i], tense: tense, person: persons[j])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageViewModel.getVerbCubeBlockVerb(i:i), tense: tense, person: persons[j])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageViewModel.isVerbType(verb: languageViewModel.getVerbCubeBlockVerb(i:i), tense: tense, person: persons[j], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                        printDiagnostic(i: i, j: j)
                    }
                }
            }
        case .Tense:
            switch vcDimension2 {
            case .Tense: break  //cannot have tense / tense
            case .Person:  // tense vs person
                conjStringArrayDimension1 = tenses.count
                conjStringArrayDimension2 = persons.count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<tenses.count {
                    for j in 0..<persons.count {
                        cellColor = Color.white
                        wordString =  languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tenses[i], person: persons[j])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tenses[i], person: persons[j])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageViewModel.isVerbType(verb: verb, tense: tenses[i], person: persons[j], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                        printDiagnostic(i: i, j: j)
                    }
                }
            case .Verb:  //tense vs verb
                conjStringArrayDimension1 = tenses.count
                conjStringArrayDimension2 = languageViewModel.getVerbCubeBlock().count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<tenses.count {
                    for j in 0..<languageViewModel.getVerbCubeBlock().count {
                        cellColor = Color.white
                        wordString =  languageViewModel.createAndConjugateAgnosticVerb(verb: languageViewModel.getVerbCubeBlockVerb(i:j), tense: tenses[i], person: person)
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageViewModel.getVerbCubeBlockVerb(i:j), tense: tenses[i], person: person)
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageViewModel.isVerbType(verb: languageViewModel.getVerbCubeBlockVerb(i:j), tense: tenses[i], person: person, verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                        printDiagnostic(i: i, j: j)
                    }
                }
            }
        case .Person:
            switch vcDimension2 {
            case .Person: break
            case .Tense:  //person vs tense
                conjStringArrayDimension1 = persons.count
                conjStringArrayDimension2 = tenses.count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<persons.count {
                    for j in 0..<tenses.count {
                        cellColor = Color.white
                        wordString = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tenses[j], person: persons[i])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tenses[j], person: persons[i])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageViewModel.isVerbType(verb: verb, tense: tenses[j], person: persons[i], verbType: currentShowVerbType)
                        {
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                        printDiagnostic(i: i, j: j)
                    }
                }
            case .Verb:  //person vs verb
                conjStringArrayDimension1 = persons.count
                conjStringArrayDimension2 = languageViewModel.getVerbCubeBlock().count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<persons.count {
                    for j in 0..<languageViewModel.getVerbCubeBlock().count {
                        cellColor = Color.white
                        wordString =  languageViewModel.createAndConjugateAgnosticVerb(verb: languageViewModel.getVerbCubeBlockVerb(i:j), tense: tense, person: persons[i])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageViewModel.getVerbCubeBlockVerb(i:j), tense: tense, person: persons[i])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageViewModel.isVerbType(verb: languageViewModel.getVerbCubeBlockVerb(i:j), tense: tense, person: persons[i], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                        printDiagnostic(i: i, j: j)
                    }
                }
            }
        }
    }
}

