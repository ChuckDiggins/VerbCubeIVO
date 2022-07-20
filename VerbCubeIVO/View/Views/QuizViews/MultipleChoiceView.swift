//
//  MultipleChoiceView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/25/22.
//

import SwiftUI
import JumpLinguaHelpers
import AVFoundation

enum  MultipleChoiceType : String {
    case oneSubjectToFiveVerbs = "One subject, five verbs"
    case oneSubjectToFiveTenses = "One subject, five tenses"
    case oneVerbToFiveSubjects = "One verb, five subjects"
    case oneVerbToFiveModels = "One verb, five models"
}

enum MultipleChoiceDifficulty : String {
    case simple = "person"
    case medium = "person-tense"
    case hard = "person-tense-verb"
}

enum ProblemMode : String {
    case verbMode = "Verb mode"  //verb stays still for current quiz
    case tenseMode = "Tense mode"
    case personMode = "Person mode"
}

struct MultipleChoiceView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var multipleChoiceType: MultipleChoiceType
    @State var multipleChoiceDifficulty = MultipleChoiceDifficulty.medium
    @State private var currentLanguage = LanguageType.Spanish
    @State private var problemInstructionString = "Subject yo: Present tense"
    @State private var personMixString = [PersonMixStruct]()
    @State private var allSubjects = false
    @State private var subjunctiveParticiple = ""
    @State var currentTense = Tense.present
    @State var currentPerson = Person.S1
    @State var currentVerb = Verb()
    
    @State var primaryProblemMode = ProblemMode.verbMode
    @State var secondaryProblemMode = ProblemMode.tenseMode
    @State var currentVerbIndex  = 0
    @State var currentTenseIndex  = 0
    @State var currentPersonIndex  = 0
    
    @State var verbList = [Verb]()
    @State var randomPersonList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    @State var randomTenseList = [Tense.present, .imperfect, .preterite, .future, .conditional, .presentSubjunctive]
    @State var romanceModelList = [RomanceVerbModel]()
    @State var verbPatternList = [SpecialPatternType]()
    @State var currentVerbString = ""
    @State var currentTenseString = ""
    @State var currentPersonString = ""
    @State var modelVerb = ""
    @State var modelID = 0
    @State var modelVerbEnding = VerbEnding.none
    @State var leftHandString = ""
    @State var rightHandStringList = ["acabo", "tengo", "vienes", "acabamos", "aclaron", "tenemos"]
    @State var tenseList = [Tense]()
    @State var correctValue: Float = 0.0
    @State var wrongValue: Float = 0.0
    @State var correctPerson : Person = .S1
    @State var correctRightHandString = "correcto"
    @State private var correctAnswerCount = 0
    @State private var wrongAnswerCount = 0
    @State private var totalCorrectCount = 0
    @State private var isNew = true
    
    var body: some View {
        ZStack{
            Color("GeneralColor")
                .ignoresSafeArea()
            VStack{
                NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                    HStack{
                        Text("Verb model:")
                        Text(modelVerb)
                        Spacer()
                        Image(systemName: "rectangle.and.hand.point.up.left.filled")
                    }
                    .frame(width: 350, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
                .task {
                    setBescherelleModelInfo()
                    setVerbList()
                }
                
                HStack{
                    Button{
                        switch multipleChoiceDifficulty {
                        case .simple: multipleChoiceDifficulty = .medium
                        case .medium: multipleChoiceDifficulty = .hard
                        case .hard: multipleChoiceDifficulty = .simple
                        }
                    } label: {
                        Text("Mode: \(multipleChoiceDifficulty.rawValue)")
                            .frame(width: 300, height: 40)
                            .padding(.leading, 10)
                            .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                            .foregroundColor(.yellow)
                    }
                    
                }
                HStack{
                    Spacer()
                    Text("Wrong \(wrongAnswerCount)").foregroundColor(.black)
                    Spacer()
                    Text("Correct \(correctAnswerCount)").foregroundColor(.black)
                    Spacer()
                    NavigationLink(destination: StudentScoreView(languageViewModel: languageViewModel)){
                        Text("👩🏻‍🎓")
                    }.frame(width: 40, height: 40)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                        .font(.title2)
                }
                .frame(width: 300, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 3)

                Rectangle()
                    .fill(.orange)
                    .frame(height: 2, alignment: .center)
                
                VStack{
                    //setNextProblemView()
                    Text(problemInstructionString)
                        .font(.headline)
                        .padding(2)
                        .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .foregroundColor(.black)
                        .cornerRadius(4)
                        .buttonStyle(.bordered)
                    HStack{
                        Button(leftHandString){
                            print("soon I will do something cool with this")
                        }
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                        .background(.orange)
                        .cornerRadius(8)
                        .font(.body)
                        
                        VStack{
                            ForEach(rightHandStringList.indices, id: \.self) { index in
                                Button(rightHandStringList[index]){
                                    if rightHandStringList[index] == correctRightHandString {
                                        correctAnswerCount += 1
                                        languageViewModel.getStudentScoreModel().incrementVerbScore(value: currentVerb, correctScore: 1, wrongScore: 0)
                                        languageViewModel.getStudentScoreModel().incrementTenseScore(value: currentTense, correctScore: 1, wrongScore: 0)
                                        languageViewModel.getStudentScoreModel().incrementPersonScore(value: currentPerson, correctScore: 1, wrongScore: 0)
                                        correctValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
                                        if languageViewModel.isSpeechModeActive(){
                                            textToSpeech(text: "Correct", language: .English)
                                        }
                                        showCurrentStudentScores()
                                    } else {
                                        wrongAnswerCount += 1
                                        languageViewModel.getStudentScoreModel().incrementVerbScore(value: currentVerb, correctScore: 0, wrongScore: 1)
                                        languageViewModel.getStudentScoreModel().incrementTenseScore(value: currentTense, correctScore: 0, wrongScore: 1)
                                        languageViewModel.getStudentScoreModel().incrementPersonScore(value: currentPerson, correctScore: 0, wrongScore: 1)
                                        
                                        wrongValue = Float(wrongAnswerCount) / Float(totalCorrectCount)
                                        if languageViewModel.isSpeechModeActive(){
                                            textToSpeech(text: "Wrong", language: .English)
                                        }
                                        showCurrentStudentScores()
                                    }
                                    showCurrentStudentScores()
                                    showNewProblem()
                                    
                                }
                                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                                .background(.yellow)
                                .cornerRadius(8)
                                .font(.body)
                            }
                        }
                        
                    }
                }
                Spacer()
            }
            .onAppear{
                if isNew {
                    initialize()
                }
            }
            //            if showAlert {
            //                CustomAlertView(show: $showAlert )
            //            }
        }
        
    }
    
    func initialize(){
        print("On appear")
        currentLanguage = languageViewModel.getCurrentLanguage()
        setVerbList()
        tenseList = languageViewModel.getTenseList()
        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
        currentTenseString = currentTense.rawValue
        fillPersonMixStruct()
        setProblemMode()
        createNextProblem()
        isNew = false
        setBescherelleModelInfo()
    }
    
    func setCurrentVerb(){
        currentVerbIndex += 1
        if currentVerbIndex >= verbList.count {currentVerbIndex = 0}
        currentVerb = verbList[currentVerbIndex]
        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
        //createNextProblem()
    }
    
    func showCurrentStudentScores(){
        var result = languageViewModel.getStudentScoreModel().getVerbScores(value: currentVerb)
        print("\nVerb: \(currentVerb.getWordAtLanguage(language: currentLanguage)): correct = \(result.0), wrong = \(result.1)")
        result = languageViewModel.getStudentScoreModel().getTenseScores(value: currentTense)
        print("Tense: \(currentTenseString): correct = \(result.0), wrong = \(result.1)")
        result = languageViewModel.getStudentScoreModel().getPersonScores(value: currentPerson)
        print("Person: \(currentPersonString): correct = \(result.0), wrong = \(result.1)")
    }
    
    func setProblemMode(){
        switch multipleChoiceType {
        case .oneSubjectToFiveVerbs:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.tenseMode
            totalCorrectCount = randomPersonList.count * tenseList.count * verbList.count
        case .oneSubjectToFiveTenses:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.personMode
            totalCorrectCount = randomTenseList.count * personMixString.count * verbList.count
            
        case .oneVerbToFiveModels:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.personMode
            totalCorrectCount = 0
        case .oneVerbToFiveSubjects:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.personMode
            totalCorrectCount = randomPersonList.count * tenseList.count * verbList.count
            
        }
    }
    func setSubjunctiveParticiple(){
        subjunctiveParticiple = ""
        if currentTense.isSubjunctive() {
            subjunctiveParticiple = "que "
            if currentLanguage == .French {subjunctiveParticiple = "qui "}
        }
    }
    
    func setBescherelleModelInfo() {
        let brv = languageViewModel.createAndConjugateAgnosticVerb(verb: verbList[0])
        modelID = brv.getBescherelleID()
        modelVerb = brv.getBescherelleModelVerb()
        let result = languageViewModel.getModelStringAtTensePerson(bVerb: brv, tense: languageViewModel.getCurrentTense(), person: currentPerson)
        print("verb \(brv.getWordStringAtLanguage(language: languageViewModel.getCurrentLanguage())) = \(result.0) + \(result.1)")
        modelVerbEnding = VerbUtilities().determineVerbEnding(verbWord: modelVerb)
    }
    
//    func setNextProblemView() -> some View {
//        VStack {
//            Button{
//                createNextProblem()
//            } label: {
//                Text("Verb: \(currentVerb.getWordAtLanguage(language: currentLanguage))")
//            }
//            .font(.headline)
//            .padding(2)
//            .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
//            .foregroundColor(.black)
//            .cornerRadius(4)
//            .buttonStyle(.bordered)
//        }
//    }
    
    func showNewProblem(){
        switch multipleChoiceDifficulty {
        case .simple:
            setNewPerson()
        case .medium:
            setNewPerson()
            setNewTense()
        case .hard:
            setNewPerson()
            setNewTense()
            setNewVerb()
        }
        loadRightHandVerbsForThisLeftHandSubject(verb: currentVerb, tense: currentTense, person: currentPerson)
    }
    
    func setNextQuiz(){
        switch secondaryProblemMode {
        case .verbMode:
            setNewVerb()
        case .tenseMode:
            setNewTense()
        case .personMode:
            setNewPerson()
        }
        setNewPerson()
        loadRightHandVerbsForThisLeftHandSubject(verb: currentVerb, tense: currentTense, person: currentPerson)
    }
    
    
    func createNextProblem(){
        switch multipleChoiceType {
        case .oneSubjectToFiveVerbs:
            switch primaryProblemMode {
            case .verbMode:
                resetVerbs()
            case .tenseMode:
                resetTenses()
            case .personMode:
                resetPersons()
            }
            switch secondaryProblemMode {
            case .verbMode:
                resetVerbs()
            case .tenseMode:
                resetTenses()
            case .personMode:
                resetPersons()
            }
            setNewPerson()
            resetScores()
            loadRightHandVerbsForThisLeftHandSubject(verb: currentVerb, tense: currentTense, person: currentPerson)
        case .oneSubjectToFiveTenses:
            switch primaryProblemMode {
            case .verbMode:
                resetVerbs()
            case .tenseMode:
                resetTenses()
            case .personMode:
                resetPersons()
            }
            switch secondaryProblemMode {
            case .verbMode:
                resetVerbs()
            case .tenseMode:
                resetTenses()
            case .personMode:
                resetPersons()
            }
            setNewPerson()
            resetScores()
            loadRightHandVerbsForThisLeftHandSubject(verb: currentVerb, tense: currentTense, person: currentPerson)
        case .oneVerbToFiveSubjects:
            rightHandStringList = loadSubjectsForThisVerb(verb: currentVerb, tense: currentTense, person: currentPerson)
        case .oneVerbToFiveModels:
            rightHandStringList = loadModelsForThisVerb(verb: currentVerb)
        }
    }
    
    func resetScores(){
        correctAnswerCount = 0
        wrongAnswerCount = 0
        wrongValue = 0
        correctValue = 0
//        studentScoreModel.resetAllScores()
    }
    
    func loadRightHandVerbsForThisLeftHandSubject(verb: Verb, tense: Tense, person: Person){
        rightHandStringList.removeAll()
        switch multipleChoiceType {
        case .oneSubjectToFiveVerbs:
            randomPersonList.shuffle()
            for person in randomPersonList {
                let str = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                rightHandStringList.append( str )
                if person == currentPerson {
                    correctRightHandString = str
                }
            }
            problemInstructionString = "Subject \"\(leftHandString)\": \(currentTense.rawValue): \(verb.getWordAtLanguage(language: currentLanguage))"
        case .oneSubjectToFiveTenses:
            randomTenseList.shuffle()
            for tense in randomTenseList {
                let str = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                rightHandStringList.append( str )
                if tense == currentTense {
                    correctRightHandString = str
                }
            }
            problemInstructionString = "Subject \"\(leftHandString)\": \(currentTense.rawValue): \(verb.getWordAtLanguage(language: currentLanguage))"
        case .oneVerbToFiveSubjects:
            correctRightHandString = ""
        case .oneVerbToFiveModels:
            correctRightHandString = ""
        }
        
    }
    
    func loadSubjectsForThisVerb(verb: Verb, tense: Tense, person: Person)->[String]{
        let stringList = [String]()
        correctRightHandString = ""
        return stringList
    }
    
    func loadModelsForThisVerb(verb: Verb)->[String]{
        let stringList = [String]()
        correctRightHandString = ""
        return stringList
    }
    
    func setNewVerb(){
        currentVerbIndex += 1
        if currentVerbIndex >= verbList.count {currentVerbIndex = 0}
        currentVerb = verbList[currentVerbIndex]
        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
    }
    
    func setNewTense(){
        currentTenseIndex += 1
        if currentTenseIndex >= tenseList.count {currentTenseIndex = 0}
        currentTense = tenseList[currentTenseIndex]
        setSubjunctiveParticiple()
        currentTenseString = currentTense.rawValue
    }
    
    func getSubjectStringAtPersonIndex(index : Int)->String{
        let person = Person.all[index]
        return person.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
    }
    
    func getSubjectStringAtPerson(person : Person)->String{
        return person.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
    }
    
    
    func setNewPerson(){
        currentPersonIndex += 1
        //        print("setNewPerson: currentPersonIndex = \(currentPersonIndex), personMixString.count = \(personMixString.count)")
        if currentPersonIndex >= personMixString.count {
            currentPersonIndex = 0
            setNewTense()
        }
        currentPerson =  personMixString[currentPersonIndex].person
        leftHandString = subjunctiveParticiple + getSubjectStringAtPerson(person: currentPerson)
        currentPersonString = leftHandString
    }
    
    func setVerbList(){
        verbList = languageViewModel.getFilteredVerbs()
        if verbList.isEmpty {
            print("no active verbs")
        }
        verbList.shuffle()
        currentVerbIndex = 0
        currentVerb = verbList[currentVerbIndex]
    }
    
    func resetVerbs(){
        verbList.shuffle()
        currentVerbIndex = 0
        currentVerb = verbList[currentVerbIndex]
    }
    
    func resetTenses(){
        tenseList.shuffle()
        currentTense = tenseList[0]
        setSubjunctiveParticiple()
        currentTenseString = currentTense.rawValue
        currentTenseIndex = 0
    }
    
    func resetPersons(){
        personMixString.shuffle()
        currentPersonIndex = 0
        currentPerson =  personMixString[currentPersonIndex].person
        leftHandString = subjunctiveParticiple + " " + getSubjectStringAtPerson(person: currentPerson)
    }
    
    
    func fillPersonMixStruct(){
        personMixString.removeAll()
        personMixString.append(PersonMixStruct(person: .S1, personString: getSubjectStringAtPerson(person : .S1)))
        personMixString.append(PersonMixStruct(person: .S2, personString: getSubjectStringAtPerson(person : .S2)))
        personMixString.append(PersonMixStruct(person: .S3, personString: getSubjectStringAtPerson(person : .S3)))
        personMixString.append(PersonMixStruct(person: .P1, personString: getSubjectStringAtPerson(person : .P1)))
        personMixString.append(PersonMixStruct(person: .P2, personString: getSubjectStringAtPerson(person : .P2)))
        personMixString.append(PersonMixStruct(person: .P3, personString: getSubjectStringAtPerson(person : .P3)))
    }
}

//MultipleChoiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleChoiceView()
//    }
//}
