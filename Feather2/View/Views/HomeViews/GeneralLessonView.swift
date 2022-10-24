//
//  GeneralLessonView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/13/22.
//

import SwiftUI
import JumpLinguaHelpers


struct showGeneralVerbsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var studentLevel : StudentLevel
    @State var selection : StudentLevel
    var body: some View {
        HStack{
            NavigationLink{
                CurrentGeneralLessonView(languageViewModel: languageViewModel, studentLevel: studentLevel)
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

struct CurrentGeneralLessonView: View {
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
                Text("Lesson Objective").font(.title2)
                Text(lessonObjectiveStrings.0)
                Text(lessonObjectiveStrings.1)
            }
            .padding()
            .border(.red)
            
            ShowTenses(languageViewModel: languageViewModel)
            
            if lessonLevel == 4 {
                ListPatternsView(languageViewModel: languageViewModel, function: listVerbsForPatternType)
            } else if lessonLevel == 5 {
                ListModels(languageViewModel: languageViewModel, studentLevel: studentLevel, function: listVerbsForModel)
            }
            
            VStack{
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
                setVerbLists()
            } .onDisappear{
                languageViewModel.fillVerbCubeAndQuizCubeLists()
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
                
                //fillFlashCardsForProblemsOfRandomPerson()
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
        var vl = languageViewModel.getVerbsForPatternGroup(patternType: patternType)
        languageViewModel.setFilteredVerbList(verbList: vl)
        setVerbLists()
    }
    
    func listVerbsForModel(modelWord: String){
        let mdl = languageViewModel.getModelAtModelWord(modelWord: modelWord)
        let vl = languageViewModel.findVerbsOfSameModel(targetID: mdl.id)
        languageViewModel.setFilteredVerbList(verbList: vl)
        setVerbLists()
    }
    
    struct ShowTenses: View {
        @ObservedObject var languageViewModel: LanguageViewModel
        var body: some View {
            VStack{
                if languageViewModel.getTenseList().count == 1 {
                    VStack{
                        Text("Your tense:").font(.title2)
                        Text("\(languageViewModel.getTenseList()[0].rawValue)")
                    }
                }
                else {
                    VStack{
                        Text("Your tenses:").font(.title2)
                        HStack{
                            ForEach(languageViewModel.getTenseList(), id: \.self){ tense in
                                Text(tense.rawValue)
                            }
                        }
                    }
                }
            }.padding()
        }
    }
    
    
}
