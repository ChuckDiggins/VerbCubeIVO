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
    let conjugatedVerbForm : String
}

struct UnconjugateView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var verbFormToUnconjugate = ""
    @State var vtpList = [VTP]()
    @State var unconjugateMessage = ""
    @State var unconjugateMessage2 = ""
    @State var fontSize : CGFloat = 12
    @State var isAnalyzed : Bool = false
    @State var isSpecialTense : Bool = false
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                Text("Unconjugate").font(.title2).foregroundColor(Color("ChuckText1"))
                
                let gridFixSize = CGFloat(50.0)
                let gridItems = [GridItem(.fixed(gridFixSize*2)),
                                 GridItem(.fixed(gridFixSize)),
                                 GridItem(.fixed(gridFixSize)),
                                 GridItem(.fixed(gridFixSize))]
                let gridItemsSpecial  = [GridItem(.fixed(gridFixSize*2)),
                                         GridItem(.fixed(gridFixSize*2)),
                                         GridItem(.fixed(gridFixSize*2))]
                VStack{
                    Text("Find matching verbs")
                    if vtpList.count == 0 {
                        HStack{
                            Text("Enter conjugated form, such as:")
                            Text("estaba").foregroundColor(.red)
                        }
                    }
                    
                }.padding(10)
                HStack{
                    Button {
                        if verbFormToUnconjugate.count > 1 {
                            vtpList = unConjugate(verbForm: verbFormToUnconjugate)
                            hideKeyboard()
                        }
                    } label: {
                        Text("Find verbs")
                            .frame(width: 100, height: 50)
                            .padding(.leading, 10)
                            .background((Color("BethanyPurpleButtons")))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    TextField("Verb form", text: $verbFormToUnconjugate, onEditingChanged: {changed in
                        isAnalyzed = false})
                    .frame(width: 150, height: 15)
                    .onSubmit(){
                        if verbFormToUnconjugate.count > 1 {
                            vtpList = unConjugate(verbForm: verbFormToUnconjugate)
                            hideKeyboard()
                        }
                    }
                    .onChange(of: verbFormToUnconjugate){ _ in
                        vtpList = [VTP]()
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
                            .font(.title2)
                    })
                }
                
                
//                if isAnalyzed {
                    VStack{
                        if ( unconjugateMessage.count > 0 ){
                            HStack{
                                Text(unconjugateMessage)
                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
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
//                        if ( unconjugateMessage2.count > 0 ){
//                            HStack{
//                                Text(unconjugateMessage2)
//                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
//                                    .cornerRadius(8)
//                                    .font(.system(size: fontSize))
//                                    .background(Color.black)
//                                    .foregroundColor(.yellow)
//                            }
//                        }
                        Text("Target word: \(verbFormToUnconjugate)")
                            .font(.headline)
                        
                        if isSpecialTense {
                            LazyVGrid(columns: gridItemsSpecial, spacing: 5){
                                WordCell(wordText: "Word", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                                WordCell(wordText: "Verb", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                                WordCell(wordText: "Tense", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                            }.foregroundColor(.black)
                        } else {
                            LazyVGrid(columns: gridItems, spacing: 5){
                                WordCell(wordText: "Phrase", backgroundColor: .black, foregroundColor: .orange, fontSize: .system(size: fontSize) )
                                WordCell(wordText: "Verb", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                                WordCell(wordText: "Tense", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                                WordCell(wordText: "Person", backgroundColor: .black, foregroundColor: .yellow, fontSize: .system(size: fontSize) )
                            }.foregroundColor(.black)
                        }
                            
                       
                        
                        if vtpList.count > 0 {
                            Text(getMessage2(vtpList[0]))
                                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                                .cornerRadius(8)
//                                .font(.system(size: fontSize))
                                .background(Color.black)
                                .foregroundColor(.yellow)
                            if isSpecialTense {
                                LazyVGrid(columns: gridItemsSpecial, spacing: 5){
                                    ForEach (0..<vtpList.count, id:\.self ){ i in
                                        if vtpList[i].conjugatedVerbForm.count > 0 {
                                            WordCell(wordText: vtpList[i].conjugatedVerbForm, backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize))
                                        } else {
                                            WordCell(wordText: verbFormToUnconjugate, backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize))
                                        }
                                        WordCell(wordText: vtpList[i].verb.getWordStringAtLanguage(language:languageViewModel.currentLanguage), backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize))
                                        WordCell(wordText: vtpList[i].tense.rawValue, backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize))
                                    }
                                }
                            } else {
                                LazyVGrid(columns: gridItems, spacing: 5){
                                    ForEach (0..<vtpList.count, id:\.self ){ i in
                                        WordCell(wordText: getSubjectString(vtp: vtpList[i]), backgroundColor: .orange, foregroundColor: .black, fontSize: .system(size: fontSize) )
                                        WordCell(wordText: vtpList[i].verb.getWordStringAtLanguage(language:languageViewModel.currentLanguage), backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize))
                                        WordCell(wordText: vtpList[i].tense.rawValue, backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize*0.7))
                                        WordCell(wordText: vtpList[i].person.getSubjectString(language: languageViewModel.currentLanguage, subjectPronounType: languageViewModel.getSubjectPronounType()),  backgroundColor: .yellow, foregroundColor: .black, fontSize: .system(size: fontSize*0.7))
                                    }
                                    
//                                    Button{
//                                        textToSpeech(text : "\(vtpList[i])", language: languageViewModel.currentLanguage)
//                                    } label: {
//                                        Image(systemSymbol: .speakerWave1Fill).foregroundColor(.red).padding()
//                                    }
                                }
                            }
                        }
                        
                    }
                }.foregroundColor(Color("BethanyGreenText"))
                .onAppear {
                    verbFormToUnconjugate = "estaba"
                }
                Spacer()
                
                //                }
                
//            }
            
            
        }
        .accentColor(.black)
       
        
    }
    
    func isSpecialTense(_ tense: Tense)->Bool{
        if tense == .infinitive || tense == .pastParticiple || tense == .gerund {
            return true
        }
        return false
    }
    
    func getMessage2(_ vtp: VTP)->String{
        if vtp.conjugatedVerbForm.count > 0 {
//            unconjugateMessage2 = "Did you mean \(vtp.conjugatedVerbForm)?)"
            return "Did you mean \(vtp.conjugatedVerbForm)?"
        }
        return ""
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
//        if vtp.conjugatedVerbForm.count > 0 {
//            return str0 + subj + reflexivePronoun + vtp.conjugatedVerbForm
//        }
//        return str0 + subj + reflexivePronoun + verbFormToUnconjugate
        
        if vtp.conjugatedVerbForm.count > 0 {
            return str0 + subj + vtp.conjugatedVerbForm
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
            isSpecialTense = isSpecialTense(list[0].tense)
        }
        return list
    }
}

