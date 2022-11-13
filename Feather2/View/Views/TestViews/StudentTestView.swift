//
//  MultipleChoiceAlert.swift
//  CustomAlertTest
//
//  Created by Charles Diggins on 9/16/22.
//

import SwiftUI
import JumpLinguaHelpers

enum FlashMode {
    case TextField, MultipleChoice, Random
}

struct StudentTestView: View {
    @ObservedObject var languageViewModel : LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @State var multipleChoiceShown = false
    @State var textEditorShown = false
    @State var randomShown = false
    @State var wrong = 3
    @State var correct = 5
    
    var body: some View {
        ZStack {
            NavigationView{
                
                List{
                   
                    Button{
                        textEditorShown = false
                        randomShown = false
                        multipleChoiceShown.toggle()
                    } label: {
                        Text("Multiple choice flash cards")
                    }
                    Button{
                        multipleChoiceShown = false
                        randomShown = false
                        textEditorShown.toggle()
                    } label: {
                        Text("Text editor flash cards")
                    }
                    
                    
                }.navigationBarTitle("Testing")
                    .padding()
                
            }
            //            .blur(radius: shown ? 30 : 0)
            
            if multipleChoiceShown {
                CombinedAlert(languageViewModel: languageViewModel, flashMode: .MultipleChoice, shown: $multipleChoiceShown)
            }
            
            if textEditorShown {
                CombinedAlert(languageViewModel: languageViewModel, flashMode: .TextField, shown: $textEditorShown)
            }
            
            if randomShown {
                CombinedAlert(languageViewModel: languageViewModel, flashMode: .Random, shown: $randomShown)
            }
        }.foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            .onAppear{
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
            }
        
    }
}

struct CombinedAlert: View {
    @ObservedObject var languageViewModel : LanguageViewModel
    var flashMode : FlashMode
    @State var currentLanguage = LanguageType.Agnostic
    
    @State var fcp = FlashCard()
    @Binding var shown : Bool
    @State var myText = "sdfasdf"
    @State var answerText = ""
    @State var footerText = ""
    @State var isCorrect = false
    @State var answerComplete = false
    @State var previousCorrectAnswer = ""
    @State var previousWrongAnswer = ""
    
    @State var isComplete = false
    
    enum FocusField: Hashable {
        case field
    }
    @State var wrong = 0
    @State var correct = 0
    
    @State var flashChoice = [0, 1]
    
    @State var correctSymbol = ""
    @State var userMsg1 = ""
    @State var userMsg2 = ""
    @State var personString = ""
    @State var isMale = true
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        ZStack{
            VStack(spacing: 5){
                showHeaderInfo()
                    .padding(.horizontal, 3)
                Spacer(minLength: 5)
                switch flashMode {
                case .MultipleChoice:
                    MultipleChoiceView()
                case .TextField:
                    TextFieldView()
                case .Random:
                    if flashChoice.randomElement() == 0 {
                        MultipleChoiceView()
                    } else {
                        TextFieldView()
                    }
                }
                Spacer()
            }
            .onAppear{
                currentLanguage = languageViewModel.getCurrentLanguage()
                wrong = languageViewModel.getWrongScore()
                correct = languageViewModel.getCorrectScore()
                getNextStudentProblem()
            }
            
        }.frame(width: UIScreen.main.bounds.width - 25, height: 400)
            .background(Color("BethanyNavalBackground"))
            .cornerRadius(20)
            .border(.green)
    }
    
    fileprivate func MultipleChoiceView() -> some View {
        let gridFixSize = CGFloat(160.0)
        let gridItems = [GridItem(.fixed(gridFixSize)),
                         GridItem(.fixed(gridFixSize))]
        return  VStack{
            VStack{
                Text("Verb: \(fcp.verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())), Tense: \(fcp.tense.rawValue.lowercased())").font(.callout)
                Text("Subject: \(fcp.person.getMaleString())" ).font(.title3)
            }
            LazyVGrid(columns: gridItems, spacing: 5){
                ForEach(0..<fcp.getAnswerCount(), id: \.self ){i in
                    Button{
                        if fcp.isCorrectAnswer(ans: fcp.getAnswer(i: i)) {
                            languageViewModel.incrementCorrectScore()
                            correct = languageViewModel.getCorrectScore()
                            languageViewModel.incrementStudentCorrectScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                            isCorrect = true
                            previousCorrectAnswer = fcp.correctAnswer
                        } else {
                            languageViewModel.incrementWrongScore()
                            wrong = languageViewModel.getWrongScore()
                            languageViewModel.incrementStudentWrongScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                            isCorrect = false
                            previousCorrectAnswer = fcp.correctAnswer
                            previousWrongAnswer = fcp.getAnswer(i: i)
                        }
                        personString = fcp.person.getMaleString()
                        fillMessageFooter(isCorrect: isCorrect)
                        answerComplete = true
                        //                            getNextStudentProblem()
                    } label: {
                        Text(fcp.getAnswer(i: i))
                            .frame(width:160, height:40)
                            .font(.callout)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(3)
                    }
                    
                }
            }
            if answerComplete{
                messageFooter()
            }
            else {
                emptyFooter()
            }
            
            
            
            
        }
        .background(Color("BethanyNavalBackground"))
        //        .frame(width: UIScreen.main.bounds.width - 25, height: 500)
        .cornerRadius(20)
    }
    
    fileprivate func TextFieldView() -> some View {
        VStack(spacing: 5){
            HStack {
                Text("Verb: \(fcp.verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))")
                Text("Tense: \(fcp.tense.rawValue.lowercased())")
            }
            HStack{
                Text("\(personString)").font(.title2).foregroundColor(.yellow)
                    .frame(width: 150, alignment: .trailing)
                
                TextField("", text: $answerText)
                    .padding(.horizontal, 3)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.red)
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .modifier(NeumorphicTextfieldModifier())
                    .focused($focusedField, equals: .field)
                    .border(.yellow)
                    .task {
                        self.focusedField = .field
                    }
                //                        .onChange(of: answerText){ value in
                //                            print("OnChange: answerText = \(answerText)")
                //                        }
                    .onSubmit(){
                        if fcp.isCorrectAnswer(ans: answerText) {
                            languageViewModel.incrementCorrectScore()
                            correct = languageViewModel.getCorrectScore()
                            languageViewModel.incrementStudentCorrectScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                            isCorrect = true
                            previousWrongAnswer = answerText
                            previousCorrectAnswer = fcp.correctAnswer
                        } else {
                            languageViewModel.incrementWrongScore()
                            wrong = languageViewModel.getWrongScore()
                            languageViewModel.incrementStudentWrongScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                            isCorrect = false
                            previousCorrectAnswer = fcp.correctAnswer
                        }
                        fillMessageFooter(isCorrect: isCorrect)
                        
                        //                            if isCorrect {
                        //                                getNextStudentProblem()
                        //                            }
                        answerComplete = true
                    }
                //                if ( answerText.count > 1 ){
                //                    HStack{
                //                        Text("\(fcp.person.getMaleString())").font(.title3)
                //                        Text(answerText).font(.title3).foregroundColor(.red)
                //                    }
                //                }
            }
            if answerComplete{
                messageFooter()
            }
            Spacer()
            
        }.border(.yellow)
    }
    
    func fillMessageFooter(isCorrect: Bool){
        correctSymbol = "❌"
        if isCorrect {
            correctSymbol = "✅"
            userMsg1 = "Your correct answer"
            userMsg2 = personString + " " + previousCorrectAnswer
            
        }
        else {
            correctSymbol = "❌"
            userMsg1 = "Correct answer was"
            userMsg2 = personString + " " + previousCorrectAnswer
            if languageViewModel.isSpeechModeActive(){
                let vu = VerbUtilities()
//                textToSpeech(text: "Wrong, your answer was", language: .English)
//                textToSpeech(text: previousWrongAnswer, language: .Spanish)
//                textToSpeech(text: "The correct answer was", language: .English)
                textToSpeech(text: userMsg2, language: .Spanish)
            }
        }
        if languageViewModel.isSpeechModeActive(){
            let vu = VerbUtilities()
            textToSpeech(text: userMsg2, language: .Spanish)
        }
        
    }
    
    fileprivate func emptyFooter() -> some View {
        VStack{
        }.frame(width: 300, height: 100)
            .border(Color("BethanyNavalBackground"))
    }
    
    fileprivate func messageFooter() -> some View {
        VStack{
            HStack(spacing: 20) {
                Text(correctSymbol).font(.title)
                Button{
                    getNextStudentProblem()
                } label: {
                    Text("Next").padding(3)
                }.foregroundColor(Color("BethanyNavalBackground"))
                    .background(Color("BethanyGreenText"))
            }
            VStack{
                Text(userMsg1)
                Text(userMsg2)
            }
            
        }.frame(width: 300, height: 100)
            .border(.red)
    }
    
    fileprivate func showHeaderInfo() -> some View {
        return  VStack{
            HStack{
                Text("Wrong: \(wrong)")
                Spacer()
                Button{
                    languageViewModel.resetScores()
                    correct = languageViewModel.getCorrectScore()
                    wrong = languageViewModel.getWrongScore()
                } label: {
                    Text("Reset").padding()
                }
                Spacer()
                Text("Correct: \(correct)")
            }
            .padding(.horizontal, 5)
            .border(.red)
            Button{
                setVerbCompleted()
               
            } label: {
                Text("Set complete")
            }
        }
        .padding(.horizontal, 3)
    }
    
    func setVerbCompleted(){
        isComplete = true
        languageViewModel.setSelectedVerbModelsComplete()
        dismiss()
    }
    
    func getNextStudentProblem(){
        answerComplete = false
        answerText = ""
        languageViewModel.setNextFlashCard()
        fcp = languageViewModel.getCurrentFlashCard()
        personString = fcp.person.getMaleString()
        if fcp.tense.isSubjunctive() {
            personString = "que " + personString
        }
        self.focusedField = .field
    }
    
}



