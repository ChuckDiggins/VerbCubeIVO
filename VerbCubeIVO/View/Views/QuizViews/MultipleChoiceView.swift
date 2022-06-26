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
    @State private var studentScoreModel = StudentScoreModel()
    @State private var isNew = true
    
    var body: some View {
        ZStack{
            VStack{
                
                HStack{
                    Button{
                        switch multipleChoiceDifficulty {
                        case .simple: multipleChoiceDifficulty = .medium
                        case .medium: multipleChoiceDifficulty = .hard
                        case .hard: multipleChoiceDifficulty = .simple
                        }
                    } label: {
                        Text("\(multipleChoiceDifficulty.rawValue)")
                            .frame(width: 200, height: 40)
                            .padding(.leading, 10)
                            .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                            .cornerRadius(10)
                            .foregroundColor(.yellow)
                    }
                    NavigationLink(destination: StudentScoreView(languageViewModel: languageViewModel, studentScoreModel: studentScoreModel)){
                        Text("Student scores")
                    }.frame(width: 150, height: 40)
                        .padding(.leading, 10)
                        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                        .cornerRadius(10)
                        .foregroundColor(.yellow)
                    
                }
                
                ZStack{
                    ProgressBar(value: $wrongValue, barColor: .yellow).frame(height: 20)
                    Text("Wrong \(wrongAnswerCount) out of \(totalCorrectCount)").foregroundColor(.green)
                }
                ZStack{
                    ProgressBar(value: $correctValue, barColor: .green).frame(height: 20)
                    Text("Correct \(correctAnswerCount) out of \(totalCorrectCount)").foregroundColor(.yellow)
                }
                //
                .frame(width: 300, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 3)
                
                Rectangle()
                    .fill(.orange)
                    .frame(height: 2, alignment: .center)
                
                VStack{
                    setNextProblemView()
                    Text(problemInstructionString)
                        .foregroundColor(.black)
                        .background(.white)
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
                                        studentScoreModel.incrementVerbScore(value: currentVerb, correctScore: 1, wrongScore: 0)
                                        studentScoreModel.incrementTenseScore(value: currentTense, correctScore: 1, wrongScore: 0)
                                        studentScoreModel.incrementPersonScore(value: currentPerson, correctScore: 1, wrongScore: 0)
                                        correctValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
                                    } else {
                                        wrongAnswerCount += 1
                                        studentScoreModel.incrementVerbScore(value: currentVerb, correctScore: 0, wrongScore: 1)
                                        studentScoreModel.incrementTenseScore(value: currentTense, correctScore: 0, wrongScore: 1)
                                        studentScoreModel.incrementPersonScore(value: currentPerson, correctScore: 0, wrongScore: 1)
                                        wrongValue = Float(wrongAnswerCount) / Float(totalCorrectCount)
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
                }
            }
            //            if showAlert {
            //                CustomAlertView(show: $showAlert )
            //            }
        }
        
    }
    
    func showCurrentStudentScores(){
        var result = studentScoreModel.getVerbScores(value: currentVerb)
        print("\nVerb: \(currentVerbString): correct = \(result.0), wrong = \(result.1)")
        result = studentScoreModel.getTenseScores(value: currentTense)
        print("Tense: \(currentTenseString): correct = \(result.0), wrong = \(result.1)")
        result = studentScoreModel.getPersonScores(value: currentPerson)
        print("Person: \(currentPersonString): correct = \(result.0), wrong = \(result.1)")
    }
    
    func setProblemMode(){
        switch multipleChoiceType {
        case .oneSubjectToFiveVerbs:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.tenseMode
            totalCorrectCount = randomPersonList.count * tenseList.count * verbList.count
            studentScoreModel.createStudentScoreModels(verbList: verbList, tenseList: tenseList, personList: randomPersonList, modelList: romanceModelList, patternList: verbPatternList)
        case .oneSubjectToFiveTenses:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.personMode
            totalCorrectCount = randomTenseList.count * personMixString.count * verbList.count
            studentScoreModel.createStudentScoreModels(verbList: verbList, tenseList: tenseList, personList: randomPersonList, modelList: romanceModelList, patternList: verbPatternList)
        case .oneVerbToFiveModels:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.personMode
            totalCorrectCount = 0
        case .oneVerbToFiveSubjects:
            primaryProblemMode = ProblemMode.verbMode
            secondaryProblemMode = ProblemMode.personMode
            totalCorrectCount = randomPersonList.count * tenseList.count * verbList.count
            studentScoreModel.createStudentScoreModels(verbList: verbList, tenseList: tenseList, personList: randomPersonList, modelList: romanceModelList, patternList: verbPatternList)
        }
    }
    func setSubjunctiveParticiple(){
        subjunctiveParticiple = ""
        if currentTense.isSubjunctive() {
            subjunctiveParticiple = "que "
            if currentLanguage == .French {subjunctiveParticiple = "qui "}
        }
    }
    
    func setNextProblemView() -> some View {
        VStack {
            Text("Next problem").foregroundColor(.black)
            Button{
                createNextProblem()
            } label: {
                Text("Verb: \(currentVerb.getWordAtLanguage(language: currentLanguage))")
            }
            .font(.headline)
            .padding(2)
            .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
            .foregroundColor(.black)
            .cornerRadius(4)
            .buttonStyle(.bordered)
        }
    }
    
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
        studentScoreModel.resetAllScores()
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
            problemInstructionString = "Subject \(leftHandString): \(currentTense.rawValue) tense"
        case .oneSubjectToFiveTenses:
            randomTenseList.shuffle()
            for tense in randomTenseList {
                let str = languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
                rightHandStringList.append( str )
                if tense == currentTense {
                    correctRightHandString = str
                }
            }
            problemInstructionString = "Subject \(leftHandString): \(currentTense.rawValue) tense"
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
    
    func setNewPerson(){
        currentPersonIndex += 1
        //        print("setNewPerson: currentPersonIndex = \(currentPersonIndex), personMixString.count = \(personMixString.count)")
        if currentPersonIndex >= personMixString.count {
            currentPersonIndex = 0
            setNewTense()
        }
        leftHandString = subjunctiveParticiple + " " + personMixString[currentPersonIndex].personString
        currentPerson =  personMixString[currentPersonIndex].person
        currentPersonString = leftHandString
    }
    
    func setVerbList(){
        //get 10 random verbs from filtered list
        verbList = languageViewModel.getFilteredVerbs()
        if verbList.isEmpty {
            print("no active verbs")
        }
        verbList.shuffle()
        if verbList.count > 10 {
            verbList.removeLast(verbList.count - 10)
        }
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
        leftHandString = subjunctiveParticiple + " " + personMixString[currentPersonIndex].personString
        currentPerson =  personMixString[currentPersonIndex].person
    }
    
    
    func fillPersonMixStruct(){
        personMixString.removeAll()
        switch currentLanguage {
        case .Spanish:
            personMixString.append(PersonMixStruct(person: .S1, personString: "yo"))
            personMixString.append(PersonMixStruct(person: .S2, personString: "tú"))
            personMixString.append(PersonMixStruct(person: .S3, personString: "él"))
            personMixString.append(PersonMixStruct(person: .P1, personString: "nosotros"))
            personMixString.append(PersonMixStruct(person: .P2, personString: "vosotros"))
            personMixString.append(PersonMixStruct(person: .P3, personString: "ellos"))
            if allSubjects {
                personMixString.append(PersonMixStruct(person: .S3, personString: "ella"))
                
                personMixString.append(PersonMixStruct(person: .S3, personString: "usted"))
                
                personMixString.append(PersonMixStruct(person: .P1, personString: "nosotras"))
                
                personMixString.append(PersonMixStruct(person: .P2, personString: "vosotras"))
                personMixString.append(PersonMixStruct(person: .P3, personString: "ellos"))
                personMixString.append(PersonMixStruct(person: .P3, personString: "ellas"))
                personMixString.append(PersonMixStruct(person: .P3, personString: "ustedes"))
            }
        case .French:
            personMixString.append(PersonMixStruct(person: .S1, personString: "je"))
            personMixString.append(PersonMixStruct(person: .S2, personString: "tu"))
            personMixString.append(PersonMixStruct(person: .S3, personString: "il"))
            personMixString.append(PersonMixStruct(person: .P1, personString: "nous"))
            personMixString.append(PersonMixStruct(person: .P2, personString: "vous"))
            personMixString.append(PersonMixStruct(person: .P3, personString: "ils"))
            if allSubjects {
                personMixString.append(PersonMixStruct(person: .S3, personString: "elle"))
                personMixString.append(PersonMixStruct(person: .S3, personString: "on"))
                personMixString.append(PersonMixStruct(person: .P3, personString: "elles"))
            }
        default: break
        }
    }
}

//MultipleChoiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleChoiceView()
//    }
//}
