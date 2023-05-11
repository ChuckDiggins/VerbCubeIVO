//
//  MixAndMatchView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/8/22.
//

import SwiftUI
import JumpLinguaHelpers
import AVFoundation

struct MixMatchStruct: Identifiable, Hashable, Equatable{
    var id = UUID().uuidString
    var matchID : Int
    var person: Person
    var subjectString: String
    var verbString: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 15
    var isShowing: Bool = false
    var isMatched: Bool = false
    
    init(){
        self.matchID = 0
        self.person = .S1
        self.subjectString = "yo"
        self.verbString = "tengo"
    }
    
    init(matchID: Int, person: Person, subjectString: String, verbString: String){
        self.matchID = matchID
        self.person = person
        self.subjectString = subjectString
        self.verbString = verbString
    }
}

struct PersonMixStruct: Identifiable, Hashable, Equatable{
    var id = UUID().uuidString
    var person : Person
    var personString : String
}


//
//func displaySoundsAlert() {
//    let alert = UIAlertController(title: "Play Sound", message: nil, preferredStyle: UIAlertController.Style.alert)
//    for i in 1000...1010 {
//        alert.addAction(UIAlertAction(title: "\(i)", style: .default, handler: {_ in
//            AudioServicesPlayAlertSound(UInt32(i))
//            self.displaySoundsAlert()
//        }))
//    }
//    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//    self.present(alert, animated: true, completion: nil)
//}


struct MixAndMatchView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    @State var currentTense = Tense.present
    @State var currentVerb = Verb()
    @State var currentPerson = Person.S1
//    @State var currentModelString = ""
    @State var currentVerbString = ""
    @State var currentTenseString = ""
    @State private var mixMatchList = [MixMatchStruct]()
    @State private var subjectStringList = [String]()
    @State private var matchStringList = [String]()
    @State private var verbStringList = [String]()
    @State private var isThisVerbAMatch = [false]
    @State private var isThisSubjectAMatch = [false]
    @State private var isThisSubjectDisabled = [false]
    @State private var isThisVerbDisabled = [false]
    @State private var verbMatchID = [false]
    @State private var subjectMatchID = [false]
    @State private var matchString = ""
    @State private var verbString = ""
    @State private var subjectString = ""
    @State private var mixIndex = 0
    @State private var matchIndex = 0
    @State var progressValue: Float = 0.0
    @State private var correctAnswerCount = 0
    @State private var totalCorrectCount = 0
    @State private var personMixString = [PersonMixStruct]()
    @State private var subjunctiveParticiple = ""
    @State private var isHelpExpanded = false
    @State private var allSubjects = false
    @State private var showAlert = false
    @State private var number = Number.singular
    @State private var dependentVerb = Verb()
    @State var speechModeActive = false
    @State var rightParticiple = ""
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            ScrollView{
                HStack{
                    ExitButtonViewWithSpeechIcon(setSpeechModeActive: setSpeechModeActive)
                }
//                DisclosureGroupMixAndMatch()
//                ListVerbModelsView(languageViewModel: languageViewModel)
//                RandomVerbButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                Button{
                    setCurrentVerb()
                } label: {
                    Text("Verb: \(currentVerbString)")
                        .modifier(ModelTensePersonButtonModifier())
                }
                Button{
                    currentTense = languageViewModel.getNextTense()
                    fillMixMatchList()
                    correctAnswerCount = 0
                } label: {
                    Text("Tense: \(currentTense.rawValue)")
                        .modifier(ModelTensePersonButtonModifier())
                }
//                TenseButtonView(languageViewModel: languageViewModel, function: setCurrentVerb)
                HStack{
                    ZStack{
                        ProgressBar(value: $progressValue, barColor: .red).frame(height: 20)
                        Text("Correct \(correctAnswerCount) out of \(totalCorrectCount)").foregroundColor(.black)
                    }
                }
                //
                .frame(width: 300, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 3)
                .onAppear{
                    currentLanguage = languageViewModel.getCurrentLanguage()
                    currentTense = languageViewModel.getCurrentTense()
                    languageViewModel.createAndConjugateCurrentFilteredVerb()
                    currentVerb = languageViewModel.getRandomVerb()
                    currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
                    currentTenseString = currentTense.rawValue
                    getParticipleForThisTense()
                    dependentVerb = getVerbFromRandomInfinitives()
                    setCurrentVerb()
                    fillPersonMixStruct()
                    fillMixMatchList()
                }.background( isThisVerbAMatch[matchIndex] && isThisSubjectAMatch[mixIndex] ? .green : .yellow)
                    .foregroundColor(.black)
                    .font(.body)
         
                HStack{
                    
                    VStack{
                        
                        ForEach(subjectStringList.indices, id: \.self) { subjectIndex in
                            
                            Button(subjectStringList[subjectIndex]){
                                getWordToMatch(subjectIndex: subjectIndex, matchString: matchStringList[subjectIndex])
                            }
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
//                            .background(isThisSubjectAMatch[subjectIndex] ? .green.opacity(0.3): Color("BethanyNavalBackground"))
//                             .foregroundColor(isThisSubjectDisabled[subjectIndex] ? .black: Color("BethanyGreenText"))
                             .background(isThisSubjectAMatch[subjectIndex] ? .green.opacity(0.3): .blue)
                             .foregroundColor(isThisSubjectDisabled[subjectIndex] ? .black: .white)
                            .cornerRadius(8)
                            .rotationEffect(Angle.degrees(isThisSubjectDisabled[subjectIndex] ? 360 : 0))
                            .animation(.linear(duration: 1), value: isThisSubjectDisabled[subjectIndex] ) // Delay the animation
                            .disabled(isThisSubjectDisabled[subjectIndex])
                            .font(Font.callout)
                                    
                        }
                    }
                    
                    VStack{
                        ForEach(verbStringList.indices, id: \.self) { verbIndex in
                            Button(verbStringList[verbIndex]){
                                isMatch(verbIndex: verbIndex, verbString: verbStringList[verbIndex])
                            }
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
//                            .background(isThisVerbAMatch[verbIndex] ? .green.opacity(0.3): Color("BethanyNavalBackground"))
//                             .foregroundColor(isThisVerbDisabled[verbIndex] ? .black: Color("BethanyGreenText"))
                            .background(isThisVerbAMatch[verbIndex] ? .green.opacity(0.3): .blue)
                            .foregroundColor(isThisVerbDisabled[verbIndex] ? .black: .white)
                            .cornerRadius(8)
                            .rotationEffect(Angle.degrees(isThisVerbAMatch[verbIndex] ? 360 : 0))
                            .animation(.linear(duration: 1), value: isThisVerbDisabled[verbIndex]) // Delay the animation
                            .disabled(isThisVerbDisabled[verbIndex])
                            .font(Font.callout)
                        }
                       
                    }
                    
                }
                Spacer()
                VStack{
                    Text("1. Click subject   2. Click matching verb")
                }
                .modifier(TextModifier())
                Spacer()
            }
            
            if showAlert {
                CustomAlertView(show: $showAlert )
            }
        }.foregroundColor(Color("BethanyGreenText"))
            .background( Color("BethanyNavalBackground"))
        
    }
    
    func setSpeechModeActive(){
        speechModeActive.toggle()
        if speechModeActive {
            if speechModeActive {
                textToSpeech(text : "speech mode is active", language: .English)
            } else {
                textToSpeech(text : "speech mode has been turned off", language: .English)
            }
                
        }
    }
    
//    func getAlert()->Alert{
//        return Alert (
//            title: Text("Congratulations"),
////            message: Text("Click ok to move to next problem"),
//            primaryButton: .cancel(),
//            secondaryButton: .cancel()
//        )
//    }
    func helpView() -> some View {
        DisclosureGroup("Help", isExpanded: $isHelpExpanded){
            VStack(alignment: .leading){
                Text("Click on a subject in the left column.  It will turn 🟩")
                Text("Click on a correct matching verb form in the right column.  If correct, it will also turn 🟩")
                Text("Continue until all pairs are matched")
                Text("")
                
                HStack{
                    Text("Click on")
                    Text("Verb Model").background(.orange)
                  Text("to change verbs")
                }
                Button{
                    isHelpExpanded = false
                } label: {
                    Text("Close this")
                }.background(.white)
                    .padding()
            }.background(.yellow)
                .foregroundColor(.black)
                .padding()
            
                
        }.padding()
    }
    
    func getSubjectStringAtPerson(person : Person)->String{
        return person.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
    }
    
    func fillPersonMixStruct(){
        
        personMixString.removeAll()
        print("fillPersonMixStruct: \(languageViewModel.getSpecialVerbType().rawValue)")
        personMixString.append(PersonMixStruct(person: .S1, personString: languageViewModel.getPersonString(personIndex: 0, tense: languageViewModel.getCurrentTense(), specialVerbType: languageViewModel.getSpecialVerbType(), verbString: "bailar")))
        personMixString.append(PersonMixStruct(person: .S2, personString: languageViewModel.getPersonString(personIndex: 1, tense: languageViewModel.getCurrentTense(), specialVerbType: languageViewModel.getSpecialVerbType(), verbString: "bailar")))
        personMixString.append(PersonMixStruct(person: .S3, personString: languageViewModel.getPersonString(personIndex: 2, tense: languageViewModel.getCurrentTense(), specialVerbType: languageViewModel.getSpecialVerbType(), verbString: "bailar")))
        personMixString.append(PersonMixStruct(person: .P1, personString: languageViewModel.getPersonString(personIndex: 3, tense: languageViewModel.getCurrentTense(), specialVerbType: languageViewModel.getSpecialVerbType(), verbString: "bailar")))
        personMixString.append(PersonMixStruct(person: .P2, personString: languageViewModel.getPersonString(personIndex: 4, tense: languageViewModel.getCurrentTense(), specialVerbType: languageViewModel.getSpecialVerbType(), verbString: "bailar")))
        personMixString.append(PersonMixStruct(person: .P3, personString: languageViewModel.getPersonString(personIndex: 5, tense: languageViewModel.getCurrentTense(), specialVerbType: languageViewModel.getSpecialVerbType(), verbString: "bailar")))
    }
    
    func getParticipleForThisTense() {
        let thisVerb = languageViewModel.getRomanceVerb(verb: currentVerb)
        if languageViewModel.getCurrentTense().isProgressive(){
            rightParticiple = thisVerb.createGerund()
        } else if languageViewModel.getCurrentTense().isPerfectIndicative(){
            rightParticiple = languageViewModel.getPastParticiple(thisVerb.m_verbWord)
            let pp = thisVerb.createDefaultPastParticiple()
            if rightParticiple.count == 0 { rightParticiple = pp }
        }
    }
    
    func fillMixMatchList(){
        getParticipleForThisTense()

        mixMatchList.removeAll()
        print("MixAndMatch: fillMixMatchList: currentVerb = \(currentVerb.getWordAtLanguage(language: currentLanguage))")
        let dos = languageViewModel.getDirectObjectStruct(specialVerbType: languageViewModel.getSpecialVerbType())
        let directObjectString = dos.objectString
        number = dos.objectNumber
        var gerundString = languageViewModel.getGerundString(specialVerbType: languageViewModel.getSpecialVerbType())
        var infinitiveString = languageViewModel.getInfinitiveString(specialVerbType: languageViewModel.getSpecialVerbType())
        for pms in personMixString {
            var verbString = languageViewModel.createAndConjugateVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense(), person: pms.person, number: number, specialVerbType: languageViewModel.getSpecialVerbType(), directObjectString: directObjectString, gerundString: gerundString, infinitiveString: infinitiveString)
            mixMatchList.append(MixMatchStruct(matchID: pms.person.getIndex(), person: pms.person, subjectString: pms.personString,
                                               verbString: verbString))
        }
        
        mixMatchList.shuffle()
        subjectStringList.removeAll()
        matchStringList.removeAll()
        isThisSubjectAMatch.removeAll()
        isThisSubjectDisabled.removeAll()
        
        for mm in mixMatchList {
            subjectStringList.append(subjunctiveParticiple + mm.subjectString)
            matchStringList.append(mm.verbString)
            isThisSubjectAMatch.append(false)
            isThisSubjectDisabled.append(false)
        }
        
        mixMatchList.shuffle()
        verbStringList.removeAll()
        isThisVerbAMatch.removeAll()
        isThisVerbDisabled.removeAll()
        for mm in mixMatchList {
            verbStringList.append(mm.verbString)
            isThisVerbAMatch.append(false)
            isThisVerbDisabled.append(false)
        }
        correctAnswerCount = 0
        totalCorrectCount = mixMatchList.count
        progressValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
        if correctAnswerCount == totalCorrectCount && correctAnswerCount > 0 {
            showAlert.toggle()
            
        }
    }
    
    func getWordToMatch(subjectIndex: Int, matchString: String){
        if isThisSubjectAMatch[mixIndex] && !isThisSubjectDisabled[mixIndex] {isThisSubjectAMatch[mixIndex] = false}
        self.mixIndex = subjectIndex
        self.matchString = matchString
        subjectString = subjectStringList[subjectIndex]
        isThisSubjectAMatch[mixIndex] = true
        verbString = ""
        //        print("mixIndex: \(mixIndex), getWordToMatch \(matchString)")
    }
    
    func isMatch(verbIndex: Int, verbString: String){
        //if subject string has content
        if subjectString.count>0 {
            self.matchIndex = verbIndex
            self.verbString = verbString
            currentPerson = getPerson(personString: subjectString)
            let answerText =  subjectString + verbString
            if verbString == matchString {
                isThisVerbAMatch[verbIndex] = true
                isThisVerbDisabled[verbIndex] = true
                isThisSubjectAMatch[mixIndex] = true
                isThisSubjectDisabled[mixIndex] = true
                matchString = ""
                subjectString = ""
                self.verbString = ""
                incrementStudentCorrectScore()
                if speechModeActive{
                    textToSpeech(text: answerText, language: .Spanish)
                }
                //AudioServicesPlayAlertSound(UInt32(1008))
            } else {
                if languageViewModel.isSpeechModeActive(){
                    textToSpeech(text: "wrong", language: .English)
                }
                incrementStudentWrongScore()
                AudioServicesPlayAlertSound(UInt32(1003))
            }
            
            correctAnswerCount = 0
            for match in isThisVerbAMatch {
                if match {
                    correctAnswerCount += 1
                }
                else {
                }
            }
            
            progressValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
            if correctAnswerCount == totalCorrectCount && correctAnswerCount > 0 {
                showAlert = true
                setCurrentVerb()
            }
            else {showAlert = false}
            
            printFlags()
        }
    }
    
    func printFlags(){
        print("\n")
        for i in 0 ..< 6 {
            print("index \(i)")
            print ("subject \(subjectStringList[i]), match \(matchStringList[i]), verb \(verbStringList[i])")
            print ("isMatch? - subject \(isThisSubjectAMatch[i]), verb \(isThisVerbAMatch[i]) ")
            print ("disabled? - subject \(isThisSubjectDisabled[i]), verb \(isThisVerbDisabled[i])")
        }
    }
    func getPerson(personString: String)->Person{
        switch (languageViewModel.getCurrentLanguage()){
        case .Spanish:
            if personString == "yo" { return .S1}
            if personString == "tú" { return .S2}
            if personString == "el" || personString == "ella" || personString == "usted" { return .S3}
            if personString == "nosotros" { return .P1}
            if personString == "vosotros" { return .P2}
            if personString == "ellos" || personString == "ellas" || personString == "ustedes" { return .P3}
        case .French:
            if personString == "yo" { return .S1}
            if personString == "tú" { return .S2}
            if personString == "el" || personString == "ella" || personString == "usted" { return .S3}
            if personString == "nosotros" { return .P1}
            if personString == "vosotros" { return .P2}
            if personString == "ellos" || personString == "ellas" || personString == "ustedes" { return .P3}        
        case .English:
            if personString == "I" { return .S1}
            if personString == "you" { return .S2}
            if personString == "he" || personString == "she" || personString == "it" { return .S3}
            if personString == "we" { return .P1}
            if personString == "they" { return .P3}
        default:
            return .S1
        }
        return .S1
    }
    
    func incrementStudentCorrectScore(){
        languageViewModel.getStudentScoreModel().incrementVerbScore(value: currentVerb, correctScore: 1, wrongScore: 0)
        languageViewModel.getStudentScoreModel().incrementTenseScore(value: currentTense, correctScore: 1, wrongScore: 0)
        languageViewModel.getStudentScoreModel().incrementPersonScore(value: currentPerson, correctScore: 1, wrongScore: 0)
    }
    
    func incrementStudentWrongScore(){
        languageViewModel.getStudentScoreModel().incrementVerbScore(value: currentVerb, correctScore: 0, wrongScore: 1)
        languageViewModel.getStudentScoreModel().incrementTenseScore(value: currentTense, correctScore: 0, wrongScore: 1)
        languageViewModel.getStudentScoreModel().incrementPersonScore(value: currentPerson, correctScore: 0, wrongScore: 1)
    }
    
    func fillPersonStringList()->[String]{
        let stringList = [String]()
        switch currentLanguage {
        case .Spanish:
            return subjectList.shuffled()
        case .French: return stringList
        default: return stringList
        }
        
    }
    
    func showNewVerbsButton()->some View{
        Button{
            languageViewModel.setFilteredVerbList(verbList: languageViewModel.getRandomEnglishVerbs(maxCount : 30))
            fillMixMatchList()
        } label: {
            Text("New Verbs")
        }
    }
        
    func setCurrentVerb(){
        currentVerb = languageViewModel.getRandomVerb()
        print("MixAndMatch: setCurrentVerb: currentVerb = \(currentVerb.getWordAtLanguage(language: currentLanguage))")
        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
        currentTense = languageViewModel.getCurrentTense()
//        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
        //this sets up the initial invitation message to the user "Click here"
//        dependentVerb = getVerbFromRandomInfinitives()
        fillMixMatchList()
        correctAnswerCount = 0
    }
    
//
}
