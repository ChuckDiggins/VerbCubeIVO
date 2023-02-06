//
//  VerbsLikeQuedarView.swift
//  Feather2
//
//  Created by Charles Diggins on 1/1/23.
//

import SwiftUI
import JumpLinguaHelpers

struct ObjectStruct {
    var objectString : String
    var objectNumber : Number
}

enum VLGButtonType {
    case indirectObject, directObject, verb, all
}

struct VerbsLikeGustarView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
  
    @State var currentLanguage = LanguageType.Spanish
    @State var currentVerb = Verb()
    @State var currentPersonIndex = 3
    @State var currentDOIndex = 0
    @State var currentTenseString = ""
    @State var indirectObjectString = "a mi"
    @State var currentVerbString = "me gustan"
    @State var directObjectString = "las cosas"
    @State var subjunctiveWord = "que"
    @State private var currentNumber = Number.singular
    @State private var dependentVerb = Verb()
    @State var residualPhrase = ""
    @State var comment1 = ""
    @State var comment2 = ""
    @State var speechModeActive = false
    @State var currentPhrase = "speech mode active"
    
    @State var indirectObjectRotate = false
    @State var verbRotate = false
    @State var directObjectRotate = false
    
    @State var indirectObjectSelected = false
    @State var verbSelected = false
    @State var directObjectSelected = false
    
    @State var directObjectList = [ObjectStruct(objectString: "la cosa", objectNumber: .singular),
                                   ObjectStruct(objectString: "las cosas", objectNumber: .plural),
                                   ObjectStruct(objectString: "el libro", objectNumber: .singular),
                                   ObjectStruct(objectString: "los libros", objectNumber: .plural),
                                   ObjectStruct(objectString: "bailar", objectNumber: .singular),]
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                ExitButtonView()
                HStack{
                    Text("Phrase type: Verbs like Gustar")
                        .labelsHidden()
                        .font(.subheadline)
                        .padding(10)
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
                            changeIndirectObject()
                        } label: {
                            Text(indirectObjectString)
                                .foregroundColor(indirectObjectSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(indirectObjectRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: indirectObjectSelected) // Delay the animation
                        }
                        .padding(1)
                           
                        Button{
                            changeCurrentVerb()
                        } label: {
                            Text(currentVerbString)
                                .foregroundColor(verbSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(verbRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: verbSelected) // Delay the animation
                        }
                        .padding(1)
                    
                        Button{
                            changeDirectObject()
                        } label: {
                            Text(directObjectString)
                                .foregroundColor(directObjectSelected ? .red : Color("BethanyGreenText"))
                                .rotationEffect(Angle.degrees(directObjectRotate ? 360 : 0))
                                .animation(.linear(duration: 1), value: directObjectSelected) // Delay the animation
                        }
                        .padding(1)
                        Spacer()
                    }.font(.callout)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 350, height: 45)
                        .padding(5)
                        .cornerRadius(10)
                        .border(Color("BethanyGreenText"))
                    
                }
 
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
    
   
    func changeVLGButton(_ buttonType: VLGButtonType){
        switch buttonType{
        case .indirectObject:
            indirectObjectSelected = true
            verbSelected = false
            directObjectSelected = false
            indirectObjectRotate.toggle()
            verbRotate.toggle()
        case .verb:
            indirectObjectSelected = false
            verbSelected = true
            directObjectSelected = false
            verbRotate.toggle()
        case .directObject:
            indirectObjectSelected = false
            verbSelected = false
            directObjectSelected = true
            directObjectRotate.toggle()
            verbRotate.toggle()
        case .all:
            indirectObjectSelected = false
            verbSelected = false
            directObjectSelected = false
            verbRotate.toggle()
            directObjectRotate.toggle()
            indirectObjectRotate.toggle()
        }
    }
    
    func changeTense(){
        let tense = languageViewModel.getNextTense()
        currentTenseString = tense.rawValue
        setCurrentVerb()
        changeVLGButton(.verb)
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
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if languageViewModel.getCurrentTense().isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
    func changeIndirectObject(){
        if currentPersonIndex < 5 {
            currentPersonIndex += 1
        } else {
            currentPersonIndex = 0
        }
        setCurrentVerb()
        comment1 = "Indirect object changed to '\(indirectObjectString)'"
        let person = Person.all[currentPersonIndex]
        var iop = Pronoun().getIndirectObjectPronoun(language: currentLanguage, person: person)
        comment2 = ""
        changeVLGButton(.indirectObject)
    }
    
    func changeCurrentVerb(){
        languageViewModel.setNextFilteredVerb()
        setCurrentVerb()
        if languageViewModel.getFilteredVerbs().count == 1 {
            comment1 = "Verb '\(currentVerb.getWordAtLanguage(language: currentLanguage))' is only verb in list"
            comment2 = ""
        } else {
            comment1 = "Verb changed to '\(currentVerb.getWordAtLanguage(language: currentLanguage))'"
            comment2 = ""
        }
        changeVLGButton(.verb)
    }
    
    func changeDirectObject(){
        if currentDOIndex < directObjectList.count-1 {
            currentDOIndex += 1
        } else {
            currentDOIndex = 0
        }
        directObjectString = directObjectList[currentDOIndex].objectString
        currentNumber = directObjectList[currentDOIndex].objectNumber
        let beforeVerbString = currentVerbString
        setCurrentVerb()
        comment1 = "Changes the verb from '\(beforeVerbString)' to '\(currentVerbString)'"
        comment2 = "This does NOT change the object pronouns"
        changeVLGButton(.directObject)
    }
    
    func setCurrentVerb(){
        let vu = VerbUtilities()
        setSubjunctiveStuff()
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        currentVerbString = languageViewModel.getVerbString(personIndex: currentPersonIndex, number: currentNumber, tense: languageViewModel.getCurrentTense(), specialVerbType: .verbsLikeGustar, verbString: currentVerb.getWordString(), dependentVerb: dependentVerb, residualPhrase: residualPhrase)
        
        indirectObjectString = languageViewModel.getPersonString(personIndex: currentPersonIndex, tense: languageViewModel.getCurrentTense(), specialVerbType: .verbsLikeGustar, verbString: currentVerbString)
        
        currentPhrase = indirectObjectString + currentVerbString + directObjectString
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
        currentDOIndex = Int.random(in: 0...3)
        directObjectString = directObjectList[currentDOIndex].objectString
        currentNumber = directObjectList[currentDOIndex].objectNumber
        languageViewModel.setNextFilteredVerb()
        currentTenseString = languageViewModel.getNextTense().rawValue
        setCurrentVerb()
        changeVLGButton(.all)
        comment1 = "Random phrase was created"
        comment2 = "Click on any word to change"
    }
    
}

struct VerbsLikeGustarView_Previews: PreviewProvider {
    static var previews: some View {
        VerbsLikeGustarView(languageViewModel: LanguageViewModel())
    }
}
