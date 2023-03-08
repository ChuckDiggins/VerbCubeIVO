//
//  VerbModelManager.swift
//  Feather2
//
//  Created by chuckd on 2/25/23.
//

import Foundation
import JumpLinguaHelpers

enum VerbModelType : String {
    case Sequential, Lesson, Pattern
}

struct VerbModelLesson: Identifiable, Equatable {
    var id = UUID()
    let description : String
    var verbModelList : [RomanceVerbModel]
    
    static func == (lhs: VerbModelLesson, rhs: VerbModelLesson) -> Bool {
        lhs.description == rhs.description
    }
    
    init(_ desc: String, _ vml : [RomanceVerbModel]){
        self.description = desc
        self.verbModelList = vml
    }
                                 
    func getVerbModelAt(_ index: Int)->RomanceVerbModel{
        if index >= 0 && index < verbModelList.count {
            return verbModelList[index]
        }
        return RomanceVerbModel()
    }
    
    func getDescription()->String{
        return description
    }
    
}

//two modes:
//    1.  sequential verb model list
//    2.  current verb model lesson containing several verb models

class VerbModelHandler: ObservableObject {
    var verbModelList : [RomanceVerbModel]
    var verbModelLessonList = [VerbModelLesson]()
    var currentLessonIndex = 0
    var verbModelType = VerbModelType.Sequential  //by default, all verb models in order as constructed
    
    @Published var currentVerbModelLesson = VerbModelLesson("", [RomanceVerbModel]())
    
    init(){
        verbModelList = [RomanceVerbModel]()
    }
    
    func getDefaultModelLesson()->VerbModelLesson{
        VerbModelLesson("", [RomanceVerbModel]())
    }
    
    func setVerbModelList(verbModelList: [RomanceVerbModel]){
        self.verbModelList = verbModelList
    }
    
    func appendLesson(_ lesson: VerbModelLesson){
        verbModelLessonList.append(lesson)
    }
    
    func setCurrentLesson(_ index: Int){
        currentLessonIndex = 0
        if index <= 0 && index < verbModelLessonList.count {
            currentLessonIndex = index
            currentVerbModelLesson = verbModelLessonList[currentLessonIndex]
        }
    }
    
    func getCurrentLesson()->VerbModelLesson{
        currentVerbModelLesson
    }
    
   
}
