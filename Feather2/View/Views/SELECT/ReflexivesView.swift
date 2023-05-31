//
//  ReflexivesView.swift
//  Feather2
//
//  Created by Charles Diggins on 5/14/23.
//

import SwiftUI
import Combine
import JumpLinguaHelpers

//func fillReflexivePairList()->ReflexivePairManager {
//    var mgr = ReflexivePairManager()
//    mgr.append(ReflexivePair(ReflexivePair(nonReflexive: Verb()))
//    return mgr
//}

struct ReflexivesView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    //    @ObservedObject var reflexiveVerbManager : ReflexiveVerbManager
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @EnvironmentObject var router: Router
    @State private var currentLanguage = LanguageType.Agnostic
    @Environment(\.dismiss) private var dismiss
    @State private var reflexiveVerbPairList = [FeatherVerbPair]()
    @State private var currentVerbPair = FeatherVerbPair(Verb(), Verb())
    @State private var spanishPhrase = ""
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State var tenseIndex = 0
    var tenseList = [Tense.present, .preterite, .imperfect, .conditional, .presentPerfect, .presentProgressive, .presentSubjunctive, .imperfectSubjunctiveRA]
//    var tenseList = [Tense.presentSubjunctive, .imperfectSubjunctiveRA, .presentPerfect, .presentProgressive]
    //  @State private var reflexivePairManager = ReflexivePairManager(languageViewModel: languageViewModel)
    @State private var currentVerbNumber = 1
    @State private var verbCount = 0
    @State var currentIndex = 0
    @State var currentTense = Tense.present
    @State var personString = ["","","","","",""]
    @State var verb1String = ["","","","","",""]
    @State var english1String = ["","","","","",""]
    @State var verb2String = ["","","","","",""]
    @State var english2String = ["","","","","",""]
    @State var currentVerbModel = RomanceVerbModel()
    @State var lockSymbol = ""
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
    var frameHeight = CGFloat(20)
    @State var reflexiveType = ReflexiveType.NonReflexive
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    
    //@State var bAddNewVerb = false
    
    var body: some View {
        //        ZStack{
        //            Color("BethanyNavalBackground")
        //                .ignoresSafeArea()
        //
        VStack{
            ZStack{
                ExitButtonView()
                Text("")
                VStack{
                    Button{
                        changeReflexiveType()
                    } label: {
                        Text(getReflexiveTypeString())
                        
                    }.frame(width: 300, height: 35, alignment: .center)
                        .background(.red).foregroundColor(.yellow)
                        .cornerRadius(10)
                }
            }
            VStack{
                
                VStack{
                    //            Text("Spanish Reflexives").foregroundColor(Color("ChuckText1")).font(.title2)
                    Text("Current tense: \(currentTense.rawValue)")
                        .onTapGesture {
                            getNextTense()
                        }.frame(width: 300, height: 35, alignment: .center)
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
                                Text(currentVerbPair.primaryVerb.getWordAtLanguage(language: .Spanish))
                                Text("-")
                                Text(currentVerbPair.primaryVerb.getWordAtLanguage(language: .English))
                            }
                                    .foregroundColor(Color("BethanyGreenText"))
                                    .frame(width: 200, height: 35, alignment: .center)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .border(.yellow)

                            HStack{
                                Text(currentVerbPair.secondaryVerb.getWordAtLanguage(language: .Spanish))
                                Text("-")
                                Text(currentVerbPair.secondaryVerb.getWordAtLanguage(language: .English))
                            }
                                .foregroundColor(Color("BethanyGreenText"))
                                .frame(width: 200, height: 35, alignment: .center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
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
                                Text(personString[personIndex])
                                    .frame(width: 100, height: frameHeight, alignment: .trailing)
                                HStack{
                                    Text(verb1String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                    Spacer()
                                    Text(english1String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                }
                                
                                .border(.yellow)
                                HStack{
                                    Text(verb2String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                    Spacer()
                                    Text(english2String[personIndex]).frame(minWidth: 50, maxWidth: .infinity, minHeight: frameHeight)
                                }
                                .border(.green)
                            }.font(.system(size: 12))
                        }
                    }.background(Color("BethanyNavalBackground"))
                        .foregroundColor(Color("BethanyGreenText"))
                }
            }
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
            reflexiveVerbPairList = languageViewModel.getReflexiveVerbManager().getReflexivePairList(.NonReflexive)
            currentVerbPair = reflexiveVerbPairList[currentIndex]
            verbCount = reflexiveVerbPairList.count
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
    
    func changeReflexiveType(){
        if reflexiveType == .NonReflexive {
            reflexiveType = .Reciprocal
        } else if reflexiveType == .Reciprocal {
            reflexiveType = .NormalReflexive
        }  else if reflexiveType == .NormalReflexive {
            reflexiveType = .OnlyReflexive
        } else {
            reflexiveType = .NonReflexive
        }
        currentIndex = 0
        reflexiveVerbPairList = languageViewModel.getReflexiveVerbManager().getReflexivePairList(reflexiveType)
        currentVerbPair = reflexiveVerbPairList[currentIndex]
        verbCount = reflexiveVerbPairList.count
        showCurrentWordInfo()
    }
    
    func getReflexiveTypeString()->String{
        return reflexiveType.getString()
    }
    //
    func setPatternStuff(){
        let patternList = languageViewModel.getPatternsForThisModel(verbModel: currentVerbModel)
        stemString = ""
        orthoString = ""
        for sps in patternList {
            if sps.tense == currentTense {
                if sps.pattern.isStemChangingSpanish() { stemString = sps.pattern.rawValue }
                if sps.pattern.isSpellChangingSpanish() { orthoString = sps.pattern.rawValue }
            }
        }
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
    
    func getPreviousVerb(){
        currentIndex -= 1
        if currentIndex < 0 {currentIndex = verbCount-1}
        currentVerbNumber = currentIndex + 1
        currentVerbPair = reflexiveVerbPairList[currentIndex]
        showCurrentWordInfo()
    }
    
    func getNextVerb(){
        currentIndex += 1
        if currentIndex >= verbCount {currentIndex = 0}
        currentVerbPair = reflexiveVerbPairList[currentIndex]
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
        var englishSubjunctiveWord = ""
        spanishPhrase = currentVerbPair.primaryVerb.getWordAtLanguage(language: .Spanish)
        let vu = VerbUtilities()
        let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
        isReflexive = result.3
        residualPhrase = result.2
        if currentTense.isSubjunctive() {
            englishSubjunctiveWord = "that "
        }
        
        var thisVerb = currentVerbPair.primaryVerb
        if thisVerb.getWordAtLanguage(language: currentLanguage).count > 0 {
            verb1String[0] = constructConjugateForm(person: .S1, currentVerb: thisVerb )
            verb1String[1] = constructConjugateForm(person: .S2, currentVerb: thisVerb )
            verb1String[2] = constructConjugateForm(person: .S3, currentVerb: thisVerb )
            verb1String[3] = constructConjugateForm(person: .P1, currentVerb: thisVerb )
            verb1String[4] = constructConjugateForm(person: .P2, currentVerb: thisVerb )
            verb1String[5] = constructConjugateForm(person: .P3, currentVerb: thisVerb )
        } else {
            verb1String[0] = "..."
            verb1String[1] = "..."
            verb1String[2] = "..."
            verb1String[3] = "..."
            verb1String[4] = "..."
            verb1String[5] = "..."
        }
        if thisVerb.getWordAtLanguage(language: currentLanguage).count > 0 {
            english1String[0] = englishSubjunctiveWord + "I " + constructConjugateForm(language: .English, tense: currentTense, person: .S1, currentVerb: thisVerb )
            english1String[1] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, tense: currentTense, person: .S2, currentVerb: thisVerb )
            english1String[2] = englishSubjunctiveWord + "she " + constructConjugateForm(language: .English, tense: currentTense, person: .S3, currentVerb: thisVerb )
            english1String[3] = englishSubjunctiveWord + "we " + constructConjugateForm(language: .English, tense: currentTense, person: .P1, currentVerb: thisVerb )
            english1String[4] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, tense: currentTense, person: .P2, currentVerb: thisVerb )
            english1String[5] = englishSubjunctiveWord + "they " + constructConjugateForm(language: .English, tense: currentTense, person: .P3, currentVerb: thisVerb )
        } else {
            english1String[0] = "..."
            english1String[1] = "..."
            english1String[2] = "..."
            english1String[3] = "..."
            english1String[4] = "..."
            english1String[5] = "..."
        }
        thisVerb = currentVerbPair.secondaryVerb
        if reflexiveType == .Reciprocal {
            verb2String[0] = "..."
            verb2String[1] = "..."
            verb2String[2] = "..."
        } else {
            verb2String[0] = constructConjugateForm(person: .S1, currentVerb: thisVerb)
            verb2String[1] = constructConjugateForm(person: .S2, currentVerb: thisVerb)
            verb2String[2] = constructConjugateForm(person: .S3, currentVerb: thisVerb)
        }
        verb2String[3] = constructConjugateForm(person: .P1, currentVerb: thisVerb)
        verb2String[4] = constructConjugateForm(person: .P2, currentVerb: thisVerb)
        verb2String[5] = constructConjugateForm(person: .P3, currentVerb: thisVerb)
        
        if reflexiveType == .Reciprocal {
            english2String[0] = "..."
            english2String[1] = "..."
            english2String[2] = "..."
        } else {
            english2String[0] = englishSubjunctiveWord + "I " + constructConjugateForm(language: .English, tense: currentTense, person: .S1, currentVerb: thisVerb)
            english2String[1] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, tense: currentTense, person: .S2, currentVerb: thisVerb)
            english2String[2] = englishSubjunctiveWord + "he " + constructConjugateForm(language: .English, tense: currentTense, person: .S3, currentVerb: thisVerb)
        }
        english2String[3] = englishSubjunctiveWord + "we " + constructConjugateForm(language: .English, tense: currentTense, person: .P1, currentVerb: thisVerb)
        english2String[4] = englishSubjunctiveWord + "you " + constructConjugateForm(language: .English, tense: currentTense, person: .P2, currentVerb: thisVerb)
        english2String[5] = englishSubjunctiveWord +  "they " + constructConjugateForm(language: .English, tense: currentTense, person: .P3, currentVerb: thisVerb)
        if reflexiveType != .Reciprocal {
            processReflexiveEnglishStrings()
        }
    }
    
    func processReflexiveEnglishStrings()
    {
        let possessiveAdjective = ["my", "your", "his", "our", "your", "their"]
        let possessiveNoun = ["me", "you", "him", "us", "you", "them"]
        let possessivePronoun = ["myself", "yourself", "himself", "ourselves", "yourselves", "themselves"]
        var vu = VerbUtilities()
    
        for i in 0..<6 {
            english2String[i] = vu.replaceSubstringInString(inputString: english2String[i], findString: "oneself", replacementString: possessivePronoun[i])
            english2String[i] = vu.replaceSubstringInString(inputString: english2String[i], findString: "one's", replacementString: possessiveAdjective[i])
            if i < 3 {
                english2String[i] = vu.replaceSubstringInString(inputString: english2String[i], findString: "each other", replacementString: possessivePronoun[i])
            }
        }
    }
    
    // - MARK: Conjugation here
    
    func constructConjugateForm(language: LanguageType, tense: Tense, person: Person, currentVerb: Verb)->String{
        
        var ansString = languageViewModel.createAndConjugateAgnosticVerb(language: language, verb: currentVerb, tense: tense, person: person, isReflexive: false)
        
        return ansString
    }
    
    func constructConjugateForm(person: Person, currentVerb: Verb)->String{
        
        let thisVerb = languageViewModel.getRomanceVerb(verb: currentVerb)
        let vu = VerbUtilities()
        var rightPhrase = languageViewModel.createAndConjugateAgnosticVerb(language: currentLanguage, verb: currentVerb, tense: currentTense, person: person, isReflexive: isReflexive)
        rightPhrase = vu.removeLeadingOrFollowingBlanks(characterArray: rightPhrase)
        return rightPhrase
    }
    
}
