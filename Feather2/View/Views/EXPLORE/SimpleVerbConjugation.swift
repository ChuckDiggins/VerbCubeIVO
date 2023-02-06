//
//  AnalyzeVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/26/22.
//

import SwiftUI
import JumpLinguaHelpers
import AVFoundation

//struct PlainSimpleVerbConjugation: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @Environment(\.presentationMode) var presentationMode
//
//    @State var currentLanguage = LanguageType.Agnostic
//    @State var verb = Verb()
//    var residualPhrase: String
//    @State var multipleVerbFlag = false
//    var cycleThroughIcon = Image("arrow.triangle.2.circlepath")
//    var navigationIcon = Image("chevron.right")
//
//    var newVerb : Bool = false
//
//    @State var currentTense = Tense.present
//    @State var currentTenseString = ""
//    @State var currentVerbString = ""
//    @State var isBackward = false
//    @State var stemColor = Color.white
//    @State var orthoColor = Color.white
//    @State var irregularColor = Color.white
//    @State var currentVerbPhrase = ""
//    @State var newVerbPhrase = ""
//    @State var subjunctiveWord = "que "
//
//    @State var vvm = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
//    @State var person = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
//    var vu = VerbUtilities()
//    @State var isSubjunctive = false
//    @State private var bValidVerb = true
//    @State var isSwiping = true
//    @State var startPos : CGPoint = .zero
//    @State var newVerbString = ""
//    @State var verbModelString = ""
//    @State private var isNameValid = false
//    @State private var isAnalyzed = false
//    @FocusState private var textFieldFocus : Bool
//
//    var body: some View {
//        VStack{
////            Color("BethanyNavalBackground")
////                .ignoresSafeArea()
////
////
//
//            Text("Simple Verb Conjugation").font(.title2).foregroundColor(Color("ChuckText1"))
//
//            VStack{
//                CurrentVerbButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
//                TenseButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
////                Button(action: {
////                    currentTenseString = languageViewModel.getNextTense().rawValue
////                    setCurrentVerb()
////                }){
////                    HStack{
////                        Text("Tense: \(currentTenseString)")
////                        Spacer()
////                        Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
////                    }
////                    .modifier(ModelTensePersonButtonModifier())
////
////                }.buttonStyle(ThemeAnimationStyle())
//
//                //            .disabled(currentVerbPhrase.isEmpty)
//
//
//                VStack {
//                    ForEach (0..<6){ i in
//                        HStack {
//                            Text(person[i])
//                                .foregroundColor(Color("ChuckText1"))
//                            Text(vvm[i])
//                                .foregroundColor(Color("BethanyGreenText"))
//                                .animation(.default.delay(1.0), value: isAnalyzed) // Delay the animation
//                            Spacer()
//                            Button{
//                                textToSpeech(text : "\(person[i]) \(vvm[i])", language: currentLanguage)
//                            } label: {
//                                Image(systemName: "speaker.wave.3.fill").foregroundColor(Color("BethanyGreenText"))
//                            }
//                        }.frame(width: 350, height:30)
//                            .background(Color("BethanyNavalBackground"))
//                            .padding(.horizontal)
//
//
//                    }
//                    Button("Press to Dismiss"){
//                        presentationMode.wrappedValue.dismiss()
//                    } .padding(5)
//                        .background(Color.black)
//                        .foregroundColor(.yellow)
//                        .cornerRadius(8)
//                        .font(.subheadline)
//                    Spacer()
//                    .background(Color("BethanyNavalBackground"))
//                    .padding(10)
//
//                    .onAppear {
//                        currentVerbPhrase = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
////                        print("onAppear1: currentVerbPhrase: \(currentVerbPhrase)")
//                        currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
//                        setCurrentVerb()
//                    }
//
//                }
//            }
//            .onAppear{
//                currentVerbString = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//            }
//            .background( Color("BethanyNavalBackground") )
//            .gesture(DragGesture()
//                .onChanged { gesture in
//                    if self.isSwiping {
//                        self.startPos = gesture.location
//                        self.isSwiping.toggle()
//                    }
//                }
//                .onEnded { gesture in
//                    let xDist =  abs(gesture.location.x - self.startPos.x)
//                    let yDist =  abs(gesture.location.y - self.startPos.y)
//                    if self.startPos.x > gesture.location.x && yDist < xDist {
//                        setPreviousTense()
//                    }
//                    else if self.startPos.x < gesture.location.x && yDist < xDist {
//                        setNextTense()
//                    }
//                    self.isSwiping.toggle()
//                }
//            )
//
//        }//ZStack
//    }
//
//    func setNextTense(){
//        currentTense = languageViewModel.getLanguageEngine().getNextTense()
//        currentTenseString = currentTense.rawValue
//        setCurrentVerb()
//    }
//
//    func setPreviousTense(){
//        currentTense = languageViewModel.getLanguageEngine().getPreviousTense()
//        currentTenseString = currentTense.rawValue
//        setCurrentVerb()
//    }
//
//    func setSubjunctiveStuff(){
//        subjunctiveWord = ""
//        if languageViewModel.getCurrentTense().isSubjunctive() {
//            if currentLanguage == .French { subjunctiveWord = "qui "}
//            else {subjunctiveWord = "que "}
//        }
//    }
//
//    func analyze(verbString: String)-> Verb{
//        let vu = VerbUtilities()
//        var verb = Verb()
//        switch languageViewModel.getCurrentLanguage(){
//        case .Spanish:
//            let result = vu.analyzeSpanishWordPhrase(testString: newVerbString)
//            verb = Verb(spanish: result.0, french: "", english: "")
//
//        case .French:
//            let result = vu.analyzeFrenchWordPhrase(phraseString: newVerbString)
//            verb = Verb(spanish: "", french:  result.0, english:  "")
//        default:
//            return verb
//        }
//        return verb
//    }
//
//    func setCurrentVerb(){
//        currentVerbPhrase = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//        setSubjunctiveStuff()
//        currentTenseString = languageViewModel.getCurrentTense().rawValue
//        languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: languageViewModel.getCurrentTense())
//        let brv = languageViewModel.createAndConjugateAgnosticVerb(verb: verb)
//        verbModelString = brv.getBescherelleModelVerb()
//        //set the persons here
//        var msm = languageViewModel.getMorphStructManager()
//        vvm.removeAll()
//        for i in 0..<6 {
//            vvm.append(msm.getFinalVerbForm(person: Person.all[i]) + " " + residualPhrase)
//            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(),
//                                        subjectPronounType: languageViewModel.getSubjectPronounType(),
//                                        verbStartsWithVowel: vu.startsWithVowelSound(characterArray: vvm[i]))
//        }
//        isAnalyzed.toggle()
//    }
//}
//


struct SimpleVerbConjugation: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    @State var verb = Verb()
    var residualPhrase: String
    @State var multipleVerbFlag = false
    
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
    @State var specialVerbType = SpecialVerbType.normal
    @State private var number = Number.singular
    @State private var dependentVerb = Verb()
    @State var currentVerbModel = RomanceVerbModel()
    @State var stemString = ""
    @State var orthoString = ""
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            ScrollView{
                ExitButtonView()
                
                //                PreferencesButtonView(languageViewModel: languageViewModel).foregroundColor(Color("BethanyGreenText"))
                Text("Simple Verb Conjugation").font(.title2).foregroundColor(Color("ChuckText1"))
                //                HStack{
                //                    Text("Current verb")
                //                    Text(currentVerbPhrase).bold().font(.title3).foregroundColor(Color("BethanyGreenText"))
                //                }.foregroundColor(Color("ChuckText1"))
                //
                CurrentVerbButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                TenseButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                HStack{
                    Text("Model verb: \(currentVerbModel.modelVerb)")
                    if stemString.count > 0 { Text("(\(stemString))") }
                    if orthoString.count > 0 { Text("(\(orthoString))")  }
                }.modifier(ClearButtonModifier())
                
                //            .disabled(currentVerbPhrase.isEmpty)
                
                
                if ( bValidVerb ){
                    VStack {
                        ForEach (0..<6){ i in
                            HStack {
                                Text(person[i])
                                    .foregroundColor(Color("ChuckText1"))
                                Text(vvm[i])
                                    .foregroundColor(Color("BethanyGreenText"))
                                    .animation(Animation.linear(duration: 1), value: isAnalyzed)
                                
                                Spacer()
                                Button{
                                    textToSpeech(text : "\(person[i]) \(vvm[i])", language: currentLanguage)
                                } label: {
                                    Image(systemName:"speaker.wave.3.fill").foregroundColor(Color("BethanyGreenText"))
                                }
                            }.frame(width: 350, height:30)
                                .background(Color("BethanyNavalBackground"))
                                .padding(.horizontal)
                            
                            
                        }
                        
                    }
                    .background(Color("BethanyNavalBackground"))
                    .padding(10)
                    
                    .onAppear {
                        //                        dependentVerb = languageViewModel.getRandomVerb()  //for use with auxiliary verbs
                        //                        specialVerbType = languageViewModel.getStudyPackage().specialVerbType
                        //                        print("SimpleVerbConjugation: specialVerbType = \(specialVerbType.rawValue)")
                        currentVerbPhrase = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
                        //                        print("onAppear1: currentVerbPhrase: \(currentVerbPhrase)")
                        currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                        languageViewModel.addVerbToFilteredList(verb: verb)
                        setCurrentVerb()
                        if languageViewModel.getSelectedVerbModelList().count > 0 {
                            verbModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
                        }
                        verbModelString = languageViewModel.getStudyPackage().name
                        multipleVerbFlag = false
                        if languageViewModel.getFilteredVerbs().count > 1 {
                            //                            for v in languageViewModel.getFilteredVerbs(){
                            //                                print("SimpleVerbConjugation: \(v.getWordAtLanguage(language: .Spanish))")
                            //                            }
                            multipleVerbFlag = true
                        }
                        setSubjunctiveStuff()
                        
                    }
                    //                    processTextField()
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
        //        currentVerbPhrase = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        //        setSubjunctiveStuff()
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        setSubjunctiveStuff()
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        //extracts the core verb in presence of reflexives and/or verb phrases
        let result = VerbUtilities().analyzeSpanishWordPhrase(testString: currentVerbString)
        currentVerbModel = languageViewModel.findModelForThisVerbString(verbWord: result.verbWord)
        setPatternStuff()
        //        var msm = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        for i in 0..<6 {
            var vs = languageViewModel.getVerbString(personIndex: i, number: number, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerbPhrase, dependentVerb: dependentVerb, residualPhrase: residualPhrase)
            if languageViewModel.getCurrentTense() == .imperative && i == 0 {
                vs = ""
            }
            vvm.append(vs)
            person[i] = subjunctiveWord + languageViewModel.getPersonString(personIndex: i, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: vvm[i])
        }
        isAnalyzed.toggle()
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
                            let vm = languageViewModel.findModelForThisVerbString(verbWord: reconstructedVerbString)
                            if ( vm.id > 0 ){
                                if result.isReflexive {  reconstructedVerbString += "se" }
                                if result.residualPhrase.count > 0 { reconstructedVerbString += " " + result.residualPhrase }
                                verb = Verb(spanish: reconstructedVerbString, french: "", english: "")
                                newVerbString = verb.getWordAtLanguage(language: currentLanguage)
                                currentVerbPhrase = verb.getWordAtLanguage(language: currentLanguage)
                                languageViewModel.setVerbsForCurrentVerbModel(modelID: vm.id)
                                languageViewModel.addVerbToFilteredList(verb: verb)
                                isAnalyzed = true
                                setCurrentVerb()
                                newVerbString = ""
                            }
                            else {
                                print("illegal verb ... ")
                            }
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



