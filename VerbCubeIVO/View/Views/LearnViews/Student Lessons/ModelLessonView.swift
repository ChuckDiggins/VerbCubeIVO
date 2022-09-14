//
//  ModelLessonView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/13/22.
//

import SwiftUI
import JumpLinguaHelpers

struct showModelVerbsView: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var studentLevel : StudentLevel
    @State var selection : StudentLevel
    var body: some View {
        HStack{
            NavigationLink{
                CurrentModelLessonView(languageViewModel: languageViewModel, studentLevel: studentLevel)
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

struct CurrentModelLessonView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var studentLevel : StudentLevel
    @State var currentLanguage = LanguageType.Agnostic
    @State var lessonObjectiveStrings = ("Part1", "Part 2")
    @State var maxVerbCount = 0
    @State var modelVerbList = [Verb]()
    @State var lessonLevel = 0
    @State private var showingConjugationSheet = false
    var body: some View {
        let gridFixSize = CGFloat(100.0)
        
        let gridItems = [GridItem(.fixed(gridFixSize)),
                         GridItem(.fixed(gridFixSize)),
                         GridItem(.fixed(gridFixSize))]
        
        VStack{
            VStack{
                Text("Model Lesson Objective").font(.title2)
                Text(lessonObjectiveStrings.0)
                Text(lessonObjectiveStrings.1)
            }
            .padding(horizontal: 10, vertical: 5)
            .border(.red)
            
            ListModels(languageViewModel: languageViewModel, function: listVerbsForModel)
            
            ScrollView{
                Text("Your Verbs:").font(.title2)
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach(modelVerbList, id: \.self){ verb in
                        LessonWordCellButton(languageViewModel: languageViewModel, verb: verb)
                    }
                    
                }
            }
            
        }.padding(horizontal: 0, vertical: 5)
            .navigationTitle("Lesson Overview")
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
                listVerbsForModel(modelWord: languageViewModel.getCurrentModelListAll()[0].modelVerb)
            }
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
    }
    
    func listVerbsForModel(modelWord: String){
        let mdl = languageViewModel.getModelAtModelWord(modelWord: modelWord)
        let vl = languageViewModel.findVerbsOfSameModel(targetID: mdl.id)
        languageViewModel.setFilteredVerbList(verbList: vl)
        modelVerbList = languageViewModel.getFilteredVerbs()
    }
    
    //    struct ShowTenses: View {
    //        @ObservedObject var languageViewModel: LanguageViewModel
    //        var body: some View {
    //            VStack{
    //                if languageViewModel.getTenseList().count == 1 {
    //                    VStack{
    //                        Text("Your tense:").font(.title2)
    //                        Text("\(languageViewModel.getTenseList()[0].rawValue)")
    //                    }
    //                }
    //                else {
    //                    VStack{
    //                        Text("Your tenses:").font(.title2)
    //                        HStack{
    //                            ForEach(languageViewModel.getTenseList(), id: \.self){ tense in
    //                                Text(tense.rawValue)
    //                            }
    //                        }
    //                    }
    //                }
    //            }.padding(horizontal: 5, vertical: 5)
    //        }
    //    }
    //}
}

struct ListModels: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    @State var currentVerbEnding = VerbEnding.AR
    @State var endingList = [VerbEnding.AR, .ER, .IR]

    var function: (_ modelWord: String) -> Void
    
    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    Text("Model Endings")
                    Picker("", selection: $currentVerbEnding){
                        ForEach(endingList, id:\.self){ending in
                            Text("\(ending.rawValue)")
                        }
                    }.pickerStyle(.segmented)
                }
                .padding()
                Text("Model List").font(.title2).foregroundColor(Color("ChuckText1"))
                
                ScrollView{
                    let gridFixSize = CGFloat(100.0)
                    let gridItems = [GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize)),
                                     GridItem(.fixed(gridFixSize))]
                    
                    LazyVGrid(columns: gridItems, spacing: 5){
                        ForEach (0..<languageViewModel.getCurrentModelList(ending: currentVerbEnding).count, id: \.self){ i in
                            Button{
                                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb)
                            } label: {
                                Text(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb)
                            }
                        }
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .foregroundColor(Color("BethanyGreenText"))
                    .cornerRadius(8)
                    .font(fontSize)
                }
                
            }.onAppear{
                currentLanguage = languageViewModel.getCurrentLanguage()
                currentVerbEnding = .AR
            }
        }

    }
    
//    func getCurrentModels()->[RomanceVerbModel]{
////        var currentModels = languageViewModel.getCurrentModelList(ending: currentVerbEnding)
////        for cm in currentModels {
////            print("Current model = \(cm.modelVerb)")
////        }
////
////
//        return languageViewModel.getCurrentModelList(ending: currentVerbEnding)
//    }
}

