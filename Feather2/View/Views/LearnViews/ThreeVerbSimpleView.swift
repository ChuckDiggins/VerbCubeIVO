//
//  ThreeVerbSimpleView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/6/22.
//

import SwiftUI
import JumpLinguaHelpers

struct ThreeVerbSimpleView: View {
    
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    
    @State private var currentLanguage = LanguageType.Agnostic
    @State private var verb1List = [Verb]()
    @State private var verb2List = [Verb]()
    @State private var verb3List = [Verb]()
    
    @State private var verb1 = Verb()
    @State private var verb2 = Verb()
    @State private var verb3 = Verb()
    
    @State private var verb1Index = 0
    @State private var verb2Index = 0
    @State private var verb3Index = 0
    
    @State var currentTense = Tense.present
    @State var currentTenseString = ""
    @State var personString = ["","","","","",""]
    @State var verb1String = ["","","","","",""]
    @State var verb2String = ["","","","","",""]
    @State var verb3String = ["","","","","",""]
    
    @State var isLoaded = false
    @State var columnWidth = CGFloat(160)
    @State var subjectWidth = CGFloat(100)
    
    @State var verb1Changed = false
    @State var verb2Changed = false
    @State var verb3Changed = false
    
    @State var showingAlert = false
    
    var body: some View {
        ZStack{
            ExitButtonView()
            VStack{
                Button(action: {
                    currentTense = languageViewModel.getNextTense()
                    currentTenseString = currentTense.rawValue
                    reloadAll()
                }){
                    HStack{
                        Text("Tense: \(currentTenseString)")
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                    }
                    .modifier(ModelTensePersonButtonModifier())
                    
                }.buttonStyle(ThemeAnimationStyle())
                
                HStack{
                    Text(" ")
                        .frame(width: subjectWidth, height: 30, alignment: .trailing)
                    Button{
                        getNextVerb1()
                    } label: {
                        HStack{
                            if (verb1List.count > 0 ) {
                                Text("\(verb1.getWordAtLanguage(language: currentLanguage))")
                                Spacer()
                                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                            } else {
                                Text("No AR Verbs")
                            }
                        }.frame(width: columnWidth, height: 30, alignment: .leading)
                            .padding(.horizontal, 3)
                    }
                    .padding(2)
                    .border(.red)
                    Button{
                        getNextVerb2()
                    } label: {
                        HStack{
                            if (verb2List.count > 0 ) {
                                Text("\(verb2.getWordAtLanguage(language: currentLanguage))")
                                Spacer()
                                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                            } else {
                                Text("No ER Verbs")
                            }
                        }.frame(width: columnWidth, height: 30, alignment: .leading)
                        .padding(.horizontal, 3)
                    }
                    .padding(2)
                    .border(.red)
                    Button{
                        getNextVerb3()
                    } label: {
                        HStack{
                            if (verb3List.count > 0 ) {
                                Text("\(verb3.getWordAtLanguage(language: currentLanguage))")
                                Spacer()
                                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                            } else {
                                Text("No IR Verbs")
                            }
                        }.frame(width: columnWidth, height: 30, alignment: .leading)
                            .padding(.horizontal, 3)
                    }.border(.red)
                }
                
                if isLoaded {
                    ForEach((0...5), id:\.self) { index in
                        HStack{
                            Text(personString[index])
                                .frame(width: subjectWidth, height: 30, alignment: .trailing)
                            Button{
                                
                            } label: {
                                if (verb1List.count > 0 ) {
                                    Text(verb1String[index])
                                } else {
                                    Text("")
                                }
                                    
                            }.frame(width: columnWidth, height: 30, alignment: .center)
                                .animation(.linear(duration: 1), value: verb1Changed)
                            
                            Button{
                                
                            } label: {
                                if (verb2List.count > 0 ) {
                                    Text(verb2String[index])
                                } else {
                                    Text("")
                                }
                            }.frame(width: columnWidth, height: 30, alignment: .center)
                                .animation(.linear(duration: 1), value: verb2Changed)
                            Button{
                                
                            } label: {
                                if (verb3List.count > 0 ) {
                                    Text(verb3String[index])
                                } else {
                                    Text("")
                                }
                            }.frame(width: columnWidth, height: 30, alignment: .center)
                                .animation(.linear(duration: 1), value: verb3Changed)
                            
                        }.font(.system(size: 20))
                    }
                }
            }
            
            .onAppear(){
                currentTense = languageViewModel.getCurrentTense()
                currentTenseString = currentTense.rawValue
                currentLanguage = languageViewModel.getCurrentLanguage()
                let vamslu =  VerbAndModelSublistUtilities()
                verb1List = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), inputEnding: .AR,  language: languageViewModel.getCurrentLanguage())
                verb2List = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), inputEnding: .ER,  language: languageViewModel.getCurrentLanguage())
                verb3List = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), inputEnding: .IR,  language: languageViewModel.getCurrentLanguage())
                if verb1List.count == 0 || verb2List.count == 0 || verb3List.count == 0 {
                    showingAlert.toggle()
                }
                if verb1List.count > 0 { verb1 = verb1List[0] }
                if verb2List.count > 0 { verb2 = verb2List[0] }
                if verb3List.count > 0 { verb3 = verb3List[0] }
    
                reloadAll()
                isLoaded = true
                
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                        UINavigationController.attemptRotationToDeviceOrientation()
                
//                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
//                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//                UINavigationController.attemptRotationToDeviceOrientation()
            }
            .onDisappear{
                AppDelegate.orientationLock = UIInterfaceOrientationMask.all
            }
            .alert("This exercise works best with at least one AR, ER and IR verb.", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {
//                            router.reset()
//                            dismiss()
                        }
                    }
            
        }.foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
    }
    

    func getNextVerb1(){
        verb1Index += 1
        if  verb1Index >= verb1List.count {
            verb1Index = 0
        }
        verb1 = verb1List[verb1Index]
        reloadVerb1()
    }
    

    func getNextVerb2(){
        verb2Index += 1
        if  verb2Index >= verb2List.count {
            verb2Index = 0
        }
        verb2 = verb2List[verb2Index]
        reloadVerb2()
    }
    
    func getNextVerb3(){
        verb3Index += 1
        if  verb3Index >= verb3List.count {
            verb3Index = 0
        }
        verb3 = verb3List[verb3Index]
        reloadVerb3()
    }
    
    
    func  fillPersons(){
        for i in 0..<6 {
            personString[i] = Person.all[i].getSubjectString(language: currentLanguage,
                                                             subjectPronounType: languageViewModel.getSubjectPronounType(),
                                                             verbStartsWithVowel: false)
        }
    }
    
    func reloadAll(){
        fillPersons()
        if verb1List.count > 0 {reloadVerb1() }
        if verb2List.count > 0 {reloadVerb2() }
        if verb3List.count > 0 {reloadVerb3() }
    }
    
    func  reloadVerb1(){
        if verb1List.count > 0 {
            languageViewModel.createAndConjugateAgnosticVerb(verb: verb1, tense: currentTense)
            var msm = languageViewModel.getMorphStructManager()
            for i in 0..<6 {
                verb1String[i] = msm.getFinalVerbForm(person: Person.all[i])
            }
            verb1Changed.toggle()
        }
    }
    
    func  reloadVerb2(){
        if verb2List.count > 0 {
            languageViewModel.createAndConjugateAgnosticVerb(verb: verb2, tense: currentTense)
            var msm = languageViewModel.getMorphStructManager()
            for i in 0..<6 {
                verb2String[i] = msm.getFinalVerbForm(person: Person.all[i])
            }
            verb2Changed.toggle()
        }
    }
    
    func  reloadVerb3(){
        if verb3List.count > 0 {
            languageViewModel.createAndConjugateAgnosticVerb(verb: verb3, tense: currentTense)
            var msm = languageViewModel.getMorphStructManager()
            for i in 0..<6 {
                verb3String[i] = msm.getFinalVerbForm(person: Person.all[i])
            }
            verb3Changed.toggle()
        }
    }
    
}

//struct ThreeVerbSimpleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThreeVerbSimpleView()
//    }
//}
