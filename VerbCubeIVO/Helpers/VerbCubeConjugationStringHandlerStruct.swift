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
    var languageEngine: LanguageEngine
    var vcDimension1 : VerbCubeDimension
    var vcDimension2 : VerbCubeDimension
    
    var vcCurrentDimension = VerbCubeDimension.Person
    var currentLanguage = LanguageType.Spanish
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
    
    init(languageEngine: LanguageEngine, d1 : VerbCubeDimension, d2 : VerbCubeDimension ){
        self.languageEngine = languageEngine
        currentLanguage = .Spanish
        vcDimension1 = d1
        vcDimension2 = d2
        initializeVerbCube()
    }
    
    mutating func initializeVerbCube(){
        currentLanguage = languageEngine.getCurrentLanguage()
        setDimensions()
        setTenses(tenses: languageEngine.getTenseList())
        fillCellData()
    }
    
    mutating func setDimensions(){
        switch vcDimension1 {
        case .Person :
            if vcDimension2 == .Tense {
                vcCurrentDimension = .Verb
                horizontalSwipeDimension = .Verb
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Verb {
                vcCurrentDimension = .Tense
                horizontalSwipeDimension = .Tense
                verticalSwipeDimension = .Verb
            }
        case .Tense:
            if vcDimension2 == .Person {
                vcCurrentDimension = .Verb
                horizontalSwipeDimension = .Verb
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Verb {
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        case .Verb:
            if vcDimension2 == .Person {
                vcCurrentDimension = .Tense
                horizontalSwipeDimension = .Tense
                verticalSwipeDimension = .Verb
            }
            else if vcDimension2 == .Tense {
                vcCurrentDimension = .Person
                horizontalSwipeDimension = .Person
                verticalSwipeDimension = .Verb
            }
        }
    
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
        case .Verb: print("Current verb: \(languageEngine.getCurrentVerbCubeVerb().getWordStringAtLanguage(language: currentLanguage))")
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
            for j in 0..<languageEngine.getVerbCubeBlock().count {
                list.append(languageEngine.getVerbCubeBlockVerb(i:j).getWordAtLanguage(language: languageEngine.getCurrentLanguage()))
            }
        case .Tense:
            for j in 0..<tenses.count {list.append(tenses[j].rawValue)}
        case .Person:
            for j in 0..<persons.count { list.append(persons[j].getMaleString())}
        }
        return list
    }
    
     func fillCornerWord(vcd: VerbCubeDimension)->String {
        var str = ""
        switch vcd {
        case .Verb:
            str = languageEngine.getCurrentVerbCubeVerb().getWordAtLanguage(language: languageEngine.getCurrentLanguage())
        case .Tense:
            str = currentTense.rawValue
        case .Person:
            str = currentPerson.getMaleString()
        }
        return str
        
    }
    
    mutating func fillCellData(){
        cellDataArray.removeAll()
        verbCubeCellInfoArray.removeAll()
   
        let tense = currentTense
        let verb = languageEngine.getCurrentVerb()
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
                conjStringArrayDimension1 = languageEngine.getVerbCubeBlock().count
                conjStringArrayDimension2 = tenses.count
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<languageEngine.getVerbCubeBlock().count {
                    for j in 0..<tenses.count {
                        cellColor = Color.white
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getVerbCubeBlockVerb(i:i), tense: tenses[j], person: person)
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getVerbCubeBlockVerb(i:i), tense: tenses[j], person: person)
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getVerbCubeBlockVerb(i:i), tense: tenses[j], person: person, verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            case .Person:  // verb vs person
                conjStringArrayDimension1 = languageEngine.getVerbCubeBlock().count
                conjStringArrayDimension2 = persons.count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<languageEngine.getVerbCubeBlock().count {
                    for j in 0..<persons.count {
                        cellColor = Color.white
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getVerbCubeBlock()[i], tense: tense, person: persons[j])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getVerbCubeBlockVerb(i:i), tense: tense, person: persons[j])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getVerbCubeBlockVerb(i:i), tense: tense, person: persons[j], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
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
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tenses[i], person: persons[j])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tenses[i], person: persons[j])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: verb, tense: tenses[i], person: persons[j], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            case .Verb:  //tense vs verb
                conjStringArrayDimension1 = tenses.count
                conjStringArrayDimension2 = languageEngine.getVerbCubeBlock().count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<tenses.count {
                    for j in 0..<languageEngine.getVerbCubeBlock().count {
                        cellColor = Color.white
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getVerbCubeBlockVerb(i:j), tense: tenses[i], person: person)
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getVerbCubeBlockVerb(i:j), tense: tenses[i], person: person)
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getVerbCubeBlockVerb(i:j), tense: tenses[i], person: person, verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
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
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tenses[j], person: persons[i])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tenses[j], person: persons[i])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: verb, tense: tenses[j], person: persons[i], verbType: currentShowVerbType)
                        {
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
//                        print("CellDataArray[\(i)][\(j)] - cellString \(cellDataArray[i][j].cellString), cellColor: \(cellDataArray[i][j].cellColor)")
                    }
                }
            case .Verb:  //person vs verb
                conjStringArrayDimension1 = persons.count
                conjStringArrayDimension2 = languageEngine.getVerbCubeBlock().count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<persons.count {
                    for j in 0..<languageEngine.getVerbCubeBlock().count {
                        cellColor = Color.white
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getVerbCubeBlockVerb(i:j), tense: tense, person: persons[i])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getVerbCubeBlockVerb(i:j), tense: tense, person: persons[i])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getVerbCubeBlockVerb(i:j), tense: tense, person: persons[i], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            }
        }
    }
    
    mutating func fillQuizCellData(){
        cellDataArray.removeAll()
        verbCubeCellInfoArray.removeAll()
   
        let tense = currentTense
        let verb = languageEngine.getCurrentVerb()
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
                conjStringArrayDimension1 = languageEngine.getQuizVerbs().count
                conjStringArrayDimension2 = tenses.count
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<languageEngine.getQuizVerbs().count {
                    for j in 0..<tenses.count {
                        cellColor = Color.white
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getQuizVerb(i:i), tense: tenses[j], person: person)
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getQuizVerb(i:i), tense: tenses[j], person: person)
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getQuizVerb(i:i), tense: tenses[j], person: person, verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            case .Person:  // verb vs person
                conjStringArrayDimension1 = languageEngine.getQuizVerbs().count
                conjStringArrayDimension2 = persons.count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<languageEngine.getQuizVerbs().count {
                    for j in 0..<persons.count {
                        cellColor = Color.white
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getQuizVerb(i:i), tense: tense, person: persons[j])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getQuizVerb(i:i), tense: tense, person: persons[j])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getQuizVerb(i:i), tense: tense, person: persons[j], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
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
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tenses[i], person: persons[j])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tenses[i], person: persons[j])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: verb, tense: tenses[i], person: persons[j], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            case .Verb:  //tense vs verb
                conjStringArrayDimension1 = tenses.count
                conjStringArrayDimension2 = languageEngine.getQuizVerbs().count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<tenses.count {
                    for j in 0..<languageEngine.getQuizVerbs().count {
                        cellColor = Color.white
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getQuizVerb(i:j), tense: tenses[i], person: person)
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getQuizVerb(i:j), tense: tenses[i], person: person)
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getQuizVerb(i:j), tense: tenses[i], person: person, verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
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
                        wordString = languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tenses[j], person: persons[i])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: verb, tense: tenses[j], person: persons[i])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: verb, tense: tenses[j], person: persons[i], verbType: currentShowVerbType)
                        {
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            case .Verb:  //person vs verb
                conjStringArrayDimension1 = persons.count
                conjStringArrayDimension2 = languageEngine.getQuizVerbs().count
                cellDataArray = Array(repeating: Array(repeating: CellData(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                verbCubeCellInfoArray = Array(repeating: Array(repeating: VerbCubeCellInfo(), count : conjStringArrayDimension2), count : conjStringArrayDimension1)
                for i in 0..<persons.count {
                    for j in 0..<languageEngine.getQuizVerbs().count {
                        cellColor = Color.white
                        wordString =  languageEngine.createAndConjugateAgnosticVerb(verb: languageEngine.getQuizVerb(i:j), tense: tense, person: persons[i])
                        verbCubeCellInfoArray[i][j].setConjugationInfo(verb: languageEngine.getQuizVerb(i:j), tense: tense, person: persons[i])
                        verbCubeCellInfoArray[i][j].showVerbType = ShowVerbType.NONE
                        if languageEngine.isVerbType(verb: languageEngine.getQuizVerb(i:j), tense: tense, person: persons[i], verbType: currentShowVerbType){
                            verbCubeCellInfoArray[i][j].showVerbType = currentShowVerbType
                            cellColor = getComputedBackgroundColor(showVerbType: verbCubeCellInfoArray[i][j].showVerbType!)
                            colorCellCount += 1
                        }
                        cellDataArray[i][j] = CellData(cellString: wordString, cellColor: cellColor, colorString: cellColor.description)
                    }
                }
            }
        }
    }

}

