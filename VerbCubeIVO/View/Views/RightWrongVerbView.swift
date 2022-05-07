//
//  AnalyzeVerbView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/26/22.
//

import SwiftUI
import JumpLinguaHelpers
import SFSafeSymbols

struct RightWrongVerbView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    
    @State var verb = Verb()
    var residualPhrase: String = ""
    var newVerb : Bool = false
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var currentVerbString = ""
    @State var isBackward = false
    @State var stemColor = Color.white
    @State var orthoColor = Color.white
    @State var irregularColor = Color.white
    @State var currentVerbPhrase = ""
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
        
        VStack{
            HStack{
                Text("Verb model:")
                    .foregroundColor(.blue)
                Text(verbModelVerb)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .padding(2)
                    .cornerRadius(4)
            }
            

            //show relevant tenses
            HStack{
                Spacer()
                Button(action: {
                    languageViewModel.setNextVerb()
                    verb = languageViewModel.getCurrentVerb()
                    setCurrentVerb()
                }){
                    Text(currentVerbPhrase)
                        .background(Color.yellow)
                }
                Spacer()
                Button(action: {
                    currentTense = languageViewModel.getLanguageEngine().getNextTense()
                    currentTenseString = currentTense.rawValue
                    setCurrentVerb()
                }){
                    Text(currentTenseString)
                        .background(Color.yellow)
                }
                Spacer()
            }.background(Color.yellow)
            
            if ( bValidVerb ){
                
                VStack {
                    HStack {
                        Text("Mode:")
                            .frame(width: 100, height: 20, alignment: .trailing)
                            .background(.white )
                            .foregroundColor(.black)
                        Text("as Model")
                            .frame(width:100, height:20, alignment: .trailing)
                            .background(.green )
                            .foregroundColor(.black)
                        Text("as Regular")
                            .frame(width:100, height:20, alignment: .trailing)
                            .background(.yellow)
                            .foregroundColor(.black)
                    }.font(fontSize)
                    Divider().background(Color.orange)
                    ForEach (0..<6){ i in
                        HStack{
                            Text(person[i])
                                .frame(width: 100, height: 20, alignment: .trailing)
                                .background(vvm[i] == vvr[i] ? .white : .red  )
                                .foregroundColor(vvm[i] == vvr[i] ? .black : .yellow)
                            
                            Text(vvm[i])
                                .frame(width: 100, height: 20, alignment: .trailing)
                                .background(.green )
                                .foregroundColor(.black)
                            
                            Text(vvr[i])
                                .frame(width: 100, height: 20, alignment: .trailing)
                                .background(.yellow)
                                .foregroundColor(.black)
                        }.font(fontSize)
                    }
                }
                .onAppear {
                    currentLanguage = languageViewModel.getLanguageEngine().getCurrentLanguage()
                    verb = languageViewModel.getCurrentVerb()
                    setCurrentVerb()
                }
            }
        }
        
    }
    
    func setCurrentVerb(){
        setSubjunctiveStuff()
        currentVerbPhrase = verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: verb, tense: languageViewModel.getCurrentTense())
        verbModelVerb = languageViewModel.getRomanceVerb(verb: verb).getBescherelleInfo()
        //set the persons here
        var msm = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        vvr.removeAll()
        for i in 0..<6 {
            vvm.append(msm.getFinalVerbForm(person: Person.all[i]))
            vvr.append(languageViewModel.conjugateAsRegularVerb(verb: verb, tense: currentTense, person: Person.all[i]))
            person[i] = subjunctiveWord + Person.all[i].getSubjectString(language: languageViewModel.getCurrentLanguage(), gender: .masculine, verbStartsWithVowel: vu.startsWithVowelSound(characterArray: vvm[i]))
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



