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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    
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
    @State private var userString = ""
    @State private var currentModelCompleted = false
    @State private var currentModelSelected = false
    @State private var sortedModelList = [RomanceVerbModel]()
    
    var body: some View {
        VStack{
            ExitButtonView()
            HStack{
                TextField("🔍Type name here", text: $userString,
                          onEditingChanged: { changed in
                    findClosestModel(userString)
                }){
                }
                .disableAutocorrection(true)

                .modifier(NeumorphicTextfieldModifier())
                .onChange(of: userString){ (value) in
                    findClosestModel(userString)
                }
                .onSubmit(){
                    findClosestModel(userString)
                    userString = ""
                }
            }
            ScrollView{
                Button{
                    setNextVerbModel()
                } label: {
                    HStack{
                        Text("Current model = \(modelVerbString)")
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
                
                VStack{
                    ScrollView() {
                        if patternTenseStringList.count > 0 {
                            Text("Pattern information:").bold()
                            ForEach( 0..<patternTenseStringList.count, id: \.self){i in
                                HStack{
                                    Text("\(patternTenseStringList[i]):")
                                    Text(patternTypeStringList[i])
                                    //                            Text(patternLabelStringList[i])
                                }
                            }
                        } else {
                            Text("This is a regular verb.")
                            Text("There are no associated patterns.")
                        }
                    }
                    Spacer()
                    Text("\(languageViewModel.findVerbsOfSameModel(targetID: currentModel.id).count) \(currentModel.modelVerb) verbs in dictionary ").bold()
                }
                .font(.caption)
                .foregroundColor(.black)
                .padding(5)
                .frame(width: 300, height: 170)
                .border(.red)
                .background(.yellow)
                
                HStack{
                    Button{
                        languageViewModel.setVerbModelTo(currentModel)
                        router.reset()
                        dismiss()
                    } label: {
                        Text("¿Install: \(currentModel.modelVerb) as selected model?")
                    }.tint(.purple)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius:5))
                    .controlSize(.regular)
                    .foregroundColor(.yellow)
                }
                    
                
                if currentModelCompleted {
                    Button{
//                        currentModelCompleted.toggle()
                    } label: {
                        Text("\(currentModel.modelVerb) has been completed")
                    }.frame(width: 300, height: 35, alignment: .center)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
                if currentModelSelected {
                    Button{
//                        currentModelCompleted.toggle()
                    } label: {
                        Text("\(currentModel.modelVerb) is current selection")
                    }.frame(width: 300, height: 35, alignment: .center)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
//                else {
//                    Text("You can now Select above")
//                        .frame(width: 300, height: 35, alignment: .center)
//                            .background(.white)
//                            .foregroundColor(.black)
//                            .cornerRadius(10)
//                            .padding(.bottom)
//                }
                
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
                }
            }.onAppear{
                tempTenseList = languageViewModel.getTenseList()
                languageViewModel.setTenses(tenseList: tenseList)
                currentLanguage = languageViewModel.getCurrentLanguage()
                sortVerbModelsAlphabetically()
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
    
    //modelDictionary: [String: Int] = [:]
    
    func sortVerbModelsAlphabetically(){
        verbModelList.removeAll()
        
        var modelNameList = [String]()
        for m in languageViewModel.getVerbModels() {
            modelNameList.append(m.modelVerb)
        }
        modelNameList.sort()
        
        for name in modelNameList{
            for m in languageViewModel.getVerbModels(){
                if name == m.modelVerb
                {
                verbModelList.append(m)
//                print("sortVerbModelsAlphabetically: \(m.id), \(m.modelVerb)")
                break
                }
            }
        }
//        print("sortVerbModelsAlphabetically: sorted verbModelList \(verbModelList.count) models, originally \(languageViewModel.getVerbModels().count) models")
    }
    
    func findClosestModel(_ userString: String){
//        var modelIndex = 0
        var string1 = ""
        var string2 = ""
        
        for index in 0 ..< verbModelList.count-1 {
//            modelIndex = index
            string1 = verbModelList[index].modelVerb
            string2 = verbModelList[index+1].modelVerb
            if userString > string1 && userString < string2 {
                currentModel = verbModelList[index+1]
                verbModelIndex = index+1
                break
            }
        }
        loadModelVerbString()
        setCurrentVerb()
        analyzeModel()
    }
    
    func loadModelVerbString(){
//        if currentModel.modelVerb == "regularAR" { modelVerbString = "cortar" }
//        else if currentModel.modelVerb == "regularER" { modelVerbString = "deber" }
//        else if currentModel.modelVerb == "regularIR" { modelVerbString = "vivir" }
//        else
//        {
//            modelVerbString = currentModel.modelVerb
//        }
        modelVerbString = currentModel.modelVerb
    }
    
    func swipeUp(){
        setPreviousTense()
    }
    
    func swipeDown(){
        setNextTense()
    }
    
    func swipeRight(){
        setPreviousVerbModel()
    }
    
    func swipeLeft(){
        setNextVerbModel()
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

    func setCurrentVerb(){
        loadModelVerbString()
        analyzeModel()
        currentModelCompleted = false
        currentModelSelected = false
        if languageViewModel.isCompleted(verbModel: currentModel){ currentModelCompleted = true}
        if vmecdm.isSelected(verbModelString:currentModel.modelVerb){ currentModelSelected = true}
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
//            if sps.pattern.isOrthoChangingSpanish(){ patternLabelStringList.append("(Spell)") }
//            if sps.pattern.isIrregularPreteriteSpanish(){ patternLabelStringList.append("(Spell)") }
//            else if sps.pattern.isStemChangingPresentSpanish(){
//                patternLabelStringList.append("(Stem)")
//            }
//            else if sps.pattern.isStemChangingPreteriteSpanish(){ patternLabelStringList.append("(Stem)")}
//            else {
//                patternLabelStringList.append("None")
//            }
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
