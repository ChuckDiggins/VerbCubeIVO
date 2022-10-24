//
//  QuizVerbSingleView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/23/22.
//

import SwiftUI
import JumpLinguaHelpers

struct QuizVerbSingleView: View {
    enum DisplayMode {
        case blank, infinitive
    }
    
    enum CommentMode {
        case initial, wrong, success, cheat
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
    
//    @State var currentVerbPhrase = ""
//    @State var newVerbPhrase = ""
    @State var isCorrect = [false, false, false, false, false, false]
    @State var correctAnswer = ["", "", "", "", "", ""]
    @State var studentAnswer = ["", "", "", "", "", ""]
//    @State var studentAnswerCopy = ["", "", "", "", "", ""]
    @State var studentAnswerToggle = false
    
    @State var subjunctiveWord = ""
    @State var residualPhrase = ""
    @FocusState var focusedField: FocusEnum?
    
//    @State var saoList = [StudentAnswerObject]()
    var studentAnswerFrameWidth : CGFloat = 150
    var studentAnswerFrameHeight : CGFloat = 30
    @State var currentPersonIndex = 0
    @State var currentComment1 = "Type in your answer"
    @State var currentComment2 = "Type in your answer"
    @State var commentMode = CommentMode.initial
    @State private var displayMode = DisplayMode.infinitive
    
    var vu = VerbUtilities()
    
    //    @State var bValidVerb = true
    
    @State private var bValidVerb = true
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemPink),
                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            VStack{
                SetVerbAndTenseView()
                StudentAnswerTextEditView()
                SetQuizModeView()
                Spacer()
            }
        }
        
    }
    
    func setCurrentVerb(){
        commentMode = .initial
        focusedField = .p1
        currentVerb = languageViewModel.getCurrentVerb()
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
            }
            correctAnswer[i] = correctAnswerStr
            studentAnswer[i] = studentStr
            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType(), verbStartsWithVowel: vu.startsWithVowelSound(characterArray: correctAnswer[i]))
            //            print("setCurrentVerb:  studentAnswer: \(studentAnswer[i]), correctAnswer: \(correctAnswer[i])")
        }
        fillComment()
    }
    
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
    
    func StudentAnswerTextEditView() -> some View {
        VStack {
            VStack{
                HStack {
                    Spacer()
                    Text(person[currentPersonIndex])
                    TextField("", text: $studentAnswer[currentPersonIndex])
                        .focused($focusedField, equals: .p1)
                        .background(studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex] ? .green : .yellow)
                        .foregroundColor(.black)
                        .border(Color.black)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit{
                            if studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex] {
                                commentMode = .success
                                if allCorrect(){
                                    nextVerb()
                                } else {
                                    setNextPerson()
                                    fillComment()
                                }
                                focusedField = .p1
                                
                            }
                            else {
                                commentMode = .wrong
                                fillComment()
                            }
                        }
                    Image(systemName: studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex]  ? "checkmark.square" : "square")
                        .foregroundColor(studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex] ? .green : .yellow)
                }.font(.title)
                
                HStack(spacing: 0){
                    Spacer()
                    Text (currentComment1)
                        .frame(width: 210, height: 30)
                        .background(.white)
                        .foregroundColor(.black)
                        .border(Color.black)
                    Text (currentComment2)
                        .frame(width: 100, height: 30)
                        .background(.white)
                        .foregroundColor(.red)
                        .border(Color.black)
                    Button{
                        commentMode = studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex] ? .success : .wrong
                        fillComment()
                    } label: {
                        Image(systemName: studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex]  ? "eye.fill" : "eye")
                            .foregroundColor(studentAnswer[currentPersonIndex] == correctAnswer[currentPersonIndex] ? .green : .yellow)
                    }
                }
            }
        }
        .background(.gray)
//        .opacity(0.7)
        .onAppear {
            currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
            setCurrentVerb()
        }
    }
    
    func fillComment(){
        switch commentMode {
        case .initial:
            currentComment1 = "Conjugate \(currentVerbString) for"
            currentComment2 = person[currentPersonIndex]
        case .wrong:
            currentComment1 = "Wrong!"
            currentComment2 = "Try again."
        case .success:
            currentComment1 = "Awesome! The correct form is"
            currentComment2 = "\(correctAnswer[currentPersonIndex])!"
        case .cheat:
            currentComment1 = person[currentPersonIndex]
            currentComment2 = correctAnswer[currentPersonIndex]
        }
    }
    
    func allCorrect()->Bool{
        for i in 0..<6 {
            if correctAnswer[i] !=
                studentAnswer[i] { return false}
        }
        return true
    }
    
    func setNextPerson(){
        currentPersonIndex += 1
        if currentPersonIndex > 5 {
            currentPersonIndex = 0
        }
        commentMode = .initial
    }
    
    func fillStudentAnswersWithInfinitive(){
        displayMode = .infinitive
        commentMode = .initial
        setCurrentVerb()
    }
    
    func fillStudentAnswersWithBlank(){
        displayMode = .blank
        commentMode = .initial
        setCurrentVerb()
    }

    
    func nextVerb(){
        currentPersonIndex = 0
        languageViewModel.setNextVerb()
        displayMode = .infinitive
        setCurrentVerb()
    }
    
    func SetQuizModeView() -> some View {
        HStack{
            Button{
                fillStudentAnswersWithInfinitive()
            } label: {
                Text("Infinitive")
                    .foregroundColor(.yellow)
            }
            Text("Quiz mode").font(.callout)
            Button{
                fillStudentAnswersWithBlank()
            } label: {
                ZStack{
                    Text("Blank")
                        .foregroundColor(.yellow)
                    Text("X")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            
        }
        .buttonStyle(.bordered)
        .background(.black)
    }
    
    func SetVerbAndTenseView() -> some View {
        VStack {
            HStack{
                VStack{
                    Text("Verb").foregroundColor(.black)
                    Button{
                        nextVerb()
                    } label: {
                        Text("\(currentVerbString)")
                    }.foregroundColor(.yellow)
                        .background(.black)
                }
                VStack{
                    Text("Tense").foregroundColor(.black)
                    Button(action: {
                        currentTense = languageViewModel.getLanguageEngine().getNextTense()
                        currentTenseString = currentTense.rawValue
                        setCurrentVerb()
                    }){
                        Text(currentTenseString)
                    }.foregroundColor(.yellow)
                        .background(.black)
                }
            }
            
            .buttonStyle(.bordered)
            .tint(.blue)
            .padding(5)
           
        }
        .padding(3)
    }

}



//struct QuizVerbSingleView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizVerbSingleView()
//    }
//}
