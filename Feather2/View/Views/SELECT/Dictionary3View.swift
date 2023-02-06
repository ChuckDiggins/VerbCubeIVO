//
//  Dictionary3View.swift
//  Feather2
//
//  Created by Charles Diggins on 1/14/23.
//

//
//  MultiVerbConjugation.swift
//  ContextFree
//
//  Created by Charles Diggins on 6/18/21.
//

import SwiftUI
import Combine
import JumpLinguaHelpers

struct ColoredGrowingButton: ButtonStyle {
    var buttonColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(buttonColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct Dictionary3View: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    @State private var language = LanguageType.English
    @State private var spanishVerb = SpanishVerb()
    @State private var frenchVerb = FrenchVerb()
    @State private var englishVerb = EnglishVerb()
    @State private var spanishPhrase = ""
    @State private var englishPhrase = ""
    @State private var frenchPhrase = ""
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var currentVerbPhrase = ""
    @State var newVerbPhrase = ""
    @State private var verbList = [Verb]()
    @State private var currentVerb = Verb()
    @State private var currentVerbNumber = 1
    @State private var verbCount = 0
    @State var currentIndex = 0
    @State var currentTense = Tense.present
    @State var personString = ["","","","","",""]
    @State var verb1String = ["","","","","",""]
    @State var verb2String = ["","","","","",""]
    @State var verb3String = ["","","","","",""]
    
    @State var showResidualPhrase = true
    @State var showReflexivePronoun = true
    
    //swipe gesture
    
    @State var startPos : CGPoint = .zero
    @State var isSwiping = true
    @State var color = Color.red.opacity(0.4)
    @State var direction = ""
    
    //@State var bAddNewVerb = false
    
    var body: some View {
        //ChangeTenseButtonView()
        
        /*
         Button(action: {
         currentTenseString = currentTense.rawValue
         }){
         Text("Tense: \(currentTenseString)")
         //Image(systemName: "play.rectangle.fill").foregroundColor(.black)
         }
         .font(.callout)
         .padding(2)
         .background(Color.green)
         .foregroundColor(.white)
         .cornerRadius(4)
         */
        VStack{
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
            
            HStack{
                Text(" ").frame(width: 60, height: 30, alignment: .trailing)
                Text("    Spanish ")
                    .frame(width: 100, height: 30, alignment: .leading)

                Text("    French ")
                    .frame(width: 100, height: 30, alignment: .leading)

                Text("    English ")
                    .frame(width: 100, height: 30, alignment: .leading)
            }
            HStack{
                Text(" ").frame(width: 60, height: 30, alignment: .trailing)
                Text(spanishPhrase)
                    .padding()
                    .frame(width: 100, height: 30, alignment: .leading)
                    .border(.red)
                Text(frenchPhrase)
                    .padding()
                    .frame(width: 100, height: 30, alignment: .leading)
                    .border(.red)
                Text(englishPhrase)
                    .padding()
                    .frame(width: 100, height: 30, alignment: .leading)
                    .border(.red)
            }
            ForEach((0...5), id:\.self) { personIndex in
                HStack{
                    Text(personString[personIndex])
                        .frame(width: 60, height: 30, alignment: .trailing)
                    Text(verb1String[personIndex])
                        .padding()
                        .frame(width: 100, height: 30, alignment: .leading)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                    Text(verb2String[personIndex])
                        .padding()
                        .frame(width: 100, height: 30, alignment: .leading)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                    Text(verb3String[personIndex])
                        .padding()
                        .frame(width: 100, height: 30, alignment: .leading)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                }.font(.system(size: 12))
            }
        }.font(.system(size: 16))
        
            .onAppear(){
                verbList = languageViewModel.getVerbList()
                currentIndex = 0
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
                    print("Swiped")
                }
                .onEnded { gesture in
                    let xDist =  abs(gesture.location.x - self.startPos.x)
                    let yDist =  abs(gesture.location.y - self.startPos.y)
                    if self.startPos.y <  gesture.location.y && yDist > xDist {
                        self.direction = "Down"
                        self.color = Color.green.opacity(0.4)
                        getNextVerb()
                    }
                    else if self.startPos.y >  gesture.location.y && yDist > xDist {
                        self.direction = "Up"
                        self.color = Color.blue.opacity(0.4)
                        getPreviousVerb()
                    }
                    else if self.startPos.x > gesture.location.x && yDist < xDist {
                        self.direction = "Left"
                        self.color = Color.yellow.opacity(0.4)
                        getNextVerb()
                    }
                    else if self.startPos.x < gesture.location.x && yDist < xDist {
                        self.direction = "Right"
                        self.color = Color.purple.opacity(0.4)
                        getNextVerb()
                    }
                    self.isSwiping.toggle()
                    print("gesture here")
                }
            )
            .background(Color("BethanyNavalBackground"))
            .foregroundColor(Color("BethanyGreenText"))
    }
    
    func getNextTense(){
        currentTense = languageViewModel.getNextTense()
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
        switch language {
        case .English:
            personString[0] = "I"
            personString[1] = "you"
            personString[2] = "he"
            personString[3] = "we"
            personString[4] = "you"
            personString[5] = "they"
        case .Spanish:
            personString[0] = "yo"
            personString[1] = "tú"
            personString[2] = "él"
            personString[3] = "nosotros"
            personString[4] = "vosotros"
            personString[5] = "ellos"
        default: break
        }
        
    }
    
    func  showCurrentWordInfo(){
        let thisVerb = currentVerb
        spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
        englishPhrase = thisVerb.getWordAtLanguage(language: .English)
        frenchPhrase = thisVerb.getWordAtLanguage(language: .French)
        
        if spanishPhrase.count > 0 {
            verb1String[0] = constructConjugateForm(language: .Spanish, tense: currentTense, person: .S1)
            verb1String[1] = constructConjugateForm(language: .Spanish, tense: currentTense, person: .S2)
            verb1String[2] = constructConjugateForm(language: .Spanish, tense: currentTense, person: .S3)
            verb1String[3] = constructConjugateForm(language: .Spanish, tense: currentTense, person: .P1)
            verb1String[4] = constructConjugateForm(language: .Spanish, tense: currentTense, person: .P2)
            verb1String[5] = constructConjugateForm(language: .Spanish, tense: currentTense, person: .P3)
        }
        
        if frenchPhrase.count > 0  {
            verb2String[0] = constructConjugateForm(language: .French, tense: currentTense, person: .S1)
            verb2String[1] = constructConjugateForm(language: .French, tense: currentTense, person: .S2)
            verb2String[2] = constructConjugateForm(language: .French, tense: currentTense, person: .S3)
            verb2String[3] = constructConjugateForm(language: .French, tense: currentTense, person: .P1)
            verb2String[4] = constructConjugateForm(language: .French, tense: currentTense, person: .P2)
            verb2String[5] = constructConjugateForm(language: .French, tense: currentTense, person: .P3)
        }
        
        if englishPhrase.count > 0 {
            verb3String[0] = constructConjugateForm(language: .English, tense: currentTense, person: .S1)
            verb3String[1] = constructConjugateForm(language: .English, tense: currentTense, person: .S2)
            verb3String[2] = constructConjugateForm(language: .English, tense: currentTense, person: .S3)
            verb3String[3] = constructConjugateForm(language: .English, tense: currentTense, person: .P1)
            verb3String[4] = constructConjugateForm(language: .English, tense: currentTense, person: .P2)
            verb3String[5] = constructConjugateForm(language: .English, tense: currentTense, person: .P3)
        }
        
    }
    
    // - MARK: Conjugation here
    
    func constructConjugateForm(language: LanguageType, tense: Tense, person: Person)->String{
        languageViewModel.createAndConjugateAgnosticVerb(language: language, verb: currentVerb, tense: tense, person: person, isReflexive: false)
    }
    
}
