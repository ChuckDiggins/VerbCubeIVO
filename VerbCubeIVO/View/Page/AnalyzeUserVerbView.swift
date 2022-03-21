//
//  AddVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/9/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbListStruct : Identifiable {
    var id = UUID()
    var romanceString = "dummy"
    var englishString = "dummy"
}

struct AnalyzeUserVerbView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
    @State var newVerbString = ""
    @State var currentVerb = Verb()
//    @Binding var isPresented = false
    @State var criticalVerbForms = [String]()
    @State var comment0 = "First person singular, present tense"
    @State var comment1 = "First person singular, present subjunctive tense"
    @State var comment2 = "First person singular, preterite tense"
    @State var comment3 = "Third person singular, preterite tense"
    @State var comment4 = "Third person plural, preterite tense"
    @State var comment5 = "Third person plural, imperfect subjunctive (-ra) tense"
    @State var comment6 = "Participles"
    
    @State private var isDarkMode = false
    @State private var isNameValid = false
    @State private var isAnalyzed = false
    @State private var languageString = "Agnostic"
    @State private var currentLanguage = LanguageType.Agnostic
    
    var body : some View {
        VStack{
            VStack {
                Button(action: {
                    languageViewModel.changeLanguage()
                    currentLanguage = languageViewModel.getCurrentLanguage()
                    languageString = currentLanguage.rawValue
                    newVerbString = ""
                }){
                    Text(currentLanguage.rawValue)
                }
                .background(.yellow)
                .foregroundColor(.black)
                .buttonStyle(.bordered)
            }
            VStack {
                VStack {
                    VStack {
                        Text("Critical Verb Forms").font(.title).bold()
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
                            blankOutCvfs()
                            isAnalyzed = false
                        }
                        .onSubmit(){
                            if isValidVerb(language: languageViewModel.getCurrentLanguage(), verbString: newVerbString) {
                                let result =  analyze(newVerbString: newVerbString)
                                currentVerb = result.0
                                isAnalyzed = result.1
                                hideKeyboard()
                            }
                        }
                            Button(action: {
                                newVerbString = ""
                            },
                            label: {  Text("X")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                            })
                        }
                    }
                    //                        Text(newVerbString)
//                            .bold()
//                            .foregroundColor(isNameValid ? Color(.systemGray2) : .red)
                        
                        if isNameValid {
                            VStack{
                                HStack {
                                    Button(action: {
                                        let result =  analyze(newVerbString: newVerbString)
                                        currentVerb = result.0
                                        isAnalyzed = result.1
                                        hideKeyboard()
                                    }, label: {
                                        Text("Analyze ")
                                            .padding(.all, 2 )
                                            .background(Color.orange)
                                            .cornerRadius(10)

                                    })
                                }
                                let vsList = languageViewModel.getCriticalVerbForms()
                                var subjunctiveString = ""
                                ForEach (0 ..< vsList.count, id:\.self) { i in
                                    CriticalFormView(comment: vsList[i].comment,
                                                     person: vsList[i].person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3),
                                                     cvf: isAnalyzed ? vsList[i].verbForm : "",
                                                     subjunctiveString: languageViewModel.getSubjunctiveTerm(tense: vsList[i].tense)
                                                     )
                                }

                                VStack{
                                    if currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()).count > 2 {
                                        Text("Bescherelle id: \(languageViewModel.getRomanceVerb(verb: currentVerb).getBescherelleID())")
                                        Text("Bescherelle model verb: \(languageViewModel.getRomanceVerb(verb: currentVerb).getBescherelleModelVerb())")
                                        Text(languageViewModel.getRomanceVerb(verb: currentVerb).getBescherelleInfo())
                                        if languageViewModel.isVerbType(verb : currentVerb, verbType: .STEM) {
                                            Text("Verb is stem changing")
                                        }
                                        if languageViewModel.isVerbType(verb : currentVerb, verbType: .ORTHO) {
                                            Text("Verb is orthographic changing")
                                        }
                                        if languageViewModel.isVerbType(verb : currentVerb, verbType: .IRREG) {
                                            Text("Verb is irregular")
                                        }
                                        if languageViewModel.isVerbType(verb : currentVerb, verbType: .SPECIAL) {
                                            Text("Verb is special")
                                        }
                                        
                                        Text("Verbs of a feather count \(findVerbsLike(verb: currentVerb))")
                                    }
                                }.padding()
                                    .foregroundColor(.black)
                                
                                NavigationLink(destination: AnalyzeFilteredVerbView(verb: currentVerb)){
                                    HStack{
                                        Text("Show me ")
                                        Text("\(currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))").bold()
                                    }
                                }.frame(width: 200, height: 50)
                                .padding(.leading, 10)
                                .background(Color.orange)
                                .cornerRadius(10)
                            }
                        }
                    }.padding(8)
                }
                Spacer()
                .onAppear(){
                    currentLanguage = languageViewModel.getCurrentLanguage()
                }
            }
        .padding(20)
        .background(Color.gray)
        .padding(.all, 8)
        Spacer()
        
    }
    
    func findVerbsLike(verb: Verb)->Int{
        let vList = languageViewModel.findVerbsLike(verb: currentVerb)
        print("Verbs of a feather for \(verb):")
        for v in vList {
            print("verb: \(v.spanish)")
        }
        return vList.count
    }
    
//struct  VerbInfoView : View {
////    @EnvironmentObject var languageEngine : LanguageEngine
//    @EnvironmentObject var languageViewModel: LanguageViewModel
//    let verb: Verb
//
//    var body : some View {
//        if verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()).count > 2 {
//            Text("Bescherelle id: \(languageViewModel.getRomanceVerb(verb: verb).getBescherelleID())")
//            Text("Bescherelle model verb: \(languageViewModel.getRomanceVerb(verb: verb).getBescherelleModelVerb())")
//            Text(languageViewModel.getRomanceVerb(verb: verb).getBescherelleInfo())
//            if languageViewModel.isVerbType(verb : verb, verbType: .STEM) {
//                Text("Verb is stem changing")
//            }
//            if languageViewModel.isVerbType(verb : verb, verbType: .ORTHO) {
//                Text("Verb is orthographic changing")
//            }
//            if languageViewModel.isVerbType(verb : verb, verbType: .IRREG) {
//                Text("Verb is irregular")
//            }
//            if languageViewModel.isVerbType(verb : verb, verbType: .SPECIAL) {
//                Text("Verb is special")
//            }
//        }
//    }
//}
//
//
    struct  CriticalFormView : View {
        let comment: String
        let person: String
        let cvf: String
        let subjunctiveString: String
        
        var body : some View {
            VStack{
                HStack{
                    Text(comment)
                        .font(.caption).bold().italic()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack{
                    Text(subjunctiveString)
                    Text(person)
                    Text(cvf.count > 3 ? cvf : "...").bold()
                    Spacer()
                }
            }
        }
    }

    func analyze(newVerbString: String)-> (Verb, Bool) {
        let vu = VerbUtilities()
        var verb = Verb()
        var reconstructedVerbString = ""
        switch languageViewModel.getCurrentLanguage(){
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: newVerbString)
            //reconstruct the verb phrase, eliminating spaces, erroneous symbols, etc.
            reconstructedVerbString = result.0
            if result.isReflexive {  reconstructedVerbString += "se" }
            if result.residualPhrase.count > 0 { reconstructedVerbString += " " + result.residualPhrase }
            //make it into a Verb
            verb = Verb(spanish: reconstructedVerbString, french: "", english: "")
            languageViewModel.fillCriticalVerbForms(verb: verb, residualPhrase: result.2, isReflexive: result.3)
            print("Verb: \(reconstructedVerbString), verbEnding: \(result.1.rawValue), residualPhrase: \(result.2), isReflexive: \(result.3)")
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: newVerbString)
            reconstructedVerbString = result.0
            var startsWithVowelSound = vu.startsWithVowelSound(characterArray: reconstructedVerbString)
            if result.isReflexive {
                if startsWithVowelSound { reconstructedVerbString = "s'" + reconstructedVerbString}
                else { reconstructedVerbString = "se " + reconstructedVerbString }
            }
            if result.residualPhrase.count > 0 { reconstructedVerbString += " " + result.residualPhrase }
            verb = Verb(spanish: "", french:  reconstructedVerbString, english:  "")
            languageViewModel.fillCriticalVerbForms(verb: verb, residualPhrase: result.2, isReflexive: result.3)
            print("Verb: \(result.0), verbEnding: \(result.1.rawValue), residualPhrase: \(result.2), isReflexive: \(result.3)")
        default:
            return (verb, false)
        }
        return (verb, true)
    }
    
    func blankOutCvfs(){
        let vsList = languageViewModel.getCriticalVerbForms()
        for i in 0 ..< vsList.count{
            CriticalFormView(comment: vsList[i].comment,
                             person: vsList[i].person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3),
                             cvf: "", subjunctiveString: "")
        }
    }
    
    func fillCriticalVerbStuff(){
        //let nvs = "contar"
        
        let vsList = languageViewModel.getCriticalVerbForms()
        criticalVerbForms.removeAll()
        for index in 0..<vsList.count {
            let criticalStruct = vsList[index]
            _ = criticalStruct.person
            _ = criticalStruct.tense
            let verbString = criticalStruct.verbForm
            criticalVerbForms.append(verbString)
        }
    }
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

//struct AddUserVerbView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyzeUserVerbView()
//    }
//}

extension View {
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct NeumorphicTextfieldModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            //.textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.accentColor)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray3), lineWidth: 1)
                            )
                )
    }
}

extension View {
    func neumorphicTextField()-> some View {
        modifier(NeumorphicTextfieldModifier())
    }
}

extension Color {
    static let lightShadow = Color(red: 255/255, green: 255/255, blue: 255/255)
    static let darkShadow = Color(red: 163/255, green: 177/255, blue: 198/255)
    static let background = Color(red: 224/255, green: 229/255, blue: 236/255)
    static let neumorphicTextColor = Color(red: 132/255, green: 132/255, blue: 132/255)
}


