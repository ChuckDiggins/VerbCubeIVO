//
//  LanguageEngine.swift
//  LanguageEngine
//
//  Created by Charles Diggins on 2/16/22.
//

import Foundation
import JumpLinguaHelpers
import Dot

class LanguageEngine : ObservableObject {
    private var currentLanguage = LanguageType.Agnostic
    private var currentVerb = Verb()
    private var currentTense = Tense.present
    private var currentPerson = Person.S1
    private var morphStructManager = MorphStructManager(verbPhrase: "", tense: .present)
    
    private var currentVerbIndex = 0
    private var currentTenseIndex = 0
    private var currentPersonIndex = 0
    
    var tenseList = [Tense.present, .preterite, .imperfect, .conditional, .presentSubjunctive]
    private var verbList = [Verb]()
    
    private var currentFilteredVerbIndex = 0
    var filteredVerbList = [Verb]()
    
    private var verbModelConjugation : VerbModelConjugation!
    private var spanishVerbModelConjugation = RomanceVerbModelConjugation()
    private var frenchVerbModelConjugation = RomanceVerbModelConjugation()
    private var englishVerbModelConjugation = EnglishVerbModelConjugation()
    private var jsonDictionaryManager = JSONVerbPronounDictionaryManager()
    private var verbModelManager = VerbModelManager()
    private var tenseManager = TenseManager()
    private var wsp : ViperWordStringParser!
    
    
    var startingVerbCubeListIndex = 0
    var verbCubeVerbIndex = 0
    @Published var verbCubeList = [Verb]()
    let verbBlockCount: Int = 6
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
    
    init(){
        
    }
 

    
    init(load: Bool) {
        verbModelConjugation = VerbModelConjugation(currentLanguage: currentLanguage)
        wsp = ViperWordStringParser(language: currentLanguage,
                                      span: spanishVerbModelConjugation,
                                      french: frenchVerbModelConjugation,
                                      english: englishVerbModelConjugation)
        loadVerbsFromJSON()
        createVerbList()
        filteredVerbList = verbList
        fillVerbCubeLists()   //verb cube list is a list of all the filtered verbs
        setPreviousCubeBlockVerbs()  //verbCubeBlock is a block of verbBlockCount verbs
        fillQuizCubeVerbList()
        fillQuizCubeBlock()
        currentLanguage = .Spanish  //pick one
//        testLogic(tense: .preterite)
    }

    func testLogic(tense: Tense){
        print("testLogic: \(getCurrentConjugatedVerbString())")
        
        createAndConjugateAgnosticVerb(verb: currentVerb, tense: tense)
        for p in 0..<6 {
            let person = Person.allCases[p]
            print("Person: \(person.getMaleString()): \(morphStructManager.getFinalVerbForm(person: person))")
        }
    }
    
    func loadVerbsFromJSON(){
        jsonDictionaryManager.setWordStringParser(wsp: wsp)
        jsonDictionaryManager.loadJsonWords()
    }
    
    func createVerbList(){
        for i in 0 ..< wsp!.getWordCount(wordType: .verb) {
            let word = wsp!.getAgnosticWordFromDictionary(wordType: .verb, index: i)
            verbList.append(word as! Verb)
        }
        currentVerbIndex = 0
        currentVerb = verbList[currentVerbIndex]
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
    
   
    func getTenseList()->[Tense]{return tenseList}
    func getCurrentVerb()->Verb{return currentVerb}
    func getCurrentTense()->Tense{return tenseList[currentTenseIndex]}
    
    func getCurrentLanguage()->LanguageType{return currentLanguage}
    
    func getCurrentConjugatedVerbString()->String{
        createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
        return morphStructManager.verbPhrase
    }
    
    func getMorphStructManager()->MorphStructManager{
        return morphStructManager
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
            let ms = bVerb.getConjugatedMorphStruct(tense: currentTense, person: person, conjugateEntirePhrase : true, isPassive: verb.isPassive() )
            morphStructManager.set(index: p, ms: ms)
        }
        //morphStructManager.dumpVerboseForPerson(p: .P3, message: "After: createAndConjugateAgnosticVerb")
    }
}

// MARK: - General Utilities

extension LanguageEngine{
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
        createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
        return currentTense
    }
    
    func getPreviousTense()->Tense {
        currentTenseIndex -= 1
        if ( currentTenseIndex < 0 ){
            currentTenseIndex = tenseList.count-1
        }
        currentTense = tenseList[currentTenseIndex]
        createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense)
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
    
    func getRomanceVerb(verb: Verb)->BRomanceVerb{
        var vmm = VerbModelManager()
        switch currentLanguage {
        case .Spanish:
            let verbWord = verb.getWordAtLanguage(language: currentLanguage)
            let bSpanishVerb = vmm.createSpanishBVerb(verbPhrase: verbWord)
            return bSpanishVerb
        case .French:
            let verbWord = verb.getWordAtLanguage(language: currentLanguage)
            let bFrenchVerb = vmm.createFrenchBVerb(verbPhrase: verbWord)
            return bFrenchVerb
        default:
            return BRomanceVerb()
        }
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
                return checkForStemChanging(verb: bSpanishVerb, tense: tense, person: person )
            case .ORTHO:
                return checkForOrthoChanging(verb: bSpanishVerb, tense: tense, person: person )
            case .IRREG:
                return checkForIrregular(verb: bSpanishVerb, tense: tense, person: person )
            case .SPECIAL:
                return checkForSpecial(verb: bSpanishVerb, tense: tense, person: person )
            case .NONE:
                return false
            }
            
        case .English:
            return false
        case .French:
            let verbWord = verb.getWordAtLanguage(language: currentLanguage)
            let bFrenchVerb = vmm.createFrenchBVerb(verbPhrase: verbWord)
            if verbType == .STEM  && bFrenchVerb.isStemChanging(){
                if (tense == .present || tense == .presentSubjunctive) && bFrenchVerb.isPersonStem(person: person) {
                    return true
                }
            }
            if ( verbType == .SPECIAL &&  bFrenchVerb.m_specialModel != SpecialFrenchVerbModel.none ){
                return true
            }
        case .Italian:
            return false
        case .Portuguese:
            return false
        case .Agnostic:
            return false
        }
        return false
    }
    
    func checkForStemChanging(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        
        if verb.isStemChanging() {
            if (tense == .present || tense == .presentSubjunctive) && verb.isPersonStem(person: person) {
                if verb.isOrthoPresent(tense: tense, person: person){ return false }  //tener - tengo
//                var stemFrom = verb.m_stemFrom
//                var stemTo = verb.m_stemTo
//                    print("\(verbWord) is stem changing for tense \(tense.rawValue), person \(person.rawValue) ")
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
    
    func checkForOrthoChanging(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        let result = verb.hasStemSingleForm(tense: tense, person: person)
        if ( result.0 != "" ){
            if verb.isOrthoPresent(tense: tense, person: person){ return true }
        }
        if verb.isOrthoPreterite(tense: tense, person: person) { return true }
        if verb.isOrthoPresent (tense: tense, person: person) { return true }
        return false
    }
    
    func checkForIrregular(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        if ( verb.m_specialModel != SpecialSpanishVerbModel.none ){
            let irreg = IrregularVerbsSpanish()
            var morphStruct = verb.getMorphStruct(tense: tense, person: person)
            morphStruct  = irreg.getIrregularFormSpecial(inputMorphStruct : morphStruct, verb : verb, preposition : "",
                                                                   specialVerbModel : verb.m_specialModel,
                                                                   tense : tense, person : person)
            if morphStruct.isIrregular() {return true}
        }
        
        if verb.m_replacementVerbInfinitive.count > 0  && (tense == .future || tense == .conditional ){return true}
        return false
    }
    
    func checkForSpecial(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
        if  verb.m_specialModel != SpecialSpanishVerbModel.none { return true }
        return false
    }
}

// MARK: filtered verb stuff

extension LanguageEngine{
    func clearFilteredVerbList(){
        filteredVerbList.removeAll()
    }
    
    func resetFilteredVerbs(){
        filteredVerbList = verbList
    }
    
    func getFilteredVerbs()->[Verb]{
        return filteredVerbList
    }
    
    func setNextFilteredVerb(){
        currentFilteredVerbIndex += 1
        if currentFilteredVerbIndex >= filteredVerbList.count {
            currentFilteredVerbIndex = 0 }
    }
    
    func setPreviousFilteredVerb(){
        currentFilteredVerbIndex -= 1
        if currentFilteredVerbIndex < 0 {
            currentFilteredVerbIndex = filteredVerbList.count - 1}
    }
    
    func getCurrentFilteredVerb()->Verb{
        return filteredVerbList[currentFilteredVerbIndex]
    }
    
    func getVerbsOfSelectedType(verbEnding: VerbEnding)->[Verb]{
        var verbs = [Verb]()
        for verb in verbList {
            if  getRomanceVerb(verb: verb).m_verbEnding == verbEnding {
                verbs.append(verb)
            }
        }
        return verbs
    }
    
    func addVerbToFilteredList(verb: Verb){
        filteredVerbList.append(verb)
    }
}

