//
//  LanguageEngine.swift
//  LanguageEngine
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import JumpLinguaHelpers
//import RealmSwift

//enum  TeachMeMode : String {
//    case model, pattern
//}

enum  VerbOrModelMode : String {
   case verbMode = "Verb Mode"
   case modelMode = "Model Mode"
}

struct StudyPackageData {
    var name = ""
    var title = ""
    var lesson = ""
}

class LanguageEngine : ObservableObject, Equatable {
    static func == (lhs: LanguageEngine, rhs: LanguageEngine) -> Bool {
        return lhs.currentLanguage.rawValue == rhs.currentLanguage.rawValue
    }
    @AppStorage("V2MChapter") var currentV2mChapter = "nada 2"
    @AppStorage("V2MLesson") var currentV2mLesson = "nada 3"
    
    var vmecdm = VerbModelEntityCoreDataManager()
    @Published private var currentLanguage = LanguageType.Agnostic
    @Published var filteredVerbList = [Verb]()
    var orderedVerbModelList = [RomanceVerbModel]()

    var selectedNewVerbModelType = NewVerbModelType.Regular
    var selectedSpecialPatternType = SpecialPatternType.c2z
    var studyPackage = StudyPackageClass()
    var studyPackageManagerList = [StudyPackageManager]()
    var studyPackageData = StudyPackageData()
    var v2MGroupManager = VerbToModelGroupManager()
    var v2MGroup = VerbToModelGroup()
    var specialVerbType = SpecialVerbType.normal
    var verbOrModelMode = VerbOrModelMode.modelMode
    
    private var currentVerb = Verb()
    private var currentTense = Tense.present
    private var currentPerson = Person.S1
    private var morphStructManager = MorphStructManager(verbPhrase: "", tense: .present)
    
    private var currentVerbIndex = 0
    private var currentTenseIndex = 0
    private var currentPersonIndex = 0
    
    private var tenseManager = TenseManager()
    
    var simpleTenseList = [Tense.present, .preterite, .imperfect, .conditional, .presentSubjunctive, .imperfectSubjunctiveSE, .imperative]
    @Published var  tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    var verbList = [Verb]()
    
    var currentFilteredVerbIndex = 0

    var behavioralVerbModel = BehavioralVerbModel()
    var criticalVerbForms = CriticalVerbForms()
    private var verbModelConjugation : VerbModelConjugation!
    var spanishVerbModelConjugation = RomanceVerbModelConjugation(language: .Spanish)
    var frenchVerbModelConjugation = RomanceVerbModelConjugation(language: .French)
    var englishVerbModelConjugation = EnglishVerbModelConjugation()

    var lessonBundlePhraseCollectionManager : LessonBundlePhraseCollectionManager!
//    var m_randomSentence : RandomSentence!
    var m_randomSentence : FeatherSentenceHandler!
    private var m_randomWordLists : RandomFeatherWordLists!
    
//    var m_jsonDictionaryManager = JSONDictionaryManager()
    private var jsonDictionaryManager = JSONVerbPronounDictionaryManager()
    
    var m_jsonVerbModelManagerAR = JsonVerbModelManager()
    var m_jsonVerbModelManagerER = JsonVerbModelManager()
    var m_jsonVerbModelManagerIR = JsonVerbModelManager()
    
    private var verbModelManager = VerbModelManager()
    var subjectPronounType = SubjectPronounType.maleInformal
    var m_wsp : WordStringParser!
    
    var startingVerbCubeListIndex = 0
    var verbCubeVerbIndex = 0
    var behavioralVerbIndex = 0
    var behaviorType = BehaviorType.likeGustar
    var behaviorVerbList = [Verb]()
    
    @Published var verbCubeList = [Verb]()
    var verbBlockCount: Int = 6
    var verbCubeBlockIndex = 0
    var verbCubeBlock = [Verb(), Verb(), Verb(), Verb(), Verb(), Verb()]
    var quizCubeBlock = [Verb]()
    @Published var quizCubeVerbList = [Verb]()
    @Published var quizCubeVerb = Verb()
    var quizCubeTense = Tense.present
    var quizCubePerson = Person.S1
    
    var quizTenseList = [Tense.present, .preterite, .imperfect, .future, .conditional]
    var quizCubeConfiguration = ActiveVerbCubeConfiguration.PersonVerb
    var quizCubeDifficulty = QuizCubeDifficulty.easy
    
    
    var currentVerbPattern = SpecialPatternStruct(tense: .present, spt: .none )
    var studentScoreModel = StudentScoreModel()
    var flashCardMgr = FlashCardManager()
    var currentRandomVerb = Verb()
    var useSpeechMode = false
    
    var verbModelGroupManager = VerbModelGroupManager()
    
//    var generalVerbModelFlag = false
//    var criticalVerbModelFlag = false
    var currentVerbModel = RomanceVerbModel()
    var selectedVerbModelList = [RomanceVerbModel]()
    var completedVerbModelList = [RomanceVerbModel]()
    
    var selectedSpecialPatternTypeList = [SpecialPatternType]()
    
    var verbsExistForAll3Endings = true  //initially all verbs are live

//    let regularStringList = ["regularAR", "regularER", "regularIR"]
//    let criticalStringList = ["estar", "haber", "hacer", "ir", "oír", "reír", "saber", "ser", "ver" ]

    init(){  //default init
    }
 
    init(language: LanguageType) {   //real init
        
        currentLanguage = language
        
//        realm = try! Realm()
        
        verbModelConjugation = VerbModelConjugation(currentLanguage: currentLanguage)
        m_wsp = WordStringParser(language: currentLanguage,
                                      span: spanishVerbModelConjugation,
                                      french: frenchVerbModelConjugation,
                                      english: englishVerbModelConjugation)
        
        
        
        loadWordDictionariesFromJSON()
        m_wsp.getWordCounts()
        
       
        
        createVerbList()
        
        initializeCriticalForms()
        
        filteredVerbList = verbList
  
        //set for initial verb model learning
        
        loadInitialVerbModel()
        if vmecdm.vm.getVerbModelEntityCount() < getVerbModels().count {
            reloadModelVerbEntitiesWithModelVerbs()
        }
        print("VerbCubeList 1:\(verbCubeList.count) verbs")
        fillVerbCubeAndQuizCubeLists()
        print("VerbCubeList 2:\(verbCubeList.count) verbs")
//        loadVerbModelManager()
//        fillVerbModelLists()  //fills regular, critical, etc.  obsolete
        createOrderedModelList()
       
        restoreSelectedVerbs()
        restoreV2MPackage()
        
        resetFeatherSentenceHandler()
        
        
//        dumpSelectedAndCompletedModels()
        
//        dumpModelStuff()
//        fillSimpleFlashCardProblem()
//        initializeStudentScoreModel()
    }
    
    func dumpModelStuff(){
        var model = findModelForThisVerbString(verbWord: "oír")
        print("languageEngine: oír - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "defender")
        print("languageEngine: xyzoír - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "conocer")
        print("languageEngine: conocer - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "comprar")
        print("languageEngine: comprar - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "cortar")
        print("languageEngine: cortar - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "deber")
        print("languageEngine: deber - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "encarbronar")
        print("languageEngine: encarbronar - modelVerb \(model.modelVerb)")
        model = findModelForThisVerbString(verbWord: "regularER")
        print("languageEngine: regularER - modelVerb \(model.modelVerb)")
        
        let verbStr = "parecer"
        print("languageEngine: \(verbStr) ... \(findNewVerbTypeForVerbString(verbStr).getTypeName())")
        
        
    }
    
    func getRandomTense()->Tense{
        tenseManager.getRandomTense()
    }
    
    func setRandomTense(){
        currentTense = tenseManager.getRandomTense()
    }
    
    func getRandomPerson()->Person{
        let pList = Person.all
        let i = Int.random(in: 0 ..< pList.count)
        return pList[i]
    }
    
    func getRandomSentenceObject()->FeatherSentenceHandler{
        m_randomSentence
    }
    
    // MARK: getVerbString
    
    func getVerbString(personIndex: Int, number: Number, tense: Tense, specialVerbType: SpecialVerbType, verbString: String, dependentVerb: Verb, residualPhrase: String)->String{
        var msm = morphStructManager
        switch specialVerbType{
        case .normal:
            return  msm.getFinalVerbForm(person: Person.all[personIndex]) + residualPhrase
        case .verbsLikeGustar:
            let vu = VerbUtilities()
            let verbStartsWithVowel = vu.startsWithVowelSound(characterArray: verbString)
            var p = Person.S3
            if number == .plural { p = Person.P3}
            let verbString = msm.getFinalVerbForm(person: p)
            return Person.all[personIndex].getIndirectObjectPronounString(language: currentLanguage, verbStartsWithVowel: verbStartsWithVowel) + " " + verbString + residualPhrase
        case .weatherAndTime:
            if personIndex == 2 { return msm.getFinalVerbForm(person: Person.all[personIndex])}
            else {return ""}
        case .ThirdPersonOnly:
            if personIndex == personIndex || personIndex == 5 {
                return msm.getFinalVerbForm(person: Person.all[personIndex])
            }
            return ""
        case .auxiliaryVerbsInfinitives, .auxiliaryVerbsGerunds:
            var verbString = msm.getFinalVerbForm(person: Person.all[personIndex])
            let result = isAuxiliary(verb: currentVerb)
            if result.1 == .infinitive {
                verbString += " " + dependentVerb.getWordAtLanguage(language: currentLanguage)
            } else if result.1 == .gerund {
                let bRomanceVerb = getRomanceVerb(verb: dependentVerb)
                verbString += " " + bRomanceVerb.m_gerund
            } else if result.1 == .pastParticiple {
                let bRomanceVerb = getRomanceVerb(verb: dependentVerb)
                verbString += " " + bRomanceVerb.m_pastParticiple
            }
            return verbString + residualPhrase
        case .defective:
            if personIndex == personIndex || personIndex == 5 {
                return msm.getFinalVerbForm(person: Person.all[personIndex])
            }
            return ""
        }
    }
 

    func getPersonString(personIndex: Int, tense: Tense, specialVerbType: SpecialVerbType, verbString: String)->String{
        let vu = VerbUtilities()
        let verbStartsWithVowel = vu.startsWithVowelSound(characterArray: verbString)
        var subjunctiveWord = ""
        if currentTense.isSubjunctive() {
            if currentLanguage == .French { subjunctiveWord = "qui "}
            else {subjunctiveWord = "Ojalá que "}
        }
        
        switch specialVerbType{
        case .normal:  return Person.all[personIndex].getSubjectString(language: currentLanguage,subjectPronounType: getSubjectPronounType())
        case .verbsLikeGustar:
            return subjunctiveWord + " a " + Person.all[personIndex].getPrepositionalPronounString(language: currentLanguage, gender: .masculine, verbStartsWithVowel: verbStartsWithVowel)
        case .weatherAndTime:
            if personIndex == 2 { return subjunctiveWord }
            return ""
        case .ThirdPersonOnly:
            if personIndex == 2 || personIndex == 5 {
                return subjunctiveWord + Person.all[personIndex].getSubjectString(language: currentLanguage, subjectPronounType: getSubjectPronounType(), verbStartsWithVowel: verbStartsWithVowel)
            }
            return ""
                
        case .auxiliaryVerbsInfinitives, .auxiliaryVerbsGerunds:
            return subjunctiveWord + Person.all[personIndex].getSubjectString(language: currentLanguage,subjectPronounType: getSubjectPronounType(), verbStartsWithVowel: verbStartsWithVowel)
                
        case .defective:
            if personIndex == 2 || personIndex == 5 {
                return subjunctiveWord + Person.all[personIndex].getSubjectString(language: currentLanguage, subjectPronounType: getSubjectPronounType(), verbStartsWithVowel: verbStartsWithVowel)
            }
            return ""
        }
    }
    
    func setVerbOrModelMode(_ mode: VerbOrModelMode){
        verbOrModelMode = mode
    }
    
    func getVerbOrModelMode()->VerbOrModelMode{
        verbOrModelMode
    }
    
    func getStudyPackageManagerList()->[StudyPackageManager]{
        return studyPackageManagerList
    }
    

    func reloadModelVerbEntitiesWithModelVerbs(){
        vmecdm.clearModelEntities()
        let vm =  vmecdm.vm
        var vmList = [RomanceVerbModel]()

        if vm.savedVerbModelEnties.isEmpty {
            switch currentLanguage{
            case .Spanish:
                vmList = spanishVerbModelConjugation.getVerbModels()
            case .French:
                vmList = frenchVerbModelConjugation.getVerbModels()
            default:
                break
            }

            for verbModelEntity in vmList {
                vm.addVerbModelEntity(name: verbModelEntity.modelVerb, isActive: true)
            }
        }
    }

    func createOrderedModelList(){
        var modelDictionary: [String: Int] = [:]
        for vm in getVerbModels() {
           
            modelDictionary.updateValue(vm.id, forKey: vm.modelVerb)
        }
        let sortInfo = modelDictionary.sorted(by: { $0.value < $1.value } )
        
        sortInfo.forEach {key, value in
            for vm in getVerbModels()  {
                if vm.modelVerb == "\(key)" {
                    orderedVerbModelList.append(vm)
                    break
                }
            }
        }
    }

    
    func loadInitialVerbModel(){
        switch currentLanguage {
        case .Spanish:
            setCurrentVerbModel(model: findModelForThisVerbString(verbWord: "hablar"))
//            setFilteredVerbList(verbList: findVerbsOfSameModel(targetID: getCurrentVerbModel().id))  //encontrar
        case .French:
            setCurrentVerbModel(model: findModelForThisVerbString(verbWord: "manger"))
//            setFilteredVerbList(verbList: findVerbsOfSameModel(targetID: getCurrentVerbModel().id))  //manger
        case .English:
            setFilteredVerbList(verbList: getRandomEnglishVerbs(maxCount : 30))
        default:
            return
        }
    }
    
    func loadInitialVerbPattern(){
        switch currentLanguage {
        case .Spanish:
            let sps = SpecialPatternStruct(tense: .present, spt: .o2ue)
            let vl = getVerbsOfPattern(verbList: verbList, thisPattern: sps)
            setFilteredVerbList(verbList: vl)
        case .French:
            let sps = SpecialPatternStruct(tense: .present, spt: .o2ue)
//            let vl = getVerbsOfPattern(verbList: verbList, thisPattern: sps)
            setFilteredVerbList(verbList: findVerbsOfSameModel(targetID: 67))  //manger
        case .English:
            setFilteredVerbList(verbList: getRandomEnglishVerbs(maxCount : 30))
        default:
            return
        }
    }
    
    func dumpDictionaryWordsByModel(){
        print("dumpDictionaryWordsByModel:")
        for verb in verbList {
            let verbString = verb.getWordStringAtLanguage(language: currentLanguage)
            let model = findModelForThisVerbString(verbWord: verbString)
            print("verb \(verbString) -- modelVerb \(model.modelVerb)")
        }
    }
    func testPatternModelListLogic(){
        var verb = Verb(spanish : "seguir", french : "seguir", english: "follow")
        let verbStr = conjugateAsRegularVerb(verb: verb, tense: .present, person: .S1, isReflexive: true, residPhrase: "cuenta de")
        print("seguir as regular verb: \(verbStr)")
        let patternVerbList = getVerbsForPatternGroup(patternType: .o2ue)
//        var vl = getVerbsOfPatternGroups(patternType: .c2z)
        verb = patternVerbList[0]
        let id = getBescherelleID(verb: verb)
        let differentModelVerbList = findVerbsOfDifferentModel(modelID: id, inputVerbList: patternVerbList)
        print("patternVerbList count = \(patternVerbList.count), patternVerb = \(verb.spanish), find id \(id), differentModelVerbList count = \(differentModelVerbList.count)")
        let sameModelVerbList = findVerbsOfSameModel(modelID: id, inputVerbList: patternVerbList)
        print("patternVerbList count = \(patternVerbList.count), patternVerb = \(verb.spanish), find id \(id), sameModelVerbList count = \(sameModelVerbList.count)")
        
//        let idList = getModelIdsOfPattern(verbList: verbList, thisPattern: SpecialPatternStruct(tense: .present, spt: .o2ue))
//        print("idList count = \(idList.count)")
        
        var modelList = [RomanceVerbModel]()
//        for spt in SpecialPatternType.stemChangingOSpanish{
//            modelList = getModelsOfPattern(verbList: verbList, thisPattern: SpecialPatternStruct(tense: .present, spt: spt))
//            print("\n\(modelList.count) models contain pattern \(spt.rawValue)")
//            for model in modelList {
//                print("model: \(model.id), verb:\(model.modelVerb)")
//            }
//        }
        
        for spt in SpecialPatternType.stemChangingESpanish{
            modelList = getModelsOfPattern(verbList: verbList, thisPattern: SpecialPatternStruct(tense: .present, spt: spt))
            print("\n\(modelList.count) models contain pattern \(spt.rawValue)")
            for model in modelList {
                print("model: \(model.id), verb:\(model.modelVerb)")
            }
        }
    }
    
    
    func setVerbTypeCompleted(){
        vmecdm.setAllSelectedToCompleted()
    }
    
    func computeVerbsExistForAll3Endings()->Bool{
        verbsExistForAll3Endings = false
        let vamslu = VerbAndModelSublistUtilities()
        let ARcount = vamslu.getVerbSublistAtVerbEnding(inputVerbList: getFilteredVerbs(), inputEnding: .AR,  language: getCurrentLanguage()).count
        let ERcount = vamslu.getVerbSublistAtVerbEnding(inputVerbList: getFilteredVerbs(), inputEnding: .ER,  language: getCurrentLanguage()).count
        let IRcount = vamslu.getVerbSublistAtVerbEnding(inputVerbList: getFilteredVerbs(), inputEnding: .IR,  language: getCurrentLanguage()).count
        
        if ARcount > 0 && ERcount > 0 && IRcount > 0 { verbsExistForAll3Endings = true}
        return verbsExistForAll3Endings
    }
    
    func setVerbsExistForAll3Endings(flag: Bool){
        verbsExistForAll3Endings = flag
    }
    
    func getVerbsExistForAll3Endings()->Bool{
        verbsExistForAll3Endings
    }
    
    
    func fillVerbCubeAndQuizCubeLists(){
        fillVerbCubeLists()   //verb cube list is a list of all the filtered verbs
        setPreviousCubeBlockVerbs()  //verbCubeBlock is a block of verbBlockCount verbs
        fillQuizCubeVerbList()
        fillQuizCubeBlock()
    }
    
//    func setStudentLessonLeve(level: StudentLessonLevelEnum){
//        self.studentLessonLevel = level
//    }
//
//    func getStudentLessonLevel()->StudentLessonLevelEnum{
//        return studentLessonLevel
//    }
//
    func getWordCollections()->[dWordCollection] {
        return getWordCollectionList()
    }
    
    
    func toggleSpeechMode(){
        useSpeechMode.toggle()
    }
    
    func isSpeechModeActive()->Bool{
        return useSpeechMode
    }
    
    func setLanguage(language: LanguageType){
        currentLanguage = language
        m_wsp.m_language = language
    }
    
    func changeLanguage(){
        switch currentLanguage {
//        case .English:
//            setLanguage(language: .Spanish)
        case .Spanish:
            setLanguage(language: .French)
        case .French:
            setLanguage(language: .Spanish)
        default: return
        }
    }
    
    func initializeStudentScoreModel(){
        let tenseList = getTenseList()
        var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
        personList.shuffle()
        let verbList = getFilteredVerbs()
        studentScoreModel.createStudentScoreModels(verbList: verbList, tenseList: tenseList, personList: personList)
    }

    func initializeCriticalForms(){
        criticalVerbForms.clearAll()
        
        //Spanish critical verb forms
        
        criticalVerbForms.appendCriticalForm(person: .S1, tense: .present, comment: "First person singular, present tense")
        criticalVerbForms.appendCriticalForm(person: .S1, tense: .presentSubjunctive, comment: "First person singular, present subjunctive tense")
        criticalVerbForms.appendCriticalForm(person: .S1, tense: .preterite, comment: "First person singular, preterite tense")
        criticalVerbForms.appendCriticalForm(person: .S3, tense: .preterite, comment: "Third person singular, preterite tense")
        criticalVerbForms.appendCriticalForm(person: .P3, tense: .preterite, comment: "Third person plural, preterite tense")
        criticalVerbForms.appendCriticalForm(person: .P3, tense: .imperfectSubjunctiveRA, comment: "Third person plural,imperfect subjunctive tense")
    }
                     
    func testLogic(tense: Tense){
        print("testLogic: \(getCurrentConjugatedVerbString())")
        
        createAndConjugateAgnosticVerb(verb: currentVerb, tense: tense)
        for p in 0..<6 {
            let person = Person.allCases[p]
            print("Person: \(person.getSubjectString(language: getCurrentLanguage(), subjectPronounType: getSubjectPronounType()))")
        }
    }
    
    func loadWordDictionariesFromJSON(){
        jsonDictionaryManager.useJsonStarterFiles(useThem: true)
        jsonDictionaryManager.setWordStringParser(wsp: m_wsp)
        jsonDictionaryManager.loadJsonWords()
    }
    
    func createVerbList(){
        for i in 0 ..< m_wsp!.getWordCount(wordType: .verb) {
            let word = m_wsp!.getAgnosticWordFromDictionary(wordType: .verb, index: i)
            verbList.append(word as! Verb)
        }
        currentVerbIndex = 0
        currentVerb = verbList[currentVerbIndex]
    }
    
    func findVerbFromString(verbString: String, language: LanguageType)->Verb{
        let verb = Verb()
        for v in verbList {
            switch language{
            case .Spanish:
                if v.spanish == verbString { return v}
            case .French:
                if v.french == verbString { return v}
            case .English:
                if v.english == verbString { return v}
                
            default: return verb
            }
        }
        return verb
    }
    
    func fillCriticalVerbForms(verb: Verb, residualPhrase: String, isReflexive: Bool){
        print("VVM fillCriticalVerbForms")
        for index in 0..<criticalVerbForms.count() {
            var cs = criticalVerbForms.at(index:index)
            cs.verbForm = createAndConjugateAgnosticVerb(verb: verb, tense: cs.tense, person: cs.person)
            cs.verbForm += " " + residualPhrase
            putCriticalStruct(index: index, criticalStruct: cs)
            print("\(cs.person.getSubjectString(language: getCurrentLanguage(), subjectPronounType: getSubjectPronounType())), \(cs.verbForm), \(cs.tense.rawValue), \(cs.comment)")
        }
    }
    
    func putCriticalStruct(index: Int, criticalStruct: CriticalStruct){
        criticalVerbForms.put(index: index, criticalStruct: criticalStruct)
    }
    
    func getStudentScoreModel()->StudentScoreModel{
        studentScoreModel
    }
    
    func getVerbList()->[Verb]{
        return verbList
    }
    
    func setNextVerb(){
        currentVerbIndex += 1
        if ( currentVerbIndex >= verbList.count ){
            currentVerbIndex = 0
        }
        currentVerb = verbList[currentVerbIndex]
    }
    
    func setPreviousVerb(){
        currentVerbIndex -= 1
        if ( currentVerbIndex <= 0 ){
            currentVerbIndex = verbList.count-1
        }
        currentVerb = verbList[currentVerbIndex]
    }
    
    func setSubjectPronounType(spt: SubjectPronounType){
        return subjectPronounType = spt
    }
    
    func getSubjectPronounType()->SubjectPronounType{
        return subjectPronounType
    }
    
    func getSubjectGender()->Gender{
        if subjectPronounType == .femaleFormal || subjectPronounType == .femaleInformal { return .feminine }
        return .masculine
    }
    
    func getTenseList()->[Tense]{return tenseList}
    func setTenses(tenseList: [Tense]){ self.tenseList = tenseList }

    func getCurrentVerb()->Verb{return currentVerb}
    func getCurrentTense()->Tense{return tenseList[currentTenseIndex]}
    func setCurrentVerb(verb: Verb){
        currentVerb = verb
    }
    
    func getCurrentLanguage()->LanguageType{return currentLanguage}
    
    func getCurrentConjugatedVerbString()->String{
        createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
        return morphStructManager.verbPhrase
    }
    
    func getMorphStructManager()->MorphStructManager{
        return morphStructManager
    }
    
    func getFinalVerbForm(person: Person)->String{
        return morphStructManager.getFinalVerbForm(person: person)
    }
    
    func getFinalVerbForms(person: Person, verbList: [Verb])->[String]{
        var conjugatedStringList = [String]()
        for verb in verbList {
            conjugatedStringList.append(createAndConjugateAgnosticVerb(verb: verb, tense: getCurrentTense(), person: person))
        }
        return conjugatedStringList
    }
    
    func getVerbPhrase()->String{
        return morphStructManager.verbPhrase
    }
    
    func isCurrentMorphStepFinal(person: Person)->Bool{
        return morphStructManager.isCurrentMorphStepFinal(person: person)
    }
    
    func resetCurrentMorphStepIndex(person: Person){
        morphStructManager.resetCurrentMorphStepIndex(person: person)
    }
    
    func getCurrentMorphStepAndIncrementIndex(person: Person)->MorphStep{
        return morphStructManager.getCurrentMorphStepAndIncrementIndex(person: person)
    }
    
    func getCriticalVerbForms()->[CriticalStruct]{
        return criticalVerbForms.getCriticalVerbForms()
    }
//    func createAndConjugateCriticalTenses()->[String]{
//        return 
//    }
//
    
    
    func conjugateRomanceVerb(bVerb: BRomanceVerb, tense: Tense, person: Person)->String{
        let ms = bVerb.getConjugatedMorphStruct(tense: tense, person: person, conjugateEntirePhrase : true )
        morphStructManager.set(index: person.getIndex(), ms: ms)
        return morphStructManager.getFinalVerbForm(person: person)
    }
    
    func createAndConjugateAgnosticVerb(verb: Verb)->BRomanceVerb{
        var vmm = VerbModelManager()
        var bRomanceVerb = BRomanceVerb()
        switch currentLanguage {
        case .Spanish:
            bRomanceVerb = vmm.createSpanishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .French:
            bRomanceVerb = vmm.createFrenchBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        default:
            break
        }
        return bRomanceVerb
    }
    
    func createAndConjugateAgnosticVerb(language: LanguageType, verb: Verb, tense: Tense, person: Person, isReflexive: Bool)->String{
        var vmm = VerbModelManager()
        
        let verbPhrase = verb.getWordStringAtLanguage(language: language)
        var bVerb = verb.getBVerb()
        switch language {
        case .Spanish:
            bVerb = vmm.createSpanishBVerb(verbPhrase: verbPhrase)
        case .French:
            bVerb = vmm.createFrenchBVerb(verbPhrase: verbPhrase)
        case .English:
            bVerb = vmm.createEnglishBVerb(verbPhrase: verbPhrase, separable: .both)
        default:
            break
        }
        
        let ms = bVerb.getConjugatedMorphStruct(tense: tense, person: person, conjugateEntirePhrase : true )
        morphStructManager.set(index: person.getIndex(), ms: ms)
        
        let finalForm = morphStructManager.getFinalVerbForm(person: person)
        
        return finalForm
    }
    
    
    func createAndConjugateAgnosticVerb(verb: Verb, tense: Tense, person: Person)->String{
        var vmm = VerbModelManager()
        
        var bVerb = verb.getBVerb()
        switch currentLanguage {
        case .Spanish:
            bVerb = vmm.createSpanishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .French:
            bVerb = vmm.createFrenchBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .English:
            bVerb = vmm.createEnglishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage), separable: .both)
        default:
            break
        }
        
        let ms = bVerb.getConjugatedMorphStruct(tense: tense, person: person, conjugateEntirePhrase : true )
        morphStructManager.set(index: person.getIndex(), ms: ms)
        return morphStructManager.getFinalVerbForm(person: person)
    }
    
    func createAndConjugateCurrentFilteredVerb(){
        let verbStr = getCurrentFilteredVerb().getWordAtLanguage(language: currentLanguage)
        let currentTenseStr = getCurrentTense().rawValue
        
//        print("createAndConjugateCurrentFilteredVerb: \(verbStr): currentTenseStr \(currentTenseStr), currentTense: \(currentTense.rawValue) ")
        createAndConjugateAgnosticVerb(verb: getCurrentFilteredVerb(), tense: currentTense)
    }
    
    func createAndConjugateCurrentRandomVerb(){
        let verbStr = getCurrentRandomVerb().getWordAtLanguage(language: currentLanguage)
        let currentTenseStr = getCurrentTense().rawValue
        
//        print("createAndConjugateCurrentRandomVerb: \(verbStr): currentTenseStr \(currentTenseStr), currentTense: \(currentTense.rawValue) ")
        createAndConjugateAgnosticVerb(verb: getCurrentRandomVerb(), tense: currentTense)
    }
    
   
    func createConjugatedMorphStruct(verb: Verb, tense: Tense, person: Person)->MorphStruct{
        var vmm = VerbModelManager()
        
        var bVerb = verb.getBVerb()
        bVerb.m_isPassive = verb.m_isPassive
        switch currentLanguage {
        case .Spanish:
            bVerb = vmm.createSpanishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .French:
            bVerb = vmm.createFrenchBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .English:
            bVerb = vmm.createEnglishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage), separable: .both)
        default:
            break
        }
        verb.setBVerb(bVerb: bVerb)
        return bVerb.getConjugatedMorphStruct(tense: tense, person: person, conjugateEntirePhrase : true, isPassive: verb.isPassive() )
    }
    
    func createAndConjugateAgnosticVerb(verb: Verb, tense: Tense){
        var vmm = VerbModelManager()
        
        var bVerb = verb.getBVerb()
        bVerb.m_isPassive = verb.m_isPassive
        switch currentLanguage {
        case .Spanish:
            bVerb = vmm.createSpanishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .French:
            bVerb = vmm.createFrenchBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage))
        case .English:
            bVerb = vmm.createEnglishBVerb(verbPhrase: verb.getWordStringAtLanguage(language: currentLanguage), separable: .both)
        default:
            break
        }
        
//        print("verb: \(verb.getWordStringAtLanguage(language: currentLanguage)), \(vmm.modelName)")
        //Since this is a new bVerb
        verb.setBVerb(bVerb: bVerb)
        for p in 0..<6 {
            let person = Person.allCases[p]
            let ms = bVerb.getConjugatedMorphStruct(tense: tense, person: person, conjugateEntirePhrase : true, isPassive: verb.isPassive() )
            morphStructManager.set(index: p, ms: ms)
        }
        //morphStructManager.dumpVerboseForPerson(p: .P3, message: "After: createAndConjugateAgnosticVerb")
    }
    
    
}



// MARK: - General Utilities

extension LanguageEngine{
    func getCurrentPerson()->Person{
        Person.allCases[currentPersonIndex]
    }
    
    func getNextPerson()->Person{
        currentPersonIndex += 1
        if ( currentPersonIndex >= 6){
            currentPersonIndex = 0
        }
        return Person.allCases[currentPersonIndex]
    }
    
    func getPreviousPerson()->Person{
        currentPersonIndex -= 1
        if ( currentPersonIndex < 0 ){
            currentPersonIndex = 5
        }
        return Person.allCases[currentPersonIndex]
    }
    
    func getNextTense()->Tense {
        currentTenseIndex += 1
        if ( currentTenseIndex >= tenseList.count ){
            currentTenseIndex = 0
        }
        currentTense = tenseList[currentTenseIndex]
//        createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
        return currentTense
    }
    
    func getPreviousTense()->Tense {
        currentTenseIndex -= 1
        if ( currentTenseIndex < 0 ){
            currentTenseIndex = tenseList.count-1
        }
        currentTense = tenseList[currentTenseIndex]
//        createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
        return currentTense
    }
}
// MARK: - Verb Cube Utilities


// MARK: verb type stuff

extension LanguageEngine{
    enum verbSelectionType {
        case AR, ER, IR, Stem, Ortho, Irregular, Special
    }
    
    func examineVerbs(){
        var i = 0
        var vmm = VerbModelManager()
        while i <= 100 {
            let _ = setNextVerb()
            let verb = getCurrentVerb()
            let verbWord = verb.getWordAtLanguage(language: .Spanish)
            let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
                extractVerbProperties(verb: bSpanishVerb, tense: .present, person: .S3)
            i += 1
        }
    }

    func extractVerbProperties(verb : BSpanishVerb, tense : Tense, person : Person){
        if verb.isStemChanging(){
            if (tense == .present || tense == .presentSubjunctive) && verb.isPersonStem(person: person) {
                print("verb: \(verb.m_verbWord) has stem changing from: \(verb.m_stemFrom) to \(verb.m_stemTo)")
            }
        }
        if ( verb.m_specialModel != SpecialSpanishVerbModel.none ){
            print("verb: \(verb.m_verbWord) is irregular")
        }
    }
    
    //être d'accord avec
    
    func getRomanceVerb(verb: Verb)->BRomanceVerb{
        var vmm = VerbModelManager()
        let vu = VerbUtilities()
        
        switch currentLanguage {
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: verb.spanish)
            let ending = vu.determineVerbEnding(verbWord: result.0)
            if ending == .AR || ending == .ER || ending == .IR || ending == .accentIR || ending == .umlautIR {
                let verbWord = verb.getWordAtLanguage(language: currentLanguage)
                let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
                return bSpanishVerb
            }
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: verb.french)
            let ending = vu.determineVerbEnding(verbWord: result.0)
            if ending == .ER || ending == .IR || ending == .RE  {
                let verbWord = verb.getWordAtLanguage(language: currentLanguage)
                let bFrenchVerb = vmm.createFrenchBVerb(verbPhrase: verbWord)
                return bFrenchVerb
            }
        default:
            return BRomanceVerb()
        }
        return BRomanceVerb()
    }
    
    
    
    public func hasVerbEnding(verb: Verb, verbEnding: VerbEnding)->Bool{
        return getRomanceVerb(verb: verb).m_verbEnding == verbEnding
    }

    func isVerbType(verb : Verb, verbType: ShowVerbType)->Bool{
        let bRomanceVerb = getRomanceVerb(verb: verb)
        
        if verbType == .NONE { return false }
        
        switch verbType{
        case .STEM:
            return bRomanceVerb.isStemChanging()
        case .ORTHO:
            return bRomanceVerb.isOrthographicPresent() || bRomanceVerb.isOrthographicPreterite()
        case .IRREG:
            return bRomanceVerb.isIrregular()
        case .SPECIAL:
            return bRomanceVerb.isSpecial()
        case .REFLEXIVE:
            return bRomanceVerb.isReflexive()
        case .PHRASAL:
            return bRomanceVerb.isPhrasalVerb()
        default:
            return false
        }

    }
    
    func isVerbType(verb : Verb, tense : Tense, person : Person, verbType: ShowVerbType)->Bool{
        var vmm = VerbModelManager()
//        var stemFrom = ""
//        var stemTo = ""
        
        if verbType == .NONE { return false }
            
        switch currentLanguage {
        case .Spanish:
            let verbWord = verb.getWordAtLanguage(language: currentLanguage)
            let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
            switch verbType{
            case .STEM:
                return checkForStemChangingSpanish(verb: bSpanishVerb, tense: tense, person: person )
            case .ORTHO:
                return checkForOrthoChangingSpanish(verb: bSpanishVerb, tense: tense, person: person )
            case .IRREG:
                return checkForIrregularSpanish(verb: bSpanishVerb, tense: tense, person: person )
            case .SPECIAL:
                return checkForSpecialSpanish(verb: bSpanishVerb, tense: tense, person: person )
            case .REFLEXIVE:
                return isVerbType(verb: verb, verbType: verbType)
            case .PHRASAL:
               return isVerbType(verb: verb, verbType: verbType)
            case .NONE:
                return false
            }
            
        case .English:
            return false
        case .French:
            let verbWord = verb.getWordAtLanguage(language: currentLanguage)
            let bFrenchVerb = vmm.createFrenchBVerb(verbPhrase: verbWord)
            switch verbType{
            case .STEM:
                return checkForStemChangingFrench(verb: bFrenchVerb, tense: tense, person: person )
            case .ORTHO:
                return checkForOrthoChangingFrench(verb: bFrenchVerb, tense: tense, person: person )
            case .IRREG:
                return checkForIrregularFrench(verb: bFrenchVerb, tense: tense, person: person )
            case .SPECIAL:
                return checkForSpecialFrench(verb: bFrenchVerb, tense: tense, person: person )
            case .REFLEXIVE:
                return isVerbType(verb: verb, verbType: verbType)
            case .PHRASAL:
               return isVerbType(verb: verb, verbType: verbType)
            case .NONE:
                return false
            }
        case .Italian:
            return false
        case .Portuguese:
            return false
        case .Agnostic:
            return false
        }
    }
    
    func checkForStemChangingSpanish(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        
        if verb.isStemChanging() {
            if (tense == .present || tense == .presentSubjunctive) && verb.isPersonStem(person: person) {
                if verb.isOrthoPresent(tense: tense, person: person){ return false }  //tener - tengo
                let stemFrom = verb.m_stemFrom
                let stemTo = verb.m_stemTo
                print("\(verb.spanish) is stem changing for tense \(tense.rawValue), person \(person.rawValue)\n stemFrom - \(stemFrom), stemTo - \(stemTo)")
                return true
            }
        }
        if tense == .preterite {
            if verb.isPretStemChanging() {return true}
            if verb.isPretStem2Changing() && verb.isPersonPretStem2(person: person) {return true}
            if verb.isPretStem3Changing() && verb.isPersonPretStem3(person: person) {return true}
        }
        return false
    }
    
    func checkForStemChangingFrench(verb: BFrenchVerb, tense: Tense, person: Person)->Bool{
        
//        if verb.isStemChanging() {
        if verb.m_presentStemChanging || verb.m_presentSubjStemChanging {
            if (tense == .present || tense == .presentSubjunctive) && verb.isPersonStem(person: person) {
                if verb.isOrthoPresent(tense: tense, person: person){ return false }  //tener - tengo
//                var stemFrom = verb.m_stemFrom
//                var stemTo = verb.m_stemTo
//                    print("\(verbWord) is stem changing for tense \(tense.rawValue), person \(person.rawValue) ")
                return true
            }
        }
        return false
    }
    
    func checkForOrthoChangingSpanish(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        let result = verb.hasStemSingleForm(tense: tense, person: person)
        if ( result.0 != "" ){
            if verb.isOrthoPresent(tense: tense, person: person){ return true }
        }
        if verb.isOrthoPreterite(tense: tense, person: person) { return true }
        if verb.isOrthoPresent (tense: tense, person: person) { return true }
        return false
    }
    
    func checkForOrthoChangingFrench(verb: BFrenchVerb, tense: Tense, person: Person)->Bool{
        let result = verb.hasStemSingleForm(tense: tense, person: person)
        if ( result.0 != "" ){
            if verb.isOrthoPresent(tense: tense, person: person){ return true }
        }
        if verb.isOrthoPreterite(tense: tense, person: person) { return true }
        if verb.isOrthoPresent (tense: tense, person: person) { return true }
        return false
    }
    
    func checkForIrregularSpanish(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
            if ( verb.m_specialModel != SpecialSpanishVerbModel.none ){
                let irreg = IrregularVerbsSpanish()
                var morphStruct = verb.getMorphStruct(tense: tense, person: person)
                morphStruct  = irreg.getIrregularFormSpecial(inputMorphStruct : morphStruct, verb : verb, preposition : "",
                                                             specialVerbModel : verb.m_specialModel,
                                                             tense : tense, person : person)
                if morphStruct.isIrregular() {return true}
            
            if verb.m_replacementVerbInfinitive.count > 0  && (tense == .future || tense == .conditional ){return true}
        }
        return false
    }
    
    func checkForIrregularFrench(verb: BFrenchVerb, tense: Tense, person: Person)->Bool{
            if ( verb.m_specialModel != SpecialFrenchVerbModel.none ){
                let irreg = IrregularVerbsFrench()
                var morphStruct = verb.getMorphStruct(tense: tense, person: person)
                morphStruct  = irreg.getIrregularFormSpecial(inputMorphStruct : morphStruct, verb : verb, preposition : "",
                                                             specialVerbModel : verb.m_specialModel,
                                                             tense : tense, person : person)
                if morphStruct.isIrregular() {return true}
            
            if verb.m_replacementVerbInfinitive.count > 0  && (tense == .future || tense == .conditional ){return true}
        }
        return false
    }
    
    func checkForSpecialSpanish(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        if currentLanguage == .Spanish {
            if  verb.m_specialModel != SpecialSpanishVerbModel.none { return true }
        }
        return false
    }
    
    func checkForSpecialFrench(verb: BFrenchVerb, tense: Tense, person: Person)->Bool{
            if  verb.m_specialModel != SpecialFrenchVerbModel.none { return true }
        return false
    }
    
//    func getVerbsOfSelectedEnding(verbEnding: VerbEnding)->[Verb]{
//        var verbs = [Verb]()
//        print("\nlanguageEngine: getVerbsOfSelectedEnding:")
//        print("Language: \(currentLanguage.rawValue)")
//        for verb in verbList {
//            let rve = getRomanceVerbEnding(verb: verb, language: getCurrentLanguage())
//            if rve != .none {
//                print("verb: \(verb.getWordAtLanguage(language: .Spanish)), \(verb.getWordAtLanguage(language: .French)), \(verb.getWordAtLanguage(language: .English)) ...verbEnding = \(rve.rawValue)")
//                if  rve == verbEnding {
//                    verbs.append(verb)
//                }
//            }
//        }
//        return verbs
//    }
    
        
    func unConjugate(verbForm : String)->[VTP]{
        var vtpList = [VTP]()
        var conjugateForm = ""
        let tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future, .presentSubjunctive, .imperfectSubjunctiveRA, .imperfectSubjunctiveSE, .imperative]
        var count = 0
        for v in verbList {
            for tense in tenseList {
                for person in Person.all {
                    let ms = createConjugatedMorphStruct(verb: v, tense: tense, person: person)
                    conjugateForm = ms.finalVerbForm()
                    if conjugateForm == verbForm {
                        vtpList.append(VTP(verb: v, tense: tense, person: person))
                        print("\(count) verb forms were searched")
                        print("target form: \(verbForm): found: \(v.getWordAtLanguage(language: currentLanguage)), tense: \(tense.rawValue), person:\(person.rawValue)")
                    }
                    count += 1
                }
            }
        }
        return vtpList
    }
}

// MARK: filtered verb stuff

