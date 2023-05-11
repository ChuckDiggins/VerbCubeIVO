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
        if lessonModelSpecialsMode == .modelMode {
            return true
        }
        return false
    }
    
    func isLessonMode()->Bool{
        if lessonModelSpecialsMode == .lessonMode {
            return true
        }
        return false
    }
    
    func isSpecialsMode()->Bool{
        if lessonModelSpecialsMode == .specialsMode {
            return true
        }
        return false
    }
    
    func setVerbOrModelMode(_ verbOrModelModeString: String){
        switch verbOrModelModeString{
        case "Lessons": lessonModelSpecialsMode = .lessonMode
        case "Specials": lessonModelSpecialsMode = .specialsMode
        default: lessonModelSpecialsMode = .modelMode
        }
    }
    
    func setToVerbMode(_ chapterString: String, _ lessonString: String){
        currentV2mChapter = chapterString
        currentV2mLesson = lessonString
        installCurrentStudyPackage()
    }
    
    func setToLessonMode(){
        lessonModelSpecialsMode = .lessonMode
        filteredVerbList = studyPackage.preferredVerbList
        fillVerbCubeAndQuizCubeLists()
        setTenses(tenseList: studyPackage.tenseList)
        setSpecialVerbType(studyPackage.specialVerbType)
//        print("setToVerbMode: specialVerbType = \(specialVerbType.rawValue)")
        verbOrModelModeString = "Lessons"
    }
    
    func setToVerbModelMode(){
        verbOrModelModeString = "Models"
        lessonModelSpecialsMode = .modelMode
        filteredVerbList = verbModelFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
        setSpecialVerbType( SpecialVerbType.normal )
//        print("setToVerbModelMode: specialVerbType = \(specialVerbType.rawValue)")
        setTenses(tenseList: [.present, .imperfect, .preterite, .conditional, .future])
    }
    
    func setToSpecialsMode(){
        lessonModelSpecialsMode = .specialsMode
        let v2MGroupList = getV2MGroupManager().getV2MGroupListAtChapter(chapter: "Specials")
        for v2mGroup in v2MGroupList {
            if v2mGroup.lesson == currentSpecialsOptionString {
                let specialsPackage = convertV2MGroupToStudyPackage(v2mGroup: v2mGroup)
                setSpecialsPackageSimple(specialsPackage)
                verbOrModelModeString = "Specials"
            }
        }
        
    }
    
    func setStudyPackageTo(_ chapterString: String, _ lessonString: String){
        currentV2mChapter = chapterString
        currentV2mLesson = lessonString
        installCurrentStudyPackage()
        filteredVerbList = studyPackageFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
//        print("setStudyPackageTo: specialVerbType = \(specialVerbType.rawValue)")
    }
    
    func setVerbModelTo(_ verbModel: RomanceVerbModel){
        lessonModelSpecialsMode = .modelMode
        currentVerbModel = verbModel
        currentVerbModelString = currentVerbModel.modelVerb
        selectThisVerbModel(verbModel: currentVerbModel)
        fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList()
        filteredVerbList = verbModelFilteredVerbList
        fillVerbCubeAndQuizCubeLists()
        specialVerbType = SpecialVerbType.normal
//        print("setVerbModelTo: specialVerbType = \(specialVerbType.rawValue)")
    }
    
    func fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList(_ maxVerbCountPerModel: Int = 16){
        computeSelectedVerbModels()
        computeCompletedVerbModels()
        selectedVerbModelList = getSelectedVerbModelList()
        var newVerbList = [Verb]()
        print("\nfillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList:")
        if selectedVerbModelList.count > 0 {
            print("selectedVerbModelList: found \(selectedVerbModelList.count) verbs")
            var verbCount = 0
            for model in selectedVerbModelList{
                print("model: id:\(model.id). modelVerb = \(model.modelVerb)")
                var tempVerbList = findSingletonVerbsOfSameModel(targetID: model.id)
                tempVerbList.shuffle()
                for verb in tempVerbList{
                    print("\(verbCount). \(verb.getWordStringAtLanguage(language: getCurrentLanguage()))")
                    verbCount += 1
                    newVerbList.append(verb)
                    if verbCount > maxVerbCountPerModel {
                        break
                    }
                }
            }
            if verbCount > 0 {
                verbModelFilteredVerbList = newVerbList
                trimFilteredVerbList(maxVerbCountPerModel)
                currentFilteredVerbIndex = 0
                print("filteredVerbList count = \(filteredVerbList.count)")
                fillVerbCubeAndQuizCubeLists()
                _ = computeVerbsExistForAll3Endings()
                setTenses(tenseList: [.present, .preterite, .imperfect, .future, .conditional])
            }
        }
        
        //if no current verb model list find verbs associated with currentVerbModelString  ... such as French for now
        else {
            var model = findModelForThisVerbString(verbWord: currentVerbModelString)
            var tempVerbList = findSingletonVerbsOfSameModel(targetID: model.id)
            var verbCount = 0
            for verb in tempVerbList{
                verbCount += 1
                newVerbList.append(verb)
                if verbCount > maxVerbCountPerModel {
                    break
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
    
    
    func getVerbOrModelMode()->LessonModelSpecialsMode{
        lessonModelSpecialsMode
    }
    
    func installStudyPackage(sp: StudyPackageClass){
        setStudyPackageTo(sp.chapter, sp.lesson)
        tenseList = sp.tenseList
        studyPackage = sp
        setSpecialVerbType( studyPackage.specialVerbType )
        setToVerbMode(sp.chapter, sp.lesson)
    }
    
    func restoreV2MPackage(){
        //loads the lessons for the current language
        print("restoreV2MPackage: \(getCurrentLanguage().rawValue)")
        loadAllV2Ms()
        fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList()
        if lessonModelSpecialsMode == .modelMode {
            restoreModelFromCurrentVerbModelString()
        } else if lessonModelSpecialsMode == .lessonMode {
            installCurrentStudyPackage()
        } else {
            installCurrentSpecialsPackage()
        }
        fillVerbCubeAndQuizCubeLists()
        verbOrModelModeInitialized = true
    }
    
    func installCurrentSpecialsPackage(){
        let v2MGroupList = getV2MGroupManager().getV2MGroupListAtChapter(chapter: "Specials")
        for v2m in v2MGroupList {
            if v2m.lesson == currentSpecialsOptionString {
                let specialsPackage = convertV2MGroupToStudyPackage(v2mGroup: v2m)
                setSpecialsPackageSimple(specialsPackage)
            }
        }
    }
    
    func setSpecialsPackageSimple(_ specialsPackage: StudyPackageClass){
        print("setSpecialsPackageSimple: \(currentSpecialsOptionString)")
        filteredVerbList = specialsPackage.preferredVerbList
        setSpecialVerbType(specialsPackage.specialVerbType)
        setTenses(tenseList: specialsPackage.tenseList)
        fillVerbCubeAndQuizCubeLists()
    }
    
    func getSpecialVerbType()->SpecialVerbType{
//        print("...... getSpecialVerbType = \(specialVerbType.rawValue)")
        return specialVerbType
    }
    
    func setSpecialVerbType(_ svt: SpecialVerbType){
        specialVerbType = svt
//        print("... setSpecialVerbType = \(specialVerbType.rawValue)")
    }
    
    func installCurrentStudyPackage() {
        var v2mFound = false
//        print("installCurrentStudyPackage: find \(currentV2mChapter), \(currentV2mLesson)")
        for v2m in v2MGroupManager.getV2MGroupList() {
//            print("installCurrentStudyPackage: \(v2m.chapter), \(v2m.lesson)")
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
            setSpecialVerbType(studyPackage.specialVerbType)
            setTenses(tenseList: studyPackage.tenseList)
//            print("installCurrentStudyPackage: specialVerbType = \(specialVerbType.rawValue)")
        }
//        else {
//            print("installCurrentStudyPackage: StudyPackage \(currentV2mChapter), \(currentV2mLesson) found \(v2mFound)")
//        }
        
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
//        setToVerbModelMode()
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
