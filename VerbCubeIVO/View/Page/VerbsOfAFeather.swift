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

    fileprivate func BirdsOfAFeatherList() -> some View {
        return VStack{
            Text("Your verb: \(currentVerb.getWordAtLanguage(language: currentLanguage))").font(.title2)
            Text("Bescherelle id: \(languageViewModel.getRomanceVerb(verb: currentVerb).getBescherelleID())")
            Text("Bescherelle model verb: \(languageViewModel.getRomanceVerb(verb: currentVerb).getBescherelleModelVerb())")
            Divider()
            Text("The following \(getActiveCount()) verbs with the same conjugation pattern were found:").bold()

            let gridFixSize = CGFloat(200.0)
            let gridItems = [GridItem(.fixed(gridFixSize)),
//                                         GridItem(.fixed(gridFixSize)),
                                         GridItem(.fixed(gridFixSize))]
            LazyVGrid(columns: gridItems, spacing: 5){
                ForEach(0..<featherVerbList.count){ index in
                    WordCellButton(wordText: featherVerbList[index].getWordAtLanguage(language: currentLanguage), isActive:
                                    activeList[index] )
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
        for _ in 0..<featherVerbList.count{
            activeList.append(true)}
        isAnalyzed = true
        hideKeyboard()
    }
    
    var body : some View {
//        NavigationView{
            Button(action: {
                languageViewModel.changeLanguage()
                currentLanguage = languageViewModel.getCurrentLanguage()
                languageString = currentLanguage.rawValue
                newVerbString = ""
            }){
                Text(currentLanguage.rawValue)
                    .frame(width: 100, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .foregroundColor(.black)
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
                            
                            if getActiveCount() > 5 {
                                Button(action: {
                                    var activeVerbList = [Verb]()
                                    for i in 0..<featherVerbList.count { activeVerbList.append(featherVerbList[i])}
                                        languageViewModel.setFilteredVerbList(verbList: activeVerbList)
                                        saveAndExit()
                                }, label: {
                                    Text("Load Verb Cube ")
                                        .padding(.all, 2 )
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                })
                            }
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
        var reconstructedVerbString = ""
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
        let vList = languageViewModel.findVerbsLike(verb: verb)
        print("Found \(vList.count) words in findVerbLike")
        var i = 0
        for v in vList {
//            let vStr = v.getWordAtLanguage(language: currentLanguage)
            print("Verb: \(i). \(v.getWordAtLanguage(language: currentLanguage))")
            i += 1
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

