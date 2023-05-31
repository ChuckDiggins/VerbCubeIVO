//
//  DictionaryView.swift
//  Feather2
//
//  Created by Charles Diggins on 1/14/23.
//

import SwiftUI
import Combine
import JumpLinguaHelpers

enum SpanishIdiomType :  String, CaseIterable {
    case Hay,
         Haber,
         Hacer,
         Tener,
         Dar,
         Echar,
         Poner,
         Misc1,
         Misc2
    
    public func getString()->String {
        switch self{
        case .Hay:  return "Haber - Hay"
        case .Haber:  return "Haber"
        case .Hacer: return "Hacer"
        case .Tener: return "Tener"
        case .Dar: return "Dar"
        case .Echar: return "Echar"
        case .Poner: return "Poner"
        case .Misc1: return "Misc 1"
        case .Misc2: return "Misc 2"
        }
    }
}

var idiomHaberHayList =   [("hay que", "has to"),
                           ("hay", "is")]
var idiomHaberList =   [("haber de partir el inviernes", "be to leave on Friday"),
                        ("haber de", "be about to")]
var idiomHacerList =   [("hacerse falta a", "need" ),
                        ("hacer el favor", "do a favor"),
                        ("hacer dos años", "be two years old"),
                        ("hacer un pregunta", "ask a question"),]
var idiomTenerList =   [("tener sueño", "be sleepy"),
                        ("tener cuidado", "be careful"),
                        ("tener miedo", "be afraid"),
                        ("tener razón", "be correct")]
var idiomDarList =   [("dar un paseo", "take a walk"),
                      ("darse cuenta de", "realize"),
                      ("dar la mano", "shake hands"),
                      ("darse prisa","hurry")]

var idiomEcharList =   [("echar de menos a su amigo", "miss their friend"),
                      ("echar una carta", "mail a letter"),
                      ("echar con sueño", "sleep"),
                      ("echar de ver","take notice"),
                        ("echar por alto","exaggerate"),]

var idiomPonerList =   [("ponerse", "become"),
                      ("ponerse enfermo", "become sick"),
                      ("poner la mesa", "set the table"),
                        ("ponerse a", "stand"),
                      ("ponerse en pie","stand")]

var idiomMisc1List =   [("creer que sí", "think so"),
                      ("cambiar de silla", "change seats"),
                      ("convenir en escribirlo", "agree to write it"),
                      ("cumplir con","fulfill"),
                        ("dejar caer","drop"),
                        ("oír hablar de","hear about"),
                        ("perder cuidado","fulfill"),
]

var idiomMisc2List =   [("ponerse de acuerdo", "come to an agreement"),
                      ("ser aficionado a", "be fond of"),
                      ("ir de compras", "go shopping"),
                      ("llegar a ser","become"),
                        ("perder de vista","lose sight of"),
]



class VerbIdiomManager : ObservableObject {
    var idiomHaberHayList = [Verb]()
    var idiomHaberList = [Verb]()
    var idiomHacerList = [Verb]()
    var idiomTenerList = [Verb]()
    var idiomDarList = [Verb]()
    var idiomEcharList = [Verb]()
    var idiomPonerList = [Verb]()
    var idiomMisc1List = [Verb]()
    var idiomMisc2List = [Verb]()
    
    func getIdiomList(_ type: SpanishIdiomType)->[Verb]{
        switch type {
        case .Hay:
            return idiomHaberHayList
        case .Haber:
            return idiomHaberList
        case .Hacer:
            return idiomHacerList
        case .Tener:
            return idiomTenerList
        case .Dar:
            return idiomDarList
        case .Echar:
            return idiomEcharList
        case .Poner:
            return idiomPonerList
        case .Misc1:
            return idiomMisc1List
        case .Misc2:
            return idiomMisc2List
        }
    }
    
    func append(_ type: SpanishIdiomType, _ verb: Verb){
        switch type {
        case .Hay:   idiomHaberHayList.append(verb)
        case .Haber: idiomHaberList.append(verb)
        case .Hacer: idiomHacerList.append(verb)
        case .Tener: idiomTenerList.append(verb)
        case .Dar:   idiomDarList.append(verb)
        case .Echar:   idiomEcharList.append(verb)
        case .Poner:   idiomPonerList.append(verb)
        case .Misc1:   idiomMisc1List.append(verb)
        case .Misc2:   idiomMisc2List.append(verb)
        }
    }
    
}

struct IdiomsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @EnvironmentObject var router: Router
    @State private var currentLanguage = LanguageType.Agnostic
    @Environment(\.dismiss) private var dismiss
    @State private var spanishVerb = SpanishVerb()
    @State private var spanishPhrase = ""
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State private var idiomVerbList = [Verb]()
    @State private var spanishVerbOnlyList = [Verb]()
    @State private var currentVerb = Verb()
    @State private var secondaryVerb = Verb()
    @State private var verbPairList = [FeatherVerbPair]()
    @State private var currentVerbPair = FeatherVerbPair(Verb(), Verb())
    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State var tenseIndex = 0
    var tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future, .presentSubjunctive,
                     .imperfectSubjunctiveRA, .presentPerfect, .presentProgressive]
    @State private var verbCount = 0
    @State var currentIndex = 0
    @State var currentTense = Tense.present
    @State var personString = ["","","","","",""]
    @State var verb1String = ["","","","","",""]
    @State var verb2String  = ["","","","","",""]
    @State var english1String = ["","","","","",""]
    @State var english2String = ["","","","","",""]
    @State var showResidualPhrase = true
    @State var showReflexivePronoun = true
    @State var isReflexive = true
    @State var residualPhrase = ""
    @State var showReflexivesOnly = false
    @State private var matching = [false, false, false, false, false, false]
    
    //swipe gesture
    
    @State var startPos : CGPoint = .zero
    @State var isSwiping = true
    @State var color = Color.red.opacity(0.4)
    @State var direction = ""
    @State var stemString = ""
    @State var orthoString = ""
    @State var userString = ""
    @State var idiomType  = SpanishIdiomType.Hacer
    var frameHeight = CGFloat(20)
    @State var englishSubjunctiveWord = ""
    @State var spanishSubjunctiveWord = ""
    @State var verbIdiomManager = VerbIdiomManager()
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    
    //@State var bAddNewVerb = false
    
    var body: some View {
        VStack{
            ZStack{
                ExitButtonView()
                Text("")
                VStack{
                    Button{
                        changeIdiomType()
                    } label: {
                        Text("Idiom: \(getIdiomString())")
                        
                    }.frame(width: 300, height: 25, alignment: .center)
                        .background(.red).foregroundColor(.yellow)
                        .cornerRadius(10)
                }
            }
            VStack{
                //            Text("Spanish Reflexives").foregroundColor(Color("ChuckText1")).font(.title2)
                Text("Current tense: \(currentTense.rawValue)")
                    .onTapGesture {
                        getNextTense()
                    }.frame(width: 300, height: 25, alignment: .center)
                    .background(.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                HStack{
                    Button(action: {
                        getPreviousVerb()
                    }){
                        HStack{
                            Label("", systemImage: "arrow.left")
                            Text("Previous")
                        }
                        .buttonStyle(.bordered)
                        .tint(.pink)
                        
                    }
                    
                    Spacer()
                    HStack{
                        HStack{
                            Text(currentVerb.getWordAtLanguage(language: .Spanish))
                            Text("-")
                            Text("to \(currentVerb.getWordAtLanguage(language: .English))")
                        }
                        .padding(3)
                        .foregroundColor(Color("BethanyGreenText"))
                        .frame(width: 300, height: 25, alignment: .center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .cornerRadius(10)
                        .border(.green)
                        
                    }.onTapGesture(perform: {
                        getNextVerb()
                    })
                    Spacer()
                    Button(action: {
                        getNextVerb()
                    }){
                        HStack{
                            Text("  Next  ")
                            Label("", systemImage: "arrow.right")
                        }
                        .tint(.pink)
                        .buttonStyle(.bordered)
                    }
                }
            }
            VStack{
                ScrollView {
                    ForEach((0...5), id:\.self) { personIndex in
                        HStack{
                            HStack{
                                Text(verb1String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                    .border(.yellow)
                                Spacer()
                                Text(english1String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                    .border(.red)
                            }.font(.system(size: 12))
                            HStack{
                                HStack{
                                    Text(verb2String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                        .border(.yellow)
                                    Spacer()
                                    Text(english2String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                        .border(.red)
                                }.font(.system(size: 12))
                            }
                        }
                    }
                }
            }
        Spacer()
        }
        .background(Color("BethanyNavalBackground"))
        .foregroundColor(Color("BethanyGreenText"))
        .onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
        .onAppear(){
            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
            tenseIndex = 0
            currentTense = tenseList[tenseIndex]
            currentIndex = 0
            currentLanguage = languageViewModel.getCurrentLanguage()
            fillPersons()
            verbIdiomManager = languageViewModel.getVerbIdiomManager()
            idiomVerbList = verbIdiomManager.getIdiomList(.Hacer)
            createVerbPairList()
           
            currentVerb = idiomVerbList[currentIndex]
            verbCount = idiomVerbList.count
            showCurrentWordInfo()
        }
        .onTapGesture(count:2){
            getNextVerb()
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
                    //                        getNextTense()
                }
                else if self.startPos.y >  gesture.location.y && yDist > xDist {
                    self.direction = "Up"
                    self.color = Color.blue.opacity(0.4)
                    //                        getPreviousTense()
                }
                else if self.startPos.x > gesture.location.x + 10 && yDist < xDist {
                    self.direction = "Left"
                    self.color = Color.yellow.opacity(0.4)
                    //                        getNextVerb()
                    getNextVerb()
                }
                else if self.startPos.x < gesture.location.x + 10 && yDist < xDist {
                    self.direction = "Right"
                    self.color = Color.purple.opacity(0.4)
                    //                        getPreviousVerb()
                    getPreviousVerb()
                }
                self.isSwiping.toggle()
                //                    print("gesture here")
            }
        )
        //        Spacer()
        
        //        }
    }
    
    func changeIdiomType(){
        if idiomType == .Hay {
            idiomType = .Haber
        } else if idiomType == .Haber {
            idiomType = .Hacer
        } else if idiomType == .Hacer {
            idiomType = .Tener
        } else if idiomType == .Tener{
            idiomType = .Dar
        } else if idiomType == .Dar{
            idiomType = .Echar
        } else if idiomType == .Echar{
            idiomType = .Poner
        } else if idiomType == .Poner{
            idiomType = .Misc1
        } else if idiomType == .Misc1{
            idiomType = .Misc2
        } else if idiomType == .Misc2{
            idiomType = .Haber
        }
        currentIndex = 0
        idiomVerbList = verbIdiomManager.getIdiomList(idiomType)
        createVerbPairList()
    }
    
    func createVerbPairList(){
        var vu = VerbUtilities()
        verbPairList.removeAll()
        for verb in idiomVerbList{
            var verbWords = vu.getListOfWords(characterArray: verb.getWordAtLanguage(language: currentLanguage))
            let result = vu.analyzeSpanishWordPhrase(testString: verbWords[0])
            let extractedVerb = languageViewModel.findVerbFromString(verbString: result.verbWord, language: currentLanguage)
            print("primaryVerb: \(verb.getWordAtLanguage(language: currentLanguage)), secondaryVerb \(extractedVerb.getWordAtLanguage(language: .Spanish)), \(extractedVerb.getWordAtLanguage(language: .English)) ")
            verbPairList.append(FeatherVerbPair(verb, extractedVerb))
        }
        currentIndex = 0
        currentVerb = verbPairList[currentIndex].primaryVerb
        secondaryVerb = verbPairList[currentIndex].secondaryVerb
        verbCount = verbPairList.count
        showCurrentWordInfo()
    }
    
    func getIdiomString()->String{
        return idiomType.getString()
    }
    
    func getPreviousVerb(){
        currentIndex -= 1
        if currentIndex < 0 {currentIndex = verbCount-1}
        currentVerb = verbPairList[currentIndex].primaryVerb
        secondaryVerb = verbPairList[currentIndex].secondaryVerb
        showCurrentWordInfo()
    }
    
    func getNextVerb(){
        currentIndex += 1
        if currentIndex >= verbCount {currentIndex = 0}
        currentVerb = verbPairList[currentIndex].primaryVerb
        secondaryVerb = verbPairList[currentIndex].secondaryVerb
        showCurrentWordInfo()
    }
    
    
    func getNextTense(){
        tenseIndex += 1
        if tenseIndex >= tenseList.count{ tenseIndex = 0}
        currentTense = tenseList[tenseIndex]
        showCurrentWordInfo()
    }
    
    func getPreviousTense(){
        tenseIndex -= 1
        if tenseIndex < 0 {
            tenseIndex = tenseList.count - 1
        }
        currentTense = tenseList[tenseIndex]
        showCurrentWordInfo()
    }
    
    
    func  fillPersons(){
        personString[0] = "yo"
        personString[1] = "tú"
        personString[2] = "él"
        personString[3] = "nosotros"
        personString[4] = "vosotros"
        personString[5] = "ellos"
        
    }
    
    func  showCurrentWordInfo(){
        var thisVerb = currentVerb
        spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
        englishSubjunctiveWord = ""
        spanishSubjunctiveWord = ""
        if currentTense.isSubjunctive() {
            spanishSubjunctiveWord = "que "
            englishSubjunctiveWord = "that "
        }
        
        if spanishPhrase.count > 0 {
            verb1String[0] = spanishSubjunctiveWord + personString[0] + " " + constructConjugateForm(verb: currentVerb, person: .S1)
            verb1String[1] = spanishSubjunctiveWord + personString[1] + " " + constructConjugateForm(verb: currentVerb, person: .S2)
            verb1String[2] = spanishSubjunctiveWord + personString[2] + " " + constructConjugateForm(verb: currentVerb, person: .S3)
            verb1String[3] = spanishSubjunctiveWord + personString[3] + " " + constructConjugateForm(verb: currentVerb, person: .P1)
            verb1String[4] = spanishSubjunctiveWord + personString[4] + " " + constructConjugateForm(verb: currentVerb, person: .P2)
            verb1String[5] = spanishSubjunctiveWord + personString[5] + " " + constructConjugateForm(verb: currentVerb, person: .P3)
            verb2String[0] = spanishSubjunctiveWord + personString[0] + " " + constructConjugateForm(verb: secondaryVerb, person: .S1)
            verb2String[1] = spanishSubjunctiveWord + personString[1] + " " + constructConjugateForm(verb: secondaryVerb, person: .S2)
            verb2String[2] = spanishSubjunctiveWord + personString[2] + " " + constructConjugateForm(verb: secondaryVerb, person: .S3)
            verb2String[3] = spanishSubjunctiveWord + personString[3] + " " + constructConjugateForm(verb: secondaryVerb, person: .P1)
            verb2String[4] = spanishSubjunctiveWord + personString[4] + " " + constructConjugateForm(verb: secondaryVerb, person: .P2)
            verb2String[5] = spanishSubjunctiveWord + personString[5] + " " + constructConjugateForm(verb: secondaryVerb, person: .P3)
        }
        if thisVerb.getWordAtLanguage(language: currentLanguage).count > 0 {
            english1String[0] = englishSubjunctiveWord + "I " + constructConjugateForm(language: .English, verb: currentVerb, tense: currentTense, person: .S1, currentVerb: thisVerb )
            english1String[1] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, verb: currentVerb, tense: currentTense, person: .S2, currentVerb: thisVerb )
            english1String[2] = englishSubjunctiveWord + "she " + constructConjugateForm(language: .English, verb: currentVerb, tense: currentTense, person: .S3, currentVerb: thisVerb )
            english1String[3] = englishSubjunctiveWord + "we " + constructConjugateForm(language: .English, verb: currentVerb, tense: currentTense, person: .P1, currentVerb: thisVerb )
            english1String[4] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, verb: currentVerb, tense: currentTense, person: .P2, currentVerb: thisVerb )
            english1String[5] = englishSubjunctiveWord + "they " + constructConjugateForm(language: .English, verb: currentVerb, tense: currentTense, person: .P3, currentVerb: thisVerb )
            english2String[0] = englishSubjunctiveWord + "I " + constructConjugateForm(language: .English, verb: secondaryVerb, tense: currentTense, person: .S1, currentVerb: secondaryVerb )
            english2String[1] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, verb: secondaryVerb, tense: currentTense, person: .S2, currentVerb: secondaryVerb )
            english2String[2] = englishSubjunctiveWord + "she " + constructConjugateForm(language: .English, verb: secondaryVerb, tense: currentTense, person: .S3, currentVerb: secondaryVerb )
            english2String[3] = englishSubjunctiveWord + "we " + constructConjugateForm(language: .English, verb: secondaryVerb, tense: currentTense, person: .P1, currentVerb: secondaryVerb )
            english2String[4] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, verb: secondaryVerb, tense: currentTense, person: .P2, currentVerb: secondaryVerb )
            english2String[5] = englishSubjunctiveWord + "they " + constructConjugateForm(language: .English, verb: secondaryVerb, tense: currentTense, person: .P3, currentVerb: secondaryVerb )
        } else {
            english1String[0] = "..."
            english1String[1] = "..."
            english1String[2] = "..."
            english1String[3] = "..."
            english1String[4] = "..."
            english1String[5] = "..."
            english2String[0] = "..."
            english2String[1] = "..."
            english2String[2] = "..."
            english2String[3] = "..."
            english2String[4] = "..."
            english2String[5] = "..."
        }
    }
    
    // - MARK: Conjugation here
    
    func constructConjugateForm(verb: Verb, person: Person)->String{
        let thisVerb = languageViewModel.getRomanceVerb(verb: verb)
        let vu = VerbUtilities()
        var rightPhrase = languageViewModel.createAndConjugateAgnosticVerb(language: currentLanguage, verb: verb, tense: currentTense, person: person, isReflexive: isReflexive)
        rightPhrase = vu.removeLeadingOrFollowingBlanks(characterArray: rightPhrase)
        return rightPhrase
    }
    
    func constructConjugateForm(language: LanguageType, verb: Verb, tense: Tense, person: Person, currentVerb: Verb)->String{
        var ansString = languageViewModel.createAndConjugateAgnosticVerb(language: language, verb: verb, tense: tense, person: person, isReflexive: false)
        
        return ansString
    }
    
}
