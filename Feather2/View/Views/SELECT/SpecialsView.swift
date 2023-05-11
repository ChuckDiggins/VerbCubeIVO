//
//  ExtrasView.swift
//  Feather2
//
//  Created by Charles Diggins on 5/6/23.
//

import SwiftUI

import SwiftUI
import JumpLinguaHelpers

struct SpecialsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentLanguage = LanguageType.Agnostic
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    //    @State var v2MGroupManager = VerbToModelGroupManager()
    @State var v2MGroupList = [VerbToModelGroup]()
    @State var currentV2MGroup = VerbToModelGroup()
    @State var chapterSelection = Chuck1Chapters.chuck1A
    @State var lessonSelection = 0
    let numOfChapters = Chuck1Chapters.allCases.count
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 3A"
    @AppStorage("V2MLesson") var currentV2mLesson = "AR, ER, IR verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    @AppStorage("CurrentSpecialsOption") var currentSpecialsOptionString = "Auxiliary - Gerund"
    @State var tempSpecialOptionString = "Not set"
    
    var body: some View {
        VStack{
            ExitButtonView()
            HStack{
                Text("Current option:").foregroundColor(Color("ChuckText1"))
                VStack{
                    Text(currentSpecialsOptionString)
                }
            }
            
            if v2MGroupList.count > 0 {

                VStack{
                    
                    VStack{
                        GeometryReader{ geo in
                            ScrollView{
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
                    }
                }
                Spacer()
                VStack{
                    VerbAndTenseListView(v2MGroup: currentV2MGroup, currentLanguage: currentLanguage)
                    Button{
                        installLessonAsPackage()
                        router.reset()
                        dismiss()
                    } label: {
                        Text("¿Install: \(currentV2MGroup.lesson) as selected lesson?")
                    }.tint(.purple)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius:5))
                        .controlSize(.regular)
                        .foregroundColor(.yellow)
                    Spacer()
                }
            }
        }
        .onAppear{
            fillV2MGroupManager("Specials")
            tempSpecialOptionString = currentSpecialsOptionString
            currentLanguage = languageViewModel.getCurrentLanguage()
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
    }
    
    func processV2MGroup(v2mGroup: VerbToModelGroup){
        currentV2MGroup = v2mGroup
        tempSpecialOptionString = currentV2MGroup.lesson
        print("specials option changed \(tempSpecialOptionString)")
    }
    
    func installLessonAsPackage(){
        currentSpecialsOptionString = tempSpecialOptionString
        let specialsPackage = languageViewModel.convertV2MGroupToStudyPackage(v2MGroup: currentV2MGroup)
        languageViewModel.setSpecialsPackageSimple(specialsPackage)
//        languageViewModel.setSpecialOptionsTo(currentV2MGroup.lesson)
    }
    
    func fillV2MGroupManager(_ chapter: String){
        v2MGroupList = languageViewModel.getV2MGroupManager().getV2MGroupListAtChapter(chapter: "Specials")
        dumpV2MGroupManager()
        dumpV2MGroupList()
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
                print("v2m: \(v2m)")
            }
        }
        
    }
    
    
}


