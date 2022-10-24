//
//  PatternLessonView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/13/22.
//

import SwiftUI
import JumpLinguaHelpers

struct showPatternVerbsView: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var studentLevel : StudentLevel
    @State var selection : StudentLevel
    var body: some View {
        HStack{
            NavigationLink{
                CurrentPatternLessonView(languageViewModel: languageViewModel, studentLevel: studentLevel)
            }label: {
                Text(studentLevel.getEnumString())
            }
            .disabled(languageViewModel.getLessonCompletionMode(sl: studentLevel) == .closed ? true : false)
            .frame(minWidth: 200, maxWidth: 450)
            .background(selection == studentLevel ? .yellow : Color("BethanyNavalBackground") )
            .foregroundColor(selection == studentLevel ? .black : Color("BethanyGreenText") )
            Spacer()
            languageViewModel.getLessonCompletionMode(sl: studentLevel).getImage()
        }
    }
}

struct CurrentPatternLessonView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var studentLevel : StudentLevel
    @State var currentLanguage = LanguageType.Agnostic
    @State var lessonObjectiveStrings = ("Part1", "Part 2")
    @State var maxVerbCount = 0
    @State var arVerbList = [Verb]()
    @State var erVerbList = [Verb]()
    @State var irVerbList = [Verb]()
    @State var arPadding = 0
    @State var erPadding = 0
    @State var irPadding = 0
    @State var lessonLevel = 0
    @State private var showingConjugationSheet = false
    var body: some View {
        let gridFixSize = CGFloat(100.0)
        
        let gridItems = [GridItem(.fixed(gridFixSize))]
        
        ScrollView{
            VStack{
                Text("Pattern Lesson Objective").font(.title2)
                Text(lessonObjectiveStrings.0)
                Text(lessonObjectiveStrings.1)
            }
            .padding()
            .border(.red)
            
            if lessonLevel == 4 {
                ListPatternsView(languageViewModel: languageViewModel, function: listVerbsForPatternType)
            }
//            } else if lessonLevel == 5 {
//                ListModels(languageViewModel: languageViewModel, function: listVerbsForModel)
//            }
            
            ScrollView {
                Text("Your Verbs:").font(.title2)
                HStack{
                    LazyVGrid(columns: gridItems, spacing: 5){
                        Text("AR Verbs").font(.title3)
                        ForEach(arVerbList, id: \.self){ verb in
                            LessonWordCellButton(languageViewModel: languageViewModel, verb: verb)
                            
                        }
                        //make invisible
                        ForEach(0 ..< arPadding, id:\.self){ _ in
                            Text(" ")
                        }
                        
                    }
                    LazyVGrid(columns: gridItems, spacing: 5){
                        Text("ER Verbs").font(.title3)
                        ForEach(erVerbList, id: \.self){ verb in
                            LessonWordCellButton(languageViewModel: languageViewModel, verb: verb)
                        }
                        //make invisible
                        ForEach(0 ..< erPadding, id:\.self){ _ in
                            Text(" ")
                        }
                    }
                    LazyVGrid(columns: gridItems, spacing: 5){
                        Text("IR Verbs").font(.title3)
                        ForEach(irVerbList, id: \.self){ verb in
                            LessonWordCellButton(languageViewModel: languageViewModel, verb: verb)
                        }
                        //make invisible
                        ForEach(0 ..< irPadding, id:\.self){ _ in
                            Text(" ")
                        }
                    }
                }
                
            }.padding()
            
            Spacer()
            
        } .navigationTitle("Lesson Overview")
            .border(.red)
            .padding(5)
            .background(Color.black)
            .foregroundColor(.yellow)
            .cornerRadius(8)
            .font(.subheadline)
        
            .onAppear{
                languageViewModel.setStudentLevel(level: studentLevel)
                currentLanguage = languageViewModel.getCurrentLanguage()
                lessonObjectiveStrings =  languageViewModel.getStudentLevel().getLessonObjectives()
                lessonLevel = languageViewModel.getStudentLevel().getLessonLevel()
                listVerbsForPatternType(patternType: languageViewModel.getCurrentPatternList()[0])
                setVerbLists()
            }
            .onDisappear{
                languageViewModel.fillVerbCubeAndQuizCubeLists()
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
            }
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
    }
    
    func setVerbLists(){
        var vamslu =  VerbAndModelSublistUtilities()
        arVerbList = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), ending: .AR,  language: languageViewModel.getCurrentLanguage())
        erVerbList = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), ending: .ER,  language: languageViewModel.getCurrentLanguage())
        irVerbList = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), ending: .IR,  language: languageViewModel.getCurrentLanguage())
        if arVerbList.count > maxVerbCount {maxVerbCount = arVerbList.count }
        if erVerbList.count > maxVerbCount {maxVerbCount = erVerbList.count }
        if irVerbList.count > maxVerbCount {maxVerbCount = irVerbList.count }
        arPadding = maxVerbCount - arVerbList.count
        erPadding = maxVerbCount - erVerbList.count
        irPadding = maxVerbCount - irVerbList.count
    }
    
    func listVerbsForPatternType(patternType: SpecialPatternType){
        let vl = languageViewModel.getVerbsForPatternGroup(patternType: patternType)
        languageViewModel.setCurrentPattern(pattern: patternType)
        let pt = languageViewModel.getCurrentPattern()
        languageViewModel.setFilteredVerbList(verbList: vl)
        setVerbLists()
    }
    
    func listVerbsForModel(modelWord: String){
        let mdl = languageViewModel.getModelAtModelWord(modelWord: modelWord)
        let vl = languageViewModel.findVerbsOfSameModel(targetID: mdl.id)
        languageViewModel.setFilteredVerbList(verbList: vl)
        setVerbLists()
    }
    

}

struct ListPatternsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish

    @State var patternList = [SpecialPatternType]()
    @State private var selectedPattern = SpecialPatternType(rawValue: "")
//    @State private var selectedPatternIndex = 0
    var function: (_ patternType: SpecialPatternType) -> Void
    
    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Pattern List").font(.title2).foregroundColor(Color("ChuckText1"))
                
                ScrollView{
                    let gridFixSize = CGFloat(100.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]
                    
                    LazyVGrid(columns: gridItems, spacing: 5){
                        ForEach (patternList, id:\.self){ pattern in
                            Button{
                                function(pattern)
                            } label: {
                                Text(pattern.rawValue)
                                    .foregroundColor(pattern == languageViewModel.getCurrentPattern() ? .red : Color("BethanyGreenText"))
                            }
                        }
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .foregroundColor(Color("BethanyGreenText"))
                    .cornerRadius(8)
                    .font(fontSize)
                }
                
            }.onAppear{
                loadVerbPatterns()
                currentLanguage = languageViewModel.getCurrentLanguage()
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
            }
        }.foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
    }
    
    func loadVerbPatterns(){
        patternList.removeAll()
        patternList = languageViewModel.getCurrentPatternList()
     
    }
}


