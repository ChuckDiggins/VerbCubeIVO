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
    func getVerbModels()->[RomanceVerbModel]{
        switch getCurrentLanguage(){
        case .Spanish: return spanishVerbModelConjugation.getVerbModels()
        case .French: return frenchVerbModelConjugation.getVerbModels()
        default: return [RomanceVerbModel]()
        }
    }
    
    func setVerbsForCurrentVerbModel(modelID: Int){
        currentVerbModel = getModelAtID(id: modelID)
        let verbList = findVerbsOfSameModel(targetID: modelID)
        setFilteredVerbList(verbList: verbList)
    }
    
    
    func getCurrentVerbModel()->RomanceVerbModel{
        return currentVerbModel
    }
    
    func setCurrentVerbModel(model: RomanceVerbModel){
        currentVerbModel = model
    }
    
    func getVerbModelEntityCoreDataManager()->VerbModelEntityCoreDataManager{
        return vmecdm
    }
    
    func getVerbModelGroupManager()->VerbModelGroupManager{
        return verbModelGroupManager
    }
    
    func loadVerbModelManager(){
        let regularStringList = ["regularAR", "regularER", "regularIR"]
        createVerbModelGroupAndAppend(type: .regular, strList: regularStringList)
        let criticalStringList = ["estar", "haber", "hacer", "ir", "oír", "reír", "saber", "ser", "ver" ]
        createVerbModelGroupAndAppend(type: .critical, strList: criticalStringList)
        let specialStringList = ["andar", "abrir", "conocer", "dar", "decir", "dormir",
                                   "jugar", "pensar", "poder", "poner",
                                 "querer", "salir", "seguir", "tener", "traer", "venir", "volver" ]
        createVerbModelGroupAndAppend(type: .special, strList: specialStringList)
        let importantStringList = ["airar", "averiguar", "cazar", "encontrar", "enraizar", "pagar", "regar", "sacar",
                                    "caer", "cocer", "coger", "creer", "defender", "empezar", "mover", "parecer",
                                   "adquirir", "bruñir", "dirigir", "influir", "lucir",
                                    "pedir", "predecir", "producir", "sentir"]
        createVerbModelGroupAndAppend(type: .important, strList: importantStringList)
        let sparseStringList = ["actuar", "ahincar", "asir", "aullar", "avergonzar", "caber",
                             "cocer", "colgar", "delinquir", "desosar", "discernir", "distinguir", "elegir",
                             "erguir", "errar", "forzar", "guiar", "llover", "mecer", "oler",
                             "placer", "podrir", "prohibir", "raer", "regar", "reñir", "reunir",
                             "roer", "satisfacer", "soler", "tañer", "trocar", "valer", "yacer", "zurcir",  ]
        createVerbModelGroupAndAppend(type: .sparse, strList: sparseStringList)
    }
    
    func createVerbModelGroupAndAppend(type: VerbModelType, strList: [String]){
        var vmList = [RomanceVerbModel]()
    
        
        
        vmList.removeAll()
        for str in strList {
            vmList.append( findModelForThisVerbString(verbWord: str) )
        }
        let vmGroup = VerbModelGroup(verbModelType: type, language: getCurrentLanguage(), verbModelList: vmList)
        verbModelGroupManager.appendGroup(verbModelGroup: vmGroup)
    }
    
    func loadSpanishModelListsForEachVerbEnding(){
        let endingList = [VerbEnding.AR, .ER, .IR]
        var modelDictionary: [String: Int] = [:]
        
        for ending in endingList {
            var verbEndingModelList = getModelsWithVerbEnding(verbEnding: ending)
            
            //sort the verbEndingModelList by verb counts
            
            for model in verbEndingModelList {
                let verbList = findVerbsOfSameModel(targetID: model.id)
                modelDictionary.updateValue(verbList.count, forKey: model.modelVerb)
            }
            let sortInfo = modelDictionary.sorted(by: { $0.value > $1.value } )
            
            var tempList = [ModelPatternStruct]()
            sortInfo.forEach {key, value in
                print(key)
                for model in verbEndingModelList {
                    if model.modelVerb == "\(key)" {
                        tempList.append(ModelPatternStruct(id: model.id, model: model, count: value, completed: false))
                        break
                    }
                }
            }
            
            switch ending {
            case .AR: mpsListAR = tempList
            case .ER: mpsListER = tempList
            case .IR: mpsListIR = tempList
            default: break
            }
            
        }
        
        print("model counts AR: \(mpsListAR.count), ER: \(mpsListER.count), IR: \(mpsListIR.count)")
    }
    
    func getModelList(ending: VerbEnding)->[RomanceVerbModel]{
        switch ending {
        case .AR:  return modelListAR
        case .ER: return modelListER
        case .IR: return modelListIR
        default: return modelListAR
        }
    }
    
    func getModelPatternStructList(ending: VerbEnding)->[ModelPatternStruct]{
        switch ending {
        case .AR: return mpsListAR
        case .ER: return mpsListER
        case .IR: return mpsListIR
        default: return mpsListAR
        }
    }
    
    func setCurrentPattern(pattern: SpecialPatternType){
        currentPattern = pattern
    }
    
    func getCurrentPattern()->SpecialPatternType{
        return currentPattern
    }
    
    func findModelForThisVerbString(verbWord: String)->RomanceVerbModel{
        switch getCurrentLanguage(){
        case .Spanish: return spanishVerbModelConjugation.getVerbModel(verbWord: verbWord)
        case .French: return frenchVerbModelConjugation.getVerbModel(verbWord: verbWord)
        default: return RomanceVerbModel()
        }
    }
    
    
//    func setSimilarModels(){
//        let encontrarSimilarModel = SimilarModelsTo(targetNum: 58, similarModelList: [56, 53, 35])
//        let pedirSimilarModel = SimilarModelsTo(targetNum: 55, similarModelList: [35, 75, 61])
//    }
//    
//    func getModelsAroundGivenPattern(patternType: SpecialPatternType)->[Int]{
//        var modelList = [Int]()
//        return modelList
//    }
//    
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
                        print("verb: \(verbWord) - has tense \(tense.rawValue), pattern \(pattern.rawValue), targetPattern: \(thisPattern.pattern.rawValue), modelID = \(id) ")
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
                        print("verb: \(verbWord) - has tense \(tense.rawValue), pattern \(pattern.rawValue), targetPattern: \(thisPattern.pattern.rawValue), modelID = \(id) ")
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
        for i in 0..<infinitive.count {
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
