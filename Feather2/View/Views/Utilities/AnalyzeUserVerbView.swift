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
    @State var residualPhrase = ""
    
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
    @State private var languageChanged = false
    @State private var modelID  = 0
    @State private var modelVerb = ""
    
    fileprivate func changeLanguage() {
        languageViewModel.changeLanguage()
        currentLanguage = languageViewModel.getCurrentLanguage()
        languageString = currentLanguage.rawValue
        newVerbString = ""
        isAnalyzed = false
        isNameValid = false
    }
    
    var body : some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack {
                VStack {
                    VStack {
                        Text("Analyze User Verb").font(.title2).bold().foregroundColor(Color("ChuckText1"))
                        Text("Type in any verb or verb phrase")
                            .frame(width: 325, height: 50)
                            .font(.callout)

                        HStack{
                            Text("Enter verb:")
                        TextField("", text: $newVerbString,
                                  onEditingChanged: { changed in
                            print("onEditingChanged: \(changed)")
                        }){
                            print("OnCommit")
                        }
                        .disableAutocorrection(true)
                        .modifier(NeumorphicTextfieldModifier())
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
                                residualPhrase = result.1
                                isAnalyzed = result.2
                                hideKeyboard()
                            }
                        }

                            Button(action: {
                                newVerbString = ""
                            },
                                   label: {  Text("X")
                                    .font(.largeTitle)
                            })
                        }
                        
                        
                        Spacer()

                    }
                        
                        if isNameValid {
                            VStack{
                                HStack {
                                    Button(action: {
                                        let result =  analyze(newVerbString: newVerbString)
                                        currentVerb = result.0
                                        residualPhrase = result.1
                                        isAnalyzed = result.2
                                        hideKeyboard()
                                    }, label: {
                                        Text("Analyze ")
                                            .padding(.all, 5 )
                                            .background(Color("BethanyPurpleButtons"))
                                            .cornerRadius(10)
                                            .foregroundColor(.white)

                                    })
                                }
                                let vsList = languageViewModel.getCriticalVerbForms()
                                ForEach (0 ..< vsList.count, id:\.self) { i in
                                    CriticalFormView(comment: vsList[i].comment,
                                                     person: vsList[i].person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: VerbUtilities().startsWithVowelSound(characterArray: vsList[i].verbForm), useUstedForm: languageViewModel.useUstedForS3),
                                                     cvf: isAnalyzed ? vsList[i].verbForm : "",
                                                     subjunctiveString: languageViewModel.getSubjunctiveTerm(tense: vsList[i].tense)
                                                     )
                                    .padding(3)
                                }

                                VStack{
                                    if currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()).count > 2 {
                                        VStack{
                                            Text("Verb model:  \(modelID) - \(modelVerb) ")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .font(.callout)
                                                .background(Color("BethanyNavalBackground"))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }

                                NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel,  verb: currentVerb, residualPhrase: residualPhrase, multipleVerbFlag: true)){
                                    HStack{
                                        Text("Show me ")
                                        Text("\(currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))").bold()
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundColor(.yellow)
                                    }
                                }.frame(width: 325, height: 50)
                                .padding(.leading, 10)
                                .background(Color("BethanyPurpleButtons"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                    }.padding(8)
                }
            .foregroundColor(Color("BethanyGreenText"))
                .onAppear(){
                    currentLanguage = languageViewModel.getCurrentLanguage()
                }
            Spacer()
//            }
        }
//        .padding(20)
//        .padding(.all, 8)
        Spacer()
        
    }
    
    
    func setBescherelleModelInfo() {
        let brv = languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb)
        modelID = brv.getBescherelleID()
        modelVerb = brv.getBescherelleModelVerb()
        switch currentLanguage {
        case .Spanish:
            switch modelID{
            case 5: modelVerb = "Regular AR Verb"
            case 87: modelVerb = "Regular IR Verb"
            case 788: modelVerb = "Regular IR Verb"
            case 6: modelVerb = "Regular ER Verb"
            default: break
            }
        default:
            break
        }
    
    }
    
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
                    Text(cvf.count > 1 ? cvf : "...").bold()
                    Spacer()
                }
            }
        }
    }

    func analyze(newVerbString: String)-> (Verb, String, Bool) {
        let vu = VerbUtilities()
        var verb = Verb()
        var reconstructedVerbString = ""
        var residualPhrase = ""
        
        switch languageViewModel.getCurrentLanguage(){
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: newVerbString)
            //reconstruct the verb phrase, eliminating spaces, erroneous symbols, etc.
            reconstructedVerbString = result.0
            if result.isReflexive {  reconstructedVerbString += "se" }
//            if result.residualPhrase.count > 0 { reconstructedVerbString += " " + result.residualPhrase }
            //make it into a Verb
            residualPhrase = result.2
            verb = Verb(spanish: reconstructedVerbString, french: "", english: "")
            languageViewModel.fillCriticalVerbForms(verb: verb, residualPhrase: residualPhrase, isReflexive: result.3)
            print("Verb: \(reconstructedVerbString), verbEnding: \(result.1.rawValue), residualPhrase: \(result.2), isReflexive: \(result.3)")
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: newVerbString)
            reconstructedVerbString = result.0
            let startsWithVowelSound = vu.startsWithVowelSound(characterArray: reconstructedVerbString)
            if result.isReflexive {
                if startsWithVowelSound { reconstructedVerbString = "s'" + reconstructedVerbString}
                else { reconstructedVerbString = "se " + reconstructedVerbString }
            }
            residualPhrase = result.2
//            if result.residualPhrase.count > 0 { reconstructedVerbString += " " + result.residualPhrase }
            verb = Verb(spanish: "", french:  reconstructedVerbString, english:  "")
            languageViewModel.fillCriticalVerbForms(verb: verb, residualPhrase: residualPhrase, isReflexive: result.3)
            print("Verb: \(result.0), verbEnding: \(result.1.rawValue), residualPhrase: \(result.2), isReflexive: \(result.3)")
        default:
            return (verb, residualPhrase, false)
        }
        currentVerb = verb
        setBescherelleModelInfo()
        let vm = languageViewModel.findModelForThisVerbString(verbWord: reconstructedVerbString)
//        languageViewModel.setVerbsForCurrentVerbModel(modelID: vm.id)
        return (verb, residualPhrase, true)
    }
    
    func blankOutCvfs(){
        let vsList = languageViewModel.getCriticalVerbForms()
        for i in 0 ..< vsList.count{
            _ = CriticalFormView(comment: vsList[i].comment,
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
       if verbString == "ir" { return true}
        if verbString == "ver" { return true}
        if verbString == "dar" { return true}
        let result = vu.analyzeSpanishWordPhrase(testString: verbString)
        if result.0.count > 2 {
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
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.red)
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


