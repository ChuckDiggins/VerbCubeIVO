//
//  QuizVerbViewExtensions.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/21/22.
//

import SwiftUI



extension QuizVerbView {
    func SetVerbAndTenseView() -> some View {
        VStack {
            VStack{
                HStack{
                    Text("Verb ")
                    Button{
                        nextVerb()
                    } label: {
                        Text("\(currentVerbString)")
                    }
                    .padding(10)
                    Button(action: {
                        currentTense = languageViewModel.getLanguageEngine().getNextTense()
                        currentTenseString = currentTense.rawValue
                        setCurrentVerb()
                    }){
                        Text(currentTenseString)
                    }
                    Text(" tense")
                    
                }
                .buttonStyle(.bordered)
                .tint(.yellow)
                //show relevant tenses
                
                
                //            .disabled(currentVerbPhrase.isEmpty)
                
                //            if ( bValidVerb ){
                .padding(10)
                HStack{
                    Button{
                        fillStudentAnswersWithInfinitive()
                    } label: {
                        Text(currentVerbString)
                    }
                    Button{
                        fillStudentAnswersWithBlank()
                    } label: {
                        ZStack{
                            Text(currentVerbString).opacity(0.5)
                            Text("X").bold()
                                .foregroundColor(.red)
                        }
                    }
                    Button{
                        fillStudentAnswersWithCorrectAnswers()
                    } label: {
                        Text("Cheat")
                    }
                    
                }
                .buttonStyle(.bordered)
                .tint(.pink)
            }
            .padding(3)
        }
        .padding()
    }
    
    func StudentAnswerTextEditView() -> some View {
        Form {
            ForEach (0..<6){ i in
                HStack {
                    Spacer()
                    Text(person[i])
                    TextField("", text: $studentAnswer[i])
                        .focused($focusedField, equals: .p1)
                    //                        .focused($focusedField, equals: FocusEnum.findFocusEnumByIndex(index: i))
                        .frame(width: 200, height: 30)
                        .background(studentAnswer[i] == correctAnswer[i] ? .green : .yellow)    //this is where to make this cleaner
                        .foregroundColor(.black)
                        .border(Color.black)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit{
                            if studentAnswer[i] == correctAnswer[i] {
                                focusedField = .p2
                            }
                        }
                    Image(systemName: studentAnswer[i] == correctAnswer[i]  ? "checkmark.square" : "square")
                        .foregroundColor(studentAnswer[i] == correctAnswer[i] ? .green : .yellow)
                }
            }
        }
        .background(.gray).opacity(0.7)
        .onAppear {
            currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
            setCurrentVerb()
        }
    }
    
    //--------------------------------------------------------------
    //
    // couldn't get the focus to work correctly as a array of focus enums
    //
    // took the messy but easy way out
    //
    //---------------------------------------------------------------
    
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
