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
                        languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
                    } label: {
                        Text("Create new set of problems").foregroundColor(.red)
                    }
                    
                    //                    Button{
                    //                        languageViewModel.fillFlashCardsForProblemsOfRandomTense()
                    //                    } label: {
                    //                        Text("Create problems for random tense").foregroundColor(.red)
                    //                    }
                    //
                    //                    Button{
                    //                        languageViewModel.fillFlashCardsForProblemsOfRandomPerson()
                    //                    } label: {
                    //                        Text("Create problems for random person").foregroundColor(.red)
                    //                    }
                    
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
    
    
    
    enum FocusField: Hashable {
        case field
    }
    @State var wrong = 0
    @State var correct = 0
    
    @State var flashChoice = [0, 1]
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        ZStack{
            VStack{
                showHeaderInfo()
                    .padding(.horizontal, 3)
                
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
                
            }
            .onAppear{
                currentLanguage = languageViewModel.getCurrentLanguage()
                fcp = languageViewModel.getCurrentFlashCard()
                wrong = languageViewModel.getWrongScore()
                correct = languageViewModel.getCorrectScore()
            }
        }.frame(width: UIScreen.main.bounds.width - 25, height: 300)
            .background(Color("BethanyNavalBackground"))
            .cornerRadius(20)
            .border(.green)
    }
    
    fileprivate func MultipleChoiceView() -> some View {
        
        return  VStack{
            VStack{
                let gridFixSize = CGFloat(160.0)
                let gridItems = [GridItem(.fixed(gridFixSize)),
                                 GridItem(.fixed(gridFixSize))]
                
                
                Text("Verb: \(fcp.verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())), Tense: \(fcp.tense.rawValue.lowercased())").font(.callout)
                Text("Subject: \(fcp.person.getMaleString())" ).font(.title3)
                
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach(0..<fcp.getAnswerCount(), id: \.self ){i in
                        Button{
                            if fcp.isCorrectAnswer(ans: fcp.getAnswer(i: i)) {
                                languageViewModel.incrementCorrectScore()
                                correct = languageViewModel.getCorrectScore()
                                languageViewModel.incrementStudentCorrectScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                            } else {
                                languageViewModel.incrementWrongScore()
                                wrong = languageViewModel.getWrongScore()
                                languageViewModel.incrementStudentWrongScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                            }
                            getNextStudentProblem()
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
                Spacer()
            }
            .background(Color("BethanyNavalBackground"))
            .frame(width: UIScreen.main.bounds.width - 25, height: 200)
                .cornerRadius(20)
               
        }
    }
    
    fileprivate func TextFieldView() -> some View {
        return VStack{
            VStack{
                HStack {
                    Text("Verb: \(fcp.verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))")
                    Text("Tense: \(fcp.tense.rawValue.lowercased())")
                }
                HStack{
                    Text("\(fcp.person.getMaleString())").font(.title2)
                    TextField("", text: $answerText)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.red)
                        .textCase(.lowercase)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .modifier(NeumorphicTextfieldModifier())
                        .focused($focusedField, equals: .field)
                        .task {
                            self.focusedField = .field
                        }
                        .onChange(of: answerText){ value in
                            print("OnChange: answerText = \(answerText)")
                        }
                        .onSubmit(){
                            print("OnSubmit: answerText = \(answerText)")
                            if fcp.isCorrectAnswer(ans: answerText) {
                                languageViewModel.incrementCorrectScore()
                                correct = languageViewModel.getCorrectScore()
                                languageViewModel.incrementStudentCorrectScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                                isCorrect = true
                            } else {
                                languageViewModel.incrementWrongScore()
                                wrong = languageViewModel.getWrongScore()
                                languageViewModel.incrementStudentWrongScore(verb: fcp.verb, tense: fcp.tense, person: fcp.person)
                                isCorrect = false
                                previousCorrectAnswer = fcp.correctAnswer
                            }
                            if isCorrect {
                                getNextStudentProblem()
                            }
                            answerComplete = true
                        }
                    //                if ( answerText.count > 1 ){
                    //                    HStack{
                    //                        Text("\(fcp.person.getMaleString())").font(.title3)
                    //                        Text(answerText).font(.title3).foregroundColor(.red)
                    //                    }
                    //                }
                }.padding()
                if !isCorrect && answerComplete {
                    showMessageFooter()
                }
                Spacer()
            }.background(Color("BethanyNavalBackground"))
                .frame(width: UIScreen.main.bounds.width - 25, height: 200)
                    .cornerRadius(20)
                    .border(.green)
            
        }
    }
    
    fileprivate func showMessageFooter() -> some View {
        return  VStack{
            HStack{
                Text("Correct answer is \(previousCorrectAnswer)").font(.title2).foregroundColor(.red)
                Button{
                    getNextStudentProblem()
                } label: {
                    Text("Ok").padding(3)
                }.foregroundColor(Color("BethanyNavalBackground"))
                    .background(Color("BethanyGreenText"))
            }
        }.padding()
        .border(.red)
    }
    
    fileprivate func showHeaderInfo() -> some View {
        return  VStack{
            HStack{
                Spacer()
                Button{
                    shown.toggle()
                } label: {
                    Image(systemName: "xmark").resizable().frame(width: 10, height: 10).padding(8)
                }.background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
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
            Spacer()
        }
        .padding(.horizontal, 3)
    }
    
    func getNextStudentProblem(){
        answerComplete = false
        answerText = ""
        languageViewModel.setNextFlashCard()
        fcp = languageViewModel.getCurrentFlashCard()
        self.focusedField = .field
    }
    
}



