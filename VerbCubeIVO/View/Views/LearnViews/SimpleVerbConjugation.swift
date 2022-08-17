//
//  AnalyzeVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/26/22.
//

import SwiftUI
import JumpLinguaHelpers
import AVFoundation

struct SimpleVerbConjugation: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    @State var verb = Verb()
    var residualPhrase: String
    @State var teachMeMode : TeachMeMode
    
//    var bethanyBackgroundColor = Color("BethanyNavalBackground")
//    var bethanyTextColor = Color("BethanyGreenText")
//    var bethanyButtonColor = Color("BethanyPurpleButtons")
    var cycleThroughIcon = Image("arrow.triangle.2.circlepath")
    var navigationIcon = Image("chevron.right")
    
    var newVerb : Bool = false
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var isBackward = false
    @State var stemColor = Color.white
    @State var orthoColor = Color.white
    @State var irregularColor = Color.white
    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State var subjunctiveWord = "que "
    
    @State var vvm = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    @State var person = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    var vu = VerbUtilities()
    @State var isSubjunctive = false
    @State private var bValidVerb = true
    @State var isSwiping = true
    @State var startPos : CGPoint = .zero
    @State var newVerbString = ""
    @State var verbModelString = ""
    @State private var isNameValid = false
    @State private var isAnalyzed = false
    @FocusState private var textFieldFocus : Bool
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            ScrollView{
                Text("Simple Verb Conjugation").font(.title2).foregroundColor(Color("ChuckText1"))
                HStack{
                    Text("Current verb")
                    Text(currentVerbPhrase).bold().font(.title3).foregroundColor(Color("BethanyGreenText"))
                }.foregroundColor(Color("ChuckText1"))
                HStack{
                    Text("belongs to")
                    Text(verbModelString).bold().foregroundColor(Color("BethanyGreenText"))
                    Text("verb model")
                }.foregroundColor(Color("ChuckText1"))
               
                
                Button(action: {
                    currentTenseString = languageViewModel.getNextTense().rawValue
                    setCurrentVerb()
                }){
                    HStack{
                        Text("Tense: \(currentTenseString)")
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                    }
                    .modifier(ModelTensePersonButtonModifier())
                    
                }.buttonStyle(ThemeAnimationStyle())
                
                //            .disabled(currentVerbPhrase.isEmpty)
                
                
                if ( bValidVerb ){
                    VStack {
                        ForEach (0..<6){ i in
                            HStack {
                                Text(person[i])
                                    .foregroundColor(Color("ChuckText1"))
                                Text(vvm[i])
                                    .foregroundColor(Color("BethanyGreenText"))
                                Spacer()
                                Button{
                                    textToSpeech(text : "\(person[i]) \(vvm[i])", language: currentLanguage)
                                } label: {
                                    Image(systemSymbol: .speakerWave1Fill).foregroundColor(Color("BethanyGreenText"))
                                }
                            }.frame(width: 350, height:30)
                                .background(Color("BethanyNavalBackground"))
                                .padding(.horizontal)
                                
                        }
                        VStack{
                            if teachMeMode == .model {
                                VStack{
                                   
                                    NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                                        HStack{
                                            HStack{
                                                Text("Conjugate")
                                                Text("this verb").foregroundColor(.red)
                                                Text("step-by-step")
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                                        }.modifier(ModelTensePersonButtonModifier())
                                    }.buttonStyle(ThemeAnimationStyle())
                                    NavigationLink(destination: MultiVerbMorphView(languageViewModel: languageViewModel)){
                                        HStack{
                                            HStack{
                                                Text("Conjugate")
                                                Text("this model").foregroundColor(.red)
                                                Text("step-by-step")
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right").foregroundColor(.yellow)
                                        }.modifier(ModelTensePersonButtonModifier())
                                    }.buttonStyle(ThemeAnimationStyle())
                                }
                            } else {
                                NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                                    HStack{
                                        NavigationLink(destination: MultiVerbMorphView(languageViewModel: languageViewModel)){
                                            HStack{
                                                HStack{
                                                    Text("Conjugate")
                                                    Text("this model").foregroundColor(.red)
                                                    Text("step-by-step")
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                                            }.modifier(ModelTensePersonButtonModifier())
                                        }.buttonStyle(ThemeAnimationStyle())
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundColor(.yellow)
                                    }.modifier(ModelTensePersonButtonModifier())
                                }.buttonStyle(ThemeAnimationStyle())
                            }
                        }
                    }
                    .background(Color("BethanyNavalBackground"))
                    .padding(10)
                    
                    .onAppear {
                        currentVerbPhrase = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//                        print("onAppear1: currentVerbPhrase: \(currentVerbPhrase)")
                        languageViewModel.setTeachMeMode(teachMeMode: teachMeMode)
                        currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                        switch teachMeMode {
                        case .regular:
                            languageViewModel.addVerbToFilteredList(verb: verb)
                        case .model, .subjunctive, .compound, .reflexive, .none:
                            languageViewModel.addVerbToFilteredList(verb: verb)
                        }
                        setCurrentVerb()
                    }
                    processTextField()
                    Spacer()
                }
            }
            .background( Color("BethanyNavalBackground") )
            
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
                        if self.startPos.x > gesture.location.x && yDist < xDist {
                            setPreviousTense()
                        }
                        else if self.startPos.x < gesture.location.x && yDist < xDist {
                            setNextTense()
                        }
                        self.isSwiping.toggle()
                    }
                    )
            
        }//ZStack
    }
    
    func isValidVerb(language: LanguageType, verbString: String)->Bool{
        let vu = VerbUtilities()
        switch language{
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: verbString)
            if result.0.count > 3 {
                if result.1 == .AR || result.1 == .ER || result.1 == .IR || result.1 == .accentIR { return true }
            }
            return false
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: verbString)
            if result.0.count > 3 && (result.1 == .IR || result.1 == .ER || result.1 == .OIR || result.1 == .RE ){ return true }
            return false
        default: return false
        }
    }

    func setNextTense(){
        currentTense = languageViewModel.getLanguageEngine().getNextTense()
        currentTenseString = currentTense.rawValue
        setCurrentVerb()
    }

    func setPreviousTense(){
        currentTense = languageViewModel.getLanguageEngine().getPreviousTense()
        currentTenseString = currentTense.rawValue
        setCurrentVerb()
    }

    func setCurrentVerb(){
        currentVerbPhrase = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        setSubjunctiveStuff()
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: languageViewModel.getCurrentTense())
        let brv = languageViewModel.createAndConjugateAgnosticVerb(verb: verb)
        verbModelString = brv.getBescherelleModelVerb()
        //set the persons here
        var msm = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        for i in 0..<6 {
            vvm.append(msm.getFinalVerbForm(person: Person.all[i]) + " " + residualPhrase)
            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType(), verbStartsWithVowel: vu.startsWithVowelSound(characterArray: vvm[i]))
        }
//        print("setCurrentVerb: currentVerbPhrase: \(currentVerbPhrase)")
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if languageViewModel.getCurrentTense().isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    @ViewBuilder
    func processTextField()->some View{
        VStack{
            HStack{
                Text("New verb").foregroundColor(Color("BethanyGreenText"))
                TextField("Type here.  Enter when done.", text: $newVerbString)
                    .focused($textFieldFocus, equals: true)
                    .disableAutocorrection(true)
                    .modifier(NeumorphicTextfieldModifier())
                    .onChange(of: newVerbString){ (value) in
                        if isValidVerb(language: languageViewModel.getCurrentLanguage(), verbString: value) {
                            isNameValid = true
                        } else {
                            isNameValid = false
                        }
                        isAnalyzed = false
                    }
                    .onSubmit(){
                        if isValidVerb(language: languageViewModel.getCurrentLanguage(), verbString: newVerbString) {
                            verb = analyze(verbString: newVerbString)
                            let result = vu.analyzeSpanishWordPhrase(testString: newVerbString)
                            //reconstruct the verb phrase, eliminating spaces, erroneous symbols, etc.
                            var reconstructedVerbString = result.0
                            if result.isReflexive {  reconstructedVerbString += "se" }
                            if result.residualPhrase.count > 0 { reconstructedVerbString += " " + result.residualPhrase }
                            //make it into a Verb
//                            residualPhrase = result.2
                            verb = Verb(spanish: reconstructedVerbString, french: "", english: "")
                            newVerbString = verb.getWordAtLanguage(language: currentLanguage)
                            currentVerbPhrase = verb.getWordAtLanguage(language: currentLanguage)
                            isAnalyzed = true
                            setCurrentVerb()
                            newVerbString = ""
                        }
                    }
                Button(action: {
                    newVerbString = ""
                },
                       label: {  Text("X")
                        .font(.title2)
                        .foregroundColor(Color("BethanyGreenText"))
                })
            }.frame(width: 350)
                .padding(.horizontal)
        }
    }

    
    func analyze(verbString: String)-> Verb{
        let vu = VerbUtilities()
        var verb = Verb()
        switch languageViewModel.getCurrentLanguage(){
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: newVerbString)
            verb = Verb(spanish: result.0, french: "", english: "")

        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: newVerbString)
            verb = Verb(spanish: "", french:  result.0, english:  "")
        default:
            return verb
        }
        return verb
    }
}



