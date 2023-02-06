//
//  NormalPhraseView.swift
//  Feather2
//
//  Created by Charles Diggins on 1/4/23.
//

import SwiftUI
import JumpLinguaHelpers

enum NPButtonType{
    case subject, verb, all
}

struct NormalPhraseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    @State var specialVerbType : SpecialVerbType
    @State var currentLanguage = LanguageType.Spanish
    
    @State var currentVerb = Verb()
    @State var dependentVerb = Verb()
    @State var currentPersonIndex = 3
    @State var currentTenseString = "present"
    @State var subjectString = "yo"
    @State var currentVerbString = "tengo que"
    @State var subjunctiveWord = "que "
    @State private var currentNumber = Number.singular
    @State var residualPhrase = ""
    @State var comment1 = ""
    @State var comment2 = ""
    @State var subjectSelected = true
    @State var verbSelected = false
    @State var subjectRotate = false
    @State var verbRotate = false
    @State var speechModeActive = false
    @State var currentPhrase = "speech mode active"
   
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                ExitButtonViewWithSpeechIcon(setSpeechModeActive: setSpeechModeActive)
                HStack{
                    Text("Phrase type: Normal Phrases")
                        .labelsHidden()
                        .font(.subheadline)
                        .padding(10)
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
                        .padding(.bottom)
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
                                .animation(.linear(duration: 1), value: subjectSelected)
                        }
                        Button{
                            changeCurrentVerb()
                        } label: {
                            Text(currentVerbString)
                                .foregroundColor(verbSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(verbRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: verbSelected)
                                
                        }
                        Spacer()
                    }.font(.callout)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 350, height: 45)
                        .cornerRadius(10)
                        .border(Color("BethanyGreenText"))
                    
                }
 
                Text("Randomize")
                    .frame(width: 150, height: 45)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 1)) {
                            createRandomClause()
                        }
                    }
                    .padding()
                Spacer()
            }.onAppear{
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerb = languageViewModel.getCurrentFilteredVerb()
                createRandomClause()
                currentTenseString = languageViewModel.getCurrentTense().rawValue
            }.background(Color("BethanyNavalBackground"))
                .foregroundColor(Color("BethanyGreenText"))
        }
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if languageViewModel.getCurrentTense().isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
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
    
    func changeNPButton(_ buttonType: NPButtonType){
        switch buttonType{
        case .subject:
            subjectSelected = true
            verbSelected = false
            subjectRotate.toggle()
            verbRotate.toggle()
        case .verb:
            subjectSelected = false
            verbSelected = true
            verbRotate.toggle()
        case .all:
            subjectSelected = false
            verbSelected = false
            verbRotate.toggle()
            subjectRotate.toggle()
        }
        refreshAllParts()   //makes sure the text components redraw
    }
    
    func refreshAllParts(){
        currentVerbString = currentVerbString
        subjectString = subjectString
    }
    
    func changeTense(){
        let tense = languageViewModel.getNextTense()
        currentTenseString = tense.rawValue
        setCurrentVerb()
        comment1 = "Tense changed to '\(currentTenseString)'"
        changeNPButton(.verb)
    }
    
    func changeSubject(){
        if currentPersonIndex < 5 {
            currentPersonIndex += 1
        } else {
            currentPersonIndex = 0
        }
        setCurrentVerb()
        comment1 = "Subject changed to '\(subjectString)'"
        changeNPButton(.subject)
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
        changeNPButton(.verb)
    }
    
    func setCurrentVerb(){
        setSubjunctiveStuff()
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        print("currentVerb: \(currentVerb.getWordStringAtLanguage(language: currentLanguage))")
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        currentVerbString = languageViewModel.getVerbString(personIndex: currentPersonIndex, number: currentNumber, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerb.getWordString(), dependentVerb: dependentVerb, residualPhrase: residualPhrase)
        subjectString = subjunctiveWord + languageViewModel.getPersonString(personIndex: currentPersonIndex, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerbString)
        
        currentPhrase = subjectString + currentVerbString
        if ( languageViewModel.getCurrentTense() == .imperative && currentPersonIndex == 0 )
        {
            currentPhrase = "No command forms for subject yo"
        }
        
        if speechModeActive {
            textToSpeech(text : currentPhrase, language: currentLanguage)
        }
    }
    
    func createRandomClause(){
        languageViewModel.setNextFilteredVerb()
        currentPersonIndex = Int.random(in: 0...5)
        languageViewModel.setNextFilteredVerb()
        _ = languageViewModel.getNextTense()
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        setCurrentVerb()
        changeNPButton(.all)
        comment1 = "Random phrase was created"
        comment2 = "Click on any word to change"
    }
    
}

