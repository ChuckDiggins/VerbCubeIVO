////
////  ModelLessonView.swift
////  VerbCubeIVO
////
////  Created by Charles Diggins on 9/13/22.
////
//
//import SwiftUI
//import JumpLinguaHelpers
//
//struct showModelVerbsView: View{
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @State var studentLevel : StudentLevel
//    @State var selection : StudentLevel
//    var body: some View {
//        HStack{
//            NavigationLink{
//                CurrentModelLessonView(languageViewModel: languageViewModel, studentLevel: studentLevel)
//            }label: {
//                Text(studentLevel.getEnumString())
//            }
//            .disabled(languageViewModel.getLessonCompletionMode(sl: studentLevel) == .closed ? true : false)
//            .frame(minWidth: 200, maxWidth: 450)
//            .background(selection == studentLevel ? .yellow : Color("BethanyNavalBackground") )
//            .foregroundColor(selection == studentLevel ? .black : Color("BethanyGreenText") )
//            Spacer()
//            languageViewModel.getLessonCompletionMode(sl: studentLevel).getImage()
//        }
//    }
//}
//
//
//
//struct CurrentModelLessonView: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @State var studentLevel : StudentLevel
//    @State var currentLanguage = LanguageType.Agnostic
//    @State var lessonObjectiveStrings = ("Part1", "Part 2")
//    @State var maxVerbCount = 0
//    @State var modelVerbList = [Verb]()
//    @State var lessonLevel = 0
//    @State private var showingConjugationSheet = false
//    var body: some View {
//        let gridFixSize = CGFloat(100.0)
//        
//        let gridItems = [GridItem(.fixed(gridFixSize)),
//                         GridItem(.fixed(gridFixSize)),
//                         GridItem(.fixed(gridFixSize))]
//        
//        VStack{
//            VStack{
//                Text("Model-Based Verb Conjugation").font(.title2)
////                Text(lessonObjectiveStrings.0)
////                Text(lessonObjectiveStrings.1)
//                ListModels(languageViewModel: languageViewModel, studentLevel: studentLevel, function: listVerbsForModel)
//            }
//            .padding(.horizontal)
//            .border(.red)
//                
//            ScrollView{
//                Text("Your Verbs:").font(.title2)
//                LazyVGrid(columns: gridItems, spacing: 5){
//                    ForEach(modelVerbList, id: \.self){ verb in
//                        LessonWordCellButton(languageViewModel: languageViewModel, verb: verb)
//                    }
//                    
//                }
//            }
//            
//        }.padding(.horizontal)
//            .navigationTitle("MBVC")
//            .border(.red)
//            .padding(5)
//            .background(Color.black)
//            .foregroundColor(.yellow)
//            .cornerRadius(8)
//            .font(.subheadline)
//        
//            .onAppear{
//                currentLanguage = languageViewModel.getCurrentLanguage()
//                lessonObjectiveStrings =  languageViewModel.getStudentLevel().getLessonObjectives()
//                lessonLevel = languageViewModel.getStudentLevel().getLessonLevel()
////                listVerbsForModel(modelWord: languageViewModel.getCurrentModelListAll()[0].modelVerb)
//            }
//            .onDisappear{
//                languageViewModel.fillVerbCubeAndQuizCubeLists()
//                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
//            }
//            .foregroundColor(Color("BethanyGreenText"))
//            .background(Color("BethanyNavalBackground"))
//    }
//    
//    func listVerbsForModel(modelWord: String){
//        let mdl = languageViewModel.getModelAtModelWord(modelWord: modelWord)
//        let vl = languageViewModel.findVerbsOfSameModel(targetID: mdl.id)
//        languageViewModel.setFilteredVerbList(verbList: vl)
//        setVerbLists()
//    }
//    
//    func setVerbLists(){
//        modelVerbList = languageViewModel.getFilteredVerbs()
//    }
//}
//
//
//extension ListModels{
//    private var showFeatherInfo: some View {
//        VStack{
//            VStack{
//                HStack{
//                    Text("Model ID:")
//                    Text("\(currentVerbModel.id)")
//                    Text(", Model Verb:")
//                    Text(currentVerbModel.modelVerb)
//                }
//                VStack{
//                    Text("Pattern information:")
//                    ForEach( 0..<currentVerbModel.specialPatternList.count, id: \.self){i in
//                        HStack{
//                            Text(patternTypeString(patternStr: currentVerbModel.specialPatternList[i].patternStr))
//                            Text(currentVerbModel.specialPatternList[i].tenseStr)
//                            Text(currentVerbModel.specialPatternList[i].patternStr)
//                        }
//                    }
//                }
//            }
//            
//        }.border(.red)
//            .foregroundColor(Color("BethanyGreenText"))
//            .background(Color("BethanyNavalBackground"))
//    }
//    func patternTypeString(patternStr: String)->String{
//        for type in SpecialPatternType.orthoChangingSpanish{
//            if type.rawValue == patternStr { return "Spell:"}
//        }
//        return "Stem:"
//    }
//}
//
//struct ListModels: View {
//    @ObservedObject var languageViewModel: LanguageViewModel
//    @State private var currentLanguage = LanguageType.Spanish
//    @State var currentVerbEnding = VerbEnding.AR
//    @State var endingList = [VerbEnding.AR, .ER, .IR]
//    @State var currentVerbModel = RomanceVerbModel()
//    @State var studentLevel : StudentLevel
//    
//    var function: (_ modelWord: String) -> Void
//    
//    var fontSize = Font.callout
//    
//    var body: some View {
//        ZStack{
//            Color("BethanyNavalBackground")
//                .edgesIgnoringSafeArea(.all)
//            VStack{
//                    showVerbEndingTypes
//                    showFeatherInfo
//                .padding()
//                Text("Model List").font(.title2).foregroundColor(Color("ChuckText1"))
//                
//                ScrollView{
//                    let gridFixSize = CGFloat(100.0)
//                    let gridItems = [GridItem(.fixed(gridFixSize)),
//                                     GridItem(.fixed(gridFixSize)),
//                                     GridItem(.fixed(gridFixSize))]
//                    
//                    LazyVGrid(columns: gridItems, spacing: 5){
//                        ForEach (0..<languageViewModel.getCurrentModelList(ending: currentVerbEnding).count, id: \.self){ i in
//                            Button{
//                                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb)
//                                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i]
//                            } label: {
//                                Text(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb)
//                                    .foregroundColor(
//                                        currentVerbModel.modelVerb == languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb  ?
//                                    .red : .yellow)
//                            }
//                        }
//                    }
//                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
//                    .foregroundColor(Color("BethanyGreenText"))
//                    .cornerRadius(8)
//                    .font(fontSize)
//                }
//                
//            }.onAppear{
//                currentLanguage = languageViewModel.getCurrentLanguage()
//                currentVerbEnding = .AR
//                languageViewModel.setStudentLevel(level: studentLevel)
//                let modelList = languageViewModel.getCurrentModelList(ending: currentVerbEnding)
//                print ("modelList count \(modelList.count)")
//                if modelList.count > 0 { currentVerbModel = modelList[0] }
//            }
//            .onDisappear{
//                languageViewModel.fillVerbCubeAndQuizCubeLists()
//                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
//            }
//        }
//        
//    }
//    
//}
//
//extension ListModels {
//    private var showVerbEndingTypes: some View {
//        HStack{
//            Button{
//                currentVerbEnding = .AR
//                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0]
//                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0].modelVerb)
//            } label: {
//                HStack{
//                    Text("AR")
//                        .frame(width: 50, height: 30)
//                        .foregroundColor(.white)
//                        .background(currentVerbEnding == .AR ? .red : Color("BethanyPurpleButtons"))
//                        .shadow(radius: 3)
//                }
//            }
//            Button{
//                currentVerbEnding = .ER
//                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0]
//                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0].modelVerb)
//            } label: {
//                HStack{
//                    Text("ER")
//                        .frame(width: 50, height: 30)
//                        .background(currentVerbEnding == .ER ? .red : Color("BethanyPurpleButtons"))
//                        .foregroundColor(.white)
//                        .shadow(radius: 3)
//                }
//            }
//
//            Button{
//                currentVerbEnding = .IR
//                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0]
//                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0].modelVerb)
//            } label: {
//                HStack{
//                    Text("IR")
//                        .frame(width: 50, height: 30)
//                        .background(currentVerbEnding == .IR ? .red : Color("BethanyPurpleButtons"))
//                        .foregroundColor(.white)
//                        .shadow(radius: 3)
//                }
//            }
//        }
//        .foregroundColor(Color("BethanyGreenText"))
//        .background(Color("BethanyNavalBackground"))
//        .padding(5)
//        .border(Color("ChuckText1"))
//    }
//}
//
//
