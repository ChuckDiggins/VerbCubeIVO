////
////  MultiVerbView.swift
////  VerbCubeIVO
////
////  Created by Charles Diggins on 8/24/22.
////
//
//import SwiftUI
//
////
////  MultiVerbConjugation.swift
////  ContextFree
////
////  Created by Charles Diggins on 6/18/21.
////
//
//import SwiftUI
//import Combine
//import JumpLinguaHelpers
//
//class PopupCellDataArray : ObservableObject {
//    var pcdArray = [PopupCellData(),
//                    PopupCellData(),
//                    PopupCellData(),
//                    PopupCellData(),
//                    PopupCellData(),
//                    PopupCellData(),
//    ]
//    
//    func set(index: Int, pcd: PopupCellData) {
//        pcdArray[index] = pcd
//    }
//    
//    func get(index: Int)->PopupCellData {
//        pcdArray[index]
//    }
//  
//}
//
//struct ThreeVerbConjugation: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    
//    @State private var currentLanguage = LanguageType.Agnostic
//    @State private var verb1List = [Verb]()
//    @State private var verb2List = [Verb]()
//    @State private var verb3List = [Verb]()
//    
//    @ObservedObject var pcda1  = PopupCellDataArray()
//    @ObservedObject var pcda2  = PopupCellDataArray()
//    @ObservedObject var pcda3  = PopupCellDataArray()
//    
//    
//    @State private var pcv1 = [PopupCellView]()
//    @State private var pcv2 = [PopupCellView]()
//    @State private var pcv3 = [PopupCellView]()
//    
//    @State private var verb1 = Verb()
//    @State private var verb2 = Verb()
//    @State private var verb3 = Verb()
//    
//    @State private var verb1Index = 0
//    @State private var verb2Index = 0
//    @State private var verb3Index = 0
//
//    @State private var targetVerbString = ""
//    @State private var targetsubjectString = ""
//    @State private var targetTenseString = ""
//    @State private var targetAnswerString = ""
//    
//    @State var currentTense = Tense.present
//    @State var currentTenseString = ""
//    @State var personString = ["","","","","",""]
//    @State var verb1String = ["","","","","",""]
//    @State var verb2String = ["","","","","",""]
//    @State var verb3String = ["","","","","",""]
//        
//    @State var isLoaded = false
//    @State var columnWidth = CGFloat(100)
//    @State var isBlank = false
//    //@State var bAddNewVerb = false
//    
//    var body: some View {
//        VStack {
//            VStack(alignment: .center){
//                Button(action: {
//                    getNextTense()
//                }){
//                    HStack {
//                        Text("Tense: \(currentTense.rawValue)").background(Color.yellow).foregroundColor(.black).frame(width: 250, height: 80)
//                            .cornerRadius(10).padding(25)
//                        
//                    }
//                }
//            }
//            
//            HStack{
//                Text(" ")
//                    .frame(width: 60, height: 30, alignment: .trailing)
//                Button{
//                    getNextVerb1()
//
//                } label: {
//                    Text("\(verb1.getWordAtLanguage(language: currentLanguage))")
//                        .frame(width: columnWidth, height: 30, alignment: .leading)
//                        .background(Color.white)
//                        .foregroundColor(.black)
//                }
//                
//                Button{
//                    getNextVerb2()
//                } label: {
//                    Text("\(verb2.getWordAtLanguage(language: currentLanguage))")
//                        .frame(width: columnWidth, height: 30, alignment: .leading)
//                        .background(Color.white)
//                        .foregroundColor(.black)
//                }
//                Button{
//                    getNextVerb3()
//                } label: {
//                    Text("\(verb3.getWordAtLanguage(language: currentLanguage))")
//                        .frame(width: columnWidth, height: 30, alignment: .leading)
//                        .background(Color.white)
//                        .foregroundColor(.black)
//                }
//            }
//            
//            if isLoaded {
//                ForEach((0...5), id:\.self) { personIndex in
//                    HStack{
//                        Text(personString[personIndex])
//                            .frame(width: 60, height: 30, alignment: .trailing)
//                        pcv1[personIndex]
//                        pcv2[personIndex]
//                        pcv3[personIndex]
//                    }.font(.system(size: 12))
//                }
//            }
//        }.font(.system(size: 16))
//        
//        
//        .onAppear(){
//            currentLanguage = languageViewModel.getCurrentLanguage()
//            
//            languageViewModel.fillLevel1VerbLists()
//            verb1List = languageViewModel.getLevel1VerbList(index: 0)
//            verb2List = languageViewModel.getLevel1VerbList(index: 1)
//            verb3List = languageViewModel.getLevel1VerbList(index: 2)
//            verb1 = verb1List[0]
//            verb2 = verb2List[0]
//            verb3 = verb3List[0]
//            
//            initializePopupData()
//            currentTenseString = languageViewModel.getCurrentTense().rawValue
//            
//            reloadAll()
//            isLoaded = true
//        }
////
//        Spacer()
//            .frame(height: 20)
//        
//    }
//    
////    func loadQuizCubeCell(verb: Verb, person: Person, wordString: String, blank: Bool )->QuizCubeCellView{
////        let qchc = QuizCubeHandlerClass(languageViewModel: languageViewModel)
////
////        let qcc = QuizCellData(i: 0, j: 0, cellString: wordString, isBlank: blank)
////        let vccv = QuizCubeCellView(
////            vcci: qchc.getQuizCubeCellInfo(verb: verb, tense: languageViewModel.getCurrentTense(), person: person),
////            columnWidth: CGFloat(100),
////            cellData: qcc,  useAlert: blank)
////        return vccv
////    }
//
//    func initializePopupData(){
//        //set the initial popup data
//        for i in 0..<6 {
//            pcda1.set(index: i, pcd: PopupCellData())
//            pcda2.set(index: i, pcd: PopupCellData())
//            pcda3.set(index: i, pcd: PopupCellData())
//        }
//        
//        for i in 0..<6 {
//            var pcv = PopupCellView(popupCellData: pcda1.get(index: i), columnWidth: columnWidth, useAlert: true, isBlank: false)
//            pcv1.append(pcv)
//            pcv2.append(PopupCellView(popupCellData: pcda2.get(index: i), columnWidth: columnWidth, useAlert: true, isBlank: false))
//            pcv3.append(PopupCellView(popupCellData: pcda3.get(index: i), columnWidth: columnWidth, useAlert: true, isBlank: false))
//        }
//    }
//    func getNextTense(){
//        currentTense = languageViewModel.getNextTense()
//        currentTenseString = currentTense.rawValue
//        reloadAll()
//    }
//    
//    func reloadAll(){
//        fillPersons()
//        reloadVerb1()
//        reloadVerb2()
//        reloadVerb3()
//    }
//    
//    func getNextVerb1(){
//        verb1Index += 1
//        if  verb1Index >= verb1List.count {
//            verb1Index = 0
//        }
//        verb1 = verb1List[verb1Index]
//        
//        reloadVerb1()
//    }
//    
//    func getNextVerb2(){
//        verb2Index += 1
//        if  verb2Index >= verb2List.count {
//            verb2Index = 0
//        }
//        verb2 = verb2List[verb2Index]
//        
//        reloadVerb2()
//    }
//    
//    func getNextVerb3(){
//        verb3Index += 1
//        if  verb3Index >= verb3List.count {
//            verb3Index = 0
//        }
//        verb3 = verb3List[verb3Index]
//        reloadVerb3()
//    }
//    
//    
//    func  fillPersons(){
//        for i in 0..<6 {
//            personString[i] = Person.all[i].getSubjectString(language: currentLanguage,
//                                                             subjectPronounType: languageViewModel.getSubjectPronounType(),
//                                                             verbStartsWithVowel: false)
//        }
//    }
//    
//    func  reloadVerb1(){
//        languageViewModel.createAndConjugateAgnosticVerb(verb: verb1, tense: currentTense)
//        var msm = languageViewModel.getMorphStructManager()
//        for i in 0..<6 {
//            
//            isBlank = false
//            if i == 3 { isBlank = true }
//            verb1String[i] = msm.getFinalVerbForm(person: Person.all[i])
//            pcda1.get(index: i).setData(verbString: verb1.getWordAtLanguage(language: currentLanguage), tenseString : currentTenseString, personString : personString[i], correctAnswerString : verb1String[i])
//            let temp = pcda1.get(index: i)
//            pcv1[i].popupCellData = temp
//        }
//    }
//        
//    func  reloadVerb2(){
//        languageViewModel.createAndConjugateAgnosticVerb(verb: verb2, tense: currentTense)
//        var msm = languageViewModel.getMorphStructManager()
//        for i in 0..<6 {
//            isBlank = false
//            if i == 4 { isBlank = true }
//            verb2String[i] = msm.getFinalVerbForm(person: Person.all[i])
//            let pcd = pcda2.get(index: i)
//            pcd.setData(verbString: verb2.getWordAtLanguage(language: currentLanguage), tenseString : currentTenseString, personString : personString[i], correctAnswerString : verb2String[i])
//        }
//    }
//        
//    func  reloadVerb3(){
//        languageViewModel.createAndConjugateAgnosticVerb(verb: verb3, tense: currentTense)
//        var msm = languageViewModel.getMorphStructManager()
//        for i in 0..<6 {
//            isBlank = false
//            if i == 2 { isBlank = true }
//            verb3String[i] = msm.getFinalVerbForm(person: Person.all[i])
//            let pcd = pcda3.get(index: i)
//            pcd.setData(verbString: verb3.getWordAtLanguage(language: currentLanguage), tenseString : currentTenseString, personString : personString[i], correctAnswerString : verb3String[i])
//        }
//    }
//}
