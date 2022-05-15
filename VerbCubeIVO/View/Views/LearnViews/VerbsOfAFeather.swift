//
//  VerbsOfAFeather.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/18/22.
//

import SwiftUI
import JumpLinguaHelpers

extension VerbsOfAFeather {
    private var showFeatherInfo: some View {
        VStack{
            VStack{
                Text("Verb model information:")
                Text(modelNumberString)
                Text(modelNameString)
            }.background(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .font(.caption)
            
            Divider()
            switch featherMode {
            case .model: Text("The following \(getActiveCount()) verbs with the same conjugation model were found:").bold()
            case .pattern:  Text("The following \(getActiveCount()) verbs with the same conjugation pattern were found:").bold()
            }
        }
    }
}

enum FeatherMode {
    case model
    case pattern
}

struct VerbsOfAFeather: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var featherMode : FeatherMode
    @State var newVerbString = ""
    @State var currentVerb = Verb()
    @State var criticalVerbForms = [String]()
    @State private var isDarkMode = false
    @State private var isNameValid = false
    @State private var isAnalyzed = false
    @State private var languageString = "Agnostic"
    @State private var currentLanguage = LanguageType.Agnostic
    @State private var featherVerbList = [Verb]()
    @State private var activeList = [Bool]()
    @State private var patternList = [SpecialPatternStruct]()
    @State private var activeCount = 0
    @State private var languageChanged = false
    @State private var modelNumberString = ""
    @State private var modelNameString = ""
    @State private var modelVerbStringForWordCollection = ""
    @State private var featherModeHeader = ""
    
    @FocusState private var textFieldFocus : Bool
    
    var body : some View {
//        languageButton()                 This was convenient for me but not for typical users
        Button{
            if ( featherMode == .pattern ){ featherMode = .model }
            else { featherMode = .pattern }
            switch featherMode {
            case .model:  featherModeHeader = "Feather Mode: Model"
            case .pattern:  featherModeHeader = "Feather Mode: Pattern"
            }
        } label: {
            Text(featherModeHeader)
        }
        .frame(width: 150, height: 50)
        .padding(.leading, 10)
        .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
        .cornerRadius(10)
        .foregroundColor(.yellow)
        
        VStack {
            processTextField()
            if isNameValid {
                VStack{
                    Button(action: {
                        analyzeAndFind()
                    }, label: {
                        Text("Analyze ")
                            .padding(.all, 2 )
                            .background(Color.orange)
                            .cornerRadius(10)
                    })
                    processAndSaveView()
                }
            }
            //if not valid name,
            else {
                showExampleView()
            }
            
            if isAnalyzed { BirdsOfAFeatherList() }
            Spacer()
        }
        //            .navigationTitle("Verbs of a Feather")
        Spacer()
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
    }
    
    func getActiveCount()->Int{
        var count = 0
        for i in 0..<activeList.count{
            if activeList[i] { count += 1 }
        }
        return count
    }
    
    
    
    @ViewBuilder
    func processAndSaveView()->some View{
        HStack {
            if getActiveCount() > 2 {
                HStack{
                    Button(action: {
                        saveFeatherListToActiveList()
                        saveAndExit()
                    }, label: {
                        Text("Save as active verbs")
                            .padding(.all, 2 )
                            .background(Color.yellow)
                            .cornerRadius(10)
                    })
                }
            }
        }
        
    }
    
    @ViewBuilder
    func showExampleView()->some View{
        VStack{
            Text("Type in an infinitive.  It can be reflexive and part of a verb phrase.")
            Text("It can be reflexive and part of a verb phrase.")
            Text("\nExamples: ")
            Text("            encontrar").font(.callout).fontWeight(.bold)
            Text("            darse con").font(.callout).fontWeight(.bold)
            Text("            xxxeguirse de").font(.callout).fontWeight(.bold)
        }.frame(minWidth: 0, maxWidth: 400)
                .frame(height: 200)
                .background(.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(20)
    }

    @ViewBuilder
    func processTextField()->some View{
        VStack{
            HStack{
                TextField("Enter verb or verb phrase", text: $newVerbString).focused($textFieldFocus)
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
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .background(.yellow)
                })
            }
        }
    }
    

    func saveFeatherListToActiveList(){
        var activeVerbList = [Verb]()
        for i in 0..<featherVerbList.count {
            if activeList[i] { activeVerbList.append(featherVerbList[i]) }
        }
        languageViewModel.setFilteredVerbList(verbList: activeVerbList)
    }
    
    func selectRandom12()->[Verb]{
        var randomVerbList = [Verb]()
        randomVerbList = featherVerbList.shuffled()
        for i in 0..<12 { featherVerbList[i] = randomVerbList[i] }
        return featherVerbList
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
        currentVerb = result.0
        featherVerbList = result.1
        activeList.removeAll()
        
        switch featherMode {
        case .model:
            let newBrv = languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb)
            modelNumberString = "Model number: \(newBrv.getBescherelleID())"
            modelNameString = "Model verb: \(newBrv.getBescherelleModelVerb())"
            modelVerbStringForWordCollection = newBrv.getBescherelleModelVerb()
        case .pattern:
            modelNumberString = "No pattern found for this verb"
            for sps in patternList {
                modelNumberString = "Pattern: \(sps.pattern.rawValue)"
            }
            
        }
        
        for _ in 0..<featherVerbList.count{
            activeList.append(true)}
        isAnalyzed = true
        hideKeyboard()
    }
    
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
            
            //if this this verb has no special patterns, then don't load any verbs
            if patternList.count > 0 {
                vList = languageViewModel.findVerbsFromSamePatternsAsVerb(verb: verb, tense: .present)
                print("Found \(vList.count) words in findVerbLike")
                var i = 0
                var targetVerbFound = false
                for v in vList {
                    if v.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())==verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()) {
                        targetVerbFound = true
                    }
                    print("Verb: \(i). \(v.getWordAtLanguage(language: currentLanguage))")
                    i += 1
                }
                if !targetVerbFound {
                    vList.append(verb)
                }
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
            Text("Your verb: \(currentVerb.getWordAtLanguage(language: currentLanguage))").font(.caption)
            if isAnalyzed {
                showFeatherInfo
            }
            
            let gridFixSize = CGFloat(200.0)
            let gridItems = [GridItem(.fixed(gridFixSize)),
                             //                                         GridItem(.fixed(gridFixSize)),
                             GridItem(.fixed(gridFixSize))]
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach(0..<featherVerbList.count, id: \.self){ index in
                        Button(featherVerbList[index].getWordAtLanguage(language: currentLanguage)){
                            activeList[index].toggle()
                        }
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                        .background(activeList[index] ? .green : .red)
                        .foregroundColor(activeList[index] ? .black : .yellow)
                        .cornerRadius(8)
                        .font(Font.callout)
                        //                        WordCellButton(wordText: featherVerbList[index].getWordAtLanguage(language: currentLanguage), isActive:
                        //                                        activeList[index] )
                    }
                }
                .padding()
            }
            
        }
    }
    
    
    
    
}
