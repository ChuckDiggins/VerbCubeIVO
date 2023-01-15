//
//  VerbsToModelsView.swift
//  Feather2
//
//  Created by Charles Diggins on 12/15/22.
//

import SwiftUI
import JumpLinguaHelpers


struct TextBookView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    @Environment(\.dismiss) private var dismiss
    //    @State var v2MGroupManager = VerbToModelGroupManager()
    @State var v2MGroupList = [VerbToModelGroup]()
    @State var currentV2MGroup = VerbToModelGroup()
    @State var chapterSelection = Realidades1Chapters.chapter1A
    @State var lessonSelection = 0
    let numOfChapters = Realidades1Chapters.allCases.count
    @AppStorage("V2MChapter") var currentV2mChapter = "nada 2"
    @AppStorage("V2MLesson") var currentV2mLesson = "nada 3"
    
    var body: some View {
        VStack{
            HStack{
                Text("Current lesson:").foregroundColor(Color("ChuckText1"))
                VStack{
                    Text(currentV2mChapter)
                    Text(currentV2mLesson)
                }
            }
            if v2MGroupList.count > 0 {
                VStack{
                   
                    VStack{
                        Text("Realidades")
                        Picker("Select Text Book", selection: $chapterSelection){
                            ForEach(Realidades1Chapters.allCases, id:\.self){ chapter in
                                Text(chapter.getChapterDescription())
                            }
                        }.pickerStyle(.wheel)
                            .onChange(of: chapterSelection){ type in
                                fillV2MGroupManager(chapterSelection.rawValue)
                            }
                    }
                    .padding()
                    VStack{
                        LazyVStack{
                            ForEach(v2MGroupList, id:\.self){ v2m in
                                Button{
                                    processV2MGroup(v2mGroup: v2m)
                                } label: {
                                    Text("\(v2m.lesson)")
                                }.frame(width: 300)
                                    .padding(.horizontal, 5)
                                    .foregroundColor(v2m == currentV2MGroup ? .black : Color("BethanyGreenText"))
                                    .background(v2m == currentV2MGroup ? .yellow : Color("BethanyNavalBackground"))
                            }
                        }
                    }
                    .padding()
                    Button{
                        installLessonAsPackage()
                        dismiss()
                    } label: {
                        Text("¿Install: \(currentV2MGroup.lesson)?")
                    }.tint(.purple)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius:5))
                        .controlSize(.regular)
                        .foregroundColor(.yellow)
                    showVerbToModel(v2mGroup: currentV2MGroup, currentLanguage: currentLanguage)
                    Spacer()
                }
                
            }
        }
        .onAppear{
            fillV2MGroupManager("")
            currentLanguage = languageViewModel.getCurrentLanguage()
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
    }
    
    func processV2MGroup(v2mGroup: VerbToModelGroup){
        currentV2MGroup = v2mGroup
        print("currentV2MGroup changed \(currentV2MGroup.lesson)")
    }
    
    func installLessonAsPackage(){
        languageViewModel.setV2MGroup(v2MGroup: currentV2MGroup)
        let studyPackage = languageViewModel.convertV2MGroupToStudyPackage(v2MGroup: currentV2MGroup)
        languageViewModel.installStudyPackage(sp: studyPackage)
        currentV2mChapter = currentV2MGroup.chapter
        currentV2mLesson = currentV2MGroup.lesson
        languageViewModel.resetFeatherSentenceHandler()
    }
    
    func fillV2MGroupManager(_ chapter: String){
        v2MGroupList = languageViewModel.getV2MGroupManager().getV2MGroupListAtChapter(chapter: chapter)
        currentV2MGroup = v2MGroupList[0]
    }
    
    
    func dumpV2MGroupList(){
        for v2mGroup in v2MGroupList{
            print("v2MGroup = \(v2mGroup.chapter), \(v2mGroup.lesson)")
            for v2m in v2mGroup.verbToModelList {
                print("v2m: \(v2m.verb.getWordAtLanguage(language: currentLanguage)), model: \(v2m.model.modelVerb)")
            }
        }
        
    }
    func dumpV2MGroupManager(){
        for v2mGroup in languageViewModel.getV2MGroupManager().getV2MGroupList(){
            print("v2mGroup: Book \(v2mGroup.chapter), Lesson: \(v2mGroup.lesson)")
            for v2m in v2mGroup.verbToModelList {
                print("v2m: \(v2m.verb.getWordAtLanguage(language: currentLanguage)), model: \(v2m.model.modelVerb)")
            }
        }
        
    } 
}

struct showVerbToModel: View {
    var v2mGroup: VerbToModelGroup
    var currentLanguage: LanguageType
        
    var body: some View{
        HStack(spacing: 20){
            ScrollView{
                Text("Verbs:").bold()
                    .foregroundColor(Color("ChuckText1"))
                //                Spacer()
                //                Text("Verb model")
                ForEach(v2mGroup.verbToModelList, id:\.self){ v2m in
                    Text(v2m.verb.getWordAtLanguage(language: currentLanguage))
                    //                    Spacer()
                    //                    Text(v2m.model.modelVerb)
                }
            }.frame(maxWidth: .infinity)
            Spacer()
            Divider().frame(width:2).background(.yellow)
            Spacer()
            ScrollView{
                Text("Tenses:").bold()
                    .foregroundColor(Color("ChuckText1"))
                VStack{
                    ForEach(v2mGroup.tenseList, id:\.self){ tense in
                        Text(tense.rawValue)
                    }
                }
            }.frame(maxWidth: 120)
        }
        .frame(maxHeight: 120)
        .padding(10)
        .background(Color("ChuckText1").opacity(0.2))
        .border(.red)
        
    }
}
struct VerbsToModelsView_Previews: PreviewProvider {
    static var previews: some View {
        TextBookView(languageViewModel: LanguageViewModel())
    }
}