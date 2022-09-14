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
    
    var body: some View {
        ZStack{
            
            VStack{
                Button(action: {
                    currentTenseString = languageViewModel.getNextTense().rawValue
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
                        Text("\(verb1.getWordAtLanguage(language: currentLanguage))")
                            .frame(width: columnWidth, height: 30, alignment: .leading)
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                    
                    Button{
                        getNextVerb2()
                    } label: {
                        Text("\(verb2.getWordAtLanguage(language: currentLanguage))")
                            .frame(width: columnWidth, height: 30, alignment: .leading)
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                    Button{
                        getNextVerb3()
                    } label: {
                        Text("\(verb3.getWordAtLanguage(language: currentLanguage))")
                            .frame(width: columnWidth, height: 30, alignment: .leading)
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                }
                
                if isLoaded {
                    ForEach((0...5), id:\.self) { index in
                        HStack{
                            Text(personString[index])
                                .frame(width: subjectWidth, height: 30, alignment: .trailing)
                            
                            Button{
                                
                            } label: {
                                Text(verb1String[index])
                            }.frame(width: columnWidth, height: 30, alignment: .center)
                            
                            Button{
                                
                            } label: {
                                Text(verb2String[index])
                            }.frame(width: columnWidth, height: 30, alignment: .center)
                            Button{
                                
                            } label: {
                                Text(verb3String[index])
                            }.frame(width: columnWidth, height: 30, alignment: .center)
                            
                        }.font(.system(size: 20))
                    }
                }
            }
            .onAppear(){
                
                
                currentLanguage = languageViewModel.getCurrentLanguage()
                
                verb1List = languageViewModel.getSublistFilteredByVerbEnding(ending: .AR)
                verb2List = languageViewModel.getSublistFilteredByVerbEnding(ending: .ER)
                verb3List = languageViewModel.getSublistFilteredByVerbEnding(ending: .IR)
                verb1 = verb1List[0]
                verb2 = verb2List[0]
                verb3 = verb3List[0]
                
                currentTenseString = languageViewModel.getCurrentTense().rawValue
                
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
        reloadVerb1()
        reloadVerb2()
        reloadVerb3()
    }
    
    func  reloadVerb1(){
        languageViewModel.createAndConjugateAgnosticVerb(verb: verb1, tense: currentTense)
        var msm = languageViewModel.getMorphStructManager()
        for i in 0..<6 {
            verb1String[i] = msm.getFinalVerbForm(person: Person.all[i])
        }
    }
    
    func  reloadVerb2(){
        languageViewModel.createAndConjugateAgnosticVerb(verb: verb2, tense: currentTense)
        var msm = languageViewModel.getMorphStructManager()
        for i in 0..<6 {
            verb2String[i] = msm.getFinalVerbForm(person: Person.all[i])
        }
    }
    
    func  reloadVerb3(){
        languageViewModel.createAndConjugateAgnosticVerb(verb: verb3, tense: currentTense)
        var msm = languageViewModel.getMorphStructManager()
        for i in 0..<6 {
            verb3String[i] = msm.getFinalVerbForm(person: Person.all[i])
        }
    }
    
}

//struct ThreeVerbSimpleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThreeVerbSimpleView()
//    }
//}
