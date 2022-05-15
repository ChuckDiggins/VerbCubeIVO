//
//  VerbMorphView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/9/22.
//

import SwiftUI

import JumpLinguaHelpers

struct TextMorphStructManager {
    var textMorphStructList = [TextMorphStruct]()
    var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    
    init(){
        var tms : TextMorphStruct
        for _ in personList{
            tms = TextMorphStruct()
            textMorphStructList.append(tms)
        }
    }

    mutating func setTextMorphStruct(person: Person, textMorphStruct: TextMorphStruct){
        textMorphStructList[person.getIndex()] = textMorphStruct
    }
    
    func getTextMorphStruct(person: Person)->TextMorphStruct {
        return textMorphStructList[person.getIndex()]
    }
    
    func getList()->[TextMorphStruct]{
        return textMorphStructList
    }
}

struct TextMorphStruct : Identifiable, Hashable{
    let id = UUID()
    var morphString: [String]
    var morphColor: [Color]
    var bold: [Bool]
    
    init(){
        morphString = ["", "", ""]
        morphColor = [.black, .red, .black]
        bold = [false, false, false]
    }
    
    init(morphString: [String], morphColor: [Color], bold: [Bool]){
        self.morphString = morphString
        self.morphColor = morphColor
        self.bold = bold
    }
    
    func getValues(index: Int)->(String, Color, Bool){
        return (morphString[index], morphColor[index], bold[index])
    }
    
    func getString(index: Int)->(String){
        return morphString[index]
    }
    
    func getColor(index: Int)->(Color){
        return morphColor[index]
    }
    
    func getBold(index: Int)->(Bool){
        return bold[index]
    }
    
    mutating func setValues(index: Int, str: String, color: Color, bold: Bool){
        self.morphString[index] = str
        self.morphColor[index] = color
        self.bold[index] = bold
    }
    
    mutating func setTextMorphStruct(inputTms: TextMorphStruct)
    {
        setValues(index: 0, str: inputTms.getString(index:0), color: inputTms.getColor(index:0), bold: inputTms.getBold(index: 0))
        setValues(index: 1, str: inputTms.getString(index:1), color: inputTms.getColor(index:1), bold: inputTms.getBold(index: 1))
        setValues(index: 2, str: inputTms.getString(index:2), color: inputTms.getColor(index:2), bold: inputTms.getBold(index: 2))
    }
}



struct VerbMorphView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    //@EnvironmentObject var currentVerbAndTense : CurrentVerbAndTense

    @State var personString = ""
    @State var verbString = ""
    @State var currentLanguage = LanguageType.Spanish
    @State var tmsManager = TextMorphStructManager()
//    @State var morphStructMgr = MorphStructManager(verbPhrase: "", tense: .present)
    
    @State var verbModelVerb = ""

    @State var currentVerbPhrase = ""
    @State var currentVerbString = ""
    @State var currentTenseString = ""
    @State var isPassive = false
    @State var isFeminine = false
    @State var isNegative = false
    @State var showPhrase = true
    @State var personIndex = 0
    @State var needsRefresh = false
    
    @State var morphStepIndex = [0, 0, 0, 0, 0, 0]

    @State var morphStep = MorphStep()
    @State var personStr = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    @State var isBackward = false
    @State var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    @State var tmsList = [TextMorphStruct(),TextMorphStruct(),TextMorphStruct(),TextMorphStruct(),TextMorphStruct(),TextMorphStruct() ]
    @State var commentList = ["Start morphing yo form",
                              "Start morphing tú form",
                              "Start morphing él form",
                              "Start morphing nosotros form",
                              "Start morphing vosotros form",
                              "Start morphing ellos form"]
    
    func fillTheCommentList(){
        //let vu = VerbUtilities()
        for p in 0 ..< 6 {
            let person = personList[p]
            let personString =  person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)
            commentList[p] = "Start morphing the \(personString) form "
        }
    }
    
    func fillThePersonStringList(){
        for p in 0 ..< 6 {
            let person = personList[p]
            let personString =  person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)
            personStr[p] = personString
        }
    }
    
    func getPersonString(person: Person)->String{
        let personIndex = person.getIndex()
        let conjString = languageViewModel.getFinalVerbForm(person: person)
        let startsWithVowelSound = VerbUtilities().startsWithVowelSound(characterArray:conjString)
        let person = Person(rawValue: personIndex) ?? Person.S1
        var pString = ""
        if isPassive {
            pString = person.getPassiveString(language: languageViewModel.getCurrentLanguage(), verbStartsWithVowel: startsWithVowelSound)
        } else if isBackward {
            pString = person.getPassiveString(language: languageViewModel.getCurrentLanguage(), verbStartsWithVowel: startsWithVowelSound)
        }
        else {
            pString = person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3)
        }
        return pString
    }
    
    
    func createInitialMorphStruct(person: Person)->(TextMorphStruct){
        var tms = TextMorphStruct()
        tms.setValues(index: 0, str: languageViewModel.getFinalVerbForm(person: person), color: .yellow, bold: false)
        tms.setValues(index: 1, str: "", color: .red, bold: false)
        tms.setValues(index: 2, str: "", color: .black, bold: true)
        return tms
    }
    
    
    func createMorphCompositeString(morphStep : MorphStep, person: Person)->(TextMorphStruct)
    {
        var tms = TextMorphStruct()
        if morphStep.isFinalStep {
            tms.setValues(index: 0, str: morphStep.part1, color: .yellow, bold: false)
            tms.setValues(index: 1, str: morphStep.part2, color: .red, bold: false)
            tms.setValues(index: 2, str: morphStep.part3, color: .black, bold: true)
        } else {
            tms.setValues(index: 0, str: morphStep.part1, color: .black, bold: false)
            tms.setValues(index: 1, str: morphStep.part2, color: .red, bold: false)
            tms.setValues(index: 2, str: morphStep.part3, color: .black, bold: true)
        }
        return tms
    }

    
    var body: some View {
        VStack{
//            LanguagePreferencesTenseView()
            
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                setCurrentVerb()
                setCurrentBVerb(languageEngine: languageViewModel.getLanguageEngine())
            }){
                HStack{
                    Text("Current verb is: ")
                        .foregroundColor(.blue)
                    Text(currentVerbString)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .padding(2)
                        .cornerRadius(4)
                }
            }
            
            
            HStack{
                Text("Verb model:")
                    .foregroundColor(.blue)
                Text(verbModelVerb)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .padding(2)
                    .cornerRadius(4)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    languageViewModel.setPreviousFilteredVerb()
                    setCurrentVerb()
                }){
                    Text("Previous verb")
                }
                Spacer()
                Button(action: {
                    languageViewModel.setNextFilteredVerb()
                    setCurrentVerb()
                }){
                    Text("Next verb")
                }
                Spacer()
            }.background(Color.yellow)

            
            //ChangeTenseButtonView()
            
            Button(action: {
                currentTenseString = languageViewModel.getNextTense().rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(currentTenseString)")
                //Image(systemName: "play.rectangle.fill").foregroundColor(.black)
            }
            .font(.callout)
            .padding(2)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(4)
            
        }
        Spacer()
            .frame(height: 20)

        //Morphing for each person here ....
        List {
            ForEach(personList, id: \.self){person in
                
                VStack(spacing: 0){
                    
                    HStack{
                        
                        // person string here
                        
                        Text(getPersonString(person: person))
                            .frame(width: 100, height: 30, alignment: .trailing)
                        
                        //conjugated string here
                        
                        HStack(spacing: 0)
                        {
                            if ( tmsList[person.getIndex()].getBold(index: 0) ){
                                Text(tmsList[person.getIndex()].getString(index: 0))
                                    .foregroundColor(tmsList[person.getIndex()].getColor(index: 0))
                            }
                            else {
                                Text(tmsList[person.getIndex()].getString(index: 0))
                                    .foregroundColor(tmsList[person.getIndex()].getColor(index: 0))
                            }

                            if ( tmsList[person.getIndex()].getBold(index: 1) ){
                                Text(tmsList[person.getIndex()].getString(index: 1))
                                    .foregroundColor(tmsList[person.getIndex()].getColor(index: 1))
                            }
                            else {
                                Text(tmsList[person.getIndex()].getString(index: 1))
                                    .foregroundColor(tmsList[person.getIndex()].getColor(index: 1))
                            }
                            
                            if ( tmsList[person.getIndex()].getBold(index: 2) ){
                                Text(tmsList[person.getIndex()].getString(index: 2))
                                    .foregroundColor(tmsList[person.getIndex()].getColor(index: 2))
                            }
                            else {
                                Text(tmsList[person.getIndex()].getString(index: 2))
                                    .foregroundColor(tmsList[person.getIndex()].getColor(index: 2))
                            }

                        }//HStack - conjugated string
     
                    }
                    
                    Button(action: {
                        showMorph(person: person)
                    }){
                        Text(commentList[person.getIndex()]).bold()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                    }
                }.frame(minWidth: 350)
                .background(Color.green.opacity(0.5))
                .padding(0)

            }//for each person


            }//VStack all
        .onAppear {
            currentLanguage = languageViewModel.getCurrentLanguage()
//            languageEngine.createAndConjugateCurrentFilteredVerb()
            setCurrentVerb()
        }
        Spacer()
            
        }//body view


    
    func setCurrentVerb(){
        languageViewModel.getCurrentFilteredVerb()
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        
        //isBackward = viperViewModel.getCurrentAgnosticVerb().isPassive()
        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: currentLanguage)
        verbModelVerb = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
        
        //this sets up the initial invitation message to the user "Click here"
        fillTheCommentList()
        fillThePersonStringList()
        currentTenseString = languageViewModel.getCurrentTense().rawValue
//        print("currentTenseString: \(currentTenseString)")
//        isPassive = langugageEngine.currentVerbIsPassive()
        for person in personList{
            showNewVerb(person: person)
        }
//        print("Current verb string = \(currentVerbString)")
//        let agnosticVerb = languageViewModel.getCurrentFilteredVerb()
//        let bVerb = agnosticVerb.getBVerb()
//        print("\nsetCurrentAgnosticVerb:  agnosticVerb: \(agnosticVerb.spanish) ... isStemChanging = \(bVerb.m_stemChanging)")
        
    }
    
    func setCurrentBVerb(languageEngine : LanguageEngine){
        currentVerbString = languageEngine.getMorphStructManager().verbPhrase

        currentTenseString = languageEngine.getCurrentTense().rawValue
//        isPassive = langugageEngine.currentVerbIsPassive()
       
        for person in personList{
            showNewVerb(person: person)
        }
    }
    
    
    func showNewVerb(person:Person){
        //commentList[person.getIndex()] = "Click here to start conjugating"
        var tms = tmsList[person.getIndex()]
        let newTms = createInitialMorphStruct(person: person)
        tms.setTextMorphStruct(inputTms:newTms )
        tmsList[person.getIndex()] = tms
    }
    
    func showMorph(person: Person) {
        
        if languageViewModel.isCurrentMorphStepFinal(person: person) { showFinalMorph(person: person)}
        else {
            morphStep = languageViewModel.getCurrentMorphStepAndIncrementIndex(person: person)
            
            verbString = morphStep.verbForm
            var stopGoStr = "🟢 "
            if morphStep.isFinalStep {
                stopGoStr = "🛑 "
            }
            commentList[person.getIndex()] = stopGoStr + morphStep.comment
            var tms = tmsList[person.getIndex()]
            let newTms = createMorphCompositeString(morphStep: morphStep, person: person)
            tms.setTextMorphStruct(inputTms:newTms )
            tmsList[person.getIndex()] = tms
        }
     
    }
    
    func showFinalMorph(person:Person){
        commentList[person.getIndex()] = "FINISHED:  This is the conjugated form"
        var tms = tmsList[person.getIndex()]
        let newTms = createInitialMorphStruct(person: person)
        tms.setTextMorphStruct(inputTms:newTms )
        tmsList[person.getIndex()] = tms
        
        languageViewModel.resetCurrentMorphStepIndex(person: person)
    }
    
    
}

/*
enum MorphStage {
    case start
    case proceed
    case done
}

func getImage(morphStage : MorphStage) -> Image {
    switch morphStage {
    case .start:
    return Image(systemName: "play.rectangle.fill")
    case .proceed:
    return Image(systemName: "play.fill")
    case .done:
    return Image(systemName: "play.fill")
    }
}
*/
/*
struct MorphView:View {
    @State var personString = ""
    @State var verbString = ""
    @State var verb = BSpanishVerb()
    @State var comment = ""
    @State var textMorphStruct = [TextMorphStruct]()
    @Binding var needsRefresh : Bool
    
    var body: some View {
        VStack{
                        HStack{
                            Text(personString)
                    .frame(width: 100, height: 30, alignment: .trailing)
                HStack(spacing: 0){
                    ForEach(textMorphStruct, id: \.id) { tms in
                        if ( tms.bold ){
                            Text(tms.morphString).bold()
                                .foregroundColor(tms.morphColor)
                        }
                        else {
                            Text(tms.morphString).foregroundColor(tms.morphColor)
                        }
                        
                    }
                }.frame(minWidth: 200, alignment: .leading)
                .background(Color.green.opacity(0.5))
            }
            
            Button(action: {
                showMorph(person: .S1)
            }){
                Text(comment).bold()
                    .background(Color.yellow)
                    .foregroundColor(.black)
            }
          
        }
        
        
    }
}

*/

/*I could not get this to refresh!  (Expletive deleted!)

//show the verb conjugations here
   ForEach((0...5), id:\.self) { personIndex in
       VerbMorphLineView( personIndex: personIndex, needsRefresh: $needsRefresh )
           .padding(5)

   }.onAppear {


       //self.setCurrentVerb(viperViewModel : viperViewModel)


       
       currentVerbAndTense.verb = viperViewModel.getCurrentVerb()
       currentVerbAndTense.verb.resetMorphStructIndices()
       currentVerbAndTense.tense = viperViewModel.getCurrentTense()
       currentVerbPhrase = currentVerbAndTense.verb.m_verbPhrase
       currentVerbString = currentVerbAndTense.verb.m_verbWord
       currentTenseString = currentVerbAndTense.tense.description
   }
*/

