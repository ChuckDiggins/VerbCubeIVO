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
    
    var studentAnswerFrameWidth : CGFloat = 150
    @State private var number = Number.singular
    @FocusState var focusedField: FocusEnum?
    
    var body: some View {
//        NavigationView{
        VStack{
            HStack{
                Text("Verb Behavior Model")
                Text(behaviorType.rawValue)
                    .padding(2)
                    .cornerRadius(4)
            }
            .background(Color.yellow)
                .foregroundColor(.black)
                .frame(width: 350, height: 40)
            
            Button{
                showMeCorrectAnswers.toggle()
            } label: {
                Text(showMeCorrectAnswers ? "🐵" : "🙈")
                    .bold()
                    .font(.title)
                    .foregroundColor(.black)
                    .background(showMeCorrectAnswers ? .green : .yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(radius: 3)
                    .padding(10)
            }
            //show relevant tenses
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        languageViewModel.setNextBehavioralVerb()
                        currentVerb = languageViewModel.getCurrentBehavioralVerb()
                        setCurrentVerb()
                    }){
                        Text(currentVerbPhrase)
                            .background(Color.yellow)
                    }
                    Spacer()
                    Button(action: {
                        currentTense = languageViewModel.getLanguageEngine().getNextTense()
                        currentTenseString = currentTense.rawValue
                        setCurrentVerb()
                    }){
                        Text(currentTenseString)
                            .background(Color.yellow)
                    }
                    Spacer()
                }.background(Color.yellow)
                
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
                                .foregroundColor(.black)
                                .background(.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(radius: 3)
                                .padding(3)
                            Text(result.1)
                                .bold()
                                .frame(width: 350)
                                .font(.callout)
                                .foregroundColor(.black)
                                .background(.orange)
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
                                .background(Color.orange)
//                                .frame(width: 200, height: frameHeight, alignment: .trailing)
                                .cornerRadius(8)
                        }
                    }
                    Spacer()
                }
                .onAppear {
                    languageViewModel.setBehaviorType(bt: behaviorType)
                    currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                    currentVerb = languageViewModel.getCurrentBehavioralVerb()
                    setCurrentVerb()
                }
                Spacer()
            }
//        }

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
            let dependentVerb = languageViewModel.getRandomFeatherVerb()
            if result.1 == .infinitive {
                verbString += " " + dependentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
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
                return subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: .masculine, verbStartsWithVowel: vu.startsWithVowelSound(characterArray: correctAnswer[i])) }
            return ""
        }
        else if behaviorType == .auxiliary {
            return subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: .masculine, verbStartsWithVowel: vu.startsWithVowelSound(characterArray: correctAnswer[i]))
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
    func StudentAnswerTextEditViewExpanded() -> some View {
        Form {
            HStack {
                Spacer()
                Text(person[0])
                TextField("", text: $studentAnswer[0]).focused($focusedField, equals: .p1)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(studentAnswer[0] == correctAnswer[0] ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if studentAnswer[0] == correctAnswer[0] {focusedField = .p2 }
                    }
                Image(systemName: studentAnswer[0] == correctAnswer[0]  ? "checkmark.square" : "square")
                    .foregroundColor(studentAnswer[0] == correctAnswer[0] ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[1])
                TextField("", text: $studentAnswer[1]).focused($focusedField, equals: .p2)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(studentAnswer[1] == correctAnswer[1] ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if studentAnswer[1] == correctAnswer[1] {focusedField = .p3 }
                    }
                Image(systemName: studentAnswer[1] == correctAnswer[1]  ? "checkmark.square" : "square")
                    .foregroundColor(studentAnswer[1] == correctAnswer[1] ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[2])
                TextField("", text: $studentAnswer[2]).focused($focusedField, equals: .p3)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(studentAnswer[2] == correctAnswer[2] ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if studentAnswer[2] == correctAnswer[2] {focusedField = .p4 }
                    }
                Image(systemName: studentAnswer[2] == correctAnswer[2]  ? "checkmark.square" : "square")
                    .foregroundColor(studentAnswer[2] == correctAnswer[2] ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[3])
                TextField("", text: $studentAnswer[3]).focused($focusedField, equals: .p4)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(studentAnswer[3] == correctAnswer[3] ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if studentAnswer[3] == correctAnswer[3 ]{focusedField = .p5 }
                    }
                Image(systemName: studentAnswer[3] == correctAnswer[3]  ? "checkmark.square" : "square")
                    .foregroundColor(studentAnswer[3] == correctAnswer[3] ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[4])
                TextField("", text: $studentAnswer[4]).focused($focusedField, equals: .p5)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(studentAnswer[4] == correctAnswer[4] ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if studentAnswer[4] == correctAnswer[4 ]{focusedField = .p6 }
                    }
                Image(systemName: studentAnswer[4] == correctAnswer[4]  ? "checkmark.square" : "square")
                    .foregroundColor(studentAnswer[4] == correctAnswer[4] ? .green : .yellow)
            }
            HStack {
                Spacer()
                Text(person[5])
                TextField("", text: $studentAnswer[5]).focused($focusedField, equals: .p6)
                    .frame(width: studentAnswerFrameWidth, height: 30)
                    .background(studentAnswer[5] == correctAnswer[5] ? .green : .yellow)
                    .foregroundColor(.black)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit{
                        if studentAnswer[5] == correctAnswer[5 ]{ focusedField = .p1  }
                    }
                Image(systemName: studentAnswer[5] == correctAnswer[5]  ? "checkmark.square" : "square")
                    .foregroundColor(studentAnswer[5] == correctAnswer[5] ? .green : .yellow)
            }
        }
        .background(.gray).opacity(0.7)
        .onAppear {
            currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
            setCurrentVerb()
        }
    }
}
    
//struct VerbsLikeGustarView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalVerbsView()
//    }
//}
