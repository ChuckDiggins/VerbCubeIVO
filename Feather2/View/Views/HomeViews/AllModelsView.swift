//
//  AllModelsView.swift
//  Feather2
//
//  Created by Charles Diggins on 12/13/22.
//

import SwiftUI
import JumpLinguaHelpers

struct AllModelsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @AppStorage("V2MChapter") var currentV2mChapter = ""
    @AppStorage("V2MLesson") var currentV2mLesson = ""
    
    @State var isSwiping = true
    @State var startPos : CGPoint = .zero
    @State var currentModel = RomanceVerbModel()
    @State var verbModelList = [RomanceVerbModel]()
    @State var verbModelIndex = 0
    @State var currentTenseString = ""
    @State var currentTense = Tense.present
    @State var currentLanguage = LanguageType.Agnostic
    @State var currentTenseIndex = 0
    var vu = VerbUtilities()
    @State var vvm = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    @State var person = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    let tenseList = [Tense.present, .preterite, .imperfect, .future, .conditional, .presentSubjunctive, .imperfectSubjunctiveRA, .imperative]
    @State var tempTenseList = [Tense]()
    @State var subjunctiveWord = "que "
    @State private var patternList = [SpecialPatternStruct]()
    @State private var patternLabelStringList = [String]()
    @State private var patternTenseStringList = [String]()
    @State private var patternTypeStringList = [String]()
    @State private var modelVerbString = ""
    
    var body: some View {
        VStack{
            Button{
                setNextVerbModel()
            } label: {
                HStack{
                    Text("Current model = \(currentModel.id): \(modelVerbString)")
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }
                
            }.modifier(ModelTensePersonButtonModifier())
            
            Button{
                setNextTense()
            } label: {
                HStack{
                    Text("Tense: \(currentTense.rawValue)")
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }
            }.modifier(ModelTensePersonButtonModifier())
            
            VStack(spacing: 5) {
                if patternTenseStringList.count > 0 {
                    Text("Pattern information:").bold()
                    ForEach( 0..<patternTenseStringList.count, id: \.self){i in
                        HStack{
                            Text(patternTenseStringList[i])
                            Text(patternTypeStringList[i])
                            Text(patternLabelStringList[i])
                        }
                    }
                } else {
                    Text("This is a regular verb.")
                    Text("There are no associated patterns.")
                }
                
            }
            .font(.caption)
            .foregroundColor(.black)
            .padding(5)
            .frame(width: 300, height: 150)
            .border(.red)
            .background(.yellow)
            Button{
                processVerbModel()
            } label: {
                Text("Select this verb model")
            }
            Divider().frame(height:2).background(.yellow)
            ForEach (0..<6){ i in
                HStack {
                    Text(person[i])
                        .foregroundColor(Color("ChuckText1"))
                    Text(vvm[i])
                        .foregroundColor(Color("BethanyGreenText"))
                    Spacer()
                    Button{
                        textToSpeech(text : "\(person[i]) \(vvm[i])", language: currentLanguage)
                    } label: {
                        Image(systemName:"speaker.wave.3.fill").foregroundColor(Color("BethanyGreenText"))
                    }
                }.frame(width: 350, height:30)
                    .background(Color("BethanyNavalBackground"))
                    .padding(.horizontal)
                
            }.onAppear{
                tempTenseList = languageViewModel.getTenseList()
                languageViewModel.setTenses(tenseList: tenseList)
                currentLanguage = languageViewModel.getCurrentLanguage()
                verbModelList = languageViewModel.getOrderedVerbModelList()
                currentModel = verbModelList[0]
                loadModelVerbString()
                setCurrentVerb()
                analyzeModel()
            }.onDisappear{
                languageViewModel.setTenses(tenseList: tempTenseList)
                languageViewModel.resetFeatherSentenceHandler()
            }
        }
        .gesture(DragGesture()
        .onChanged { gesture in
            if self.isSwiping {
                self.startPos = gesture.location
                self.isSwiping.toggle()
            }
        }
                    .onEnded { gesture in
            let xDist =  abs(gesture.location.x - self.startPos.x)
            let yDist =  abs(gesture.location.y - self.startPos.y)
            if self.startPos.y <  gesture.location.y && yDist > xDist {
                swipeDown()
            }
            else if self.startPos.y >  gesture.location.y && yDist > xDist {
                swipeUp()
            }
            
            else if self.startPos.x > gesture.location.x && yDist < xDist {
                swipeLeft()
            }
            else if self.startPos.x < gesture.location.x && yDist < xDist {
                swipeRight()
            }
            self.isSwiping.toggle()
        }
        )
        Spacer()

    }
    
    func loadModelVerbString(){
        if currentModel.modelVerb == "regularAR" { modelVerbString = "cortar" }
        else if currentModel.modelVerb == "regularER" { modelVerbString = "deber" }
        else if currentModel.modelVerb == "regularIR" { modelVerbString = "vivir" }
        else {
            modelVerbString = currentModel.modelVerb
        }
    }
    
    func swipeUp(){
        setPreviousTense()
    }
    
    func swipeDown(){
        setNextTense()
    }
    
    func swipeRight(){
        setNextVerbModel()
    }
    
    func swipeLeft(){
        setPreviousVerbModel()
    }
    
    func setNextTense(){
        currentTense = languageViewModel.getNextTense()
        setCurrentVerb()
    }
    
    func setPreviousTense(){
        currentTense = languageViewModel.getPreviousTense()
        setCurrentVerb()
    }
    
    func setNextVerbModel(){
        if verbModelIndex < verbModelList.count-1 {
            verbModelIndex += 1
        } else {
            verbModelIndex = 0
        }
        currentModel = verbModelList[verbModelIndex]
        setCurrentVerb()
    }
   
    func setPreviousVerbModel(){
        if verbModelIndex > 0  {
            verbModelIndex -= 1
        } else {
            verbModelIndex = verbModelList.count - 1
        }
        currentModel = verbModelList[verbModelIndex]
        setCurrentVerb()
    }
   
    func processVerbModel(){
        languageViewModel.computeSelectedVerbModels()
        languageViewModel.computeCompletedVerbModels()
        
//        showSheet.toggle()
        vmecdm.setAllSelected(flag: false)
        languageViewModel.setCurrentVerbModel(model: currentModel)
        vmecdm.setSelected(verbModelString: currentModel.modelVerb, flag: true)
        //create a study package
        var verbModelList = [RomanceVerbModel]()
        verbModelList.append(currentModel)
        var verbModelStringList = [String]()
        verbModelStringList.append(currentModel.modelVerb)
        var sp = StudyPackageClass(name: currentModel.modelVerb, verbModelStringList: verbModelStringList,
                                   tenseList: [.present, .preterite, .imperfect, .conditional],
                                   chapter: "Verb model", lesson: currentModel.modelVerb)
        sp.preferredVerbList = languageViewModel.findVerbsOfSameModel(targetID: currentModel.id)
        currentV2mChapter = sp.chapter
        currentV2mLesson = sp.lesson
        languageViewModel.setStudyPackage(sp: sp)
        languageViewModel.setVerbOrModelMode(mode: .modelMode)
    }
    
    
    func setCurrentVerb(){
        loadModelVerbString()
        analyzeModel()
        currentTense = languageViewModel.getCurrentTense()
        setSubjunctiveStuff()
        let verbList = languageViewModel.findVerbsOfSameModel(targetID: currentModel.id)
        var verb = Verb()
        var verbFound = false
        for v in verbList{
            if currentModel.modelVerb == "regularAR" {
                verb = Verb(spanish: "cortar", french: "cortar", english: "cut")
                verbFound = true
                break
            }
            else if currentModel.modelVerb == "regularER" {
                verb = Verb(spanish: "deber", french: "deber", english: "owe")
                verbFound = true
                break
            }
            else if currentModel.modelVerb == "regularIR" {
                verb = Verb(spanish: "vivir", french: "livre", english: "live")
                verbFound = true
                break
            }
            if v.getWordAtLanguage(language: currentLanguage) == currentModel.modelVerb {
                verb = v
                verbFound = true
                break
            }
        }
        if !verbFound {
            verb = Verb(spanish: currentModel.modelVerb, french: currentModel.modelVerb, english: currentModel.modelVerb)
        }

        vvm.removeAll()
        for i in 0..<6 {
            vvm.append(languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: currentTense, person: Person.all[i]))
            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(),
                                                                         subjectPronounType: languageViewModel.getSubjectPronounType(),
                                                                         verbStartsWithVowel: vu.startsWithVowelSound(characterArray: vvm[i]))
        }
    }
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if languageViewModel.getCurrentTense().isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
    func analyzeModel(){
        patternList = languageViewModel.getPatternsForThisModel(verbModel: currentModel)
        patternTenseStringList.removeAll()
        patternLabelStringList.removeAll()
        patternTypeStringList.removeAll()
        
        print(patternList.count)
        for sps in patternList {
            if sps.pattern.isOrthoChangingSpanish(){ patternLabelStringList.append("(Spell)") }
            if sps.pattern.isIrregularPreteriteSpanish(){ patternLabelStringList.append("(Spell)") }
            else if sps.pattern.isStemChangingPresentSpanish(){
                patternLabelStringList.append("(Stem)")
            }
            else if sps.pattern.isStemChangingPreteriteSpanish(){ patternLabelStringList.append("(Stem)")}
            else {
                patternLabelStringList.append("None")
            }
            patternTenseStringList.append(sps.tense.rawValue)
            patternTypeStringList.append(sps.pattern.rawValue)
        }
    }
}

struct VerbModelPatternView: View {
    var body: some View {
       
        VStack{
            
        }
    }
}
//struct AllModelsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllModelsView()
//    }
//}
