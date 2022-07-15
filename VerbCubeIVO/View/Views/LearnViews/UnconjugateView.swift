//
//  UnconjugateView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/10/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VTP {
    let verb : Verb
    let tense : Tense
    let person : Person
}

struct UnconjugateView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var verbFormToUnconjugate = ""
    @State var vtpList = [VTP]()
    @State var unconjugateMessage = ""
    @State var fontSize : CGFloat = 12
    @State var isAnalyzed : Bool = false
    
    var body: some View {
        ZStack{
            Color("GeneralColor")
                .ignoresSafeArea()
            
            VStack{
                let gridFixSize = CGFloat(50.0)
                let gridItems = [GridItem(.fixed(gridFixSize*2)),
                                 GridItem(.fixed(gridFixSize)),
                                 GridItem(.fixed(gridFixSize)),
                                 GridItem(.fixed(gridFixSize))]
                HStack{
                    Text("Find verbs for:").padding(10)
                    TextField("Verb form", text: $verbFormToUnconjugate, onEditingChanged: {changed in
                        isAnalyzed = false})
                    .frame(width: 150, height: 15)
                    .onSubmit(){
                        if verbFormToUnconjugate.count > 1 {
                            vtpList = unConjugate(verbForm: verbFormToUnconjugate)
                            hideKeyboard()
                        }
                    }
                    //                    .onChange(){
                    //                        isAnalyzed = false
                    //                    }
                    .padding()
                    .background(Color.gray.opacity(0.5).cornerRadius(10))
                    .foregroundColor(.black)
                    .font(.headline)
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    Button(action: {
                        verbFormToUnconjugate = ""
                        isAnalyzed = false
                    },
                           label: {  Text("X")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    })
                }
                Button {
                    if verbFormToUnconjugate.count > 1 {
                        vtpList = unConjugate(verbForm: verbFormToUnconjugate)
                        hideKeyboard()
                    }
                } label: {
                    Text("Find verbs")
                        .frame(width: 200, height: 50)
                        .padding(.leading, 10)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
//                if isAnalyzed {
                    VStack{
                        if ( unconjugateMessage.count > 0 ){
                            HStack{
                                Text(unconjugateMessage)
                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                                    .background(Color.blue)
                                    .foregroundColor(.yellow)
                                    .cornerRadius(8)
                                    .font(.system(size: fontSize))
                                Text(verbFormToUnconjugate)
                                    .frame(minWidth: 50, maxWidth: 100, minHeight: 30)
                                    .background(Color.black)
                                    .foregroundColor(.yellow)
                                    .cornerRadius(8)
                                    .font(.system(size: fontSize * 1.2))
                            }
                        }
                        Text("Target word: \(verbFormToUnconjugate)")
                            .font(.headline)
                        
                        LazyVGrid(columns: gridItems, spacing: 5){
                            WordCell(wordText: "Phrase", backgroundColor: .black, foregroundColor: .orange, fontSize: .system(size: fontSize) )
                            WordCell(wordText: "Verb", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                            WordCell(wordText: "Tense", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                            WordCell(wordText: "Person", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                        }.foregroundColor(.black)
                        
                        if vtpList.count > 0 {
                            LazyVGrid(columns: gridItems, spacing: 5){
                                ForEach (0..<vtpList.count, id:\.self ){ i in
                                    WordCell(wordText: getSubjectString(vtp: vtpList[i]), backgroundColor: .orange, foregroundColor: .black, fontSize: .system(size: fontSize) )
                                    WordCell(wordText: vtpList[i].verb.getWordStringAtLanguage(language:languageViewModel.currentLanguage), backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize))
                                    WordCell(wordText: vtpList[i].tense.rawValue, backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize*0.7))
                                    WordCell(wordText: vtpList[i].person.getSubjectString(language: languageViewModel.currentLanguage, subjectPronounType: languageViewModel.getSubjectPronounType()),  backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize*0.7))
                                }
                            }
                        }
                        
                    }
                }
                Spacer()
                
                //                }
                
//            }
            
            
        }
        .accentColor(.black)
        .navigationTitle("Unconjugate!")
        
    }
    
    func getSubjectString(vtp: VTP)->String{
        var str0 = ""
        var reflexivePronoun = ""
        
        var subj = vtp.person.getSubjectString(language: languageViewModel.currentLanguage, subjectPronounType: languageViewModel.getSubjectPronounType()) + " "
        if vtp.tense == .imperative && vtp.person == .S3 {
            subj = "Usted "
        }
        
        if languageViewModel.isVerbType(verb: vtp.verb, verbType: .REFLEXIVE){
            reflexivePronoun = Pronoun().getReflexive(language: languageViewModel.currentLanguage, person: vtp.person, startsWithVowelSound: false)
            reflexivePronoun += " "
        }
        if vtp.tense == Tense.presentSubjunctive || vtp.tense == Tense.imperfectSubjunctiveRA || vtp.tense == Tense.imperfectSubjunctiveSE  {
            switch languageViewModel.currentLanguage{
            case .Spanish:
                str0 = "que "
            case .French:
                str0 = "qui "
            case .English:
                str0 = "that "
            default:
                str0 = ""
            }
        }
        return str0 + subj + reflexivePronoun + verbFormToUnconjugate
    }
    
    func unConjugate(verbForm: String)->[VTP]{
        let newVerbForm = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: verbForm)
        let list = languageViewModel.unConjugate(verbForm: newVerbForm)
        if list.isEmpty {
            unconjugateMessage = "No matches were found in the dictionary for: "
        }
        else {
            if list.count == 1 { unconjugateMessage = "1 match was found in the dictionary for: " }
            else {  unconjugateMessage = "\(list.count) matches were found in the dictionary for: " }
            isAnalyzed = true
        }
        return list
    }
}

