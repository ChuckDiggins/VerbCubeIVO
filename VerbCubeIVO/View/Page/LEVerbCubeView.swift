//
//  LEVerbCubeView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/23/22.
//

import SwiftUI

struct LEVerbCubeView: View {
    @EnvironmentObject var languageEngine: LanguageEngine
    public var verbCount = 6
    @State var isSwiping = true
    @State var startPos : CGPoint = .zero
    @State var specialVerbString = ""
    @State var showVerbType = ShowVerbType.NONE
    @State var xCount = 0
    @State var yCount = 0
    @State var vccsh = VerbCubeConjugatedStringHandlerStruct()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                Text(specialVerbString)
                Spacer()
                CubeTypeButtons(changeVerbCubeDimension: changeVerbCubeDimension)
                ShowCube(vccsh: vccsh)
                HStack{
                    VerbTypeButtons(vccsh: languageEngine.vccshs)
                    
                //swipeButtons ... to do
                    
                    Spacer()
                    Button(action: { swipeUp()}){
                        Image(systemName: "arrowtriangle.up")
                    }
                    Text(vccsh.verticalSwipeDimension.rawValue ).foregroundColor(Color.black)
                    Button(action: { swipeDown()}){
                        Image(systemName: "arrowtriangle.down")
                    }
                    Spacer()
                    Button(action: {
                        swipeLeft()
                    }){
                        Image(systemName: "arrowtriangle.backward")
                    }
                    Text(vccsh.horizontalSwipeDimension.rawValue).foregroundColor(Color.black)
                    Button(action: {
                        swipeRight()
                    }){
                        Image(systemName: "arrowtriangle.forward")
                    }
//                    Spacer()
                    
                }.background(Color.yellow)
                    
                    .padding(10)
            }.navigationBarTitle("Verb Cube - \(languageEngine.vccshs.vcDimension1.rawValue) v \(languageEngine.vccshs.vcDimension2.rawValue)")
        }
        .onAppear{
            vccsh = languageEngine.vccshs
            xCount = vccsh.conjStringArrayDimension1
            yCount = vccsh.conjStringArrayDimension2
        }
        .gesture(DragGesture()
        .onChanged { gesture in
            if self.isSwiping {
                self.startPos = gesture.location
                self.isSwiping.toggle()
            }
        }
                    .onEnded { gesture in
            let xDist =  abs(gesture.location.x - self.startPos.x)
            let yDist =  abs(gesture.location.y - self.startPos.y)
            if self.startPos.y <  gesture.location.y && yDist > xDist {
                swipeDown()
            }
            else if self.startPos.y >  gesture.location.y && yDist > xDist {
                swipeUp()
            }
            
            else if self.startPos.x > gesture.location.x && yDist < xDist {
                swipeLeft()
            }
            else if self.startPos.x < gesture.location.x && yDist < xDist {
                swipeRight()
            }
            self.isSwiping.toggle()
        }
        )
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
        var body: some View {
        HStack{
            HStack{
                Button(action: { changeVerbCubeDimension(.Person, .Verb)}){
                    Text("PV")
                }
                Button(action: { changeVerbCubeDimension(.Verb, .Person)}){
                    Text("VP")
                }
                Button(action: { changeVerbCubeDimension(.Person, .Tense)}){
                    Text("PT")
                }
                Button(action: { changeVerbCubeDimension(.Tense, .Person)}){    //change active button to yellow
                    Text("TP")
                }
                Button(action: { changeVerbCubeDimension(.Tense, .Verb)}){
                    Text("TV")
                }
                Button(action: { changeVerbCubeDimension(.Verb, .Tense)}){
                    Text("VT")
                }
            }
            Spacer()
        }
        }
    }
    
    struct ShowCube: View {
        var body: some View {
            VStack (spacing: 0){
                CreateLineOfHeaderCells()
                CreateGridOfConjugatedCells()
            }
        }
    }
    
    struct CreateLineOfHeaderCells: View {
//        var vccsh : VerbCubeConjugatedStringHandlerStruct
        var body: some View {
            //show the verb conjugations here
            HStack(spacing: 0){
                //first cell is actually a button
                
                VerbCubeCellView(cellColor: .yellow, cellString: vccsh.getCornerWord())
                
                //these cells are the headers
                
                ForEach(vccsh.getHeaderStringList(), id:\.self) { str in
                    VerbCubeCellView(cellColor: .green, cellString: str)
                }
                Spacer()
            }
            
        }
    }
    
    struct CreateGridOfConjugatedCells: View {
        
        var body: some View {
            VStack(spacing: 0){
                ForEach((0 ..< xCount), id:\.self) { index in
                    HStack(spacing: 0){
                        VerbCubeCellView(cellColor: .blue, cellString: languageEngine.vccshs.getFirstColumnStringValue(i: index) )
                        ForEach(( 0 ..< yCount), id:\.self) {jndex in
                            InteractiveVerbCubeCellView(vcci: languageEngine.vccshs.getVerbCubeCellInfo(i: index, j: jndex),
                                                        cellData: vccsh.getCellData(i: index, j: jndex))
                                                       
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    
}


extension LEVerbCubeView {
    
    
    func changeVerbCubeDimension(d1: VerbCubeDimension, d2: VerbCubeDimension){
        vccsh = VerbCubeConjugatedStringHandlerStruct(d1: d1, d2: d2)
    }

}
extension LEVerbCubeView {
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

extension LEVerbCubeView {
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
    
    func LEVerbCubeView(){
        switch vccsh.horizontalSwipeDimension  {
        case .Verb:
            setPreviousVerbs()
        case .Tense:
            setPreviousTense()
        case .Person:
            setPreviousPerson()
        }
        
    }
    
    func LEVerbCubeView() {
        vccsh.setCurrentTense(tense: languageEngine.getPreviousTense())
        vccsh.fillCellData()
    }
    
    func LEVerbCubeView() {
        vccsh.setCurrentTense(tense: languageEngine.getNextTense())
        vccsh.fillCellData()
    }
    
    func LEVerbCubeView() {
        if vccsh.vcCurrentDimension == .Verb {
            languageEngine.setPreviousVerb()
            vccsh.setCurrentVerb(verb: languageEngine.getCurrentVerb())
        } else {
            vccsh.setVerbs(verbs: languageEngine.getNextVerbCubeVerbs(count: verbCount))
        }
        vccsh.fillCellData()
    }
    
    func LEVerbCubeView() {
        if vccsh.vcCurrentDimension == .Verb {
            languageEngine.setNextVerb()
            vccsh.setCurrentVerb(verb: languageEngine.getCurrentVerb())
        } else {
            vccsh.setVerbs(verbs: languageEngine.getPreviousCubeVerbs(count: verbCount))
        }
        vccsh.fillCellData()
    }
    
    
    func LEVerbCubeView(){
        vccsh.setCurrentPerson(person: languageEngine.getPreviousPerson())
        vccsh.fillCellData()
    }
    
    func LEVerbCubeView(){
        vccsh.setCurrentPerson(person: languageEngine.getNextPerson())
        vccsh.fillCellData()
    }

    
    func LEVerbCubeView(){
        vccsh.setTenses(tenses: languageEngine.getTenseList())
        vccsh.setVerbs(verbs: languageEngine.getPreviousCubeVerbs(count: verbCount))
        vccsh.setCurrentVerb(verb: languageEngine.getCurrentVerb())
        vccsh.fillCellData()
//        vccsh?.dumpConjugateStringArray()
    }
    
}

struct LEVerbCubeView_Previews: PreviewProvider {
    static var previews: some View {
        LEVerbCubeView()
    }
}
