//
//  QuizVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/18/22.
//

import SwiftUI
import JumpLinguaHelpers

class StudentAnswerObject : ObservableObject, Equatable {
    static func == (lhs: StudentAnswerObject, rhs: StudentAnswerObject) -> Bool {
        lhs.studentAnswer == rhs.studentAnswer
    }
    
    var studentAnswer : String
    var correctAnswer : String
    
    init(studentAnswer: String, correctAnswer: String){
        self.studentAnswer = studentAnswer
        self.correctAnswer = correctAnswer
    }
}

struct QuizVerbView: View {
    enum DisplayMode {
        case blank, infinitive, cheat
    }
    
    
    
    
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    
    @State var currentVerb : Verb = Verb()
    var newVerb : Bool = false
    
    @State var person = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var isBackward = false

    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State var isCorrect = [false, false, false, false, false, false]
    @State var correctAnswer = ["", "", "", "", "", ""]
    @State var studentAnswer = ["", "", "", "", "", ""]
    @State var studentAnswerCopy = ["", "", "", "", "", ""]
    @State var studentAnswerToggle = false
    
    @State var subjunctiveWord = ""
    @State var residualPhrase = ""
    @FocusState var focusedField: FocusEnum?
    @State private var displayMode = DisplayMode.infinitive
    @State var saoList = [StudentAnswerObject]()
    var studentAnswerFrameWidth : CGFloat = 150
    var studentAnswerFrameHeight : CGFloat = 25
    var vu = VerbUtilities()
    
//    @State var bValidVerb = true
    
    @State private var bValidVerb = true
    
    var body: some View {
        
        VStack{
            SetVerbAndTenseView()
            Spacer()
            StudentAnswerTextEditViewExpanded()
            Spacer()
       }
       
    }
    
//    func toggleStudentAnswer(index: Int){
//        if studentAnswer[index].isEmpty {
//            studentAnswer[index] = vvm[index]
//        }
//        else{
//            studentAnswer[index] = ""
//        }
//    }
    
    func fillStudentAnswersWithInfinitive(){
        displayMode = .infinitive
        setCurrentVerb()
    }
    
    func fillStudentAnswersWithBlank(){
        displayMode = .blank
        setCurrentVerb()
    }
    
    func fillStudentAnswersWithCorrectAnswers(){
        displayMode = .cheat
//        studentAnswerToggle.toggle()
//        if studentAnswerToggle {
//            studentAnswerCopy = studentAnswer
//        }
        setCurrentVerb()
    }
    
    func nextVerb(){
        languageViewModel.setNextVerb()
        displayMode = .infinitive
        setCurrentVerb()
    }
    
//
    func setCurrentVerb(){
        currentVerb = languageViewModel.getCurrentVerb()
        bValidVerb = true
        setSubjunctiveStuff()
        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
        
        //set the persons here
        var msm = languageViewModel.getMorphStructManager()
        var studentStr = ""
        var correctAnswerStr = ""

        for i in 0..<6 {
            correctAnswerStr = msm.getFinalVerbForm(person: Person.all[i]) + " " + residualPhrase
            correctAnswerStr = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: correctAnswerStr)
            switch displayMode {
            case .blank:
                studentStr = ""
            case .infinitive:
                studentStr = currentVerbString
            case .cheat:
                studentStr = correctAnswerStr
            }
            correctAnswer[i] = correctAnswerStr
            studentAnswer[i] = studentStr
//            if !studentAnswerToggle {
//                studentAnswer = studentAnswerCopy
//            }
            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: .masculine, verbStartsWithVowel: vu.startsWithVowelSound(characterArray: correctAnswer[i]))
//            print("setCurrentVerb:  studentAnswer: \(studentAnswer[i]), correctAnswer: \(correctAnswer[i])")
        }
    }
    
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }

}

//func setCurrentVerb(){
//        currentVerb = languageViewModel.getCurrentVerb()
//        bValidVerb = true
//        setSubjunctiveStuff()
//        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
//        currentTenseString = languageViewModel.getCurrentTense().rawValue
//        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
//
//        //set the persons here
//        var msm = languageViewModel.getMorphStructManager()
////        vvm.removeAll()
////        studentAnswer.removeAll()
//        saoList.removeAll()
//        var studentStr = ""
//        var correctAnswerStr = ""
//
//        for i in 0..<6 {
//            correctAnswerStr = msm.getFinalVerbForm(person: Person.all[i]) + " " + residualPhrase
//            correctAnswerStr = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: correctAnswerStr)
//            switch displayMode {
//            case .blank:
//                studentStr = ""
//            case .infinitive:
//                studentStr = currentVerbString
//            case .cheat:
//                studentStr = correctAnswerStr
//            }
//            saoList.append(StudentAnswerObject(studentAnswer: studentStr, correctAnswer: correctAnswerStr))
//            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: .masculine, verbStartsWithVowel: vu.startsWithVowelSound(characterArray: vvm[i]))
//        }
//    }
   


