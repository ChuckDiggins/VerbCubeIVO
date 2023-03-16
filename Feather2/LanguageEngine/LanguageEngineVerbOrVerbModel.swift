//
//  LanguageEngineVerbOrVerbModel.swift
//  Feather2
//
//  Created by Charles Diggins on 3/4/23.
//

import Foundation
import JumpLinguaHelpers
    

extension LanguageEngine{
    
    func isModelMode()->Bool{
        if verbOrModelMode == .modelMode {
            return true
        }
        return false
    }
    
    func setVerbOrModelMode(_ verbOrModelModeString: String){
        switch verbOrModelModeString{
        case "Verbs": verbOrModelMode = .verbMode
        default: verbOrModelMode = .modelMode
        }
    }
    
    func setToVerbMode(_ chapterString: String, _ lessonString: String){
        currentV2mChapter = chapterString
        currentV2mLesson = lessonString
        installCurrentStudyPackage()
    }
    
    func setToVerbMode(){
        verbOrModelMode = .verbMode
        filteredVerbList = studyPackageFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
        setTenses(tenseList: studyPackage.tenseList)
        specialVerbType = studyPackage.specialVerbType
        verbOrModelModeString = "Verbs"
    }
    
    func setToVerbModelMode(){
        verbOrModelMode = .modelMode
        filteredVerbList = verbModelFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
        specialVerbType = SpecialVerbType.normal
        setTenses(tenseList: [.present, .imperfect, .preterite, .conditional, .future])
    }
    
    func setStudyPackageTo(_ chapterString: String, _ lessonString: String){
        currentV2mChapter = chapterString
        currentV2mLesson = lessonString
        installCurrentStudyPackage()
        filteredVerbList = studyPackageFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
    }
    
    func setVerbModelTo(_ verbModel: RomanceVerbModel){
        verbOrModelMode = .modelMode
        currentVerbModel = verbModel
        currentVerbModelString = currentVerbModel.modelVerb
        selectThisVerbModel(verbModel: currentVerbModel)
        fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList()
        filteredVerbList = verbModelFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
        specialVerbType = SpecialVerbType.normal
    }
    
    func fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList(_ maxVerbCountPerModel: Int = 16){
        computeSelectedVerbModels()
        computeCompletedVerbModels()
        selectedVerbModelList = getSelectedVerbModelList()
        var newVerbList = [Verb]()
        if selectedVerbModelList.count > 0 {
            for model in selectedVerbModelList{
                var verbCount = 0
                var tempVerbList = findSingletonVerbsOfSameModel(targetID: model.id)
                tempVerbList.shuffle()
                for verb in tempVerbList{
                    verbCount += 1
                    newVerbList.append(verb)
                    if verbCount > maxVerbCountPerModel {
                        break
                    }
                }
            }
            verbModelFilteredVerbList = newVerbList
            trimFilteredVerbList(maxVerbCountPerModel)
            currentFilteredVerbIndex = 0
            print("fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList: filteredVerbList count = \(filteredVerbList.count)")
            fillVerbCubeAndQuizCubeLists()
            _ = computeVerbsExistForAll3Endings()
            setTenses(tenseList: [.present, .preterite, .imperfect, .future, .conditional])
        }
    }
    
    
    func getVerbOrModelMode()->VerbOrModelMode{
        verbOrModelMode
    }
    
    func installStudyPackage(sp: StudyPackageClass){
        setStudyPackageTo(sp.chapter, sp.lesson)
        tenseList = sp.tenseList
        studyPackage = sp
        specialVerbType = studyPackage.specialVerbType
        setToVerbMode(sp.chapter, sp.lesson)
    }
    
    func restoreV2MPackage(){
        loadAllV2Ms()
        if verbOrModelMode == .modelMode {
            restoreModelFromCurrentVerbModelString()
        } else {
            installCurrentStudyPackage()
        }
    }
    
    func installCurrentStudyPackage() {
        var v2mFound = false
        
        for v2m in v2MGroupManager.getV2MGroupList() {
            if v2m.chapter == currentV2mChapter && v2m.lesson == currentV2mLesson {
                v2MGroup = v2m
                v2mFound = true
                break
            }
        }
        
        if v2mFound {
            studyPackage = convertV2MGroupToStudyPackage(v2mGroup: v2MGroup)
            studyPackageFilteredVerbList = studyPackage.preferredVerbList
            filteredVerbList = studyPackageFilteredVerbList
            specialVerbType = studyPackage.specialVerbType
            setTenses(tenseList: studyPackage.tenseList)
        }
        else {
            print("installCurrentStudyPackage: StudyPackage \(currentV2mChapter), \(currentV2mLesson) not found")
        }
        
    }
    
    func processVerbModel(currentModel: RomanceVerbModel){
        computeSelectedVerbModels()
        computeCompletedVerbModels()
        vmecdm.setAllSelected(flag: false)
        setCurrentVerbModel(model: currentModel)
        vmecdm.setSelected(verbModelString: currentModel.modelVerb, flag: true)
        setVerbModelFilteredVerbList(verbList: findVerbsOfSameModel(targetID: currentModel.id))
        filteredVerbList = verbModelFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
        setToVerbModelMode()
    }
    
    func restoreModelFromCurrentVerbModelString(){
        if currentVerbModelString == "" {
            processVerbModel(currentModel: findModelForThisVerbString(verbWord: "ser"))
            trimFilteredVerbList(16)
            return
        }
        currentVerbModel = findModelForThisVerbString(verbWord: currentVerbModelString)
        print("restoreModel: currentVerbModelString = \(currentVerbModelString)")
        setToVerbModelMode()
        trimFilteredVerbList(16)
    }
    
    func trimFilteredVerbList(_ maxCount: Int){
        var verbList = verbModelFilteredVerbList
        if verbList.count > maxCount {
            let extra = verbList.count - maxCount
            verbList.shuffle()
            verbList.removeLast(extra)
        }
        verbModelFilteredVerbList = verbList
    }

}
