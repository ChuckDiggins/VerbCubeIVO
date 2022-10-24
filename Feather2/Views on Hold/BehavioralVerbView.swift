//
//  VerbsLikeGustarView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/15/22.
//

import SwiftUI
import JumpLinguaHelpers

struct BehavioralVerbView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var behaviorType : BehaviorType
    @State var currentLanguage = LanguageType.Agnostic
    
    @State var currentVerb = Verb()
    var residualPhrase: String = ""
    var newVerb : Bool = false
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var isBackward = false
    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State var subjunctiveWord = "que "
    @State var dependentVerb = Verb()
    @State var highlightPerson = Person.S1
    
    //    @State var vvm = ["", "", "", "", "", ""]
    //    @State var vvr = ["", "", "", "", "", ""]
    @State var person = ["a mí", "a ti", "a él", "a nosotros", "a vosotros", "a ellos", "a usted", "a ella", "a ellas" ]
    @State var studentAnswer = ["", "", "", "", "", ""]
    @State var correctAnswer = ["", "", "", "", "", ""]
    var vu = VerbUtilities()
    @State var isSubjunctive = false
    @State var showMeCorrectAnswers = false
    @State private var bValidVerb = true
    @State private var isRight = true
    @State private var verbModelVerb = ""
    var fontSize = Font.body
    var frameHeight = CGFloat(30)
    
    var studentAnswerFrameWidth : CGFloat = 225
    @State private var number = Number.singular
    @FocusState var focusedField: FocusEnum?
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("Verb Behavior Model:")
                    Text(behaviorType.rawValue)
                        .padding(2)
                        .cornerRadius(4)
                        .font(.title2)
                        .foregroundColor(Color("ChuckText1"))
                    Text(" ")
                }
//                    Button{
//                        showMeCorrectAnswers.toggle()
//                    } label: {
//                        Text(showMeCorrectAnswers ? "🐵" : "🙈")
//                            .bold()
//                            .font(.title)
//                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                            .shadow(radius: 3)
//                            .padding(10)
//                    }
//                    .frame(width: 350, height: 45)
                    
                VStack{
                    HStack{
                        if behaviorType == .auxiliary {
                            Button{
                                changeDependentVerb()
                                setCurrentVerb()
                            } label: {
                                HStack{
                                    Text("Dependent verb:")
                                    Text(dependentVerb.getWordAtLanguage(language: currentLanguage))
                                }
                                .padding(2)
                                
                            }
                        }
                        
                    }
                }
                    //show relevant tenses
                        HStack{
                            Spacer()
                            Button(action: {
                                languageViewModel.setNextBehavioralVerb()
                                currentVerb = languageViewModel.getCurrentBehavioralVerb()
                                setCurrentVerb()
                            }){
                                Text(currentVerbPhrase)
                                
                            }
                            Spacer()
                            Button(action: {
                                currentTense = languageViewModel.getLanguageEngine().getNextTense()
                                currentTenseString = currentTense.rawValue
                                setCurrentVerb()
                            }){
                                Text(currentTenseString)
                                
                            }
                            Spacer()
                        }
                    
                    if ( bValidVerb ){
                        
                        VStack {
                            StudentAnswerTextEditViewExpanded()
                            //                    ForEach (0..<6){ i in
                            //                        HStack{
                            //                            Text(person[i])
                            //                                .padding(2)
                            //                                .frame(width: 200, height: frameHeight, alignment: .trailing)
                            //                                .background(.white  )
                            //                                .foregroundColor(.black)
                            ////                            TextField("answer here")
                            //                            Text(correctAnswer[i])
                            //                                .padding(2)
                            //                                .frame(width: 200, height: frameHeight, alignment: .leading)
                            //                                .background(.green )
                            //                                .foregroundColor(.black)
                            ////                            Text(vvr[i])
                            ////                                .frame(width: 100, height: 20, alignment: .trailing)
                            ////                                .background(.yellow)
                            ////                                .foregroundColor(.black)
                            //                        }.font(fontSize)
                            //                    }
                            if behaviorType == .auxiliary {
                                let result = languageViewModel.getBehavioralVerbModel().getAuxiliaryComment(language: currentLanguage, verb: currentVerb)
                                
                                VStack{
                                    Text(result.0)
                                        .bold()
                                        .frame(width: 350)
                                        .font(.callout)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .shadow(radius: 3)
                                        .padding(3)
                                    Text(result.1)
                                        .bold()
                                        .frame(width: 350)
                                        .font(.callout)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .shadow(radius: 3)
                                        .padding(3)
                                }
                            }
                            else if behaviorType == .likeGustar {
                                
                                Button{
                                    if number == .singular { number = .plural }
                                    else { number = .singular }
                                    setCurrentVerb()
                                } label: {
                                    Text("Number is: \(number.rawValue)")
                                        .padding()
                                        .cornerRadius(8)
                                }
                            }
                            Spacer()
                        }
                        .onAppear {
                            languageViewModel.setBehaviorType(bt: behaviorType)
                            highlightPerson = .S1
                            currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                            currentVerb = languageViewModel.getCurrentBehavioralVerb()
                            setCurrentVerb()
                        }
                        Spacer()
                    }
                }.foregroundColor(Color("BethanyGreenText"))
            }
        }

    
    
    func setCurrentVerb(){
        focusedField = .p1
        setSubjunctiveStuff()
        currentVerbPhrase = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
        verbModelVerb = languageViewModel.getRomanceVerb(verb: currentVerb).getBescherelleInfo()
        
        //set the persons here
        
        studentAnswer.removeAll()
        correctAnswer.removeAll()
        for i in 0..<6 {
            correctAnswer.append(getVerbString(i: i))
            studentAnswer.append("")
            person[i] = getPersonString(i: i)
        }
        highlightPerson = .S1
    }
    
    func changeDependentVerb(){
        dependentVerb = languageViewModel.getRandomVerb()
    }
    
    func getVerbString(i: Int)->String{
        var msm = languageViewModel.getMorphStructManager()
        if behaviorType == .likeGustar {
            var p = Person.S3
            if number == .plural { p = Person.P3}
            let verbString = msm.getFinalVerbForm(person: p)
            return Person.all[i].getIndirectObjectPronounString(language: languageViewModel.getCurrentLanguage(), verbStartsWithVowel: vu.startsWithVowelSound(characterArray: verbString)) + " " + verbString
        }
        else if behaviorType == .weather {
            if i == 2 { return msm.getFinalVerbForm(person: Person.all[i])}
            else {return ""}
        }
        else if behaviorType == .thirdPersonOnly {
            if i == 2 || i == 5 {
                return msm.getFinalVerbForm(person: Person.all[i])
            }
            return ""
        }
        
        // is auxiliary
        else {
            var verbString = msm.getFinalVerbForm(person: Person.all[i])
            let result = languageViewModel.isAuxiliary(verb: currentVerb)
            
            if result.1 == .infinitive {
                verbString += dependentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
            } else if result.1 == .gerund {
                let bRomanceVerb = languageViewModel.getRomanceVerb(verb: dependentVerb)
                verbString += " " + bRomanceVerb.m_gerund
            } else if result.1 == .pastParticiple {
                let bRomanceVerb = languageViewModel.getRomanceVerb(verb: dependentVerb)
                verbString += " " + bRomanceVerb.m_pastParticiple
            }
            return verbString
        }
    }
    
    func getPersonString(i: Int)->String{
        var msm = languageViewModel.getMorphStructManager()
        if behaviorType == .likeGustar {
            let verbString = msm.getFinalVerbForm(person: Person.all[i])
            return subjunctiveWord + " a " + Person.all[i].getPrepositionalPronounString(language: languageViewModel.getCurrentLanguage(), gender: .masculine, verbStartsWithVowel: vu.startsWithVowelSound(characterArray: verbString))
        }
        else if behaviorType == .weather {
            if i == 2 { return subjunctiveWord }
            return ""
        }
        else if behaviorType == .thirdPersonOnly {
            if i == 2 || i == 5 {
                return subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType(), verbStartsWithVowel: vu.startsWithVowelSound(characterArray: correctAnswer[i])) }
            return ""
        }
        else if behaviorType == .auxiliary {
            return subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(),subjectPronounType: languageViewModel.getSubjectPronounType(), verbStartsWithVowel: vu.startsWithVowelSound(characterArray: correctAnswer[i]))
        }
        return ""
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
}

extension BehavioralVerbView {
    
    
    func evaluateStudentAnswer(studentAnswer: String, correctAnswer: String)->Bool{
        let studentAnswerClean = VerbUtilities().removeExtraBlanks(verbString: studentAnswer)
        return studentAnswerClean == correctAnswer
    }
    
    func StudentAnswerTextEditViewExpanded() -> some View {
        Form {
            HStack {
                Spacer()
                Text(person[0])
                    .foregroundColor(highlightPerson == .S1 ? .red : .black)
                    .font(highlightPerson == .S1 ? .title3.weight(.bold) : .headline.weight(.regular))
                TextField("", text: $studentAnswer[0]).focused($focusedField, equals: .p1)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(evaluateStudentAnswer(studentAnswer: studentAnswer[0], correctAnswer: correctAnswer[0]) ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(highlightPerson == .S1 ? .red : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if evaluateStudentAnswer(studentAnswer: studentAnswer[0], correctAnswer: correctAnswer[0]) {focusedField = .p2 }
                        highlightPerson = .S2
                    }
                Image(systemName: evaluateStudentAnswer(studentAnswer: studentAnswer[0], correctAnswer: correctAnswer[0]) ? "checkmark.square" : "square")
                    .foregroundColor(evaluateStudentAnswer(studentAnswer: studentAnswer[0], correctAnswer: correctAnswer[0]) ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[1])
                    .foregroundColor(highlightPerson == .S2 ? .red : .black)
                    .font(highlightPerson == .S2 ? .title3.weight(.bold) : .headline.weight(.regular))
                TextField("", text: $studentAnswer[1]).focused($focusedField, equals: .p2)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(evaluateStudentAnswer(studentAnswer: studentAnswer[1], correctAnswer: correctAnswer[1]) ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(highlightPerson == .S2 ? .red : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if evaluateStudentAnswer(studentAnswer: studentAnswer[1], correctAnswer: correctAnswer[1]){focusedField = .p3 }
                        highlightPerson = .S3
                    }
                Image(systemName: evaluateStudentAnswer(studentAnswer: studentAnswer[1], correctAnswer: correctAnswer[1]) ? "checkmark.square" : "square")
                    .foregroundColor(evaluateStudentAnswer(studentAnswer: studentAnswer[1], correctAnswer: correctAnswer[1]) ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[2])
                    .foregroundColor(highlightPerson == .S3 ? .red : .black)
                    .font(highlightPerson == .S3 ? .title3.weight(.bold) : .headline.weight(.regular))
                TextField("", text: $studentAnswer[2]).focused($focusedField, equals: .p3)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(evaluateStudentAnswer(studentAnswer: studentAnswer[2], correctAnswer: correctAnswer[2]) ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(highlightPerson == .S3 ? .red : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if evaluateStudentAnswer(studentAnswer: studentAnswer[2], correctAnswer: correctAnswer[2]){focusedField = .p4 }
                        highlightPerson = .P1
                    }
                Image(systemName: evaluateStudentAnswer(studentAnswer: studentAnswer[2], correctAnswer: correctAnswer[2]) ? "checkmark.square" : "square")
                    .foregroundColor(evaluateStudentAnswer(studentAnswer: studentAnswer[2], correctAnswer: correctAnswer[2]) ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[3])
                    .foregroundColor(highlightPerson == .P1 ? .red : .black)
                    .font(highlightPerson == .P1 ? .title3.weight(.bold) : .headline.weight(.regular))
                TextField("", text: $studentAnswer[3]).focused($focusedField, equals: .p4)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(evaluateStudentAnswer(studentAnswer: studentAnswer[3], correctAnswer: correctAnswer[3]) ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(highlightPerson == .P1 ? .red : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if evaluateStudentAnswer(studentAnswer: studentAnswer[3], correctAnswer: correctAnswer[3]){focusedField = .p5 }
                        highlightPerson = .P2
                    }
                Image(systemName: evaluateStudentAnswer(studentAnswer: studentAnswer[3], correctAnswer: correctAnswer[3]) ? "checkmark.square" : "square")
                    .foregroundColor(evaluateStudentAnswer(studentAnswer: studentAnswer[3], correctAnswer: correctAnswer[3]) ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[4])
                    .foregroundColor(highlightPerson == .P2 ? .red : .black)
                    .font(highlightPerson == .P2 ? .title3.weight(.bold) : .headline.weight(.regular))
                TextField("", text: $studentAnswer[4]).focused($focusedField, equals: .p5)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(evaluateStudentAnswer(studentAnswer: studentAnswer[4], correctAnswer: correctAnswer[4]) ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(highlightPerson == .P2 ? .red : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if evaluateStudentAnswer(studentAnswer: studentAnswer[4], correctAnswer: correctAnswer[4]){focusedField = .p6 }
                        highlightPerson = .P3
                    }
                Image(systemName: evaluateStudentAnswer(studentAnswer: studentAnswer[4], correctAnswer: correctAnswer[4]) ? "checkmark.square" : "square")
                    .foregroundColor(evaluateStudentAnswer(studentAnswer: studentAnswer[4], correctAnswer: correctAnswer[4]) ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[5])
                    .foregroundColor(highlightPerson == .P3 ? .red : .black)
                    .font(highlightPerson == .P3 ? .title3.weight(.bold) : .headline.weight(.regular))
                TextField("", text: $studentAnswer[5]).focused($focusedField, equals: .p6)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(evaluateStudentAnswer(studentAnswer: studentAnswer[5], correctAnswer: correctAnswer[5]) ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(highlightPerson == .P3 ? .red : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if evaluateStudentAnswer(studentAnswer: studentAnswer[5], correctAnswer: correctAnswer[5]){ focusedField = .p1  }
                        highlightPerson = .S1
                    }
                Image(systemName: evaluateStudentAnswer(studentAnswer: studentAnswer[5], correctAnswer: correctAnswer[5]) ? "checkmark.square" : "square")
                    .foregroundColor(evaluateStudentAnswer(studentAnswer: studentAnswer[5], correctAnswer: correctAnswer[5]) ? .green : .yellow)
            }
        }
        .background(.gray).opacity(0.7)
        .onAppear {
            currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
            changeDependentVerb()
            setCurrentVerb()
        }
    }
}

//struct VerbsLikeGustarView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalVerbsView()
//    }
//}
