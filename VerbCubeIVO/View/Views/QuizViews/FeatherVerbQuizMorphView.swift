//
//  FeatherVerbQuizMorphView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/7/22.
//


//
//  FeatherVerbMorphView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/29/22.
//

import SwiftUI
import JumpLinguaHelpers


struct HelpScreenQuizMorph: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showMeMore: Bool
    //    let url = Bundle.main.url(forResource: "PatternRecognitionTutorial", withExtension: ".mov")!
    
    var body : some View {
        ZStack(alignment: .topLeading){
            Color.purple
                .edgesIgnoringSafeArea(.all)
            Button {
                //                presentationMode.wrappedValue.dismiss()
                showMeMore.toggle()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
            }
            //            VideoPlayer(player: AVPlayer(url: url)).frame(width:100, height:400)
            
        }
    }
}


struct FeatherVerbQuizMorphView: View {
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
    
    @State var showPhrase = true
    @State var needsRefresh = false
    @State var maxVerbCount = 12
    @State var finalMessage = ""
    @State var simpleAlert = false
    @State var currentVerbModelString = ""
    @State var textFieldText = ""
    @State var infinitiveString = ""
    
    @State var verbStringList = ["", "", "", "", "", "",
                                 "", "", "", "", "", ""]
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
    
    var body: some View {
        VStack {
            showHeaderInfo()
            showInstructionBar()
            showStudentEditWordSingle()
            showObservationString()
            showVerbs()
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
        }.padding()
        .background(.yellow)
        .font(.callout)
    }
    
    fileprivate func showStudentEditWordSingle()-> some View {
        HStack(spacing: 0){
            Text(nonEditableText)
                .foregroundColor(.black)
            TextField("", text: $textFieldText)
                .onChange(of: textFieldText){ _ in
                    analyzeStudentEdit(studentText: textFieldText)
                }
                .focused($focusedField, equals: true)
                .foregroundColor(.red)
                .textCase(.lowercase)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }.padding()
        .background(Color.gray.opacity(0.8).cornerRadius(4))
        .font(.headline)
    }
    
    fileprivate func showVerbs() -> some View {
        VStack{
            List {
                ForEach( 0..<verbList.count, id: \.self){verbIndex in
                    HStack{
                        Text(currentPersonString)
                            .frame(width: 100, height: 30, alignment: .trailing)
                        //                        Text(verbStringList[verbIndex])
                        HStack(spacing: 0){
                            Text(fivePartVerbStructList[verbIndex].root).foregroundColor(.green)
                            Text(fivePartVerbStructList[verbIndex].stemFrom).foregroundColor(.red)
                            Text(fivePartVerbStructList[verbIndex].root2).foregroundColor(.green)
                            Text(fivePartVerbStructList[verbIndex].orthoFrom).foregroundColor(.red)
                            Text(fivePartVerbStructList[verbIndex].endingFrom).foregroundColor(.red)
                        }
                    }
                }
            }.environment(\.defaultMinListRowHeight, 15) // HERE
        }
        .navigationBarTitle ("Verb model: \(modelVerb): \(verbList.count) verbs", displayMode: .inline)
    }
    
    func analyzeStudentEdit(studentText: String){
        
//        if studentText != infinitiveString {
            let stringChange = processStudentAnswer(studentText: studentText)
            if stringChange == .unknown {
                textFieldText = previousEditFieldText
                showMeComment = "You cannot do that"
            } else {
                dumpStudentVerbConjugationList()
                propogateChangeToOtherVerbs()
                previousEditFieldText = textFieldText
            }
//        }
    }
    
    func dumpStudentVerbConjugationList(){
        print("\nStudentVerbConjugation")
        for svg in studentVerbConjugationList {
            dumpStudentVerbConjugationStep(svg: svg)
        }
    }
    
    func dumpStudentVerbConjugationStep(svg: FivePartVerbStruct){
        svg.printThyself()
    }
    
    func processStudentAnswer(studentText: String)->StringChangeEnum{
        var vuExtra = VerbUtilitiesExtra()
        var currentWorkingString = ""
        currentWorkingString = previousEditFieldText
        
        //check for removing the ending
        print("processStudentAnswer: studentText = \(studentText), currentWorkingString = \(currentWorkingString)")
        
        var str = nonEditableText + studentText + "r"
        if str == infinitiveString {
            var fpvs = FivePartVerbStruct()
            fpvs.removingEnding()
            studentVerbConjugationList.append(fpvs)
            showMeComment = "You are removing the ending"
            return StringChangeEnum.removingEnding
        }
        
        str = nonEditableText + studentText + modelVerbEnding.getEnding()
        if str == infinitiveString {
            var fpvs = FivePartVerbStruct()
            fpvs.removeEnding()
            studentVerbConjugationList.append(fpvs)
            showMeComment = "You have removed the ending"
            return StringChangeEnum.endingRemoved
        }
        
        let startingStudentVerbConjugation = studentVerbConjugationList[0]
        //student has added a stem or ortho
        if  studentText.count > currentWorkingString.count {
            let resultSplit = vuExtra.findExtraLetterAndSplit(newString: studentText, oldString: currentWorkingString)
            
            //is this the stem?
            if resultSplit.0 == "" && startingStudentVerbConjugation.stemTo.contains(resultSplit.1){
                var fpvs = FivePartVerbStruct()
                fpvs.appendStem(stem: resultSplit.1)
                showMeComment = "You are adding the stem \(startingStudentVerbConjugation.stemTo)"
                return StringChangeEnum.appendStem
            }
            
            else if startingStudentVerbConjugation.stemTo.contains(resultSplit.0 + resultSplit.1){
                var fpvs = FivePartVerbStruct()
                fpvs.appendStem(stem: resultSplit.1)
                showMeComment = "You have added the stem \(startingStudentVerbConjugation.stemTo)"
                return StringChangeEnum.appendStem
            }
            
            //is this ortho?
            else if resultSplit.0 != "" && startingStudentVerbConjugation.orthoTo.contains(resultSplit.1){
                var fpvs = FivePartVerbStruct()
                fpvs.appendOrtho(ortho: resultSplit.1)
                showMeComment = "You are adding the spell change \(startingStudentVerbConjugation.orthoTo)"
                return StringChangeEnum.appendOrtho
            }
            //is this ortho?
            else if startingStudentVerbConjugation.orthoTo.contains(resultSplit.0 + resultSplit.1){
                var fpvs = FivePartVerbStruct()
                fpvs.appendOrtho(ortho: resultSplit.1)
                showMeComment = "You have added the spell change \(startingStudentVerbConjugation.orthoTo)"
                return StringChangeEnum.appendOrtho
            }
        }
        
        //student has removed a stem or ortho
        else {
            let resultSplit = vuExtra.findMissingLetterAndSplit(newString: studentText, oldString: currentWorkingString)
            
            //stemFrom and orthoFrom are single letters
            //this has to be the stem if it's the first part of the editable field
            if resultSplit.0 == "" && resultSplit.1 == startingStudentVerbConjugation.stemFrom {
                var fpvs = FivePartVerbStruct()
                fpvs.removeStem()
                studentVerbConjugationList.append(fpvs)
                showMeComment = "You have removed the stem \(startingStudentVerbConjugation.stemFrom)"
                return StringChangeEnum.removeStem
            }
            
            //is this ortho?
            else if resultSplit.0 != "" && resultSplit.1  == startingStudentVerbConjugation.orthoFrom{
                var fpvs = FivePartVerbStruct()
                fpvs.removeOrtho()
                studentVerbConjugationList.append(fpvs)
                showMeComment = "You have removed the stem \(startingStudentVerbConjugation.orthoFrom)"
                return StringChangeEnum.removeOrtho
            }
        }
        
        return StringChangeEnum.unknown
    }
    
    
    func propogateChangeToOtherVerbs(){
        let vux = VerbUtilitiesExtra()
        
//        for i in 0..<fivePartVerbStructList.count{
//            fivePartVerbStructList[i].getInfinitive() = morphInfoList[i].infinitive
//        }
        
        for svg in studentVerbConjugationList {
            switch svg.stringChangeType {
            case .startWithInfinitive:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].root = morphInfoList[i].root
                }
            case .removingEnding:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].removingEnding()
                }
            case .appendEnding:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].appendStem(stem: svg.endingFrom)
                }
            case .endingRemoved:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].removeEnding()
                }
            case .appendStem:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].appendStem(stem: svg.stemFrom)
                }
            case .removeStem:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].removeStem()
                }
            case .appendOrtho:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].appendOrtho(ortho: svg.orthoFrom)
                }
            case .removeOrtho:
                for i in 0..<fivePartVerbStructList.count{
                    fivePartVerbStructList[i].removeOrtho()
                }
                
            default: break
            }
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
        showMeComment = "Start conjugating"
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
        createInstructionListForThisVerbModel()
        showMeComment = "Start conjugating"
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
        createInstructionListForThisVerbModel()
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
        
    }
    
    
//    func setVerbStringsAtTense(tense: Tense){
//        verbStringList.removeAll()
//        fivePartVerbStructList.removeAll()
//        studentVerbConjugationList.removeAll()
//        studentVerbConjugationList.append(FivePartVerbStruct(stringChangeType: .startWithInfinitive, morphInfo: morphInfoList[0]))
//        for i in 0..<verbList.count {
//            verbStringList.append(verb.getWordStringAtLanguage(language: currentLanguage))
//            fivePartVerbStructList.append(FivePartVerbStruct(stringChangeType: .startWithInfinitive, morphInfo: morphInfoList[i]))
//        }
//    }
    
    func getNextPerson()->Person{
        personIndex += 1
        if personIndex >= persons.count {
            personIndex = 0
        }
        return persons[personIndex]
    }
    
    fileprivate func showInstructionBar() -> some View {
        HStack{
            Button(action: {
                showPreviousInstruction()
            }){
                Image(systemName: "arrowtriangle.backward")
            }
            Button{
                showNextInstruction()
            } label: {
                Text("\(instructionString)")
                    .background(.yellow)
                    .foregroundColor(.black)
                    
                    
            }
            Button(action: {
                showNextInstruction()
            }){
                Image(systemName: "arrowtriangle.forward")
            }
            .padding()
        }.frame(width: 300, height:30)
    }
    
    func showNextInstruction(){
        instructionString = instructionStringList[instructionIndex]
        if instructionIndex < instructionStringList.count - 1 {
            instructionIndex += 1
        }
        else {
            instructionIndex = 0
        }
    }
    
    func showPreviousInstruction(){
        instructionString = instructionStringList[instructionIndex]
        if instructionIndex > 0 {
            instructionIndex -= 1
        }
        else {
            instructionIndex = instructionStringList.count - 1
        }
    }
    
    func createInstructionListForThisVerbModel(){
        instructionStringList.removeAll()
        
        instructionStringList.append("Start with infinitive: \(morphInfoList[0].infinitive)")
        if !morphInfoList[0].stemTo.isBlank {
            instructionStringList.append("These verbs are stem-changing")
            instructionStringList.append("Change \(morphInfoList[0].stemFrom) to \(morphInfoList[0].stemTo)")
        }
        if !morphInfoList[0].orthoTo.isBlank {
            instructionStringList.append("These verbs are spell-changing")
                instructionStringList.append("Change \(morphInfoList[0].orthoFrom) to \(morphInfoList[0].orthoTo)")
        }
        instructionStringList.append("Replace \(morphInfoList[0].endingFrom) ending with - \(morphInfoList[0].endingTo)")
        instructionIndex = 0
    }
    
    fileprivate func showHeaderInfo() -> some View {
        VStack{
            HStack{
                Button(action: {
                    currentTenseString = languageViewModel.getNextTense().rawValue
                    setVerbStringsAtPerson(person: currentPerson)
                }){
                    Text("\(currentTenseString)")
                }
                .font(.callout)
                .padding(2)
                .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                .foregroundColor(.black)
                .cornerRadius(4)
                Spacer()
                NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                    Text("New Model")
                }.font(.callout)
                    .padding(2)
                    .background(.linearGradient(colors: [.orange, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                Button{
                    shuffleVerbList()
                } label: {
                    Text("Shuffle")
                }.font(.callout)
                    .padding(2)
                    .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                
                Spacer()
                Button(action: {
                    currentPerson = getNextPerson()
                    currentPersonString = currentPerson.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
                    setVerbStringsAtPerson(person: currentPerson)
                }){
                    Text("\(currentPersonString) form")
                }
                .font(.callout)
                .padding(2)
                .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                .foregroundColor(.black)
                .cornerRadius(4)
            }.padding(.horizontal, 20)
            HStack{
                
//                Button{
//                    showMeMore.toggle()
//                    if showMeMore {loadCurrentHint()}
//                    else { loadCurrentComment()}
//                } label: {
//                    Text(showMeMore ? "🐵" : "🙈")
//                        .bold()
//                        .font(.title)
//                        .foregroundColor(.black)
//                        .background(showMeMore ? .green : .yellow)
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                        .shadow(radius: 3)
//                        .padding(10)
//                }
            }
        }
    }

}
