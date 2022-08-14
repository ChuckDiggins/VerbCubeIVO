//
//  FeatherVerbStepView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/14/22.
//

import SwiftUI
import JumpLinguaHelpers

enum HighlightEnum{
    case stem, spell, ending, irregular, reflexive, none
}

struct FeatherVerbStepView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    //    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var verbString = ""
    @State var currentLanguage = LanguageType.Spanish
    
    @State var modelVerb = ""
    @State var modelID = 0
    @State var modelVerbEnding = VerbEnding.none
    @State var verbList = [Verb]()
    @State var  verbCount = 0
    @State var currentTenseString = ""
    @State var currentPerson = Person.S1
    @State var currentPersonString = "yo"
    @State var personIndex = 0
    
    var persons = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    @State var verbStringList = ["", "", "", "", "", "",
                                 "", "", "", "", "", ""]
    @State var showPhrase = true
    @State var needsRefresh = false
    @State var maxVerbCount = 8
    @State var finalMessage = ""
    @State var simpleAlert = false
    @State var currentVerbModelString = ""
    @State var textFieldText = ""
    @State var infinitiveString = ""
    @State var morphStructList = [MorphStruct]()
    @State var morphInfoList = [MorphInfo]()
    @State var fivePartVerbStructList = [FivePartVerbStruct]()
    @State var studentVerbConjugationList = [FivePartVerbStruct]()
    @State var showFeatherVerbSheet = false
    @State var showMeComment = "You are changing the ending"
    @State var showMeMore = false
    @State var previousEditFieldText = ""
    @State var nonEditableText = "hello"
    @State var instructionString = "hello"
    @State var instructionStringList = [String]()
    @State var instructionIndex = 0
    @FocusState private var focusedField: Bool
    
    @State var irregularIndex = 0
    @State var stemIndex = 0
    @State var orthoIndex = 0
    @State var endingIndex = 0
    @State var reflexiveIndex = 0
    @State var disableStem = false
    @State var disableOrtho = false
    @State var disableIrregular = true
    @State var disableReflexive = true
    @State var actionBackgroundColor = Color.yellow
    @State var verbListBackgroundColor = Color.white

    @State var highlight = HighlightEnum.none

    @State var showVerbType = ShowVerbType.NONE
    @State var showVerbTypeColor = Color.red
    @State var conjugationComplete = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemOrange),
                //                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            VStack {
                Text("Model Verb Step").font(.title).foregroundColor(.black)
                showHeaderInfo()
                showActionButtons()
                //                showStudentEditWordSingle()
                showObservationString()
//                ShowFivePartVerbs(currentPersonString: currentPersonString, verbList: verbList, fivePartVerbStructList: fivePartVerbStructList, conjugationComplete: conjugationComplete, highlight: highlight)
//                VStack{
//                    List {
//                        ForEach( 0..<verbList.count, id: \.self){verbIndex in
//                            HStack{
//                                Text(currentPersonString)
//                                    .frame(width: 100, height: 30, alignment: .trailing)
//        //                        //                        Text(verbStringList[verbIndex])
//                                HStack(spacing: 0){
//                                    Text(fivePartVerbStructList[verbIndex].root).foregroundColor(.black)
//                                    Text(fivePartVerbStructList[verbIndex].workingStem)
//                                        .foregroundColor(highlight == .stem  ? .yellow : .black)
//                                        .background(highlight == .stem ? .black : verbListBackgroundColor)
//                                    Text(fivePartVerbStructList[verbIndex].root2).foregroundColor(.black)
//                                    Text(fivePartVerbStructList[verbIndex].workingOrtho)
//                                        .foregroundColor(highlight == .spell ? .yellow : .black)
//                                        .background(highlight == .spell  ? .black : verbListBackgroundColor)
//                                    Text(fivePartVerbStructList[verbIndex].workingEnding)
//                                        .foregroundColor(highlight == .ending  ? .yellow : .black)
//                                        .background(highlight == .ending  ? .black : verbListBackgroundColor)
//                                        .font(.headline.weight(.heavy))
//                                }
//                                .background(conjugationComplete ? Color.red : verbListBackgroundColor)
//                            }.listRowBackground(conjugationComplete ? Color.red : verbListBackgroundColor)
//                        }
//                    }.environment(\.defaultMinListRowHeight, 15) // HERE
//                    Spacer()
//                }
                Spacer()
            }
            Spacer()
        }
        .onAppear{
            focusedField = true
            initializeStuff()
        }
    }
    



    fileprivate func showObservationString()-> some View {
        HStack(spacing: 0){
            Text(showMeComment)
                .foregroundColor(.black)
        }
        .frame(width: 400, height: 30)
        .background(.yellow)
        .font(.callout)
    }
    
    fileprivate func showStudentEditWordSingle()-> some View {
        ForEach( 0..<studentVerbConjugationList.count, id: \.self){ci in
//            HStack(alignment: .bottom, spacing: 0){
            HStack(spacing: 0){
                Text(studentVerbConjugationList[0].root).foregroundColor(.black)
                Text(studentVerbConjugationList[0].workingStem)
                    .foregroundColor(highlight == .stem ? .yellow : .black)
                    .background(highlight == .stem  ? .black : actionBackgroundColor)
                Text(studentVerbConjugationList[0].root2).foregroundColor(.black)
                Text(studentVerbConjugationList[0].workingOrtho)
                    .foregroundColor(highlight == .spell  ? .yellow : .black)
                    .background(highlight == .spell  ? .black : actionBackgroundColor)
                Text(studentVerbConjugationList[0].workingEnding)
                    .foregroundColor(highlight == .ending  ? .yellow : .black)
                    .background(highlight == .ending ? .black : actionBackgroundColor)
                    .font(.headline.weight(.heavy))
            }.padding()
        }
        .background(conjugationComplete ? Color.red : actionBackgroundColor)
        .font(.headline)
        
    }
    
//
    fileprivate func showActionButtons()-> some View {
        HStack{
            Spacer()
            if !disableStem {
                Button{
                    stepStem()
                } label: {
                    HStack(spacing: 0){
                        Text("Stem").foregroundColor(.black)
                        Image(systemName: "rectangle.and.hand.point.up.left.filled").foregroundColor(.yellow).background(.black)
                    }
                }
            }
            if !disableOrtho {
                Button{
                    stepOrtho()
                } label: {
                    HStack(spacing: 0){
                        Text("Spell").foregroundColor(.black)
                        Image(systemName: "rectangle.and.hand.point.up.left.filled").foregroundColor(.green).background(.black)
                    }
                }
                
            }

            if !disableIrregular {
                Button{
                    //
                } label: {
                    HStack(spacing: 0){
                        Text("Irregular").foregroundColor(.black)
                        Image(systemName: "rectangle.and.hand.point.up.left.filled").foregroundColor(.blue).background(.black)
                    }
                }
            }
            
            Button{
                stepEnding()
            } label: {
                HStack(spacing: 0){
                    Text("Ending").foregroundColor(.black)
                    Image(systemName: "rectangle.and.hand.point.up.left.filled").foregroundColor(.red).background(.black)
                }
            }
            
            Spacer()
            
        }.background(.white)
       
    }
    
    func checkConjugationComplete() {
        conjugationComplete = false
        verbListBackgroundColor = .white
        actionBackgroundColor = .yellow
        if studentVerbConjugationList[0].root + studentVerbConjugationList[0].workingStem + studentVerbConjugationList[0].root2 + studentVerbConjugationList[0].workingOrtho + studentVerbConjugationList[0].workingEnding == studentVerbConjugationList[0].getConjugatedForm() {
            conjugationComplete = true
            showMeComment = "Congratulations!  Conjugation completed."
            verbListBackgroundColor = .red
            actionBackgroundColor = .red
            highlight = .none
            if languageViewModel.isSpeechModeActive(){
                textToSpeech(text: showMeComment, language: .English)
            }
        }
    }
    
    func stepStem(){
        
        switch stemIndex {
        case 0:
            highlight = .stem
            showMeComment = "Grab the stem"
            stemIndex += 1
            checkConjugationComplete()
        case 1:
            highlight = .stem
            studentVerbConjugationList[0].workingStem = "_"
            showMeComment = "Remove the stem"
            stemIndex += 1
            checkConjugationComplete()
        case 2:
            highlight = .stem
            studentVerbConjugationList[0].workingStem = studentVerbConjugationList[0].stemTo
            showMeComment = "Change the stem"
            stemIndex += 1
            checkConjugationComplete()
        case 3:
            studentVerbConjugationList[0].workingStem = studentVerbConjugationList[0].stemFrom
            showMeComment = "Put back the original stem"
            stemIndex = 0
            highlight = .none
            checkConjugationComplete()
        default:
            break
        }
        if languageViewModel.isSpeechModeActive(){
            textToSpeech(text: showMeComment, language: .English)
        }
        propogateChangeToOtherVerbs()
    }
    
    func stepOrtho(){
        
        switch orthoIndex {
        case 0:
            highlight = .spell
            showMeComment = "Grab the spell-changing letter"
            orthoIndex += 1
            checkConjugationComplete()
        case 1:
            highlight = .spell
            studentVerbConjugationList[0].workingOrtho = "_"
            showMeComment = "Remove the spell-changing letter"
            orthoIndex += 1
            checkConjugationComplete()
        case 2:
            highlight = .spell
            studentVerbConjugationList[0].workingOrtho = studentVerbConjugationList[0].orthoTo
            showMeComment = "Replace the spell-changing letter"
            orthoIndex += 1
            checkConjugationComplete()
        case 3:
            studentVerbConjugationList[0].workingOrtho = studentVerbConjugationList[0].orthoFrom
            showMeComment = "Put back the original spell-changing letter"
            highlight = .none
            orthoIndex = 0
            checkConjugationComplete()
        default:
            break
        }
        if languageViewModel.isSpeechModeActive(){
            textToSpeech(text: showMeComment, language: .English)
        }
        propogateChangeToOtherVerbs()
    }
    
    func stepEnding(){
        
        switch endingIndex {
        case 0:
            highlight = .ending
            showMeComment = "Grab the verb ending"
            endingIndex += 1
            checkConjugationComplete()
        case 1:
            highlight = .ending
            studentVerbConjugationList[0].workingEnding = "_"
            showMeComment = "Remove the verb ending"
            endingIndex += 1
            checkConjugationComplete()
        case 2:
            highlight = .ending
            studentVerbConjugationList[0].workingEnding = studentVerbConjugationList[0].endingTo
            showMeComment = "Add on the conjugated ending for this tense and person"
            endingIndex += 1
            checkConjugationComplete()
        case 3:
            studentVerbConjugationList[0].workingEnding = studentVerbConjugationList[0].endingFrom
            showMeComment = "Put back the original verb ending"
            highlight = .none
            endingIndex = 0
            checkConjugationComplete()
        default:
            break
        }
        if languageViewModel.isSpeechModeActive(){
            textToSpeech(text: showMeComment, language: .English)
        }
        propogateChangeToOtherVerbs()
    }
    
    func propogateChangeToOtherVerbs(){
        propogateStemChangeToOtherVerbs()
        propogateOrthoChangeToOtherVerbs()
        propogateEndingChangeToOtherVerbs()
        
    }
    
    func propogateStemChangeToOtherVerbs(){
        let svg = studentVerbConjugationList[0]
        for i in 0..<fivePartVerbStructList.count{
            if svg.workingStem == svg.stemTo { fivePartVerbStructList[i].workingStem = fivePartVerbStructList[i].stemTo }
            else if svg.workingStem == svg.stemFrom { fivePartVerbStructList[i].workingStem = fivePartVerbStructList[i].stemFrom }
            else { fivePartVerbStructList[i].workingStem = "_" }
        }
    }
    
    func propogateOrthoChangeToOtherVerbs(){
        let svg = studentVerbConjugationList[0]
        for i in 0..<fivePartVerbStructList.count{
            if svg.workingOrtho == svg.orthoTo { fivePartVerbStructList[i].workingOrtho = fivePartVerbStructList[i].orthoTo }
            else if svg.workingOrtho == svg.orthoFrom { fivePartVerbStructList[i].workingOrtho = fivePartVerbStructList[i].orthoFrom }
            else { fivePartVerbStructList[i].workingOrtho = "_" }
        }
    }
    
    func propogateEndingChangeToOtherVerbs(){
        let svg = studentVerbConjugationList[0]
        for i in 0..<fivePartVerbStructList.count{
            if svg.workingEnding == svg.endingTo { fivePartVerbStructList[i].workingEnding = fivePartVerbStructList[i].endingTo }
            else if svg.workingEnding == svg.endingFrom { fivePartVerbStructList[i].workingEnding = fivePartVerbStructList[i].endingFrom }
            else { fivePartVerbStructList[i].workingEnding = "_" }
        }
    }
    
    
    func shuffleVerbList(){
        loadVerbList()
        verbList.shuffle()
        verbCount = verbList.count
        if verbCount > maxVerbCount {
            verbList.removeLast(verbCount-maxVerbCount)
            verbCount = verbList.count
        }
        setVerbStringsAtPerson(person: currentPerson)
//        textFieldText = verbList[0].getWordAtLanguage(language: currentLanguage)
        //textFieldText should only be the editable part of the user editable verb
        nonEditableText = morphInfoList[0].root
        textFieldText = morphInfoList[0].stemFrom + morphInfoList[0].root2 + morphInfoList[0].orthoFrom + morphInfoList[0].endingFrom
        previousEditFieldText = textFieldText
        infinitiveString = morphInfoList[0].infinitive
        checkConjugationComplete()
        showMeComment = "Start with the infinitive"
        if languageViewModel.getCurrentTense() == Tense.imperfectSubjunctiveRA ||
            languageViewModel.getCurrentTense() == Tense.imperfectSubjunctiveSE {
            showMeComment = "Start with preterite, third person plural"
        }
    }
    
    func loadVerbList(){
        verbList = languageViewModel.getFilteredVerbs()
        currentLanguage = languageViewModel.currentLanguage
        verbList = removeReflexiveVerbs()
    }
    
    func initializeStuff(){
        currentVerbModelString = languageViewModel.getCurrentVerbModel().modelVerb
        loadVerbList()
        verbCount = verbList.count
        if verbCount > maxVerbCount {
            verbList.removeLast(verbCount-maxVerbCount)
            verbCount = verbList.count
        }
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        currentPersonString = currentPerson.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
        setVerbStringsAtPerson(person: currentPerson)
        setBescherelleModelInfo()
        nonEditableText = morphInfoList[0].root
        textFieldText = morphInfoList[0].stemFrom + morphInfoList[0].root2 + morphInfoList[0].orthoFrom + morphInfoList[0].endingFrom
        infinitiveString = morphInfoList[0].infinitive
        previousEditFieldText = textFieldText
        disableOrtho = morphInfoList[0].orthoFrom.isEmpty
        disableStem = morphInfoList[0].stemFrom.isEmpty
        checkConjugationComplete()
        showMeComment = "Click on ↖️ above to start conjugating"
    }
    
    
    func setBescherelleModelInfo() {
        let brv = languageViewModel.createAndConjugateAgnosticVerb(verb: verbList[0])
        modelID = brv.getBescherelleID()
        modelVerb = brv.getBescherelleModelVerb()
        let result = languageViewModel.getModelStringAtTensePerson(bVerb: brv, tense: languageViewModel.getCurrentTense(), person: currentPerson)
        print("verb \(brv.getWordStringAtLanguage(language: languageViewModel.getCurrentLanguage())) = \(result.0) + \(result.1)")
        modelVerbEnding = VerbUtilities().determineVerbEnding(verbWord: modelVerb)
    }
    
    //reflexive verbs mess up the synch
    func removeReflexiveVerbs()->[Verb]{
        var newVerbList = [Verb]()
        for verb in verbList {
            if languageViewModel.isVerbType(verb : verb, verbType: .REFLEXIVE) { continue }
            newVerbList.append(verb)
        }
        return newVerbList
    }
    
    func setMorphStructsAtPerson(person: Person){
        morphStructList.removeAll()
        morphInfoList.removeAll()
        
        for verb in verbList{
            morphStructList.append(languageViewModel.createConjugatedMorphStruct(verb: verb, tense: languageViewModel.getCurrentTense(), person: currentPerson))
        }
        
        for morphStruct in morphStructList {
            morphInfoList.append(extractMorphInfo(morphStruct: morphStruct))
        }
        printMorphInfo(mi: morphInfoList[0])
    }
    
    func setVerbStringsAtPerson(person: Person){
        verbStringList.removeAll()
        fivePartVerbStructList.removeAll()
        studentVerbConjugationList.removeAll()
        setMorphStructsAtPerson(person: person)
        studentVerbConjugationList.append(FivePartVerbStruct(stringChangeType: .startWithInfinitive, morphInfo: morphInfoList[0]))
        for i in 0..<verbList.count {
            verbStringList.append(verbList[i].getWordStringAtLanguage(language: currentLanguage))
            fivePartVerbStructList.append(FivePartVerbStruct(stringChangeType: .startWithInfinitive, morphInfo: morphInfoList[i]))
        }
        disableOrtho = morphInfoList[0].orthoFrom.isEmpty
        disableStem = morphInfoList[0].stemFrom.isEmpty
        checkConjugationComplete()
    }
    
    func getNextPerson()->Person{
        personIndex += 1
        if personIndex >= persons.count {
            personIndex = 0
        }
        return persons[personIndex]
    }
    
    fileprivate func showHeaderInfo() -> some View {
        return VStack{
            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                HStack{
                    Text("Verb model:")
                    Text(modelVerb)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
            }
            .task {
                setBescherelleModelInfo()
            }
            Button(action: {
                currentTenseString = languageViewModel.getNextTense().rawValue
                setVerbStringsAtPerson(person: currentPerson)
                setMorphStructsAtPerson(person: currentPerson)
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }
            .frame(width: 350, height: 30)
            .font(.callout)
            .padding(2)
            .background(Color.orange)
            .foregroundColor(.black)
            .cornerRadius(4)
            Button(action: {
                currentPerson = getNextPerson()
                currentPersonString = currentPerson.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
                setMorphStructsAtPerson(person: currentPerson)
                currentPerson = getNextPerson()
                setVerbStringsAtPerson(person: currentPerson)
            }){
                Text("Person: \(currentPersonString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }
            .frame(width: 350, height: 30)
            .font(.callout)
            .padding(2)
            .background(Color.orange)
            .foregroundColor(.black)
            .cornerRadius(4)
            
            HStack{
                Button{
                    shuffleVerbList()
                } label: {
                    Text("Shuffle")
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 150, height: 30)
                .font(.callout)
                    .padding(2)
                    .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                
                if verbString.count > 1 {
                    NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: modelVerb, french: modelVerb, english: modelVerb), residualPhrase: "", teachMeMode: .model)){
                        HStack{
                            Text("Show me ")
                            Text(modelVerb).bold()
                        }
                    }.frame(width: 300, height: 50)
                        .padding(2)
                        .buttonStyle(.bordered)
                        .background(.green)
                        .tint(.black)
                        .cornerRadius(10)
                }
            }
        }
        
       
    }

}

struct ShowFivePartVerbs : View {
    @State var currentPersonString : String
    @State var verbList : [Verb]
    @State var fivePartVerbStructList : [FivePartVerbStruct]
    @State var conjugationComplete : Bool
    @State var highlight : HighlightEnum
    @State var verbListBackgroundColor = Color.white
//
    var body: some View {
        VStack{
            Text("Hello world")
//            List {
//                ForEach( 0..<verbList.count, id: \.self){verbIndex in
//                    HStack{
//                        Text(currentPersonString)
//                            .frame(width: 100, height: 30, alignment: .trailing)
//                        HStack(spacing: 0){
//                            Text(fivePartVerbStructList[verbIndex].root).foregroundColor(.black)
//                            Text(fivePartVerbStructList[verbIndex].workingStem)
//                                .foregroundColor(highlight == .stem  ? .yellow : .black)
//                                .background(highlight == .stem ? .black : verbListBackgroundColor)
//                            Text(fivePartVerbStructList[verbIndex].root2).foregroundColor(.black)
//                            Text(fivePartVerbStructList[verbIndex].workingOrtho)
//                                .foregroundColor(highlight == .spell ? .yellow : .black)
//                                .background(highlight == .spell  ? .black : verbListBackgroundColor)
//                            Text(fivePartVerbStructList[verbIndex].workingEnding)
//                                .foregroundColor(highlight == .ending  ? .yellow : .black)
//                                .background(highlight == .ending  ? .black : verbListBackgroundColor)
//                                .font(.headline.weight(.heavy))
//                        }
//                        .background(conjugationComplete ? Color.red : verbListBackgroundColor)
//                    }.listRowBackground(conjugationComplete ? Color.red : verbListBackgroundColor)
//                }
//            }.environment(\.defaultMinListRowHeight, 15) // HERE
//            Spacer()
        }
    }
}
