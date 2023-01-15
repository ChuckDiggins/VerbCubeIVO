//
//  AuxiliaryPhraseView.swift
//  Feather2
//
//  Created by Charles Diggins on 1/3/23.
//

import SwiftUI
import JumpLinguaHelpers

enum APButtonType {
    case subject, auxVerb, mainVerb, all
}

struct AuxiliaryPhraseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var specialVerbType : SpecialVerbType
    @State var currentLanguage = LanguageType.Spanish
    
    @State var currentVerb = Verb()
    @State var currentPersonIndex = 3
    @State var mainVerbIndex = 0
    @State var currentTenseString = "present"
    @State var subjectString = "yo"
    @State var auxiliaryVerbString = "tengo que"
    @State var mainVerbString = "bailar"
    @State var subjunctiveWord = "que"
    @State private var currentNumber = Number.singular
    @State private var mainVerb = Verb()
    @State var residualPhrase = ""
    @State var comment1 = ""
    @State var comment2 = ""
    @State var mainVerbStringList = [""]
    @State var subjectSelected = true
    @State var auxiliaryVerbSelected = false
    @State var mainVerbSelected = false
    @State var subjectRotate = false
    @State var auxiliaryVerbRotate = false
    @State var mainVerbRotate = false
    
    @State var speechModeActive = false
    @State var currentPhrase = "speech mode active"
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("Phrase type: Auxiliary Verb Phrases")
                        .labelsHidden()
                        .font(.subheadline)
                        .padding(10)
                    Spacer()
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(speechModeActive ? Color("BethanyGreenText") : .red)
                        .font(speechModeActive ? .title3 : .callout)
                        .onTapGesture{
                            setSpeechModeActive()
                        }
                }
                VStack{
                    Text("Verb: \(currentVerb.getWordStringAtLanguage(language: currentLanguage))")
                    Text("Current tense: \(currentTenseString)")
                        .onTapGesture {
                            withAnimation(Animation.linear(duration: 1)) {
                                changeTense()
                            }
                        }.frame(width: 300, height: 35, alignment: .center)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(10)
                }
                VStack {
                    HStack{
                        Text("Comments").font(.callout).bold().padding(5)
                        Spacer()
                    }
                    VStack{
                        Text(comment1)
                        if comment2.count > 0 {
                            Text(comment2)
                        }
                    }
                    .font(.caption)
                    .frame(width: 300, height: 45)
                    .foregroundColor(Color("ChuckText1"))
                    .cornerRadius(10)
                    .border(Color("BethanyGreenText"))
                    .padding(.bottom)
                    
                    HStack{
                        Text("Your phrase").font(.callout).bold().padding(5)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Button{
                            changeSubject()
                        } label: {
                            Text(subjectString)
                                .foregroundColor(subjectSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(subjectRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: subjectSelected) // Delay the animation
                        }
                        .padding(1)
                       
                        Button{
                            changeCurrentVerb()
                        } label: {
                            Text(auxiliaryVerbString)
                                .foregroundColor(auxiliaryVerbSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(auxiliaryVerbRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: auxiliaryVerbSelected) // Delay the animation
                        }
                        .padding(1)
                        
                        Button{
                            changeMainVerb()
                        } label: {
                            Text(mainVerbString)
                                .foregroundColor(mainVerbSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(mainVerbRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: mainVerbSelected) // Delay the animation
                        }
                        .padding(1)
                      Spacer()
                    }
                     .font(.callout)
                     .frame(width: 350, height: 45)
                     .lineLimit(1)
                     .minimumScaleFactor(0.5)
                     .padding(5)
                     .cornerRadius(10)
                     .border(Color("BethanyGreenText"))
                    
                }
 
                VStack{
                    HStack(alignment: .center){
                        Spacer()
                        Text("Randomize")
                            .frame(width: 150, height: 45, alignment: .center)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 1)) {
                                    createRandomClause()
                                }
                            }
                            .padding()
//                        Button(action: {createRandomClause( )}) {
//                            Text("Randomize")
//                                .buttonStyle(.borderedProminent)
//                        }
                        Spacer()
                    }
                }
                .padding()
                Spacer()
            }.onAppear{
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerb = languageViewModel.getCurrentFilteredVerb()
                setSubjunctiveStuff()
                createMainVerbList()
                createRandomClause()
                currentTenseString = languageViewModel.getCurrentTense().rawValue
            }.background(Color("BethanyNavalBackground"))
                .foregroundColor(Color("BethanyGreenText"))
        }
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
    
    func changeAPButton(_ buttonType: APButtonType){
        switch buttonType{
        case .subject:
            subjectSelected = true
            auxiliaryVerbSelected = false
            mainVerbSelected = false
            subjectRotate.toggle()
            auxiliaryVerbRotate.toggle()
        case .auxVerb:
            subjectSelected = false
            auxiliaryVerbSelected = true
            mainVerbSelected = false
            auxiliaryVerbRotate.toggle()
        case .mainVerb:
            subjectSelected = false
            auxiliaryVerbSelected = false
            mainVerbSelected = true
            mainVerbRotate.toggle()
        case .all:
            subjectSelected = false
            auxiliaryVerbSelected = false
            mainVerbSelected = false
            mainVerbRotate.toggle()
            auxiliaryVerbRotate.toggle()
            subjectRotate.toggle()
        }
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if languageViewModel.getCurrentTense().isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
    func changeTense(){
        let tense = languageViewModel.getNextTense()
        currentTenseString = tense.rawValue
        setCurrentVerb()
        changeAPButton(.auxVerb)
    }
    
    func changeSubject(){
        if currentPersonIndex < 5 {
            currentPersonIndex += 1
        } else {
            currentPersonIndex = 0
        }
        setCurrentVerb()
        comment1 = "Subject changed to '\(subjectString)'"
//        var person = Person.all[currentPersonIndex]
        comment2 = ""
        changeAPButton(.subject)
    }
    
    func changeMainVerb(){
        if mainVerbIndex < mainVerbStringList.count-1 {
            mainVerbIndex += 1
        } else { mainVerbIndex = 0 }
        setCurrentVerb()
        comment1 = "Main verb changed to '\(mainVerbStringList[mainVerbIndex])'"
        comment2 = ""
        changeAPButton(.mainVerb)
    }
    
    func changeCurrentVerb(){
        languageViewModel.setNextFilteredVerb()
        setCurrentVerb()
        if languageViewModel.getFilteredVerbs().count == 1 {
            comment1 = "Verb '\(currentVerb.getWordAtLanguage(language: currentLanguage))' is only verb in list"
            comment2 = "No changes"
        } else {
            comment1 = "Verb changed to '\(currentVerb.getWordAtLanguage(language: currentLanguage))'"
            comment2 = ""
        }
        changeAPButton(.auxVerb)
    }
    
    func setCurrentVerb(){
//        setSubjunctiveStuff()
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        let tense = languageViewModel.getCurrentTense()
        currentTenseString = tense.rawValue
        auxiliaryVerbString = languageViewModel.getVerbString(personIndex: currentPersonIndex, number: currentNumber, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerb.getWordString(), dependentVerb: mainVerb, residualPhrase: residualPhrase)
        subjectString = languageViewModel.getPersonString(personIndex: currentPersonIndex, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: auxiliaryVerbString)
        mainVerbString = mainVerbStringList[mainVerbIndex]
        
        currentPhrase = subjectString + auxiliaryVerbString + mainVerbString
        if speechModeActive {
            textToSpeech(text : currentPhrase, language: currentLanguage)
        }
    }
    
    func createRandomClause(){
        languageViewModel.setNextFilteredVerb()
        currentPersonIndex = Int.random(in: 0...5)
        mainVerbIndex = Int.random(in: 0...mainVerbStringList.count-1)
        languageViewModel.setNextFilteredVerb()
        _ = languageViewModel.getNextTense()
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        setCurrentVerb()
        comment1 = "Random phrase was created"
        comment2 = "Click on any word to change"
        changeAPButton(.all)
    }
    
    func createMainVerbList(){
        mainVerbIndex = 0
        if specialVerbType == .auxiliaryVerbsGerunds {
            mainVerbStringList =  ["bailando", "comiendo", "hablando", "viniendo"]
        }
        else {
            mainVerbStringList = ["bailar", "comer", "hablar", "venir"]
        }
        
    }
    
}

