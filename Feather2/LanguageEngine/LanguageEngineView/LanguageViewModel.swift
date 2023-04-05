//
//  LanguageViewModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//


import SwiftUI
import JumpLinguaHelpers

//émouvoir
//déchoir
class LanguageViewModel : ObservableObject, Equatable {
    @AppStorage("Language") var languageString = "Spanish"
    
    static func == (lhs: LanguageViewModel, rhs: LanguageViewModel) -> Bool {
        return lhs.languageEngine == rhs.languageEngine
    }

    var insertQueQuiBeforeSubjunctive = true
    //var useFeminineSubjectPronouns = true
    var useUstedForS3 = false
    var useVoceForm = false
    var useAlertMode = true
    
    
    
//    @Published var spt = SubjectPronounType.maleInformal
    
    @Published var languageEngine = LanguageEngine()
    
    var currentLanguage = LanguageType.Spanish
    
    
//    init(){
//        languageEngine = LanguageEngine()
//    }
    
//    init(language: LanguageType){
//        languageEngine = LanguageEngine(language: language)
//    }
    
    init(){
        switch languageString {
        case "French":
            currentLanguage = LanguageType.French
            languageEngine = LanguageEngine(language: .French)
        default:
            currentLanguage = LanguageType.Spanish
            languageEngine = LanguageEngine(language: .Spanish)
        }
    }
    
    func setNextLanguage(){
        languageEngine.setNextLanguage()
    }
    
    func verbCountsExistInCoreData()->Bool{
        languageEngine.verbCountsExistInCoreData()
    }
    
    func getModelVerbCountAt(_ id: Int)->Int{
        languageEngine.getModelVerbCountAt(id)
    }
    
    func clearAllVerbCountsInCoreData(){
        languageEngine.clearAllVerbCountsInCoreData()
    }
    
    func setAllVerbCountsInCoreData(){
        languageEngine.setAllVerbCountsInCoreData()
    }
    
    func getAllVerbCountsFromCoreData(){
        languageEngine.getAllVerbCountsFromCoreData()
    }
    
    func getPastParticiple(_ verbString: String)->String{
        languageEngine.getPastParticiple(verbString)
    }
    
    func verbOrModelModeInitialized()->Bool{
        languageEngine.verbOrModelModeInitialized
    }
    
    func setVerbOrModelModeInitialized(){
        languageEngine.verbOrModelModeInitialized = true
    }
    
    func changeLanguage(){
        languageEngine.changeLanguage()
        currentLanguage = languageEngine.getCurrentLanguage()
    }
    
    func isModelMode()->Bool{
        languageEngine.isModelMode()
    }
    
    func setTemporaryVerbModel(verbModel: RomanceVerbModel){
        languageEngine.setTemporaryVerbModel(verbModel: verbModel)
    }
    
    func getTemporaryVerbModel()->RomanceVerbModel{
        languageEngine.getTemporaryVerbModel()
    }
    
    func getSimpleTensesFromList(_ tenseList: [Tense])->[Tense]{
        languageEngine.getSimpleTensesFromList(tenseList)
    }
    
    func getPreviousSimpleTense()->Tense{
        languageEngine.getPreviousSimpleTense()
    }
    
    func getNextSimpleTense()->Tense{
        languageEngine.getNextSimpleTense()
    }
    
    
    func hasSimpleTenses()->Bool{
        languageEngine.getSimpleTensesFromList(getTenseList()).count > 0
    }
    
    func selectThisVerbModel(verbModel: RomanceVerbModel){
        languageEngine.selectThisVerbModel(verbModel: verbModel)
    }
    
    func getRandomSentenceObject()->FeatherSentenceHandler{
        languageEngine.getRandomSentenceObject()
    }
    
    func restoreV2MPackage(){
        languageEngine.restoreV2MPackage()
        
    }
    
    func getVerbOrModelMode()->VerbOrModelMode{
        languageEngine.getVerbOrModelMode()
    }
    
    func dumpCompletedVerbModelList(_ msg: String){
        languageEngine.dumpCompletedVerbModelList(msg)
    }
//    func getModelPatternStructList(ending: VerbEnding)->[ModelPatternStruct]{
//        languageEngine.getModelPatternStructList(ending: ending)
//    }
    
    func setLanguage(language: LanguageType){
        languageEngine.setLanguage(language: language)
        currentLanguage = languageEngine.getCurrentLanguage()
    }
    
    func getSpecialVerbType()->SpecialVerbType{
        languageEngine.specialVerbType
    }
    
    func getPersonString(personIndex: Int, tense: Tense, specialVerbType: SpecialVerbType, verbString: String)->String{
        languageEngine.getPersonString(personIndex: personIndex, tense: tense, specialVerbType: specialVerbType, verbString: verbString)
    }
    
    func getVerbString(personIndex: Int, number: Number, tense: Tense, specialVerbType: SpecialVerbType,  verbString: String, dependentVerb: Verb, residualPhrase: String)->String{
        languageEngine.getVerbString(personIndex: personIndex, number: number, tense: tense, specialVerbType: specialVerbType, verbString: verbString, dependentVerb: dependentVerb, residualPhrase: residualPhrase)
    }
    
    func computeVerbsExistForAll3Endings()->Bool{
        languageEngine.computeVerbsExistForAll3Endings()
    }
    
    func setVerbsExistForAll3Endings(flag: Bool){
        languageEngine.setVerbsExistForAll3Endings(flag: flag)
    }
    
    func getVerbsExistForAll3Endings()->Bool{
        languageEngine.getVerbsExistForAll3Endings()
    }
    
    func fillVerbCubeAndQuizCubeLists(){
        languageEngine.fillVerbCubeAndQuizCubeLists()
    }
    
    func toggleSpeechMode(){
        languageEngine.toggleSpeechMode()
    }
    
    func isSpeechModeActive()->Bool{
        languageEngine.isSpeechModeActive()
    }
    
    func getVerbList()->[Verb]{
        return languageEngine.getVerbList()
    }
    
    func getSubjunctiveTerm(tense: Tense)->String{
        if  tense == .presentSubjunctive || tense == .imperfectSubjunctiveRA  || tense == .imperfectSubjunctiveSE {
            if currentLanguage == .Spanish { return "que"}
            else if currentLanguage == .French { return "qui"}
        }
        return ""
    }
    
    func initializeStudentScoreModel(){
        languageEngine.initializeStudentScoreModel()
    }
    
    func getStudentScoreModel()->StudentScoreModel{
        languageEngine.studentScoreModel
    }
    
    func setSubjectPronounType(spt: SubjectPronounType){
        return languageEngine.setSubjectPronounType(spt: spt)
    }
    
    func getSubjectPronounType()->SubjectPronounType{
        let spt = languageEngine.getSubjectPronounType()
        return spt
    }
    
    func getLanguageEngine()->LanguageEngine{
        return languageEngine
    }
    
    func getSubjectGender()->Gender{
        languageEngine.getSubjectGender()
    }
    
    func verbsOfAFeather(verbList: [Verb])->Bool{
        return languageEngine.verbsOfAFeather(verbList:verbList)
    }
    
    func getCurrentLanguage()->LanguageType{
        return languageEngine.getCurrentLanguage()
    }
    
    func setNextVerb(){
        languageEngine.setNextVerb()
    }
    
    func setPreviousVerb(){
        languageEngine.setPreviousVerb()
    }
    
    func setCurrentVerb(verb: Verb){
        languageEngine.setCurrentVerb(verb: verb)
    }
    
    
    func getCurrentVerb()->Verb{
        languageEngine.getCurrentVerb()
    }
    
    func getRandomVerb()->Verb{
        languageEngine.getRandomVerb()
    }
    
    func getCoreVerb(verb: Verb)->Verb{
        languageEngine.getCoreVerb(verb: verb)
    }
    
    func getTenseList()->[Tense]{
        languageEngine.getTenseList()
    }
    
    func setTenses(tenseList: [Tense]){
        languageEngine.setTenses(tenseList: tenseList)
    }
    
    func getCurrentPerson()->Person{
        languageEngine.getCurrentPerson()
    }
    
    func getNextPerson()->Person{
        languageEngine.getNextPerson()
    }
    
    func getPreviousPerson()->Person{
        languageEngine.getPreviousPerson()
    }
    
    func getRandomPerson()->Person{
        languageEngine.getRandomPerson()
    }
    
    func getNextTense()->Tense {
        languageEngine.getNextTense()
    }
    
    func getPreviousTense()->Tense {
        languageEngine.getPreviousTense()
    }
    
    func getRandomTense()->Tense {
        languageEngine.getRandomTense()
    }
    
    func setRandomTense(){
        languageEngine.setRandomTense()
    }
    
    func getCurrentTense()->Tense{
        languageEngine.getCurrentTense()
    }
    
    func getCurrentConjugatedVerbString()->String{
        languageEngine.getCurrentConjugatedVerbString()
    }
    
    func getMorphStructManager()->MorphStructManager{
        languageEngine.getMorphStructManager()
    }
    
    func createConjugatedMorphStruct(verb: Verb, tense: Tense, person: Person)->MorphStruct{
        return languageEngine.createConjugatedMorphStruct(verb: verb, tense: tense, person: person)
    }
    
    func getFinalVerbForm(person: Person)->String{
        languageEngine.getFinalVerbForm(person: person)
    }
    
    func getFinalVerbForms(person: Person, verbList: [Verb])->[String]{
        return languageEngine.getFinalVerbForms(person: person, verbList: verbList)
    }
    
    func findVerbFromString(verbString: String, language: LanguageType)->Verb{
        return languageEngine.findVerbFromString(verbString: verbString, language: language)
    }
                                                 
    func getVerbPhrase()->String{
        languageEngine.getVerbPhrase()
    }
    
    func isCurrentMorphStepFinal(person: Person)->Bool{
        languageEngine.isCurrentMorphStepFinal(person: person)
    }
    
    func resetCurrentMorphStepIndex(person: Person){
        languageEngine.resetCurrentMorphStepIndex(person: person)
    }
    
    func getCurrentMorphStepAndIncrementIndex(person: Person)->MorphStep{
        languageEngine.getCurrentMorphStepAndIncrementIndex(person: person)
    }
    
    func getCriticalVerbForms()->[CriticalStruct]{
        languageEngine.getCriticalVerbForms()
    }

    func fillCriticalVerbForms(verb: Verb, residualPhrase: String, isReflexive: Bool){
        languageEngine.fillCriticalVerbForms(verb: verb, residualPhrase:residualPhrase, isReflexive: isReflexive)
    }

    func createAndConjugateAgnosticVerb(language: LanguageType, verb: Verb, tense: Tense, person: Person, isReflexive: Bool)->String{
        languageEngine.createAndConjugateAgnosticVerb(language: language, verb: verb, tense: tense, person: person, isReflexive: isReflexive)
    }
    
    func createAndConjugateAgnosticVerb(verb: Verb, tense: Tense, person: Person)->String{
        languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
    }
    
    func createAndConjugateCurrentFilteredVerb(){
        languageEngine.createAndConjugateCurrentFilteredVerb()
    }
    
    func createAndConjugateCurrentRandomVerb(){
        languageEngine.createAndConjugateCurrentRandomVerb()
    }
    
    func createAndConjugateAgnosticVerb(verb: Verb)->BRomanceVerb{
        languageEngine.createAndConjugateAgnosticVerb(verb: verb)
    }
    
    func createAndConjugateAgnosticVerb(verb: Verb, tense: Tense){
        languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense)
    }
    
    func getRomanceVerb(verb: Verb)->BRomanceVerb{
        languageEngine.getRomanceVerb(verb: verb)
    }
    
    public func hasVerbEnding(verb: Verb, verbEnding: VerbEnding)->Bool{
        languageEngine.hasVerbEnding(verb: verb, verbEnding: verbEnding)
    }

    func isVerbType(verb : Verb, verbType: ShowVerbType)->Bool{
        languageEngine.isVerbType(verb : verb, verbType: verbType)
    }
    
    func isVerbType(verb : Verb, tense : Tense, person : Person, verbType: ShowVerbType)->Bool{
        languageEngine.isVerbType(verb : verb, tense : tense, person : person, verbType: verbType)
    }
    
    func getVerbModelLessonList()->[VerbModelLesson]{
        languageEngine.getVerbModelLessonList()
    }
    
//    func checkForStemChanging(verb: BRomanceVerb, tense: Tense, person: Person)->Bool{
//        languageEngine!.checkForStemChanging(verb: verb, tense: tense, person: person)
//    }
//    
//    func checkForOrthoChanging(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
//        languageEngine!.checkForOrthoChanging(verb: verb, tense: tense, person: person)
//    }
//    
//    func checkForIrregular(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
//        languageEngine!.checkForIrregular(verb: verb, tense: tense, person: person)
//    }
//    
//    func checkForSpecial(verb: BSpanishVerb, tense: Tense, person: Person)->Bool{
//        languageEngine!.checkForSpecial(verb: verb, tense: tense, person: person)
//    }
//    
//    func getVerbsOfSelectedEnding(verbEnding: VerbEnding)->[Verb]{
//        languageEngine.getVerbsOfSelectedEnding(verbEnding: verbEnding)
//    }
//            
    func countVerbsOfSelectedType(showVerbType: ShowVerbType)->Int{
        languageEngine.countVerbsOfSelectedType(showVerbType: showVerbType)
    }
    
//    func getWordCollections()->[dWordCollection] {
//        languageEngine.getWordCollections()
//    }
    
//    func createWordCollection(verbList: [Verb], collectionName: String){
//        languageEngine.createWordCollection(verbList: verbList, collectionName: collectionName)
//    }
    
    func unConjugate(verbForm : String)->[VTP]{
        return languageEngine.unConjugate(verbForm: verbForm)
    }
    
//    func getBehavioralVerbModel()->BehavioralVerbModel{
//        languageEngine.getBehavioralVerbModel()
//    }
//    
//    func getBehavioralVerbType()->BehaviorType{
//        return languageEngine.behaviorType
//    }
//    
//    func getCurrentBehavioralVerb()->Verb{
//        languageEngine.getCurrentBehavioralVerb()
//    }
//    
//    func setNextBehavioralVerb(){
//        languageEngine.setNextBehavioralVerb()
//    }
//    
//    func setPreviousBehavioralVerb(){
//        languageEngine.setPreviousBehavioralVerb()
//    }
//    
//    func setBehaviorType(bt: BehaviorType){
//        languageEngine.setBehaviorType(bt: bt)
//    }
//    
//    func getBehaviorType()->BehaviorType{
//        languageEngine.behaviorType
//    }
//    
    func isAuxiliary(verb: Verb)->(Bool, Tense){
        languageEngine.isAuxiliary(verb: verb)
    }
}





