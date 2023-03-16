//
//  LanguageEngineFeather.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/24/22.
//

import Foundation
import JumpLinguaHelpers

struct SimilarModelsTo {
    var targetNum : Int
    var similarModelList : [Int]
    
}

extension LanguageEngine{
    
    func setTemporaryVerbModel(verbModel: RomanceVerbModel){
        tempVerbModel = verbModel
    }
    
    func getTemporaryVerbModel()->RomanceVerbModel{
        tempVerbModel
    }
    
    func getOrderedVerbModelList()->[RomanceVerbModel]{
        return orderedVerbModelList
    }
    
    func setStudyPackage(sp: StudyPackageClass){
        studyPackage =  sp
        setTenses(tenseList: sp.tenseList)
    }
    
    func selectThisVerbModel(verbModel: RomanceVerbModel){
        computeSelectedVerbModels()
        computeCompletedVerbModels()
        
        vmecdm.setAllSelected(flag: false)
        currentVerbModel = verbModel
        currentVerbModelString = currentVerbModel.modelVerb
        vmecdm.setSelected(verbModelString: verbModel.modelVerb, flag: true)
        setToVerbModelMode()
        fillVerbCubeAndQuizCubeLists()
        trimFilteredVerbList(16)
    }
    
    func getModelName()->String{
        var modelName = ""
        var vmCount = 0
        
        let list = getSelectedVerbModelList()
        let selectedCount = list.count
        for vm in list {
            if vm.modelVerb == "regularAR" ||  vm.modelVerb == "regularER" || vm.modelVerb == "regularIR" {
                vmCount = vmCount + 1
            }
        }
        if vmCount == 3 { modelName = "Regular Verbs"}
        else {
            modelName = list[0].modelVerb
        }
//        modelName = studyPackage.name
        return modelName
    }
    
    func getVerbModels()->[RomanceVerbModel]{
        switch getCurrentLanguage(){
        case .Spanish: return spanishVerbModelConjugation.getVerbModels()
        case .French: return frenchVerbModelConjugation.getVerbModels()
        default: return [RomanceVerbModel]()
        }
    }
    
    func selectNextV2MGroup()->Bool{
        v2MGroup = v2MGroupManager.getNextV2MGroup(currentGroup: v2MGroup)
        if v2MGroup.chapter.isEmpty {return false}
        let studyPackage = convertV2MGroupToStudyPackage(v2mGroup: v2MGroup)
        setStudyPackageTo(studyPackage.chapter, studyPackage.lesson)
        return true
    }
    
    func selectNextOrderedVerbModel()->Bool{
        var allModelsCompleted = true
        
        //loop through ordered model list to find next uncompleted verb model
        
        for model in orderedVerbModelList{
            if vmecdm.isCompleted(verbModelString: model.modelVerb){
                continue
            }
            currentVerbModel = model
            vmecdm.setSelected(verbModelString: currentVerbModel.modelVerb, flag: true)
            print("selectNextOrderedVerbModel: filteredVerbList count = \(filteredVerbList.count)")
            fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList(10)
            allModelsCompleted = false
            break
        }
        return allModelsCompleted
    }
    
    func setNextVerbModelInCurrentNewVerbModelType()->RomanceVerbModel{
        let nextVerbModel = RomanceVerbModel()
        
        if verbModelsComplete(newVerbModelType: selectedNewVerbModelType){ return nextVerbModel }
            
        let selectedNewVerbModelTypeString = selectedNewVerbModelType.getTypeName()
        let currentModelList = getVerbModelGroupManager().getVerbModelSublistAtVerbEnding(modelName: selectedNewVerbModelTypeString, verbEnding: VerbEnding.ALL)
        for model in currentModelList{
            if vmecdm.isCompleted(verbModelString: model.modelVerb){ continue }
            currentVerbModel = model
            vmecdm.setSelected(verbModelString: currentVerbModel.modelVerb, flag: true)
            fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList()
            break
        }
        return nextVerbModel
    }
    
    func verbModelsComplete(newVerbModelType: NewVerbModelType)->Bool{
        return false
    }
    
    func setVerbsForCurrentVerbModel(modelID: Int){
        currentVerbModel = getModelAtID(id: modelID)
        let verbList = findVerbsOfSameModel(targetID: modelID)
        setFilteredVerbList(verbList: verbList)
    }
    
    func getCurrentVerbModel()->RomanceVerbModel{
        if selectedVerbModelList.count > 0 {
            return selectedVerbModelList[0]
        }
        return RomanceVerbModel()
    }
    
    func setCurrentVerbModel(model: RomanceVerbModel){
        selectedVerbModelList.removeAll()
        selectedVerbModelList.append(model)
//        currentVerbModel = model
    }

    func setCoreAndModelSelectedToComplete(){
        vmecdm.setAllSelectedToCompleted()
        var completedModelList = [RomanceVerbModel]()
        for veString in vmecdm.vm.getCompletedVerbModelEntityList(){
            completedModelList.append(getModelAtModelWord(modelWord: veString))
        }
        setCompletedVerbModelList(vml: completedModelList)
        setSelectedVerbModelList(vml: [RomanceVerbModel]())
    }
    
    func setSelectedNewVerbModelType(selectedType : NewVerbModelType){
        self.selectedNewVerbModelType = selectedType
    }
    
    func getSelectedNewVerbModelType()->NewVerbModelType{
        selectedNewVerbModelType
    }
    
    func setSelectedSpecialPatternType(selectedPattern : SpecialPatternType){
        self.selectedSpecialPatternType = selectedPattern
    }
    
    func getSelectedSpecialPatternType()->SpecialPatternType{
        selectedSpecialPatternType
    }
    
    func setCurrentSpecialPatternTypeList(patternList: [SpecialPatternType]){
        selectedSpecialPatternTypeList = patternList
    }
    
    func getCurrentPatternList()->[SpecialPatternType]{
        selectedSpecialPatternTypeList
    }
    
    
   
    func restoreSelectedVerbs(){
        selectedNewVerbModelType = restoreSelectedVerbType()
//        print("restoreSelectedVerbs: selectedType = \(selectedNewVerbModelType.getTypeName())")
        if selectedNewVerbModelType != .undefined {
            fillSelectedVerbModelListAndPutAssociatedVerbsInFilteredVerbList()
        }
    }
    
        
    func restoreSelectedVerbType()->NewVerbModelType{
        var nvmt = NewVerbModelType.undefined
        let vmStrList = vmecdm.vm.getSelectedVerbModelEntityStringList()
        if vmStrList.count > 0 {
            let targetStr = vmStrList[0]
            nvmt = findNewVerbTypeForVerbString(targetStr)
        }
        return nvmt
    }
    
    func computeSelectedVerbType(){
        let modelVerb = filteredVerbList[0]
        currentVerbModel = findModelForThisVerbString(verbWord: modelVerb.getWordAtLanguage(language: getCurrentLanguage()))
    }
    
    func dumpCompletedVerbModelList(_ msg: String){
        print("\(msg) --  LanguageEngine:  completed verb model list:")
        for vm in completedVerbModelList {
            print (vm.modelVerb)
        }
    }
    
    func dumpSelectedVerbModelList(_ msg: String){
        print("\(msg) --  LanguageEngine:  selected verb model list:")
        for vm in selectedVerbModelList {
            print (vm.modelVerb)
        }
    }
    
    func fillSelectedVerbModelListAndPutAssociatedVerbsinFilteredVerbListA(inputStudyPackage: StudyPackageClass){
        
//        //allow for multiple models of the same type?
//        if inputStudyPackage.preferredVerbList.isEmpty {
//            for model in selectedVerbModelList{
//                let modelVerb = findVerbFromString(verbString: model.modelVerb, language: getCurrentLanguage())
//                if ( model.modelVerb.count > 0 ){
//                    print("model verb model - \(modelVerb.getWordAtLanguage(language: getCurrentLanguage())) for model - \(model.modelVerb)")
//                    if inputStudyPackage.preferredVerbList.isEmpty {
//                        inputStudyPackage.preferredVerbList.append(modelVerb)
//                    }
//                    else {
//                        for verb in inputStudyPackage.preferredVerbList {
//                            if modelVerb == verb { continue }
//                            inputStudyPackage.preferredVerbList.append(modelVerb)
//                        }
//                    }
//                }
//            }
//        }
        
        if inputStudyPackage.preferredVerbList.count > 0 {
            setFilteredVerbList(verbList: inputStudyPackage.preferredVerbList)
            fillVerbCubeAndQuizCubeLists()
            _ = computeVerbsExistForAll3Endings()
            studyPackage = inputStudyPackage
        }
//        else {
//            var newVerbList = [Verb]()
//            if selectedVerbModelList.count > 0 {
//                for model in selectedVerbModelList{
//                    var verbCount = 0
//                    var tempVerbList = findSingletonVerbsOfSameModel(targetID: model.id)
//                    tempVerbList.shuffle()
//                    for verb in tempVerbList{
//                        verbCount += 1
//                        newVerbList.append(verb)
//                        if verbCount > maxVerbCountPerModel {
//                            break
//                        }
//                    }
//                }
//                setFilteredVerbList(verbList: newVerbList)
//                fillVerbCubeAndQuizCubeLists()
//                _ = computeVerbsExistForAll3Endings()
//                studyPackage = StudyPackageClass(name: selectedVerbModelList[0].modelVerb, verbModelStringList : [selectedVerbModelList[0].modelVerb], tenseList: [.present, .preterite, .imperfect, .conditional, .future], chapter: "", lesson: "")
//            } else {
//                filteredVerbList = verbList
//                fillVerbCubeAndQuizCubeLists()
//                studyPackage = StudyPackageClass(name: "No study package", verbModelStringList : [""], tenseList: [.present, .preterite, .imperfect, .conditional, .future], chapter: "", lesson: "")
//            }
//        }

//        var vl = getFilteredVerbs()
//        for v in vl {
//            print("vl: verb \(v.getWordAtLanguage(language: getCurrentLanguage()))")
//        }
        
    }
    
    func clearAllVerbCountsInCoreData(){
        for vm in getVerbModels(){
            vmecdm.setVerbCount(vm.modelVerb, 0)
        }
    }
    
    func setAllVerbCountsInCoreData(){
        for vm in getVerbModels(){
            let verbCount = findVerbsOfSameModel(targetID: vm.id).count
            vmecdm.setVerbCount(vm.modelVerb, verbCount)
        }
        getAllVerbCountsFromCoreData()
    }
    
    func verbCountsExistInCoreData()->Bool{
        let vm = getVerbModels()[10]
        let vc = vmecdm.getVerbCount(vm.modelVerb)
        return vc > 0
    }
    
    func getAllVerbCountsFromCoreData(){
        modelVerbCountManager.reset()
        
//        print("getAllVerbCountsFromCoreData")
        for vm in getVerbModels(){
            let count = vmecdm.getVerbCount(vm.modelVerb)
            modelVerbCountManager.append(ModelVerbCountStruct(id: vm.id, verbCount: count))
        }
//        for mvc in modelVerbCountManager.mvcList {
//            print("id: \(mvc.id) - count = \(mvc.verbCount)")
//        }
    }
    
    func getModelVerbCountAt(_ id: Int)->Int{
        modelVerbCountManager.getModelVerbCountAt(id)
    }
    
    func setAllVerbModelsIncomplete(){
        vmecdm.setAllCompleted(flag: false)
        selectedNewVerbModelType = .undefined
        filteredVerbList = verbList
        fillVerbCubeAndQuizCubeLists()
        vmecdm.setAllSelected(flag: false)
        vmecdm.setSelected(verbModelString: "regularAR", flag: true)
        vmecdm.setSelected(verbModelString: "regularER", flag: true)
        vmecdm.setSelected(verbModelString: "regularIR", flag: true)
        tenseList = studyPackage.tenseList
    }
    
    func setSelectedVerbModelsComplete(){
        vmecdm.setAllSelectedToCompleted()
        selectedNewVerbModelType = .undefined
        selectedVerbModelList = [RomanceVerbModel]()
        filteredVerbList = verbList
        fillVerbCubeAndQuizCubeLists()
    }
    
    func setAllLessonsAndModelsEmpty(){
        setAllVerbModelsIncomplete()
        currentV2mChapter = "Chapter 1A"
        currentV2mLesson = "Useful verbs"
        currentVerbModelString = "ser"
    }
    
    func getSelectedVerbModelList()->[RomanceVerbModel]{
        selectedVerbModelList
    }
    
    func setSelectedVerbModelList(vml: [RomanceVerbModel]){
        selectedVerbModelList = vml
    }
    
    func isCompleted(verbModel: RomanceVerbModel)->Bool{
        vmecdm.isCompleted(verbModelString: verbModel.modelVerb)
    }
    
    func getCompletedVerbModelList()->[RomanceVerbModel]{
        completedVerbModelList
    }
    
    func setCompletedVerbModelList(vml: [RomanceVerbModel]){
        completedVerbModelList = vml
    }
    
    func computeSelectedVerbModels(){
        var vmList = [RomanceVerbModel]()
        let vmStringList = vmecdm.vm.getSelectedVerbModelEntityStringList()
        for verbModelString in vmStringList{
            vmList.append(findModelForThisVerbString(verbWord: verbModelString))
        }
        selectedVerbModelList = vmList
        
    }
    
    func computeCompletedVerbModels(){
        var vmList = [RomanceVerbModel]()
        let vmStringList = vmecdm.vm.getCompletedVerbModelEntityStringList()
        for verbModelString in vmStringList{
            vmList.append(findModelForThisVerbString(verbWord: verbModelString))
        }
        completedVerbModelList = vmList
        
    }
    
    func computeCompletedVerbCountsForAllNewVerbModelTypes(){
        var totalCount = 0
        print("computeCompletedVerbCountsForAllNewVerbModelTypes")
        
        for nvmt in NewVerbModelType.spanishVerbModelTypes{
            let result = computeVerbCountStatisticsByNewVerbModelType(newVerbModelType: nvmt)
            totalCount += result.1
            print("\(nvmt.getTypeName()) - completed verb count \(result.1) - total \(totalCount)")
        }
    }

    
    func computeVerbCountStatisticsByNewVerbModelType(newVerbModelType: NewVerbModelType)->(Int, Int) {
        var count = 0
        var totalVerbCount = 0
        computeCompletedVerbModels()  //just to be sure
        var verbList = [Verb]()
        
        let vmList = getVerbModelGroupManager().getVerbModelList(newVerbType: newVerbModelType)
        for vm in vmList {
            verbList = findAllVerbsOfThisModel(targetID: vm.id)
            totalVerbCount += verbList.count
            if vmecdm.isCompleted(verbModelString: vm.modelVerb){
                count += verbList.count
            }
        }
        return (count, totalVerbCount - count)
    }

    func dumpSelectedAndCompletedModels(){
//        let vmStringList = vmecdm.vm.getCompletedVerbModelEntityStringList()
        print("completed model count = \(completedVerbModelList.count)")
        for vm in completedVerbModelList{
            print("completed verb model \(vm.modelVerb)")
        }
        
        print("selected model count = \(selectedVerbModelList.count)")
        for vm in selectedVerbModelList{
            print("selected verb model \(vm.modelVerb)")
        }
    }
    
    func setVerbModelEntityCoreDataManager(vmecdm: VerbModelEntityCoreDataManager){
        self.vmecdm = vmecdm
    }
    
    func getVerbModelEntityCoreDataManager()->VerbModelEntityCoreDataManager{
        vmecdm
    }
    
    func getVerbModelGroupManager()->VerbModelGroupManager{
        return verbModelGroupManager
    }
    
    func createNewVerbModelGroupAndAppend(type: NewVerbModelType, strList: [String]){
        var vmList = [RomanceVerbModel]()

        vmList.removeAll()
        for str in strList {
            vmList.append( findModelForThisVerbString(verbWord: str) )
        }
        let vmGroup = VerbModelGroup(verbModelType: type, language: getCurrentLanguage(), verbModelList: vmList)
        verbModelGroupManager.appendGroup(verbModelGroup: vmGroup)
    }
    
    func findModelForThisVerbString(verbWord: String)->RomanceVerbModel{
        switch getCurrentLanguage(){
        case .Spanish: return spanishVerbModelConjugation.getVerbModel(verbWord: verbWord)
        case .French: return frenchVerbModelConjugation.getVerbModel(verbWord: verbWord)
        default: return RomanceVerbModel()
        }
    }
    
    func countVerbsOfSelectedType(showVerbType: ShowVerbType)->Int{
        var count = 0
        for verb in verbList {
            if isVerbType(verb : verb, verbType: showVerbType) { count += 1 }
        }
        return count
    }
    
    func getVerbsForPatternGroup(patternType: SpecialPatternType)->[Verb]{
        var newVerbList = verbList
        newVerbList = getVerbsOfPattern(verbList: newVerbList, thisPattern: SpecialPatternStruct(tense: .present, spt: patternType))
        return newVerbList
    }
    
    func getVerbModelsWithVerbEnding(verbEnding: VerbEnding)->[RomanceVerbModel]{
        switch getCurrentLanguage(){
        case .Spanish:
            return spanishVerbModelConjugation.getVerbModelsWithVerbEnding(verbEnding: verbEnding)
        case .French:
            return frenchVerbModelConjugation.getVerbModelsWithVerbEnding(verbEnding: verbEnding)
        default:
            return [RomanceVerbModel]()
        }
    }
    
    func getPatternsForThisModel(verbModel: RomanceVerbModel)->[SpecialPatternStruct]{
        var tempVM = verbModel
        return tempVM.parseSpecialPatterns()
    }

    func findNewVerbTypeForVerbString(_ verbString: String)->NewVerbModelType{
        for vm in verbModelGroupManager.getVerbModelList(newVerbType: .Regular){
            if vm.modelVerb == verbString { return .Regular }
        }
        for vm in verbModelGroupManager.getVerbModelList(newVerbType: .Critical){
            if vm.modelVerb == verbString { return .Critical }
        }
        for vm in verbModelGroupManager.getVerbModelList(newVerbType: .Irregular){
            if vm.modelVerb == verbString { return .Irregular }
        }
        for vm in verbModelGroupManager.getVerbModelList(newVerbType: .StemChanging){
            if vm.modelVerb == verbString { return .StemChanging}
        }
        for vm in verbModelGroupManager.getVerbModelList(newVerbType: .SpellChanging){
            if vm.modelVerb == verbString { return .SpellChanging}
        }
        
        return .undefined
    }

    func getPatternsForGivenVerbModelTypeForThisVerbModel(verbModel: RomanceVerbModel, verbType: NewVerbModelType)->[SpecialPatternType]{
        var vm = verbModel
        var sptList = [SpecialPatternType]()
        for pattern in vm.specialPatternList {
            let sps = vm.parseSpecialPattern(tenseStr: pattern.tenseStr, patternStr: pattern.patternStr)
            switch verbType {
            case .StemChanging:  if sps.pattern.isStemChangingPresentSpanish() {sptList.append(sps.pattern)}
            case .SpellChanging: if sps.pattern.isOrthoChangingSpanish() { sptList.append(sps.pattern) }
            case .Irregular: return sptList
            case .Regular:  return sptList
            case .Critical: return sptList
            case .LikeGustar: return sptList
            case .undefined: return sptList
            case .ALL:
                return sptList
            }
        }
        return sptList
    }
    
//    func fillVerbModelLists(targetTense: Tense = .present){
//        var stemChangingList = [RomanceVerbModel]()
//        var spellChangingList = [RomanceVerbModel]()
//        var irregularModelList = [RomanceVerbModel]()
//        var i_pretCount = 0
//
////        var vmg = VerbModelGroup()
//        switch getCurrentLanguage() {
//        case .Spanish:
//            let vmList = getVerbModels()
//            for vm in getVerbModels(){
//                var verbModel = vm
//                for pattern in verbModel.specialPatternList {
//                    let spt = verbModel.parseSpecialPattern(tenseStr: pattern.tenseStr, patternStr: pattern.patternStr)
//
//                    if pattern.tenseStr == Tense.present.rawValue || pattern.tenseStr == Tense.presentSubjunctive.rawValue {
//                        if spt.pattern.isStemChangingPresentSpanish() {
//                            stemChangingList.append(verbModel)
//                        }
//                        if spt.pattern.isOrthoChangingSpanish() {
//                            spellChangingList.append(verbModel)
//                        }
//                        if spt.pattern.isIrregularSpanish() {
//                            irregularModelList.append(verbModel)
//                        }
//                    }
//                    else if pattern.tenseStr == Tense.preterite.rawValue {
//                        if spt.pattern.isIrregularSpanish() {
//                            irregularModelList.append(verbModel)
//
////                            if spt.pattern == .i_pret {
////                                i_pretCount = i_pretCount + 1
////                                print("verb model \(verbModel.modelVerb) has i_pret pattern")
////                            }
//                        }
//
//                    }
//                    else if pattern.tenseStr == Tense.conditional.rawValue {
//                        if spt.pattern.isIrregularSpanish() {
//                            irregularModelList.append(verbModel)
//                        }
//                    }
//                }
//            }
//            verbModelGroupManager.appendGroup(verbModelGroup: VerbModelGroup(verbModelType: .StemChanging, language: getCurrentLanguage(), verbModelList: stemChangingList))
//            verbModelGroupManager.appendGroup(verbModelGroup: VerbModelGroup(verbModelType: .SpellChanging, language: getCurrentLanguage(), verbModelList: spellChangingList))
//            verbModelGroupManager.appendGroup(verbModelGroup: VerbModelGroup(verbModelType: .Irregular, language: getCurrentLanguage(), verbModelList: irregularModelList))
//
//            print("fillVerbModelLists:")
//            print("stem changing list count = \(verbModelGroupManager.getVerbModelList(newVerbType: .StemChanging).count)")
//            print("spell changing list count = \(verbModelGroupManager.getVerbModelList(newVerbType: .SpellChanging).count)")
//            print("spell changing list count = \(verbModelGroupManager.getVerbModelList(newVerbType: .Irregular).count)")
//            print("i_pretCount = \(i_pretCount)")
//        case .French:
////            for vm in getVerbModels(){
////                var verbModel = vm
////                for pattern in verbModel.specialPatternList {
////                    var spt = verbModel.parseSpecialPattern(tenseStr: pattern.tenseStr, patternStr: pattern.patternStr)
////                    if spt.pattern.isStemChangingFrench() { stemChangingModelList.append(verbModel) }
////                }
////            }
//            break
//        default:
//            break
//        }
//    }
    
    
    func getModelsOfPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[RomanceVerbModel]{
        switch getCurrentLanguage() {
        case .Spanish:
            return spanishVerbModelConjugation.getVerbModelsThatHavePattern(inputPatternStruct: thisPattern)
        case .French:
            break
        default:
            break
        }
        return [RomanceVerbModel]()
    }
    
    func getModelIdsOfPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[Int]{
        switch getCurrentLanguage() {
        case .Spanish:
            return  spanishVerbModelConjugation.getVerbModelIDsThatHavePattern(inputPatternStruct: thisPattern)
        case .French:
            break
        default:
            break
        }
        return [Int]()
    }
    
    func getVerbsOfPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[Verb]{
        var newVerbList = [Verb]()
//        var targetTense = thisPattern.tense
//        var targetPattern = thisPattern.pattern
        
        var vmm = VerbModelManager()
        for verb in verbList {
            switch getCurrentLanguage() {
            case .Spanish:
                let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
                let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
                let id = bSpanishVerb.getBescherelleID()
//                print("verb: \(verbWord) - specialPattern count = \(bSpanishVerb.m_specialPatternList.count)")
                for spt in bSpanishVerb.m_specialPatternList {
                    let tense = spt.tense
                    let pattern = spt.pattern
                    if spt.tense == thisPattern.tense && spt.pattern.rawValue == thisPattern.pattern.rawValue {
                        newVerbList.append(verb)
//                        print("verb: \(verbWord) - has tense \(tense.rawValue), pattern \(pattern.rawValue) ")
//                        print("verb: \(verbWord) - has tense \(tense.rawValue), pattern \(pattern.rawValue), targetPattern: \(thisPattern.pattern.rawValue), modelID = \(id) ")
                    }
                }
            case .French:
                let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
                let bFrenchVerb = vmm.createFrenchBVerb(verbPhrase: verbWord)
                for spt in bFrenchVerb.m_specialPatternList {
                    if spt.tense == thisPattern.tense && spt.pattern.rawValue == thisPattern.pattern.rawValue { newVerbList.append(verb) }
                }
            default:
                break
            }
        }

        return newVerbList
    }
    
    func getVerbsOfDifferentPattern(verbList: [Verb], thisPattern: SpecialPatternStruct)->[Verb]{
        var newVerbList = [Verb]()

        var vmm = VerbModelManager()
        for verb in verbList {
            switch getCurrentLanguage() {
            case .Spanish:
                let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
                let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
                let id = bSpanishVerb.getBescherelleID()
                for spt in bSpanishVerb.m_specialPatternList {
                    let tense = spt.tense
                    let pattern = spt.pattern
                    if spt.tense == thisPattern.tense && spt.pattern.rawValue != thisPattern.pattern.rawValue {
                        newVerbList.append(verb)
                        print("getVerbsOfDifferentPattern: verb: \(verbWord) - has tense \(tense.rawValue), pattern \(pattern.rawValue), targetPattern: \(thisPattern.pattern.rawValue), modelID = \(id) ")
                    }
                }
            case .French:
                let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
                let bFrenchVerb = vmm.createFrenchBVerb(verbPhrase: verbWord)
                for spt in bFrenchVerb.m_specialPatternList {
                    if spt.tense == thisPattern.tense && spt.pattern.rawValue != thisPattern.pattern.rawValue { newVerbList.append(verb) }
                }
            default:
                break
            }
        }

        return newVerbList
    }
    
    func getVerbsOfDifferentPattern(verbList: [Verb], targetModelID: Int)->[Verb]{
        var newVerbList = [Verb]()
        for verb in verbList {
            let rv = getRomanceVerb(verb: verb)
            let id = rv.getBescherelleID()
            if id != targetModelID {
                newVerbList.append(verb)
            }
        }
        return newVerbList
    }
    
    func getPatternsForVerb(verb: Verb, tense: Tense)->[SpecialPatternStruct]{
        var targetPatternStructList = [SpecialPatternStruct]()
        var vmm = VerbModelManager()
        switch getCurrentLanguage() {
        case .Spanish:
            let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
            let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
            if bSpanishVerb.m_specialPatternList.count > 0 {
                for spStruct in bSpanishVerb.m_specialPatternList {
                    if spStruct.tense == tense { targetPatternStructList.append(spStruct)}
                }
            }
        case .French:
            let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
            let bFrenchVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
            if bFrenchVerb.m_specialPatternList.count > 0 {
                for spStruct in bFrenchVerb.m_specialPatternList {
                    if spStruct.tense == tense { targetPatternStructList.append(spStruct)}
                }
            }
        default: break
        }
        return targetPatternStructList
    }
    
    func findVerbsFromSamePatternsAsVerb(verb: Verb, tense: Tense)->[Verb]{
        var newVerbList = [Verb]()
        let patternStructList = getPatternsForVerb(verb: verb, tense: tense)
        
        newVerbList = verbList
        for spt in patternStructList {
            newVerbList = getVerbsOfPattern(verbList: newVerbList, thisPattern: spt)
        }
        return newVerbList
    }
    
    func getVerbsOfSamePattern(verbList: [Verb], targetModelID: Int)->[Verb]{
        var newVerbList = [Verb]()
        for verb in verbList {
            let rv = getRomanceVerb(verb: verb)
            let id = rv.getBescherelleID()
            if id == targetModelID {
                newVerbList.append(verb)
            }
        }
        return newVerbList
    }
    
    func showSpecialPatterns(newVerbList: [Verb]){
        var vmm = VerbModelManager()
        for verb in newVerbList {
            switch getCurrentLanguage() {
            case .Spanish:
                let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
                let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
                if bSpanishVerb.m_specialPatternList.count > 0 {
                    for spt in bSpanishVerb.m_specialPatternList {
                        print("verb: \(verbWord) --> \(spt.tense.rawValue) ... \(spt.pattern.rawValue)")
                    }
                }
            case .French:
                let verbWord = verb.getWordAtLanguage(language: getCurrentLanguage())
                let bFrenchVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
                if bFrenchVerb.m_specialPatternList.count > 0 {
                    for spt in bFrenchVerb.m_specialPatternList {
                        print("verb: \(verbWord) --> \(spt.tense.rawValue) ... \(spt.pattern.rawValue)")
                    }
                }
            default: break
            }
        }
    }

    //ignores the model
    
    func conjugateAsRegularVerb(verb: Verb, tense: Tense, person: Person, isReflexive: Bool, residPhrase: String)->String{
        switch getCurrentLanguage() {
        case .English:
            break
        case .Spanish:
            let spVerb = SpanishVerb(word: verb.spanish, type: .normal)
            var verbString = spVerb.conjugateAsRegularVerb(tense: tense, person: person)
            if isReflexive {
                let pronoun = SpanishPronoun().getReflexive(person: person)
                if pronoun.count>0 {
                    verbString = pronoun + " " + verbString
                }
            }
            if ( residPhrase.count > 0 ){
                verbString += " " + residPhrase
            }
            return verbString
        case .French:
            let frVerb = FrenchVerb(word: verb.french, type: .normal)
            var verbString = frVerb.conjugateAsRegularVerb(tense: tense, person: person)
            if isReflexive {
                let startsWithVowelSound =  VerbUtilities().startsWithVowelSound(characterArray: verbString)
                let pronoun = FrenchPronoun().getReflexive(person: person, startsWithVowelSound: startsWithVowelSound)
                if startsWithVowelSound {
                    verbString = pronoun + verbString
                } else {
                    verbString = pronoun + " " + verbString
                }
            }
            
            if ( residPhrase.count > 0 ){
                verbString += " " + residPhrase
            }
            return verbString
        case .Italian:
            break
        case .Portuguese:
            break
        case .Agnostic:
            break
        }
        return ""
    }
    //bruñir
    
    func conjugateAsRegularVerbWithThisVerbEnding(verbEnding: VerbEnding, verb: Verb, tense: Tense, person: Person)->String{
        switch getCurrentLanguage() {
        case .English:
            break
        case .Spanish:
            let spVerb = SpanishVerb(word: verb.spanish, type: .normal)
            return spVerb.conjugateAsRegularVerbWithThisVerbEnding(verbEnding: verbEnding,tense: tense, person: person)
        case .French:
            let frVerb = FrenchVerb(word: verb.french, type: .normal)
            return frVerb.conjugateAsRegularVerbWithThisVerbEnding(verbEnding: verbEnding, tense: tense, person: person)
        case .Italian:
            break
        case .Portuguese:
            break
        case .Agnostic:
            break
        }
        return ""
    }
    
    func getModelsWithVerbEnding(verbEnding: VerbEnding)->[RomanceVerbModel]{
        switch getCurrentLanguage() {
        case .Spanish:
            return spanishVerbModelConjugation.getVerbModelsWithVerbEnding(verbEnding: verbEnding)
        case .French:
            return frenchVerbModelConjugation.getVerbModelsWithVerbEnding(verbEnding: verbEnding)
        default:
            break
        }
        return [RomanceVerbModel]()
    }
    
    func getModelsWithSameVerbEndingInModelList(verbEnding: VerbEnding, modelList: [RomanceVerbModel])->[RomanceVerbModel]{
        var verbEndingModelList = [RomanceVerbModel]()
        var tempList = [RomanceVerbModel]()
        
        //first find all models with the target verb ending
        switch getCurrentLanguage() {
        case .Spanish:
            tempList =  spanishVerbModelConjugation.getVerbModelsWithVerbEnding(verbEnding: verbEnding)
        case .French:
            tempList =  frenchVerbModelConjugation.getVerbModelsWithVerbEnding(verbEnding: verbEnding)
        default:
            break
        }
        
        //next, find only those models that are also on the input model list
        for model in modelList {
            for veModel in tempList {
                if veModel.id == model.id {
                    verbEndingModelList.append(model)
                    break
                }
            }
        }
        return verbEndingModelList
    }
    
    func getBescherelleID(verb: Verb)->Int{
        let brv = createAndConjugateAgnosticVerb(verb: verb)
        return brv.getBescherelleID()
    }
    
    func verbsOfAFeather(verbList: [Verb])->Bool {
        let targetID = getRomanceVerb(verb: verbList[0]).getBescherelleID()
        for v in verbList {
            let rv = getRomanceVerb(verb: v)
            let id = rv.getBescherelleID()
            if id != targetID { return false }
        }
        return true
    }
    
    func findVerbsOfSameModel(modelID: Int, inputVerbList: [Verb])->[Verb]{
        var vList = [Verb]()
        for v in inputVerbList {
            let vID = getBescherelleID(verb: v)
            if vID == modelID {
                vList.append(v)
            }
        }
        return vList
    }
    
    func findVerbsOfDifferentModel(modelID: Int, inputVerbList: [Verb])->[Verb]{
        var vList = [Verb]()
        for v in inputVerbList {
            let vID = getBescherelleID(verb: v)
            if vID != modelID {
                vList.append(v)
            }
        }
        return vList
    }
    
    func findVerbsOfSameModel(targetID: Int)->[Verb]{
        var vList = [Verb]()
        var newVerb = false
        for v in verbList {
            newVerb = true
                let rv = getRomanceVerb(verb: v)
            if rv.m_verbWord.count > 0 {
                let id = rv.getBescherelleID()
                if id == targetID {
                    //make sure this verb hasn't been seen before
                    for vv in vList {
                        if vv == v { newVerb = false }
                    }
                    if newVerb{ vList.append(v) }
                }
            }
        }
        return vList
    }
    
    func findSingletonVerbsOfSameModel(targetID: Int)->[Verb]{
        let vu = VerbUtilities()
        var vList = [Verb]()
        var newVerb = false
        for v in verbList {
            newVerb = true
            let rv = getRomanceVerb(verb: v)
            let id = rv.getBescherelleID()
            if id == targetID {
                if vu.getListOfWords(characterArray: rv.m_verbPhrase).count < 2 {
                    //make sure this verb hasn't been seen before
                    for vv in vList {
                        if vv == v { newVerb = false }
                    }
                    if newVerb{ vList.append(v) }
                }
            }
        }
        return vList
    }
    
    func findAllVerbsOfThisModel(targetID: Int)->[Verb]{
//        var vu = VerbUtilities()
        var vList = [Verb]()
        var newVerb = false
        for v in verbList {
            newVerb = true
            let rv = getRomanceVerb(verb: v)
            let id = rv.getBescherelleID()
            if id == targetID {
                //make sure this verb hasn't been seen before
                for vv in vList {
                    if vv == v { newVerb = false }
                }
                if newVerb{ vList.append(v) }
            }
        }
        return vList
    }
    
    
    func findVerbsFromSameModel(verb: Verb)->[Verb]{
        
        //this should always return at least one verb (itself)
        var vList = [Verb]()
        let targetID = getRomanceVerb(verb: verb).getBescherelleID()
        var newVerb = false
        for v in verbList {
            newVerb = true
            let rv = getRomanceVerb(verb: v)
            if rv.m_verbWord.count > 0 {
                let id = rv.getBescherelleID()
                if id == targetID {
                    //make sure this verb hasn't been seen before
                    for vv in vList {
                        if vv == v { newVerb = false }
                    }
                    if newVerb{ vList.append(v)    }
                }
            }
            else {
                print ("Rejected: findVerbsLike: verb: \(v.spanish), \(v.french), \(v.english) is illegal")
            }
        }
        return vList
    }
    
    func getRandomEnglishVerbs(maxCount: Int)->[Verb]{
        var newVerbList = verbList
        newVerbList.shuffle()

        if newVerbList.count > maxCount {
            let verbCount = newVerbList.count
            newVerbList.removeLast(verbCount-maxCount)
        }
        return newVerbList
    }
    
    //returns the part of the verb that is actually affected by model morphing
    //  for example, "seguir" will return "eguir" - because seguir -> sigo
    
    func getModelStringAtTensePerson(bVerb: BRomanceVerb, tense: Tense, person: Person)->(String, String){
        let finalForm = conjugateRomanceVerb(bVerb: bVerb, tense: tense, person: person)
        let infinitive = bVerb.m_verbWord
        let vu = VerbUtilities()
        var matchIndex = 0
        
        let minCharCount = min(infinitive.count, finalForm.count)
        for i in 0..<minCharCount {
            let str1 = vu.getStringCharacterAt(input: infinitive, charIndex: i)
            let str2 = vu.getStringCharacterAt(input: finalForm, charIndex: i)
            if  str1 != str2 {
                break
            }
            matchIndex = i
        }
        let removeCount = infinitive.count - matchIndex - 1
        var rootString = infinitive
        rootString.removeLast(removeCount)
        var modelString = infinitive
        modelString.removeFirst(matchIndex+1)
        return (rootString, modelString)
    }
    
    func getCommonVerbModelList()->[RomanceVerbModel]{
        var rvmList = [RomanceVerbModel]()
        var rvm = RomanceVerbModel()
        
        switch getCurrentLanguage() {
        case .Spanish:
            let idList = [21, 38, 32, 53, 54, 55, 72 ]
            for id in idList {
                rvm = spanishVerbModelConjugation.getVerbModelAtModelId(targetID: id)
                if rvm.id > 0 { rvmList.append(rvm) }
            }
        case .French:
            let idList = [81, 123, 118, 125]
            for id in idList {
                rvm = frenchVerbModelConjugation.getVerbModelAtModelId(targetID: id)
                if rvm.id > 0 { rvmList.append(rvm) }
            }
            break
        default:
            break
        }
        return rvmList
    }
    
    func getRegularVerbModelList()->[RomanceVerbModel]{
        var rvmList = [RomanceVerbModel]()
        var rvm = RomanceVerbModel()
        
        switch getCurrentLanguage() {
        case .Spanish:
            let idList = [5, 6, 7]
            for id in idList {
                rvm = spanishVerbModelConjugation.getVerbModelAtModelId(targetID: id)
                if rvm.id > 0 { rvmList.append(rvm) }
            }
        case .French:
            let idList = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79 ]
            for id in idList {
                rvm = frenchVerbModelConjugation.getVerbModelAtModelId(targetID: id)
                if rvm.id > 0 { rvmList.append(rvm) }
            }
            break
        default:
            break
        }
        return rvmList
    }
    
    
    func getModelAtID(id: Int)->RomanceVerbModel{
        switch getCurrentLanguage() {
        case .Spanish:
            return spanishVerbModelConjugation.getVerbModelAtModelId(targetID: id)
        case .French:
            return frenchVerbModelConjugation.getVerbModelAtModelId(targetID: id)
        default:
            return RomanceVerbModel()
        }
    }
    
    func getModelAtModelWord(modelWord:String)->RomanceVerbModel{
        switch getCurrentLanguage() {
        case .Spanish:
            return spanishVerbModelConjugation.getVerbModelAtModelVerb(targetVerb: modelWord)
        case .French:
            return frenchVerbModelConjugation.getVerbModelAtModelVerb(targetVerb: modelWord)
        default:
            return RomanceVerbModel()
        }
    }
//    func getRandomFeatherVerb()->Verb{
//        var vList = getFilteredVerbs()
//        vList.shuffle()
//        return vList[0]
//    }
}
