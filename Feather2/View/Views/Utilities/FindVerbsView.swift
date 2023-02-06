//
//  VerbsOfAFeather.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/18/22.
//

import SwiftUI
import JumpLinguaHelpers

struct ShowPatternInfo: View{
    @State private var modelNumberString = ""
    @State private var modelNameString = ""
    @State private var patternTenseStringList = [String]()
    @State private var patternTypeStringList = [String]()
    
    var body : some View {
        VStack{
            HStack{
                VStack{
                    Text("Verb information:")
                    Text(modelNumberString)
                    Text(modelNameString)
                }
                VStack{
                    Text("Pattern information:")
                    ForEach( 0..<patternTenseStringList.count, id: \.self){i in
                        HStack{
                            Text(patternTenseStringList[i])
                            Text(patternTypeStringList[i])
                        }
                    }
                    
                }
            }
        }
        
    }
}


extension FindVerbsView {
    private var showFeatherInfo: some View {
        VStack{
            HStack{
                VStack{
                    Text("Verb information:")
                    Text(modelNumberString)
                    Text(modelNameString)
                }
                VStack{
                    Text("Pattern information:")
                        ForEach( 0..<patternTenseStringList.count, id: \.self){i in
                            HStack{
                                Text(patternTenseStringList[i])
                                Text(patternTypeStringList[i])
                            }
                        }

                }
            }
            
            Divider().frame(height:2).background(.yellow)
            
            switch featherMode {
            case .model: Text("The following \(featherVerbList.count) verbs with the same conjugation model were found:").bold().padding(.horizontal)
            case .pattern:  Text("The following \(featherVerbList.count) verbs with the same conjugation pattern were found:").bold().padding(.horizontal)
            }
        }.border(.red)
    }
}

enum FeatherMode {
    case model
    case pattern
}

struct FindVerbsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var featherMode : FeatherMode
    @State var newVerbString = ""
    @State var currentVerb = Verb()
    @State var selectedVerb = Verb()
    @State var criticalVerbForms = [String]()
    @State private var isDarkMode = false
    @State private var isNameValid = false
    @State private var isAnalyzed = false
    @State private var languageString = "Agnostic"
    @State private var currentLanguage = LanguageType.Agnostic
    @State private var featherVerbList = [Verb]()
//    @State private var activeList = [Bool]()
    @State private var patternList = [SpecialPatternStruct]()
    @State private var patternTenseStringList = [String]()
    @State private var patternTypeStringList = [String]()
    @State private var activeCount = 0
    @State private var languageChanged = false
    @State private var modelNumberString = ""
    @State private var modelNameString = ""
    @State private var modelVerbStringForWordCollection = ""
    @State private var featherModeHeader = ""
    
    @FocusState private var textFieldFocus : Bool
    
    var body : some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                switch featherMode {
                case .model:  Text("Find Verbs with Same Model").font(.title2).bold().foregroundColor(Color("ChuckText1"))
                case .pattern: Text("Find Verbs with Same Pattern").font(.title2).bold().foregroundColor(Color("ChuckText1"))
                }
                processTextField()
                if isNameValid {
                    VStack{
                        Button(action: {
                            analyzeAndFind()
                        }, label: {
                            Text("Analyze ")
                                .modifier(ModelTensePersonButtonModifier())
                        })
                        
                    }
                }
                //if not valid name,
                else {
                    showExampleView()
                }
                
                if isAnalyzed { BirdsOfAFeatherList() }
                Spacer()
                
                if selectedVerb.getWordAtLanguage(language: currentLanguage).count > 0 {
                    ZStack{
                        NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: selectedVerb, residualPhrase: "", multipleVerbFlag: true)){
                            HStack{
                                HStack{
                                    Text("Show me ")
                                    Text(selectedVerb.getWordAtLanguage(language: currentLanguage)).bold()
                                }
                                
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.yellow)
                            }
                                .frame(width: 325, height: 50)
                                .padding(.leading, 10)
                                .background(Color("BethanyPurpleButtons"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
        
        .onAppear(){
            switch featherMode {
            case .model:  featherModeHeader = "Feather Mode: Model"
            case .pattern:  featherModeHeader = "Feather Mode: Pattern"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.textFieldFocus = true
                currentLanguage = languageViewModel.getCurrentLanguage()
            }
        }
        //        .navigationTitle("Verbs with Same Model")
        Spacer()
            
    }
    
    @ViewBuilder
    func showExampleView()->some View{
        Text("Type in any verb or verb phrase")
            .font(.callout)
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
        Spacer()
    }
    
    @ViewBuilder
    func processTextField()->some View{
        VStack{
            HStack{
                Text(" ")
                TextField("🔍", text: $newVerbString).focused($textFieldFocus)
                    .disableAutocorrection(true)
                    .background(Color.black).opacity(0.8)
                    .foregroundColor(.yellow)
                    .modifier(NeumorphicTextfieldModifier())
                    .onChange(of: newVerbString){ (value) in
                        if isValidVerb(language: languageViewModel.getCurrentLanguage(), verbString: value) {
                            isNameValid = true
                        } else {
                            isNameValid = false
                        }
                        isAnalyzed = false
                    }
                    .onSubmit(){
                        if isValidVerb(language: languageViewModel.getCurrentLanguage(), verbString: newVerbString) {
                            analyzeAndFind()
                        }
                    }
                Button(action: {
                    newVerbString = ""
                },
                       label: {  Text("X")
                        .font(.title2)
                        .foregroundColor(Color("ChuckText1"))
                })
            }.padding(.horizontal)
        }
    }
    
    
    func saveFeatherListToActiveList(){
        languageViewModel.setFilteredVerbList(verbList: featherVerbList)
    }
    
    func saveAndExit(){
        languageViewModel.fillVerbCubeLists()
        languageViewModel.setPreviousCubeBlockVerbs()
        languageViewModel.fillQuizCubeVerbList()
        languageViewModel.fillQuizCubeBlock()
        dismiss()
    }
    
    fileprivate func analyzeAndFind() {
        let result =  analyze(verbString: newVerbString)
        var reconstructedVerbString = ""
        currentVerb = result.0
        featherVerbList = result.1
//        activeList.removeAll()
        
        //process model information
        
        let newBrv = languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb)
        modelNumberString = "Model number: \(newBrv.getBescherelleID())"
        switch currentLanguage {
        case .English:
            modelNumberString = "English verb"
        case .Spanish:
            switch newBrv.getBescherelleID(){
            case 5: modelNameString = "Regular AR Verb"
            case 87: modelNameString = "Regular IR Verb"
            case 6: modelNameString = "Regular ER Verb"
            default: modelNameString = "Model verb: \(newBrv.getBescherelleModelVerb())"
            }
        case .French:
            modelNumberString = "Model number: \(newBrv.getBescherelleID())"
        default:  modelNumberString = "Some other verb"
        }
        modelVerbStringForWordCollection = newBrv.getBescherelleModelVerb()
        
        //process model information
        
        let vm = languageViewModel.findModelForThisVerbString(verbWord: currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))
        let verbList = languageViewModel.findVerbsOfSameModel(targetID: vm.id)
        languageViewModel.setFilteredVerbList(verbList: verbList)
        if ( vm.id > 0 ){
            let vu = VerbUtilities()
            let result1 = vu.analyzeSpanishWordPhrase(testString: newVerbString)
            reconstructedVerbString = result1.0
            if result1.isReflexive {  reconstructedVerbString += "se" }
            if result1.residualPhrase.count > 0 { reconstructedVerbString += " " + result1.residualPhrase }
            let verb = Verb(spanish: reconstructedVerbString, french: "", english: "")
//            newVerbString = verb.getWordAtLanguage(language: currentLanguage)
//            languageViewModel.setVerbsForCurrentVerbModel(modelID: vm.id)
            languageViewModel.addVerbToFilteredList(verb: verb)
            featherVerbList = languageViewModel.getFilteredVerbs()
        }
        
        patternList = languageViewModel.getPatternsForThisModel(verbModel: vm)
        patternTenseStringList.removeAll()
        print(patternList.count)
        for sps in patternList {
            patternTenseStringList.append(sps.tense.rawValue)
            patternTypeStringList.append(sps.pattern.rawValue)
        }
        isAnalyzed = true
        hideKeyboard()
    }
    
//    if currentVerbString.count > 1 {
//        NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: Verb(spanish: currentVerbString, french: currentVerbString, english: currentVerbString), residualPhrase: "", teachMeMode: .model)){
//            HStack{
//                Text("Show me ")
//                Text(currentVerbString).bold()
//                Spacer()
//                Image(systemName: "chevron.right").foregroundColor(.yellow)
//            }
//        }.modifier(NeumorphicTextfieldModifier())
//    }
    
    func analyze(verbString: String)-> (Verb, [Verb]){
        let vu = VerbUtilities()
        var verb = Verb()
        var verbList = [Verb]()
        switch languageViewModel.getCurrentLanguage(){
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: newVerbString)
            verb = Verb(spanish: result.0, french: "", english: "")
            verbList = findVerbsLike(verb: verb)
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: newVerbString)
            verb = Verb(spanish: "", french:  result.0, english:  "")
            verbList = findVerbsLike(verb: verb)
        default:
            return (verb, verbList)
        }
        return (verb, verbList)
    }
    
    func findVerbsLike(verb: Verb)->[Verb]{
        var vList = [Verb]()
        switch featherMode {
        case .model: vList = languageViewModel.findVerbsFromSameModel(verb: verb)
        case .pattern:
            patternList = languageViewModel.getPatternsForVerb(verb: verb, tense: .present)
            
            vList = languageViewModel.getVerbList()
            
            //patterns can have multiple aspects for different tenses
            
            for pattern in patternList {
                vList = languageViewModel.getVerbsOfPattern(verbList: vList, thisPattern: pattern)
//                print("Found \(vList.count) words in findVerbLike")
//                var i = 0
//                var targetVerbFound = false
//                for v in newVerbList {
//                    if v.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())==verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()) {
//                        targetVerbFound = true
//                    }
//                    print("Verb: \(i). \(v.getWordAtLanguage(language: currentLanguage))")
//                    i += 1
//                }
//                if !targetVerbFound {
//                    vList.append(verb)
//                }
            }
            
        }
        return vList
    }
    
    func isValidVerb(language: LanguageType, verbString: String)->Bool{
        let vu = VerbUtilities()
        switch language{
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: verbString)
            if result.0.count > 3 {
                if result.1 == .AR || result.1 == .ER || result.1 == .IR || result.1 == .accentIR { return true }
            }
            return false
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: verbString)
            if result.0.count > 3 && (result.1 == .IR || result.1 == .ER || result.1 == .OIR || result.1 == .RE ){ return true }
            return false
        default: return false
        }
    }
    
    fileprivate func BirdsOfAFeatherList() -> some View {
        return VStack{
            Text("Your verb: \(currentVerb.getWordAtLanguage(language: currentLanguage))")
            if isAnalyzed {
                showFeatherInfo
            }
            Text(" ")
            let gridFixSize = CGFloat(200.0)
            let gridItems = [GridItem(.fixed(gridFixSize)),
                             GridItem(.fixed(gridFixSize))]
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach(0..<featherVerbList.count, id: \.self){ index in
                        Button(featherVerbList[index].getWordAtLanguage(language: currentLanguage)){
                            selectedVerb = featherVerbList[index]
                        }
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                        .background(.green )
                        .foregroundColor(.black )
                        .cornerRadius(8)
                        .font(Font.callout)
                    }
                }
                .padding()
            }
            
        }
    }
    
    
    
    
}

