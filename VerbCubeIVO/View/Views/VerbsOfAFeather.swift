//
//  VerbsOfAFeather.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/18/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbsOfAFeather: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    
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
    @State private var activeCount = 0
    @State private var languageChanged = false
    @State private var modelNumberString = ""
    @State private var brv = BRomanceVerb()

    //à
    fileprivate func BirdsOfAFeatherList() -> some View {
        return VStack{
            Text("Your verb: \(currentVerb.getWordAtLanguage(language: currentLanguage))").font(.caption)
            if isAnalyzed {
                VStack{
                Text("Verb model information:")
                Text(modelNumberString)
                Text("Model verb: \(brv.getBescherelleModelVerb())")
                }
//                .frame(width: 400, height: 150)
                .background(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .font(.caption)
                Divider()
                Text("The following \(getActiveCount()) verbs with the same conjugation pattern were found:").bold()
                
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
    
    func getActiveCount()->Int{
        var count = 0
        for i in 0..<activeList.count{
            if activeList[i] { count += 1 }
        }
        return count
    }
    
    fileprivate func analyzeAndFind() {
        let result =  analyze(verbString: newVerbString)
        currentVerb = result.0
        featherVerbList = result.1
        activeList.removeAll()
        brv = languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb)
        modelNumberString = "Model number: \(brv.getBescherelleID())"
        for _ in 0..<featherVerbList.count{
            activeList.append(true)}
        isAnalyzed = true
        hideKeyboard()
    }
    
    fileprivate func changeLanguage() {
        languageViewModel.changeLanguage()
        currentLanguage = languageViewModel.getCurrentLanguage()
        languageString = currentLanguage.rawValue
        newVerbString = ""
        isAnalyzed = false
        isNameValid = false
    }
    
    var body : some View {
//        NavigationView{
            Button(action: {
                withAnimation(.easeInOut(duration: 1.0)){
                    languageChanged.toggle()
                }
                changeLanguage()
            }){
                Text(currentLanguage.rawValue)
                    .frame(width: 100, height: 30)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(languageChanged ? .linearGradient(colors: [.red, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing) : .linearGradient(colors: [.blue, .red], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(radius: 3)
            }
            
            //        .buttonStyle(.bordered)
            
            VStack {
                //            Text("Verbs of a Feather").font(.title).bold()
                HStack{
                    TextField("Enter verb or verb phrase", text: $newVerbString,
                              onEditingChanged: { changed in
                        print("onEditingChanged: \(changed)")
                    }){
                        print("OnCommit")
                    }
                    .disableAutocorrection(true)
                    .background(Color.black).opacity(0.8)
                    .foregroundColor(.yellow)
                    .modifier(NeumorphicTextfieldModifier())
                    //            neumorphicTextField()
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
                if isNameValid {
                    VStack{
                        HStack {
                            Button(action: {
                                analyzeAndFind()
                            }, label: {
                                Text("Analyze ")
                                    .padding(.all, 2 )
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            })
                            
                            if getActiveCount() > 2 {
                                Button(action: {
                                    saveFeatherListToActiveList()
                                    languageViewModel.createWordCollection(verbList: languageViewModel.getFilteredVerbs(), collectionName: "Model number: \(brv.getBescherelleID())")
                                }, label: {
                                    Text("Create Word Collection")
                                        .padding(.all, 2 )
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                })
                                Button(action: {
                                    saveFeatherListToActiveList()
                                    saveAndExit()
                                }, label: {
                                    Text("Save as active")                                              
                                        .padding(.all, 2 )
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                })
                            }
                        }
                        
                    }
                    if getActiveCount() > 12 {
                        Button{
                            featherVerbList = selectRandom12()
                            languageViewModel.setFilteredVerbList(verbList: featherVerbList)
                            saveAndExit()
                        } label: {
                            Text("Random 12")
                        }
                    }
                }
                if isAnalyzed {
                    BirdsOfAFeatherList()
                }
                Spacer()
            }
            .navigationTitle("Verbs of a Feather")
            Spacer()
                .onAppear(){
                    currentLanguage = languageViewModel.getCurrentLanguage()
                }
//        }
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
        var vList = languageViewModel.findVerbsLike(verb: verb)
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

}

