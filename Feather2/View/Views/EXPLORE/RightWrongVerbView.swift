//
//  AnalyzeVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/26/22.
//

import SwiftUI
import JumpLinguaHelpers

struct RightWrongVerbView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Verbs"  
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 1A"
    @AppStorage("V2MLesson") var currentV2mLesson = "Useful verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "ser"
    
    @State var residualPhrase: String = ""
    @State var newVerb : Bool = false
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var currentVerb = Verb()
    @State var currentModelString = ""
    @State var isReflexive = false
    @State var stemColor = Color.white
    @State var orthoColor = Color.white
    @State var irregularColor = Color.white
    @State var newVerbPhrase = ""
    @State var subjunctiveWord = "que "
    @State var rightPhrase = ["", "", "", "", "", ""]
    @State var wrongPhrase = ["", "", "", "", "", ""]
    
    @State var vvm = ["", "", "", "", "", ""]
    @State var vvr = ["", "", "", "", "", ""]
    @State var person = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    var vu = VerbUtilities()
    @State var isSubjunctive = false
    @State private var bValidVerb = true
    @State private var isRight = true
    @State private var verbModelVerb = ""
    var fontSize = Font.footnote
    @State var specialVerbType = SpecialVerbType.normal
    @State private var number = Number.singular
    @State private var dependentVerb = Verb()
    @State private var isAnalyzed = false
    @State private var stemString =  ""
    @State private var orthoString = ""
    @State private var currentVerbModel = RomanceVerbModel()
    @State var startPos : CGPoint = .zero
    @State var isSwiping = true
    @State var color = Color.red.opacity(0.4)
    @State var direction = ""
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        router.reset()
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .font(.title2)
                            .padding(20)
                    })
                    Spacer()
                    Text("Right & Wrong").font(.title2).bold().foregroundColor(Color("BethanyGreenText"))
                    Spacer()
                }
                
                setVerbAndTenseView()
                HStack{
                    if languageViewModel.isModelMode() {
                        Text("Model: \(currentVerbModelString)").font(.caption)
                    }
                    else {
                        VStack{
                            Text("Chapter: \(currentV2mChapter)")
                            Text("Lesson: \(currentV2mLesson)")
                        }.font(.caption)
                    }
                }.modifier(ClearButtonModifier())
                if ( bValidVerb ){
                    
                    VStack {
                        HStack {
                            Text("")
                                .frame(width: 100, height: 20, alignment: .trailing)
                            Text("Right")
                                .frame(width:200, height:20, alignment: .trailing)
//                                .background(.green )
//                                .foregroundColor(.black)
                            Text("As Regular")
                                .frame(width:200, height:20, alignment: .trailing)
//                                .background(.yellow)
//                                .foregroundColor(.black)
                        }.font(fontSize)
                        Divider().background(Color.orange)
                        ForEach (0..<6){ i in
                            HStack{
                                Text(person[i])
                                    .frame(width: 100, height: 20, alignment: .trailing)
                                    .background(rightPhrase[i] == wrongPhrase[i] ? .white : .red  )
                                    .foregroundColor(.black)
//                                    .foregroundColor(vvm[i] == vvr[i] ? .black : .yellow)
                                
                                Text(vvm[i])
                                    .frame(width: 200, height: 20, alignment: .trailing)
//                                    .background(.green )
                                    .foregroundColor(Color("BethanyGreenText"))
                                    .animation(Animation.linear(duration: 1), value: isAnalyzed)
                                
                                Text(vvr[i])
                                    .frame(width: 200, height: 20, alignment: .trailing)
//                                    .background(.yellow)
                                    .foregroundColor(Color("BethanyGreenText"))
                                    .animation(Animation.linear(duration: 2), value: isAnalyzed)
                            }.font(fontSize)
                        }
                        Divider().background(Color("BethanyNavalBackground"))
                    }
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            if self.isSwiping {
                                self.startPos = gesture.location
                                self.isSwiping.toggle()
                            }
                            //                    print("Swiped")
                        }
                        .onEnded { gesture in
                            let xDist =  abs(gesture.location.x - self.startPos.x)
                            let yDist =  abs(gesture.location.y - self.startPos.y)
                            if self.startPos.y <  gesture.location.y && yDist > xDist {
                                self.direction = "Down"
                                self.color = Color.green.opacity(0.4)
                                getNextTense()
                            }
                            else if self.startPos.y >  gesture.location.y && yDist > xDist {
                                self.direction = "Up"
                                self.color = Color.blue.opacity(0.4)
                                getPreviousTense()
                            }
                            else if self.startPos.x > gesture.location.x + 10 && yDist < xDist {
                                self.direction = "Left"
                                self.color = Color.yellow.opacity(0.4)
                                getNextVerb()
                            }
                            else if self.startPos.x < gesture.location.x + 10 && yDist < xDist {
                                self.direction = "Right"
                                self.color = Color.purple.opacity(0.4)
                                getPreviousVerb()
                            }
                            self.isSwiping.toggle()
                            //                    print("gesture here")
                        }
                    )
                    .onDisappear {
                        AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
                    }
                    .onAppear {
                        AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                        UINavigationController.attemptRotationToDeviceOrientation()
                        currentTense = languageViewModel.getCurrentTense()
                        currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                        currentVerb = languageViewModel.getCurrentFilteredVerb()
                        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
                        
                        currentTenseString = currentTense.rawValue
                        specialVerbType = languageViewModel.getStudyPackage().specialVerbType
                        dependentVerb = languageViewModel.findVerbFromString(verbString: "bailar", language: currentLanguage)
                        setCurrentVerb()
                    }
                    
                }
            }
            
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
        }
        
    }
    
    func getNextTense(){
        currentTense = languageViewModel.getLanguageEngine().getNextTense()
        currentTenseString = currentTense.rawValue
        setCurrentVerb()
    }

    func getPreviousTense(){
        currentTense = languageViewModel.getLanguageEngine().getPreviousTense()
        currentTenseString = currentTense.rawValue
        setCurrentVerb()
    }
    
    func getPreviousVerb(){
        languageViewModel.setPreviousFilteredVerb()
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        setCurrentVerb()
    }
    
    func getNextVerb(){
        languageViewModel.setNextFilteredVerb()
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        setCurrentVerb()
    }
    
    func setVerbAndTenseView() -> some View {
        VStack {
//            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
//                HStack{
//                    Text("Verb model:")
//                    Text(currentModelString)
//                    Spacer()
//                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
//                }
//                .modifier(ModelTensePersonButtonModifier())
//            }.task {
//                setCurrentVerb()
//            }
//
            HStack{    
                Button(action: {
                    getNextVerb()
                }){
                    HStack{
                        Text("Verb: ")
                        Text(currentVerbString)
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                    }.modifier(ModelTensePersonButtonModifier())
                }
                
                
                //ChangeTenseButtonView()
                
                Button(action: {
                    getNextTense()
                }){
                    Text("Tense: \(currentTenseString)")
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }
                .modifier(ModelTensePersonButtonModifier())
            }
        }
        
        .padding(3)
    }
    
    func setPatternStuff(){
        let patternList = languageViewModel.getPatternsForThisModel(verbModel: currentVerbModel)
        stemString = ""
        orthoString = ""
        for sps in patternList {
            if sps.tense == languageViewModel.getCurrentTense() {
                if sps.pattern.isStemChangingSpanish() { stemString = sps.pattern.rawValue }
                if sps.pattern.isSpellChangingSpanish() { orthoString = sps.pattern.rawValue }
            }
        }
    }
    
    func setCurrentVerb(){
        let vu = VerbUtilities()
        setSubjunctiveStuff()
        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        var result = vu.analyzeSpanishWordPhrase(testString: currentVerbString)
        currentVerbModel = languageViewModel.findModelForThisVerbString(verbWord: result.0)
        setPatternStuff()
        isReflexive = false
        residualPhrase = ""
        switch currentLanguage {
        case .Spanish:
            let result = VerbUtilities().analyzeSpanishWordPhrase(testString: currentVerbString)
            isReflexive = result.isReflexive
            residualPhrase = result.residualPhrase
        case .French:
            let result = VerbUtilities().analyzeFrenchWordPhrase(phraseString: currentVerbString)
            isReflexive = result.isReflexive
            residualPhrase = result.residualPhrase
        default:
            break
        }
        
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
        var thisVerb = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb())

        //set the persons here
        _ = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        vvr.removeAll()
        var pp = ""
        var rightPP = ""
        if languageViewModel.getCurrentTense().isProgressive(){
            rightPP = thisVerb.createGerund()
            pp = thisVerb.createDefaultGerund()
        } else if languageViewModel.getCurrentTense().isPerfectIndicative(){
            var verbString = thisVerb.m_verbWord
            rightPP = languageViewModel.getPastParticiple(verbString)
            pp = thisVerb.createDefaultPastParticiple()
            if rightPP.count == 0 { rightPP = pp}
        }
        var currentTense = languageViewModel.getCurrentTense()
        for i in 0..<6 {
            rightPhrase[i] = languageViewModel.getVerbString(personIndex: i, number: number, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerbString, dependentVerb: dependentVerb, residualPhrase: "")
            rightPhrase[i] = removeAllExtraBlanks(rightPhrase[i])
            if i == 0 && currentTense == .imperative { rightPhrase[i] = ""}
            vvm.append(rightPhrase[i])
            person[i] = languageViewModel.getPersonString(personIndex: i, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: vvm[i])
            if (pp.count > 0 ){
                wrongPhrase[i] = languageViewModel.conjugateAsRegularVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense(), person: Person.all[i], isReflexive: isReflexive, residPhrase: "") + pp + " " + residualPhrase
            } else {
                wrongPhrase[i] = languageViewModel.conjugateAsRegularVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense(), person: Person.all[i], isReflexive: isReflexive, residPhrase: residualPhrase) +  pp
            }
            wrongPhrase[i] = removeAllExtraBlanks(wrongPhrase[i])
            if i == 0 && currentTense == .imperative { wrongPhrase[i] = ""}
            vvr.append(wrongPhrase[i])
//            print("i: \(i).  rightPhrase \(rightPhrase[i]), wrongPhrase \(wrongPhrase[i])")
        }
        isAnalyzed.toggle()
    }
    
    func removeAllExtraBlanks(_ inputString: String)->String{
        let vu = VerbUtilities()
        
        let wordArray = vu.getListOfWords(characterArray: inputString)
        var outputString = ""
        for word in wordArray {
            outputString += word + " "
        }
        outputString = vu.removeLeadingOrFollowingBlanks(characterArray: outputString)
        return outputString
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
}



