//
//  AnalyzeVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/26/22.
//

import SwiftUI
import JumpLinguaHelpers

struct RightWrongVerbView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    
    var residualPhrase: String = ""
    var newVerb : Bool = false
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var currentVerb = Verb()
    @State var currentModelString = ""
    @State var isBackward = false
    @State var stemColor = Color.white
    @State var orthoColor = Color.white
    @State var irregularColor = Color.white
    @State var newVerbPhrase = ""
    @State var subjunctiveWord = "que "
    
    @State var vvm = ["", "", "", "", "", ""]
    @State var vvr = ["", "", "", "", "", ""]
    @State var person = ["yo", "tú", "él", "nosotros", "vosotros", "ellos"]
    var vu = VerbUtilities()
    @State var isSubjunctive = false
    @State private var bValidVerb = true
    @State private var isRight = true
    @State private var verbModelVerb = ""
    var fontSize = Font.footnote
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                Text("Right & Wrong").font(.title2).bold().foregroundColor(.white)
                setVerbAndTenseView()
                
                if ( bValidVerb ){
                    
                    VStack {
                        HStack {
                            Text("Mode:")
                                .frame(width: 100, height: 20, alignment: .trailing)
//                                .background(.white )
//                                .foregroundColor(.black)
                            Text("as Model")
                                .frame(width:100, height:20, alignment: .trailing)
//                                .background(.green )
//                                .foregroundColor(.black)
                            Text("as Regular")
                                .frame(width:100, height:20, alignment: .trailing)
//                                .background(.yellow)
//                                .foregroundColor(.black)
                        }.font(fontSize)
                        Divider().background(Color.orange)
                        ForEach (0..<6){ i in
                            HStack{
                                Text(person[i])
                                    .frame(width: 100, height: 20, alignment: .trailing)
                                    .background(vvm[i] == vvr[i] ? .white : .red  )
                                    .foregroundColor(.black)
//                                    .foregroundColor(vvm[i] == vvr[i] ? .black : .yellow)
                                
                                Text(vvm[i])
                                    .frame(width: 100, height: 20, alignment: .trailing)
//                                    .background(.green )
                                    .foregroundColor(Color("BethanyGreenText"))
                                
                                Text(vvr[i])
                                    .frame(width: 100, height: 20, alignment: .trailing)
//                                    .background(.yellow)
                                    .foregroundColor(Color("BethanyGreenText"))
                            }.font(fontSize)
                        }
                    }
                    .onAppear {
                        
                        currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                        
                        currentVerb = languageViewModel.getCurrentFilteredVerb()
                        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
                        currentTenseString = currentTense.rawValue
                        setCurrentVerb()
                    }
                }
            }
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
        }
        
    }
    
    func setVerbAndTenseView() -> some View {
        VStack {
//            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
//                HStack{
//                    Text("Verb model:")
//                    Text(currentModelString)
//                    Spacer()
//                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
//                }
//                .modifier(ModelTensePersonButtonModifier())
//            }.task {
//                setCurrentVerb()
//            }
//            
            
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                currentVerb = languageViewModel.getCurrentFilteredVerb()
                setCurrentVerb()
            }){
                HStack{
                    Text("Verb: ")
                    Text(currentVerbString)
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                }.modifier(ModelTensePersonButtonModifier())
            }
            
            
            //ChangeTenseButtonView()
            
            Button(action: {
                currentTense = languageViewModel.getLanguageEngine().getNextTense()
                currentTenseString = currentTense.rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
            }
            .modifier(ModelTensePersonButtonModifier())
            
        }
        
        .padding(3)
    }
    
    func setCurrentVerb(){
        setSubjunctiveStuff()
        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        var isReflexive = false
        var residPhrase = ""
        switch currentLanguage {
        case .Spanish:
            let result = VerbUtilities().analyzeSpanishWordPhrase(testString: currentVerbString)
            isReflexive = result.isReflexive
            residPhrase = result.residualPhrase
        case .French:
            let result = VerbUtilities().analyzeFrenchWordPhrase(phraseString: currentVerbString)
            isReflexive = result.isReflexive
            residPhrase = result.residualPhrase
        default:
            break
        }
        
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
        print("currentModelString = \(currentModelString)")
        print("currentVerbString = \(currentVerbString)")
        print("isReflexive = \(isReflexive)")

        //set the persons here
        var msm = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        vvr.removeAll()
        for i in 0..<6 {
            vvm.append(msm.getFinalVerbForm(person: Person.all[i]))
            vvr.append(languageViewModel.conjugateAsRegularVerb(verb: currentVerb, tense: currentTense, person: Person.all[i], isReflexive: isReflexive, residPhrase: residPhrase))
            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType(), verbStartsWithVowel: vu.startsWithVowelSound(characterArray: vvm[i]))
        }
    }
    
    func setSubjunctiveStuff(){
        subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "que "}
        }
    }
    
}



