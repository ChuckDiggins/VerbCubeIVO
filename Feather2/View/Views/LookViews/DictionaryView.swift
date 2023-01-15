//
//  DictionaryView.swift
//  Feather2
//
//  Created by Charles Diggins on 1/14/23.
//

import SwiftUI
import Combine
import JumpLinguaHelpers


struct DictionaryView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Agnostic
    @State private var spanishVerb = SpanishVerb()
    @State private var spanishPhrase = ""
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State var tenseIndex = 0
    var tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future, .presentSubjunctive,
                     .imperfectSubjunctiveRA, .presentPerfect, .presentProgressive]
    @State private var verbList = [Verb]()
    @State private var currentVerb = Verb()
    @State private var currentVerbNumber = 1
    @State private var verbCount = 0
    @State var currentIndex = 0
    @State var currentTense = Tense.present
    @State var personString = ["","","","","",""]
    @State var verb1String = ["","","","","",""]
    @State var currentVerbModel = RomanceVerbModel()
    @State var showResidualPhrase = true
    @State var showReflexivePronoun = true
    @State var isReflexive = true
    @State var residualPhrase = ""
    @State private var matching = [false, false, false, false, false, false]
    
    //swipe gesture
    
    @State var startPos : CGPoint = .zero
    @State var isSwiping = true
    @State var color = Color.red.opacity(0.4)
    @State var direction = ""
    
    @State var userString = ""
    
    //@State var bAddNewVerb = false
    
    var body: some View {
        //        ZStack{
        //            Color("BethanyNavalBackground")
        //                .ignoresSafeArea()
        //
        
        VStack{
            Text("Spanish Dictionary").foregroundColor(Color("ChuckText1")).font(.title2)
            HStack{
                
                TextField("🔍", text: $userString,
                          onEditingChanged: { changed in
                }){
                }
                .disableAutocorrection(true)

                .modifier(NeumorphicTextfieldModifier())
                .onChange(of: userString){ (value) in
                    let verbIndex = findClosestVerbIndex(userString)
                    if verbIndex > 0 {
                        currentIndex = verbIndex
                        currentVerb = verbList[currentIndex]
                        showCurrentWordInfo()
                    }
                }
                .onSubmit(){
                    let verbIndex = findClosestVerbIndex(userString)
                    if verbIndex > 0 {
                        currentIndex = verbIndex
                        currentVerb = verbList[currentIndex]
                        showCurrentWordInfo()
                    }
                    userString = ""
                }
            }
            .padding()
            Text("Current tense: \(currentTense.rawValue)")
                .onTapGesture {
                    withAnimation(Animation.linear(duration: 1)) {
                        getNextTense()
                    }
                }.frame(width: 300, height: 35, alignment: .center)
                .background(.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.bottom)
            HStack{
                Button(action: {
                    getPreviousVerb()
                }){
                    HStack{
                        Label("", systemImage: "arrow.left")
                        Text("Previous")
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    
                }
                Button(action: {
                    getNextVerb()
                }){
                    HStack{
                        Text("  Next  ")
                        Label("", systemImage: "arrow.right")
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                }
                
            }
        }
        
        
        Spacer()
            .frame(height: 20)
        
        VStack {
            VStack{
                HStack{
                    Text(spanishPhrase)
                    Spacer()
                    Text("\(currentIndex+1) / \(verbList.count)")
                }
                .padding()
                .frame(width: 300, height: 30, alignment: .leading)
                .border(.red)
            }
            ForEach((0...5), id:\.self) { personIndex in
                HStack{
                    Text(personString[personIndex])
                        .frame(width: 100, height: 30, alignment: .trailing)
                    Text(verb1String[personIndex])
                        .padding()
                        .frame(width: 250, height: 30, alignment: .leading)
                        .background(matching[personIndex] ? Color.yellow : Color.red)
                        .foregroundColor(.black)
                }.font(.system(size: 18))
            }
            Text("Model \(currentVerbModel.id): \(currentVerbModel.modelVerb)")
                .padding()
                .frame(width: 300, height: 30, alignment: .leading)
                .border(.red)
        }.font(.system(size: 18))
            .background(Color("BethanyNavalBackground"))
            .foregroundColor(Color("BethanyGreenText"))
            .onAppear(){
                verbList = languageViewModel.getVerbList()
                tenseIndex = 0
                currentTense = tenseList[tenseIndex]
                currentIndex = 0
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerb = verbList[currentIndex]
                verbCount = verbList.count
                fillPersons()
                showCurrentWordInfo()
            }
            .onTapGesture(count:2){
                getNextVerb()
            }
            .gesture(DragGesture()
                .onChanged { gesture in
                    if self.isSwiping {
                        self.startPos = gesture.location
                        self.isSwiping.toggle()
                    }
//                    print("Swiped")
                }
                .onEnded { gesture in
                    let xDist =  abs(gesture.location.x - self.startPos.x)
                    let yDist =  abs(gesture.location.y - self.startPos.y)
                    if self.startPos.y <  gesture.location.y && yDist > xDist {
                        self.direction = "Down"
                        self.color = Color.green.opacity(0.4)
                        getNextTense()
                    }
                    else if self.startPos.y >  gesture.location.y && yDist > xDist {
                        self.direction = "Up"
                        self.color = Color.blue.opacity(0.4)
                        getPreviousTense()
                    }
                    else if self.startPos.x > gesture.location.x + 10 && yDist < xDist {
                        self.direction = "Left"
                        self.color = Color.yellow.opacity(0.4)
                        getNextVerb()
                    }
                    else if self.startPos.x < gesture.location.x + 10 && yDist < xDist {
                        self.direction = "Right"
                        self.color = Color.purple.opacity(0.4)
                        getPreviousVerb()
                    }
                    self.isSwiping.toggle()
//                    print("gesture here")
                }
            )
        
        //        }
    }
    
    func findClosestVerbIndex(_ userString: String)->Int{
        var index = 0
        var verbString1 = ""
        var verbString2 = ""
        for index in 0 ..< verbList.count-1 {
            verbString1 = verbList[index].getWordAtLanguage(language: currentLanguage)
            verbString2 = verbList[index+1].getWordAtLanguage(language: currentLanguage)
            if userString > verbString1 && userString < verbString2 {
                return index+1
            }
        }
        return index
    }
    
    func getNextTense(){
        tenseIndex += 1
        if tenseIndex >= tenseList.count{ tenseIndex = 0}
        currentTense = tenseList[tenseIndex]
        showCurrentWordInfo()
    }
    
    func getPreviousTense(){
        tenseIndex -= 1
        if tenseIndex < 0 {
            tenseIndex = tenseList.count - 1
        }
        currentTense = tenseList[tenseIndex]
        showCurrentWordInfo()
    }
    
    func getNextVerb(){
        currentIndex += 1
        if currentIndex >= verbCount {
            currentIndex = 0
        }
        currentVerb = verbList[currentIndex]
        showCurrentWordInfo()
    }
    
    func getPreviousVerb(){
        currentIndex -= 1
        if currentIndex < 0 {currentIndex = verbCount-1}
        currentVerbNumber = currentIndex + 1
        currentVerb = verbList[currentIndex]
        showCurrentWordInfo()
    }
    
    func  fillPersons(){
        personString[0] = "yo"
        personString[1] = "tú"
        personString[2] = "él"
        personString[3] = "nosotros"
        personString[4] = "vosotros"
        personString[5] = "ellos"
        
    }
    
    func  showCurrentWordInfo(){
        let thisVerb = currentVerb
        spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
        let vu = VerbUtilities()
        let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
        isReflexive = result.3
        residualPhrase = result.2
        currentVerbModel = languageViewModel.findModelForThisVerbString(verbWord: result.0)
        if spanishPhrase.count > 0 {
            verb1String[0] = constructConjugateForm(person: .S1)
            verb1String[1] = constructConjugateForm(person: .S2)
            verb1String[2] = constructConjugateForm(person: .S3)
            verb1String[3] = constructConjugateForm(person: .P1)
            verb1String[4] = constructConjugateForm(person: .P2)
            verb1String[5] = constructConjugateForm(person: .P3)
        }
    }
    
    // - MARK: Conjugation here
    
    func constructConjugateForm(person: Person)->String{
        var thisVerb = languageViewModel.getRomanceVerb(verb: currentVerb)
        var pp = ""
        if currentTense.isProgressive(){
            pp = thisVerb.createDefaultGerund()
        } else if currentTense.isPerfectIndicative(){
            pp = thisVerb.createDefaultPastParticiple()
        }
        let vu = VerbUtilities()
        var wrongPhrase = languageViewModel.conjugateAsRegularVerb(verb: currentVerb, tense: currentTense, person: person, isReflexive: isReflexive, residPhrase: residualPhrase) + pp
        wrongPhrase = vu.removeLeadingOrFollowingBlanks(characterArray: wrongPhrase)
        
        var rightPhrase = languageViewModel.createAndConjugateAgnosticVerb(language: currentLanguage, verb: currentVerb, tense: currentTense, person: person, isReflexive: isReflexive)
        rightPhrase = vu.removeLeadingOrFollowingBlanks(characterArray: rightPhrase)
        matching[person.getIndex()] = wrongPhrase == rightPhrase
        return rightPhrase
    }
    
}
