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
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @EnvironmentObject var router: Router
    @Binding var selected: Bool
    @State private var currentLanguage = LanguageType.Agnostic
    @Environment(\.dismiss) private var dismiss
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
    @State var modelLocked = false
    @State var lockedModel = RomanceVerbModel()
    @State var lockSymbol = ""
    @State var showResidualPhrase = true
    @State var showReflexivePronoun = true
    @State var isReflexive = true
    @State var residualPhrase = ""
    @State var showReflexivesOnly = false
    @State private var matching = [false, false, false, false, false, false]
    
    //swipe gesture
    
    @State var startPos : CGPoint = .zero
    @State var isSwiping = true
    @State var color = Color.red.opacity(0.4)
    @State var direction = ""
    @State var stemString = ""
    @State var orthoString = ""
    @State var userString = ""
    
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    
    //@State var bAddNewVerb = false
    
    var body: some View {
        //        ZStack{
        //            Color("BethanyNavalBackground")
        //                .ignoresSafeArea()
        //
        
        VStack{
            HStack{
                Button(action: {
                    router.reset()
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(20)
                })
                Spacer()
            }
            Text("Spanish Dictionary").foregroundColor(Color("ChuckText1")).font(.title2)
            HStack{
                
                TextField("🔍", text: $userString,
                          onEditingChanged: { changed in
                }){
                }
                .disableAutocorrection(true)

                .modifier(NeumorphicTextfieldModifier())
                .onChange(of: userString){ (value) in
                    if userString.count > 0 {
                        let verbIndex = findClosestVerbIndex(userString)
                        if verbIndex > 0 {
                            currentIndex = verbIndex
                            currentVerb = verbList[currentIndex]
                            showCurrentWordInfo()
                        }
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
                    getNextTense()
                }.frame(width: 300, height: 35, alignment: .center)
                .background(.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
            HStack{
                Button(action: {
                    getPreviousVerbAtThisModel()
                }){
                    HStack{
                        Label("", systemImage: "arrow.left")
                        Text("Previous")
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    
                }
                
                Spacer()
                Text(spanishPhrase)
                    .foregroundColor(Color("BethanyGreenText"))
                    .frame(width: 120, height: 35, alignment: .center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .onTapGesture(perform: {
                        getNextVerbAtThisModel()
                    })
                Spacer()
                
                Button(action: {
                    getNextVerbAtThisModel()
                }){
                    HStack{
                        Text("  Next  ")
                        Label("", systemImage: "arrow.right")
                    }
                    .tint(.pink)
                    .buttonStyle(.bordered)
                }
                
            }
        }
        
        VStack {
//            VStack{
//                HStack{
//                    Text(spanishPhrase)
//                    Spacer()
//                    Text("\(currentIndex+1) / \(verbList.count)")
//                }
//                .padding()
//                .frame(width: 300, height: 30, alignment: .leading)
//                .border(.red)
//            }
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
            VStack{
                Button{
                    showReflexivesOnly.toggle()
                    modelLocked = false
                    getNextVerbAtThisModel()
                } label: {
                    HStack{
                        Text("Show reflexives only")
                        Spacer()
                        Label("", systemImage: showReflexivesOnly ? "lock" : "lock.open")
                    }
                    .padding()
                    .font(.caption)
                    .frame(width: 300, height: 30, alignment: .leading)
                    .border(.red)
                    .foregroundColor(showReflexivesOnly ? Color.black : Color("BethanyGreenText"))
                    .background(showReflexivesOnly ? Color.yellow : Color("BethanyNavalBackground"))
                }
                
                HStack{
                    Text("\(currentVerbModel.id).")
                    Text("Model \(currentVerbModel.modelVerb)")
                    if stemString.count > 0 { Text("(\(stemString))") }
                    if orthoString.count > 0 { Text("(\(orthoString))")  }
                    Spacer()
                    Label("", systemImage: modelLocked ? "lock" : "lock.open")
                    if modelLocked {
                        Button{
                            languageViewModel.processVerbModel(vm: currentVerbModel)
                            dismiss()
                        } label: {
                            Text("💚")
                        }
                    }
                }
                .padding()
                .font(.caption)
                .frame(width: 300, height: 30, alignment: .leading)
                .border(.red)
                .background(modelLocked ? .yellow : Color("BethanyNavalBackground"))
                .foregroundColor(modelLocked ? .black : Color("BethanyGreenText"))
                .onTapGesture(perform: {
                    modelLocked.toggle()
                })
                Text("Verb \(currentIndex+1) of \(verbList.count) verbs")
                Text("\(languageViewModel.findVerbsOfSameModel(targetID: currentVerbModel.id).count) verbs belong to \(currentVerbModel.modelVerb)")
            }
            
            
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
                getNextVerbAtThisModel()
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
//                        getNextTense()
                    }
                    else if self.startPos.y >  gesture.location.y && yDist > xDist {
                        self.direction = "Up"
                        self.color = Color.blue.opacity(0.4)
//                        getPreviousTense()
                    }
                    else if self.startPos.x > gesture.location.x + 10 && yDist < xDist {
                        self.direction = "Left"
                        self.color = Color.yellow.opacity(0.4)
//                        getNextVerb()
                        getNextVerbAtThisModel()
                    }
                    else if self.startPos.x < gesture.location.x + 10 && yDist < xDist {
                        self.direction = "Right"
                        self.color = Color.purple.opacity(0.4)
//                        getPreviousVerb()
                        getPreviousVerbAtThisModel()
                    }
                    self.isSwiping.toggle()
//                    print("gesture here")
                }
            )
        Spacer()
        
        //        }
    }
    
//    func selectCurrentModel(){
//        languageViewModel.computeSelectedVerbModels()
//        languageViewModel.computeCompletedVerbModels()
//        
//        vmecdm.setAllSelected(flag: false)
//        languageViewModel.setCurrentVerbModel(model: currentVerbModel)
//        vmecdm.setSelected(verbModelString: currentVerbModel.modelVerb, flag: true)
//        //create an study package
//        var verbModelList = [RomanceVerbModel]()
//        verbModelList.append(currentVerbModel)
//        var verbModelStringList = [String]()
//        verbModelStringList.append(currentVerbModel.modelVerb)
//        let sp = StudyPackageClass(name: currentVerbModel.modelVerb, verbModelStringList: verbModelStringList,
//                                   tenseList: [.present, .preterite, .imperfect, .conditional, .presentSubjunctive, .imperative],
//                                   chapter: "Verb model", lesson: currentVerbModel.modelVerb)
//        sp.preferredVerbList = languageViewModel.findVerbsOfSameModel(targetID: currentVerbModel.id)
////        languageViewModel.installStudyPackage(sp: sp)
//        languageViewModel.setStudyPackage(sp: sp)
//        print("DictionaryView: specialVerbType: \(sp.specialVerbType)")
//       
//        languageViewModel.fillVerbCubeAndQuizCubeLists()
//        
//        languageViewModel.resetFeatherSentenceHandler()
//        
//        //set the AppStorage stuff
//        languageViewModel.setToVerbModelMode()
//        
//    }
    
    func setPatternStuff(){
        let patternList = languageViewModel.getPatternsForThisModel(verbModel: currentVerbModel)
        stemString = ""
        orthoString = ""
        for sps in patternList {
            if sps.tense == currentTense {
                if sps.pattern.isStemChangingSpanish() { stemString = sps.pattern.rawValue }
                if sps.pattern.isSpellChangingSpanish() { orthoString = sps.pattern.rawValue }
            }
        }
    }
    
    func findClosestVerbIndex(_ userString: String)->Int{
        modelLocked = false
        var verbIndex = 0
        var verbString1 = ""
        var verbString2 = ""
        for index in 0 ..< verbList.count-1 {
            verbIndex = index
            verbString1 = verbList[index].getWordAtLanguage(language: currentLanguage)
            verbString2 = verbList[index+1].getWordAtLanguage(language: currentLanguage)
            if userString > verbString1 && userString < verbString2 {
                return index+1
            }
        }
        return verbIndex
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
    
//    func getNextVerb(){
//        currentIndex += 1
//        if currentIndex >= verbCount {
//            currentIndex = 0
//        }
//        currentVerb = verbList[currentIndex]
//        showCurrentWordInfo()
//    }
//
//    func getPreviousVerb(){
//        currentIndex -= 1
//        if currentIndex < 0 {currentIndex = verbCount-1}
//        currentVerbNumber = currentIndex + 1
//        currentVerb = verbList[currentIndex]
//        showCurrentWordInfo()
//    }
//
    func getPreviousVerbAtThisModel(){
        var searchCount = 0
        var modelFound = false
        var reflexiveVerbFound = false
        if modelLocked {
            repeat {
                searchCount += 1
                currentIndex -= 1
                if currentIndex < 0 {currentIndex = verbCount-1}
                currentVerbNumber = currentIndex + 1
                let thisVerb = verbList[currentIndex]
                spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
                let vu = VerbUtilities()
                let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
                let thisModel = languageViewModel.findModelForThisVerbString(verbWord: result.0)
                if thisModel == currentVerbModel{
                    currentVerb = verbList[currentIndex]
                    showCurrentWordInfo()
                    modelFound = true
//                    print("Found: \(spanishPhrase) belongs to \(currentVerbModel.modelVerb)")
                }
            } while !modelFound && searchCount < verbList.count
            
        } else if showReflexivesOnly {
            repeat {
                searchCount += 1
                currentIndex -= 1
                if currentIndex < 0 {currentIndex = verbCount-1}
                currentVerbNumber = currentIndex + 1
                let thisVerb = verbList[currentIndex]
                spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
                let vu = VerbUtilities()
                let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
                if result.isReflexive {
                    reflexiveVerbFound = true
                    currentVerb = verbList[currentIndex]
                    showCurrentWordInfo()
                }
            } while !reflexiveVerbFound  && searchCount < verbList.count
        }
        else {
            currentIndex -= 1
            if currentIndex < 0 {currentIndex = verbCount-1}
            currentVerbNumber = currentIndex + 1
            currentVerb = verbList[currentIndex]
            showCurrentWordInfo()
        }
       
    }
    
    func getNextVerbAtThisModel(){
        var thisModel = RomanceVerbModel()
        var searchCount = 0
        var modelFound = false
        var reflexiveVerbFound = false
        if modelLocked {
            repeat {
                searchCount += 1
                currentIndex += 1
                if currentIndex >= verbCount { currentIndex = 0  }
                currentVerbNumber = currentIndex + 1
                let thisVerb = verbList[currentIndex]
                spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
                let vu = VerbUtilities()
                let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
                thisModel = languageViewModel.findModelForThisVerbString(verbWord: result.0)
                if thisModel == currentVerbModel {
                    currentVerb = verbList[currentIndex]
                    showCurrentWordInfo()
                    modelFound = true
                }
            } while !modelFound && searchCount < verbList.count
        } else if showReflexivesOnly {
            repeat {
                searchCount += 1
                currentIndex += 1
                if currentIndex >= verbCount { currentIndex = 0  }
                let thisVerb = verbList[currentIndex]
                spanishPhrase = thisVerb.getWordAtLanguage(language: .Spanish)
                let vu = VerbUtilities()
                let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
                if result.isReflexive {
                    reflexiveVerbFound = true
                    currentVerb = verbList[currentIndex]
                    showCurrentWordInfo()
                }
            } while !reflexiveVerbFound && searchCount < verbList.count
        }else {
            currentIndex += 1
            if currentIndex >= verbCount {currentIndex = 0}
            currentVerb = verbList[currentIndex]
            showCurrentWordInfo()
        }
       
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
//        print("showCurrentWordInfo: spanishPhrase = \(spanishPhrase)")
        let vu = VerbUtilities()
        let result = vu.analyzeSpanishWordPhrase(testString: spanishPhrase)
        currentVerbModel = languageViewModel.findModelForThisVerbString(verbWord: result.0)
        setPatternStuff()
        isReflexive = result.3
        residualPhrase = result.2
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
        let thisVerb = languageViewModel.getRomanceVerb(verb: currentVerb)
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
