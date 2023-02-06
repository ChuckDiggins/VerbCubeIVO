//
//  VerbCubeView.swift
//  VerbCubeView
//
//  Created by Charles Diggins on 2/17/22.
//

import SwiftUI
import JumpLinguaHelpers


struct VerbCubeView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State public var vccsh : VerbCubeConjugatedStringHandlerStruct
    public var verbCount = 6
    @State var isSwiping = true
    @State var startPos : CGPoint = .zero
    @State var specialVerbString = ""
    @State var showVerbType = ShowVerbType.NONE
    @State var showVerbTypeColor = Color.red
    
    var body: some View {
//        NavigationView{
            VStack(spacing: 0){
//                Text("Verb Cube - \(vccsh.vcDimension1.rawValue) v \(vccsh.vcDimension2.rawValue)").font(.largeTitle)
                HStack{
                    Text("Highlight:")
                    Text(showVerbType.rawValue)
                        .foregroundColor(showVerbTypeColor)
                    HStack{
                        Button(action: {
                            vccsh.setShowVerbType(currentVerbType: .NONE)
                            showVerbType = vccsh.getCurrentShowVerbType()
                            showVerbTypeColor = .red
                        }){
                            Text("🔴")
                        }
                        Button(action: {
                            vccsh.setShowVerbType(currentVerbType: .STEM)
                            showVerbType = vccsh.getCurrentShowVerbType()
                            showVerbTypeColor = .yellow
                        }){
                            Text("🟡")
                        }
                        Button(action: {
                            vccsh.setShowVerbType(currentVerbType: .ORTHO)
                            showVerbType = vccsh.getCurrentShowVerbType()
                            showVerbTypeColor = .green
                        }){
                            Text("🟢")
                        }
                        Button(action: {
                            vccsh.setShowVerbType(currentVerbType: .IRREG)
                            showVerbType = vccsh.getCurrentShowVerbType()
                            showVerbTypeColor = .blue
                        }){
                            Text("🔵")
                        }
                    }
                    Spacer()
                    CubeTypeButtons(changeVerbCubeDimension: changeVerbCubeDimension)
                }
                ShowCube(vccsh: vccsh)
                HStack{
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
                    Spacer()
                    
                }.background(Color.yellow)
                    .padding(10)
                Spacer()
            }
            .onAppear{
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
//                        UINavigationController.attemptRotationToDeviceOrientation()
            }
//            .onDisappear{
//                AppDelegate.orientationLock = UIInterfaceOrientationMask.all
//            }
            .navigationTitle(Text("Verb Cube - \(vccsh.vcDimension1.rawValue) v \(vccsh.vcDimension2.rawValue)"))
        
//        }
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
                Button(action: {
                    vccsh.setShowVerbType(currentVerbType: .SPECIAL)
                }){
                    Text("🟣")
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
                ForEach(0..<data.count, id:\.self){i in
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
                        Text(data[i]).foregroundColor(active[i] ? .yellow : .cyan)
                    }
                }
            }.background(.black).opacity(0.8)
                .padding()
        }
        
        func setAllInactive(){
            for i in 0..<active.count {
                active[i] = false
            }
        }
        

    }
    
    struct ShowCube: View {
        var vccsh : VerbCubeConjugatedStringHandlerStruct
        var body: some View {
            VStack (spacing: 0){
                CreateLineOfHeaderCells(vccsh: vccsh)
                CreateGridOfConjugatedCells(vccsh: vccsh)
            }
        }
    }
    
    struct CreateLineOfHeaderCells: View {
        var vccsh : VerbCubeConjugatedStringHandlerStruct
        
        var body: some View {
            //show the verb conjugations here
            HStack(spacing: 0){
                //first cell is actually a button
                
                VerbCubeCellView(cellColor: .yellow, columnWidth: vccsh.getColumnWidth(), cellString: vccsh.getCornerWord())
                
                //these cells are the headers
                
                ForEach(vccsh.getHeaderStringList(), id:\.self) { str in
                    VerbCubeCellView(cellColor: .green, columnWidth: vccsh.getColumnWidth(), cellString: str)
                }
                Spacer()
            }
            
        }
    }
    
    struct CreateGridOfConjugatedCells: View {
        var vccsh : VerbCubeConjugatedStringHandlerStruct
        
        var body: some View {
            VStack(spacing: 0){
                ForEach((0..<vccsh.conjStringArrayDimension1), id:\.self) { index in
                    HStack(spacing: 0){
                        VerbCubeCellView(cellColor: .blue, columnWidth: vccsh.getColumnWidth(), cellString: vccsh.getFirstColumnStringValue(i: index) )
                        ForEach((0..<vccsh.conjStringArrayDimension2), id:\.self) {jndex in
                            InteractiveVerbCubeCellView(vcci: vccsh.getVerbCubeCellInfo(i: index, j: jndex),
                                                        columnWidth: vccsh.getColumnWidth(),
                                                        cellData: vccsh.getCellData(i: index, j: jndex))
                                                       
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    
    
}


extension VerbCubeView {
    
    
    func changeVerbCubeDimension(d1: VerbCubeDimension, d2: VerbCubeDimension){
        let currentVerbType = vccsh.getCurrentShowVerbType()
        vccsh = VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1: d1, d2: d2)
        vccsh.setShowVerbType(currentVerbType: currentVerbType)
    }

}
extension VerbCubeView {
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

extension VerbCubeView {
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
        vccsh.setCurrentTense(tense: languageViewModel.getPreviousTense())
        vccsh.fillCellData()
    }
    
    func setNextTense() {
        vccsh.setCurrentTense(tense: languageViewModel.getNextTense())
        vccsh.fillCellData()
    }
    
    func setNextVerbs() {
        if vccsh.vcCurrentDimension == .Verb {
            languageViewModel.setNextVerbCubeVerb()
        } else {
            languageViewModel.setNextVerbCubeBlockVerbs()
        }
        vccsh.fillCellData()
    }
    
    func setPreviousVerbs() {
        if vccsh.vcCurrentDimension == .Verb {
            languageViewModel.setPreviousVerbCubeVerb()
        } else {
            languageViewModel.setPreviousCubeBlockVerbs()
        }
        vccsh.fillCellData()
    }
    
    
    func setPreviousPerson(){
        vccsh.setCurrentPerson(person: languageViewModel.getPreviousPerson())
        vccsh.fillCellData()
    }
    
    func setNextPerson(){
        vccsh.setCurrentPerson(person: languageViewModel.getNextPerson())
        vccsh.fillCellData()
    }

    
    func fillVerbCubeConjugatedStrings(){
        vccsh.setTenses(tenses: languageViewModel.getTenseList())
        languageViewModel.setPreviousCubeBlockVerbs()
        languageViewModel.getCurrentVerbCubeVerb()
        vccsh.fillCellData()
//        vccsh?.dumpConjugateStringArray()
    }
    
}
