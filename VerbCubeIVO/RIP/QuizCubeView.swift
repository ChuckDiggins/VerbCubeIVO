//
//  NewQuizCubeView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/23/22.
//

import SwiftUI

import JumpLinguaHelpers


struct QuizCubeView: View {
    @ObservedObject var languageEngine: LanguageEngine
    @State public var vccsh : QuizCubeConjugatedStringHandlerStruct
    public var verbCount = 6
    @State var isSwiping = true
    @State var startPos : CGPoint = .zero
    @State var specialVerbString = ""
    @State var showVerbType = ShowVerbType.NONE
    @State var showVerbTypeColor = Color.red
    @State private var useAlert = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                ShowCube(vccsh: vccsh)
            }.navigationBarTitle("Quiz Cube - \(vccsh.vcDimension1.rawValue) v \(vccsh.vcDimension2.rawValue)")
                
        }
    }
    
    struct VerbTypeButtons: View {
        @State var vccsh : VerbCubeConjugatedStringHandlerStruct
        
        var body: some View {
            HStack{
                Button(action: {
                    vccsh.setShowVerbType(currentVerbType: .NONE)
                }){
                    Text("🔴")
                }
                Button(action: {
                    vccsh.setShowVerbType(currentVerbType: .STEM)
                }){
                    Text("🟡")
                }
                Button(action: {
                    vccsh.setShowVerbType(currentVerbType: .ORTHO)
                }){
                    Text("🟢")
                }
                Button(action: {
                    vccsh.setShowVerbType(currentVerbType: .IRREG)
                }){
                    Text("🔵")
                }
            }
        }
    }

    struct CubeTypeButtons: View {
        var changeVerbCubeDimension: (_ d1: VerbCubeDimension, _ d2: VerbCubeDimension) -> Void
        
        var defaultColor = Color.white
        var activeColor = Color.yellow
        var buttonColor = Color.white
        @State var activeIndex = 0
        
        var data = ["PV", "VP", "PT", "TP", "TV", "VT"]
        @State var active = [false, false, true, false, false, false]
        
        var body: some View {
            HStack{
                ForEach(0..<data.count){i in
                    Button(action: {
                        setAllInactive()
                        active[i] = true
                        switch data[i]{
                        case "PV": changeVerbCubeDimension(.Person, .Verb)
                        case "VP": changeVerbCubeDimension(.Verb, .Person)
                        case "PT": changeVerbCubeDimension(.Person, .Tense)
                        case "TP": changeVerbCubeDimension(.Tense, .Person)
                        case "TV": changeVerbCubeDimension(.Tense, .Verb)
                        case "VT": changeVerbCubeDimension(.Verb, .Tense)
                        default:
                            break
                        }
                    }){
                        Text(data[i]).foregroundColor(active[i] ? .yellow : .white)
                    }
                }
            }
        }
        func setAllInactive(){
            for i in 0..<active.count {
                active[i] = false
            }
        }
        

    }
    
    struct ShowCube: View {
        var vccsh : QuizCubeConjugatedStringHandlerStruct
        var body: some View {
            VStack (spacing: 0){
                CreateLineOfHeaderCells(vccsh: vccsh)
                CreateGridOfConjugatedCells(vccsh: vccsh)
            }
        }
    }
    
    struct CreateLineOfHeaderCells: View {
        var vccsh : QuizCubeConjugatedStringHandlerStruct
        var body: some View {
            //show the verb conjugations here
            HStack(spacing: 0){
                //first cell is actually a button
                
                VerbCubeCellView(cellColor: .yellow, columnWidth: CGFloat(600/vccsh.getHeaderStringList().count), cellString: vccsh.getCornerWord())
                
                //these cells are the headers
                
                ForEach(vccsh.getHeaderStringList(), id:\.self) { str in
                    VerbCubeCellView(cellColor: .green, columnWidth: CGFloat(600/vccsh.getHeaderStringList().count), cellString: str)
                }
                Spacer()
            }
            
        }
    }
    
    struct CreateGridOfConjugatedCells: View {
        var vccsh : QuizCubeConjugatedStringHandlerStruct
        
        var body: some View {
            VStack(spacing: 0){
                ForEach((0..<vccsh.conjStringArrayDimension1), id:\.self) { index in
                    HStack(spacing: 0){
                        VerbCubeCellView(cellColor: .blue, columnWidth: CGFloat(600/vccsh.getHeaderStringList().count), cellString: vccsh.getFirstColumnStringValue(i: index) )
                        ForEach((0..<vccsh.conjStringArrayDimension2), id:\.self) {jndex in
                            QuizCubeCellView(vcci: vccsh.getVerbCubeCellInfo(i: index, j: jndex),
                                                        columnWidth: CGFloat(600/vccsh.getHeaderStringList().count),
                                             cellData: vccsh.getCellData(i: index, j: jndex), useAlert: true)
                                                       
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    
}


extension QuizCubeView {
//
//    func resetCube(d1: VerbCubeDimension, d2: VerbCubeDimension){
//        let currentVerbType = vccsh.getCurrentShowVerbType()
//        vccsh = QuizCubeConjugatedStringHandlerStruct(languageEngine: languageEngine, quizCubeWatcher: quizCubeWatcher)
//        vccsh.setShowVerbType(currentVerbType: currentVerbType)
//    }

}
extension QuizCubeView {
    func dontShowVerbTypes(){
        specialVerbString = ""
        print(specialVerbString)
    }
    func showStemChanging(){
        specialVerbString = "🟡 Stem-changing"
    }
    func showOrthoChanging(){
        specialVerbString = "🟢 Ortho-changing"
    }
    func showIrregularChanging(){
        specialVerbString = "🔵 Irregular"
    }
}

extension QuizCubeView {
    func swipeUp(){
        setPreviousVerbs()
    }
    
    func swipeDown(){
        setNextVerbs()
    }
    
    func swipeRight(){
        switch vccsh.horizontalSwipeDimension {
        case .Verb:
            setPreviousVerbs()
        case .Tense:
            setPreviousTense()
        case .Person:
            setPreviousPerson()
        }
        
    }
    
    func swipeLeft(){
        switch vccsh.horizontalSwipeDimension  {
        case .Verb:
            setPreviousVerbs()
        case .Tense:
            setPreviousTense()
        case .Person:
            setPreviousPerson()
        }
        
    }
    
    func setPreviousTense() {
//        vccsh.setCurrentTense(tense: languageEngine.getPreviousTense())
//        vccsh.fillCellData()
    }
    
    func setNextTense() {
//        vccsh.setCurrentTense(tense: languageEngine.getNextTense())
//        vccsh.fillCellData()
    }
    
    func setNextVerbs() {
//        if vccsh.vcCurrentDimension == .Verb {
//            languageEngine.setNextVerbCubeVerb()
//        } else {
//            languageEngine.setNextVerbCubeBlockVerbs()
//        }
//        vccsh.fillCellData()
    }
    
    func setPreviousVerbs() {
//        if vccsh.vcCurrentDimension == .Verb {
//            languageEngine.setPreviousVerbCubeVerb()
//        } else {
//            languageEngine.setPreviousCubeBlockVerbs()
//        }
//        vccsh.fillCellData()
    }
    
    
    func setPreviousPerson(){
//        vccsh.setCurrentPerson(person: languageEngine.getPreviousPerson())
//        vccsh.fillCellData()
    }
    
    func setNextPerson(){
//        vccsh.setCurrentPerson(person: languageEngine.getNextPerson())
//        vccsh.fillCellData()
    }

    
    func fillVerbCubeConjugatedStrings(){
        vccsh.fillCellData()
    }

}
