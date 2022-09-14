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

//extension CurrentModelLessonView {
//    private var showFeatherInfo: some View {
//        VStack{
//            HStack{
//                VStack{
//                    Text("Verb information:")
//                    Text(modelNumberString)
//                    Text(modelNameString)
//                }
//                VStack{
//                    Text("Pattern information:")
//                        ForEach( 0..<patternTenseStringList.count, id: \.self){i in
//                            HStack{
//                                Text(patternTenseStringList[i])
//                                Text(patternTypeStringList[i])
//                            }
//                        }
//
//                }
//            }
//            
//            Divider().frame(height:2).background(.yellow)
//            
//            switch featherMode {
//            case .model: Text("The following \(featherVerbList.count) verbs with the same conjugation model were found:").bold().padding(.horizontal)
//            case .pattern:  Text("The following \(featherVerbList.count) verbs with the same conjugation pattern were found:").bold().padding(.horizontal)
//            }
//        }.border(.red)
//    }
//}
//

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
                Text("Model-Based Verb Conjugation").font(.title2)
                Text(lessonObjectiveStrings.0)
                Text(lessonObjectiveStrings.1)
            }
            .padding(horizontal: 10, vertical: 5)
            .border(.red)
            
            ListModels(languageViewModel: languageViewModel, studentLevel: studentLevel, function: listVerbsForModel)
            
            ScrollView{
                Text("Your Verbs:").font(.title2)
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach(modelVerbList, id: \.self){ verb in
                        LessonWordCellButton(languageViewModel: languageViewModel, verb: verb)
                    }
                    
                }
            }
            
        }.padding(horizontal: 0, vertical: 5)
            .navigationTitle("MBVC")
            .border(.red)
            .padding(5)
            .background(Color.black)
            .foregroundColor(.yellow)
            .cornerRadius(8)
            .font(.subheadline)
        
            .onAppear{
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
        setVerbLists()
    }
    
    func setVerbLists(){
        modelVerbList = languageViewModel.getFilteredVerbs()
    }
}


struct ListModels: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    @State var currentVerbEnding = VerbEnding.AR
    @State var endingList = [VerbEnding.AR, .ER, .IR]
    @State var currentVerbModel = RomanceVerbModel()
    @State var studentLevel : StudentLevel
    
    var function: (_ modelWord: String) -> Void
    
    var fontSize = Font.callout
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .edgesIgnoringSafeArea(.all)
            VStack{
                    showVerbEndingTypes
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
                                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i]
                            } label: {
                                Text(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb)
                                    .foregroundColor(
                                        currentVerbModel.modelVerb == languageViewModel.getCurrentModelList(ending: currentVerbEnding)[i].modelVerb  ?
                                    .red : .black)
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
                languageViewModel.setStudentLevel(level: studentLevel)
                var modelList = languageViewModel.getCurrentModelList(ending: currentVerbEnding)
                print ("modelList count \(modelList.count)")
                if modelList.count > 0 { currentVerbModel = modelList[0] }
//                loadVerbModels()
            }
        }
        
    }
    
}

extension ListModels {
    private var showVerbEndingTypes: some View {
        HStack{
            Button{
                currentVerbEnding = .AR
                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0]
                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0].modelVerb)
            } label: {
                HStack{
                    Text("AR")
                        .frame(width: 50, height: 30)
                        .foregroundColor(.white)
                        .background(currentVerbEnding == .AR ? .red : Color("BethanyPurpleButtons"))
                        .shadow(radius: 3)
                }
            }
            Button{
                currentVerbEnding = .ER
                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0]
                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0].modelVerb)
            } label: {
                HStack{
                    Text("ER")
                        .frame(width: 50, height: 30)
                        .background(currentVerbEnding == .ER ? .red : Color("BethanyPurpleButtons"))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                }
            }

            Button{
                currentVerbEnding = .IR
                currentVerbModel = languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0]
                function(languageViewModel.getCurrentModelList(ending: currentVerbEnding)[0].modelVerb)
            } label: {
                HStack{
                    Text("IR")
                        .frame(width: 50, height: 30)
                        .background(currentVerbEnding == .IR ? .red : Color("BethanyPurpleButtons"))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                }
            }
        }
        .padding(5)
        .border(Color("ChuckText1"))
    }
}


