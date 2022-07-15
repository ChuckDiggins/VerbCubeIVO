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
            Color("GeneralColor")
                .ignoresSafeArea()
            VStack{
                Text("Right & Wrong").font(.title2).bold()
                setVerbAndTenseView()
                
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
                        
                        currentVerb = languageViewModel.getCurrentFilteredVerb()
                        currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
                        currentTenseString = currentTense.rawValue
                        setCurrentVerb()
                    }
                }
            }
        }
        
    }
    
    func setVerbAndTenseView() -> some View {
        VStack {
            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                HStack{
                    Text("Verb model:")
                    Text(currentModelString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
            }.task {
                setCurrentVerb()
            }
            
            
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                currentVerb = languageViewModel.getCurrentFilteredVerb()
                setCurrentVerb()
            }){
                HStack{
                    Text("Verb: ")
                    Text(currentVerbString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }.frame(width: 350, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(4)
            }
            
            
            //ChangeTenseButtonView()
            
            Button(action: {
                currentTense = languageViewModel.getLanguageEngine().getNextTense()
                currentTenseString = currentTense.rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }
            .frame(width: 350, height: 30)
            .font(.callout)
            .padding(2)
            .background(Color.orange)
            .foregroundColor(.black)
            .cornerRadius(4)
            
        }
        
        .padding(3)
    }
    
    func setCurrentVerb(){
        setSubjunctiveStuff()
        
        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: languageViewModel.getCurrentTense())
        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
        
        //set the persons here
        var msm = languageViewModel.getMorphStructManager()
        vvm.removeAll()
        vvr.removeAll()
        for i in 0..<6 {
            vvm.append(msm.getFinalVerbForm(person: Person.all[i]))
            vvr.append(languageViewModel.conjugateAsRegularVerb(verb: currentVerb, tense: currentTense, person: Person.all[i]))
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



