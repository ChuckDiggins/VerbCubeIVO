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
    
    var residualPhrase: String = ""
    var newVerb : Bool = false
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var currentVerb = Verb()
    @State var currentModelString = ""
    @State var isBackward = false
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
    
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                Text("Right & Wrong").font(.title2).bold().foregroundColor(.white)
                setVerbAndTenseView()
                
                if ( bValidVerb ){
                    
                    VStack {
                        HStack {
                            Text("")
                                .frame(width: 100, height: 20, alignment: .trailing)
                            Text("Right")
                                .frame(width:200, height:20, alignment: .trailing)
//                                .background(.green )
//                                .foregroundColor(.black)
                            Text("Wrong")
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
            
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                currentVerb = languageViewModel.getCurrentFilteredVerb()
                setCurrentVerb()
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
                currentTense = languageViewModel.getLanguageEngine().getNextTense()
                currentTenseString = currentTense.rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
            }
            .modifier(ModelTensePersonButtonModifier())
            
        }
        
        .padding(3)
    }
    
    func setCurrentVerb(){
        setSubjunctiveStuff()
        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        var isReflexive = false
        var residPhrase = ""
        switch currentLanguage {
        case .Spanish:
            let result = VerbUtilities().analyzeSpanishWordPhrase(testString: currentVerbString)
            isReflexive = result.isReflexive
            residPhrase = result.residualPhrase
        case .French:
            let result = VerbUtilities().analyzeFrenchWordPhrase(phraseString: currentVerbString)
            isReflexive = result.isReflexive
            residPhrase = result.residualPhrase
        default:
            break
        }
        
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
        var thisVerb = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb())
        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()

        print("currentModelString = \(currentModelString)")
        print("currentVerbString = \(currentVerbString)")
        print("isReflexive = \(isReflexive)")

        //set the persons here
        var msm = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        vvr.removeAll()
        var pp = ""
        if languageViewModel.getCurrentTense().isProgressive(){
            pp = thisVerb.createDefaultGerund()
        } else if languageViewModel.getCurrentTense().isPerfectIndicative(){
            pp = thisVerb.createDefaultPastParticiple()
        }
         let vu = VerbUtilities()
        for i in 0..<6 {
            rightPhrase[i] = languageViewModel.getVerbString(personIndex: i, number: number, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerbString, dependentVerb: dependentVerb, residualPhrase: residualPhrase)
            rightPhrase[i] = vu.removeLeadingOrFollowingBlanks(characterArray: rightPhrase[i])
            vvm.append(rightPhrase[i])
            person[i] = languageViewModel.getPersonString(personIndex: i, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: vvm[i])
            wrongPhrase[i] = languageViewModel.conjugateAsRegularVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense(), person: Person.all[i], isReflexive: isReflexive, residPhrase: residPhrase) + pp
            wrongPhrase[i] = vu.removeLeadingOrFollowingBlanks(characterArray: wrongPhrase[i])
            vvr.append(wrongPhrase[i])
            print("i: \(i).  rightPhrase \(rightPhrase[i]), wrongPhrase \(wrongPhrase[i])")
        }
        isAnalyzed.toggle()
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
}



