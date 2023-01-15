
//  NormalPhraseView.swift
//  Feather2
//
//  Created by Charles Diggins on 1/4/23.
//

import SwiftUI
import JumpLinguaHelpers

struct GeneralPhraseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var specialVerbType : SpecialVerbType
    @State var currentLanguage = LanguageType.Spanish
    
    @State var currentVerb = Verb()
    @State var dependentVerb = Verb()
    @State var currentPersonIndex = 3
    @State var currentTenseString = "present"
    @State var firstString = "yo"
    @State var currentVerbString = "tengo que"
    @State var subjunctiveWord = "que"
    @State private var currentNumber = Number.singular
    @State var residualPhrase = ""
    @State var comment1 = ""
    @State var comment2 = ""
    @State var subjectSelected = true
    @State var speechModeActive = false
    @State var currentPhrase = "speech mode active"
    var phraseComponentCount = 2
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("Phrase type: Normal Phrases")
                        .labelsHidden()
                        .font(.subheadline)
                        .padding(10)
                    Spacer()
                    Image(systemName: "speaker.wave.3.fill").foregroundColor(Color("BethanyGreenText"))
                        .onTapGesture{
                            setSpeechModeActive()
                        }
                }
                Text("Current tense: \(currentTenseString)")
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 1)) {
                            changeTense()
                        }
                    }
                    .background(.yellow)
                    .foregroundColor(.black )
                
                VStack {
                    VStack{
                        Text(comment1)
                        if comment2.count > 0 {
                            Text(comment2)
                        }
                    }
                    .font(.caption)
                    .frame(width: 300, height: 45)
                    .background(.yellow)
                    .foregroundColor(.black)
                    .padding(10)
                    HStack(spacing:3){
                        Text(firstString).foregroundColor(subjectSelected ? .red : Color("BethanyGreenText"))
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 1)) {
                                    changeFirstString()
                                }
                            }
                        Text(currentVerbString).foregroundColor(subjectSelected ? Color("BethanyGreenText") : .red)
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 1)) {
                                    changeCurrentVerb()
                                }
                            }
                        
                    }.font(.callout)
                        .frame(width: 300, height: 45)
                        .background(.white)
                        .padding(10)
                    
                }
 
                VStack{
                    HStack(alignment: .center){
                        Spacer()
                        Button(action: {createRandomClause( )}) {
                            Text("Randomize")
                                .buttonStyle(.borderedProminent)
                        }
                        Spacer()
                    }
                }
                .padding()
                Spacer()
            }.onAppear{
                if specialVerbType == 
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerb = languageViewModel.getCurrentFilteredVerb()
                createRandomClause()
                currentTenseString = languageViewModel.getCurrentTense().rawValue
                comment1 = "Click on any part of the phrase to change"
                comment2 = "Current verb is \(currentVerbString)"
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
    
    func changeTense(){
        let tense = languageViewModel.getNextTense()
        currentTenseString = tense.rawValue
        setCurrentVerb()
    }
    
    func changeFirstString(){
        if currentPersonIndex < 5 {
            currentPersonIndex += 1
        } else {
            currentPersonIndex = 0
        }
        setCurrentVerb()
        comment1 = "Subject changed to '\(firstString)'"
        subjectSelected = true
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
        subjectSelected = false
    }
    
    func setCurrentVerb(){
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        currentVerbString = languageViewModel.getVerbString(personIndex: currentPersonIndex, number: currentNumber, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerb.getWordString(), dependentVerb: dependentVerb, residualPhrase: residualPhrase)
        firstString = languageViewModel.getPersonString(personIndex: currentPersonIndex, tense: languageViewModel.getCurrentTense(), specialVerbType: specialVerbType, verbString: currentVerbString)
        currentPhrase = firstString + currentVerbString
        if speechModeActive {
            textToSpeech(text : currentPhrase, language: currentLanguage)
        }
    }
    
    func createRandomClause(){
        languageViewModel.setNextFilteredVerb()
        currentPersonIndex = Int.random(in: 0...5)
        languageViewModel.setNextFilteredVerb()
        let tense = languageViewModel.getNextTense()
        setCurrentVerb()
    }
    
}



import SwiftUI

struct GeneralPhraseView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GeneralPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPhraseView()
    }
}
