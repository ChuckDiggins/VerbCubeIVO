//
//  FeatherVerbMorphView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/29/22.
//

import SwiftUI
import JumpLinguaHelpers

struct MultiVerbMorphView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    //    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var verbString = ""
    @State var currentLanguage = LanguageType.Spanish
    @State var tmsManager = TextMorphStructManager()
    @State var morphStructMgr = MorphStructManager(verbPhrase: "", tense: .present)
    
    @State var modelVerb = ""
    @State var modelID = 0
    @State var verbList = [Verb]()
    @State var  verbCount = 0
    
    @State var currentVerbPhrase = ""
    @State var currentVerbString = ""
    @State var currentTenseString = ""
//    @State var currentPerson = Person.S1
    @State var currentPersonString = "yo"
    @State var personIndex = 0
    
    var persons = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    
    @State var showPhrase = true
    @State var needsRefresh = false
    
    @State var morphStepIndex = 0
    
    @State var morphStep = MorphStep()
    @State var maxVerbCount = 9
    @State var modelVerbCount = 9
    @State var morphStructList = [MorphStruct]()
    @State var currentMorphStepIndex = 0
    @State var morphStepCount = 0
    @State var morphMode = MorphMode.person
    @State var morphComment = ""
    @State var verbPart1 = ""
    @State var modelVerbPart2 = ""
    @State var studentActive = false
    @State var isEditing = false
    @State var finalMessage = ""
    @State var verbsFromSameFeather = false
    @State var simpleAlert = false
    @State var currentVerbModelString = ""
    @State var subjunctiveWord = "que "
    
    //    @State var tmeList = Array(repeating: TextMorphStruct(), count: 12)
    @State var tmsList = [TextMorphStruct(),TextMorphStruct(),TextMorphStruct(),
                          TextMorphStruct(),TextMorphStruct(),TextMorphStruct(),
                          TextMorphStruct(),TextMorphStruct(),TextMorphStruct(),
                          TextMorphStruct(),TextMorphStruct(),TextMorphStruct() ]
    //    @State var finalVerbForms = ["", "", "", "", "", "", "", "", "", "", "", ""]
    @State var showFeatherVerbSheet = false
    
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack {
                HomePreferencesButtonView(languageViewModel: languageViewModel)
                Text("Multi-Verb Morphing")
                    .font(.title2)
                    .foregroundColor(Color("ChuckText1"))
                showHeaderInfo()
                showMorphs()
            }
            .onAppear{
                initializeStuff()
            }
        }
    }
    
   
    fileprivate func showMorphs() -> some View {
        return VStack{
            Button(action: {
                incrementCurrentMorphStepIndex()
                getCurrentMorphStepForAllVerbs()
                setMorphComment()
                if languageViewModel.isSpeechModeActive(){
                    let morphCommentClean = VerbUtilities().removeNonAlphaCharactersButLeaveBlanks(characterArray: morphComment)
                    textToSpeech(text: morphCommentClean, language: .English)
                }
            }){
                HStack{
                    Text(morphComment)
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }
                .modifier(ModelTensePersonButtonModifier())
            }
            VStack {
                ForEach( 0..<verbList.count, id: \.self){verbIndex in
                    let tms = tmsList[verbIndex]
                    //                    VStack(spacing: 0){
                    HStack{
                        HStack {
                            Text(subjunctiveWord)
                            Text(currentPersonString)
                        }
                        //conjugated string here
                        HStack(spacing: 0){
                            ForEach( 0..<3 ) { index in
                                Text(tms.getString(index: index))
                                    .background(tms.getColor(index: index))
                            }
                        }
                    }.frame(width: 300, height: 25, alignment: .leading)
                        .padding(.horizontal, 20)
                }//forEach verbIndex
            } .foregroundColor(Color("BethanyGreenText"))
                .background(Color("BethanyNavalBackground"))


        }
        
    }
    
    
    fileprivate func showHeaderInfo() -> some View {
        return VStack{
            ListVerbModelsView(languageViewModel: languageViewModel)
            TenseButtonView(languageViewModel: languageViewModel, function: setTensePersonVerb)
            CurrentPersonButtonView(languageViewModel: languageViewModel, function: setTensePersonVerb)

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
                
                if currentVerbString.count > 1 {
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
    
    enum MorphMode {
        case tense, person
    }
    
    
    func shuffleVerbList(){
        loadVerbList()
        verbList.shuffle()
        verbCount = verbList.count
        if verbCount > maxVerbCount {
            verbList.removeLast(verbCount-maxVerbCount)
            verbCount = verbList.count
        }
        setMorphStructsAtPerson(person: languageViewModel.getCurrentPerson())
        setMorphComment()
    }
    
    func loadVerbList(){
        verbList = languageViewModel.getFilteredVerbs()
        modelVerbCount = verbList.count
        currentLanguage = languageViewModel.currentLanguage
        if languageViewModel.verbsOfAFeather(verbList: verbList){
            verbsFromSameFeather = true
        }
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
        setTensePersonVerb()
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if languageViewModel.getCurrentTense().isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
    func setTensePersonVerb(){
        setSubjunctiveStuff()
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        currentPersonString = languageViewModel.getCurrentPerson().getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
        setMorphStructsAtPerson(person: languageViewModel.getCurrentPerson())
        setMorphComment()
        setBescherelleModelInfo()
    }
    
    func setBescherelleModelInfo() {
        let brv = languageViewModel.createAndConjugateAgnosticVerb(verb: verbList[0])
        modelID = brv.getBescherelleID()
        modelVerb = brv.getBescherelleModelVerb()
        if modelVerb.count > 0 && modelID > 0 {
            let result = languageViewModel.getModelStringAtTensePerson(bVerb: brv, tense: languageViewModel.getCurrentTense(), person: languageViewModel.getCurrentPerson())
            verbPart1 = result.0
            modelVerbPart2 = result.1
        print("verb \(brv.getWordStringAtLanguage(language: languageViewModel.getCurrentLanguage())) = \(result.0) + \(result.1)")
        }
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
        
        for verb in verbList{
            morphStructList.append(languageViewModel.createConjugatedMorphStruct(verb: verb, tense: languageViewModel.getCurrentTense(), person: languageViewModel.getCurrentPerson()))
        }
        currentMorphStepIndex = 0
        setMorphComment()
        morphStepCount = morphStructList[0].getMorphStepCount()
        getCurrentMorphStepForAllVerbs()
        
    }
    
//    func setMorphStructsAtTense(tense: Tense){
//        morphStructList.removeAll()
//
//        for verb in verbList{
//            morphStructList.append(languageViewModel.createConjugatedMorphStruct(verb: verb, tense: tense, person: languageViewModel.getCurrentPerson()))
//        }
//        currentMorphStepIndex = 0
//        morphStepCount = morphStructList[0].getMorphStepCount()
//        getCurrentMorphStepForAllVerbs()
//
//    }
    
    func getCurrentMorphStepForAllVerbs(){
        for verbIndex in 0..<verbList.count {
            setCurrentMorphStep(verbIndex: verbIndex)
        }
        
    }
    
    func setCurrentMorphStep(verbIndex: Int) {
        let morphStruct = morphStructList[verbIndex]
        if currentMorphStepIndex < morphStepCount {
            let morphStep = morphStruct.getMorphStep(index: currentMorphStepIndex)
            verbString = morphStep.verbForm
            var tms = tmsList[verbIndex]
            let newTms = createMorphCompositeString(morphStep: morphStep)
            tms.setTextMorphStruct(inputTms:newTms )
            tmsList[verbIndex] = tms
        }
    }
    
    func setMorphComment(){
        let i = currentMorphStepIndex
        if i == 0 {
                morphComment = "Click me: Start with the infinitive."
            }
        else if i < morphStepCount { morphComment = morphStructList[0].getMorphStep(index: i).comment }
        else { morphComment = "🛑 Conjugation complete. "}
    }
    
    func dumpTmsAll(){
        print("\nDumpTmsAll")
        for vi in 0 ..< verbCount {
            dumpTms(index: vi)
        }
    }
    
    func dumpTms(index: Int){
        let tms = tmsList[index]
        print("\nVerbIndex: \(index)")
        for i in 0..<3 {
            print("\(i), \(tms.getString(index: i)), Color =\(tms.getColor(index:i)), Bold = \(tms.getBold(index:i))")
        }
    }
    func createMorphCompositeString(morphStep : MorphStep)->(TextMorphStruct)
    {
    var tms = TextMorphStruct()
    if morphStep.isFinalStep {
        tms.setValues(index: 0, str: morphStep.part1, color: Color("BethanyNavalBackground"), bold: false)
        tms.setValues(index: 1, str: morphStep.part2, color: .red, bold: false)
        tms.setValues(index: 2, str: morphStep.part3, color: Color("BethanyNavalBackground"), bold: true)
    } else {
        tms.setValues(index: 0, str: morphStep.part1, color: Color("BethanyNavalBackground"), bold: false)
        tms.setValues(index: 1, str: morphStep.part2, color: .red, bold: false)
        tms.setValues(index: 2, str: morphStep.part3, color: Color("BethanyNavalBackground"), bold: true)
    }
    return tms
    }
    
    func setCurrentMorphStepForAllVerbs(){
        for verbIndex in 0 ..< verbCount {
            setCurrentMorphStep(verbIndex: verbIndex)
        }
    }
    
    func incrementCurrentMorphStepIndex(){
        currentMorphStepIndex += 1
        if currentMorphStepIndex > morphStepCount {
            currentMorphStepIndex = 0
        }
    }
    
    
    func showFinalMorph(verbIndex: Int){
        var tms = tmsList[verbIndex]
        let newTms = createInitialMorphStruct(verb: verbList[verbIndex])
        tms.setTextMorphStruct(inputTms:newTms)
        tmsList[verbIndex] = tms
    }
    
    func getFinalVerbForms()->[String]{
        var strList = [String]()
        for ms in morphStructList {
            let str = ms.finalVerbForm()
            strList.append(str)
            print("\(str):  msCount: \(ms.getMorphStepCount())")
        }
        return strList
    }
    
    
    
    func getNextPerson()->Person{
        personIndex += 1
        if personIndex >= persons.count {
            personIndex = 0
        }
        return persons[personIndex]
    }
    
    func createInitialMorphStruct(verb: Verb)->(TextMorphStruct){
        var tms = TextMorphStruct()
        tms.setValues(index: 0, str: languageViewModel.getFinalVerbForm(person: languageViewModel.getCurrentPerson()), color: .yellow, bold: false)
        tms.setValues(index: 1, str: "", color: .red, bold: false)
        tms.setValues(index: 2, str: "", color: .blue, bold: true)
        return tms
    }
    
}
