//
//  VerbToModelClass.swift
//  Feather2
//
//  Created by Charles Diggins on 12/16/22.
//

import Foundation
import JumpLinguaHelpers

class VerbToModelStruct: Hashable{
    static func == (lhs: VerbToModelStruct, rhs: VerbToModelStruct) -> Bool {
        return lhs.verb == rhs.verb && lhs.model.modelVerb == rhs.model.modelVerb
    }
    
    public func hash(into hasher: inout Hasher){
        hasher.combine(verb)
    }
    var verb: Verb
    var model = RomanceVerbModel()
    

    init(_ verb: Verb){
        self.verb = verb
    }
    
    init(_ verbString: String){
        self.verb = Verb(spanish: verbString, french: verbString, english: verbString)
    }
    
    func setVerbModel(_ model: RomanceVerbModel){
        self.model = model
    }
    
}

struct VerbToModelGroup: Identifiable, Hashable{
    static func == (lhs: VerbToModelGroup, rhs: VerbToModelGroup) -> Bool {
        return lhs.chapter == rhs.chapter && lhs.lesson == rhs.lesson
    }
    
    public func hash(into hasher: inout Hasher){
        hasher.combine(lesson)
    }
    
    var id = UUID()
    var chapter: String
    var lesson: String
    var verbToModelList : [VerbToModelStruct]
    var tenseList : [Tense]
    var specialVerbType : SpecialVerbType
    
    init(){
        chapter = ""
        lesson = ""
        verbToModelList = [VerbToModelStruct]()
        tenseList = [Tense]()
        specialVerbType = .normal
    }
    
    init(chapter: String, lesson: String, verbToModelList: [VerbToModelStruct], tenseList: [Tense], specialVerbType: SpecialVerbType){
        self.chapter = chapter
        self.lesson = lesson
        self.verbToModelList = verbToModelList
        self.tenseList = tenseList
        self.specialVerbType = specialVerbType
    }
    
    func getSpecialVerbType()->SpecialVerbType{
        return specialVerbType
    }
    
    func getChapter()->String{
        chapter
    }
    
    func getLesson()->String{
        lesson
    }
    
    func getV2MList()->[VerbToModelStruct]{
        verbToModelList
    }
    
    func getModelStringList()->[String]{
        var vmStringList = [String]()
        for v2m in verbToModelList{
            vmStringList.append(v2m.model.modelVerb)
        }
        return vmStringList
    }
    
    func getVerbList()->[Verb]{
        var verbList = [Verb]()
        for v2m in verbToModelList{
            verbList.append(v2m.verb)
        }
        return verbList
    }
    
}

class VerbToModelGroupManager{
    private var v2MGroupList = [VerbToModelGroup]()
    private var currentIndex = 0
    
    func clearGroups(){
        v2MGroupList.removeAll()
    }
    func appendGroup(_ group: VerbToModelGroup){
        v2MGroupList.append(group)
    }
    
    func getV2MGroupList()->[VerbToModelGroup]{
        v2MGroupList
    }
    
    func getNextV2MGroup(currentGroup: VerbToModelGroup)->VerbToModelGroup{
        currentIndex = 0
        for index in 0 ..< v2MGroupList.count {
            if v2MGroupList[index].chapter == currentGroup.chapter && v2MGroupList[index].lesson == currentGroup.lesson {
                if index < v2MGroupList.count-1 {
                    currentIndex = index + 1
                } else {
                    currentIndex = 0
                }
            }
        }
        return v2MGroupList[currentIndex]
    }
    
    func getV2MGroupListAtChapter(chapter: String)->[VerbToModelGroup]{
        var thisChapter = chapter
        var v2mList = [VerbToModelGroup]()
        //if title is blank, the default to the first text book title
        if thisChapter.count == 0 {
            thisChapter = v2MGroupList[0].chapter
        }
        
        for v2mGroup in v2MGroupList {
            if v2mGroup.chapter == thisChapter {
                v2mList.append(v2mGroup)
            }
        }
        return v2mList
    }
}
