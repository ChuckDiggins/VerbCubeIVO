//
//  LanguageViewModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//


import SwiftUI
import JumpLinguaHelpers
import RealmSwift

//émouvoir
//déchoir
class LanguageViewModel : ObservableObject {
    var insertQueQuiBeforeSubjunctive = true
    var useFeminineSubjectPronouns = true
    var useUstedForS3 = false
    var useVoceForm = false
    var useAlertMode = true
    
    @Published var spt = SubjectPronounType.maleInformal
    
    @Published var languageEngine = LanguageEngine()
   var currentLanguage = LanguageType.Spanish
    
    init(language: LanguageType){
        languageEngine = LanguageEngine(language: language)
    }
    
    func changeLanguage(){
        languageEngine.changeLanguage()
        currentLanguage = languageEngine.getCurrentLanguage()
    }
    
    func setLanguage(language: LanguageType){
        languageEngine.setLanguage(language: language)
        currentLanguage = languageEngine.getCurrentLanguage()
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
    
    func setSubjectPronounType(spt: SubjectPronounType){
        self.spt = spt
    }
    
    func getSubjectPronounType()->SubjectPronounType{
       spt
    }
    
    func getLanguageEngine()->LanguageEngine{
        return languageEngine
    }
    
    func getSubjectGender()->Gender{
        if spt == .femaleFormal || spt == .femaleInformal { return .feminine }
        return .masculine
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
    
    func getTenseList()->[Tense]{
        languageEngine.getTenseList()
    }
    
    func setTenses(tenseList: [Tense]){
        languageEngine.setTenses(tenseList: tenseList)
    }
    
    func getNextPerson()->Person{
        languageEngine.getNextPerson()
    }
    
    func getPreviousPerson()->Person{
        languageEngine.getPreviousPerson()
    }
    
    func getNextTense()->Tense {
        languageEngine.getNextTense()
    }
    
    func getPreviousTense()->Tense {
        languageEngine.getPreviousTense()
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

    func createAndConjugateAgnosticVerb(verb: Verb, tense: Tense, person: Person)->String{
        languageEngine.createAndConjugateAgnosticVerb(verb: verb, tense: tense, person: person)
    }
    
    func createAndConjugateCurrentFilteredVerb(){
        languageEngine.createAndConjugateCurrentFilteredVerb()
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
    func getVerbsOfSelectedEnding(verbEnding: VerbEnding)->[Verb]{
        languageEngine.getVerbsOfSelectedEnding(verbEnding: verbEnding)
    }
            
    func countVerbsOfSelectedType(showVerbType: ShowVerbType)->Int{
        languageEngine.countVerbsOfSelectedType(showVerbType: showVerbType)
    }
    
    func getWordCollections()->[dWordCollection] {
        languageEngine.getWordCollections()
    }
    
    func createWordCollection(verbList: [Verb], collectionName: String){
        languageEngine.createWordCollection(verbList: verbList, collectionName: collectionName)
    }
    
    func unConjugate(verbForm : String)->[VTP]{
        return languageEngine.unConjugate(verbForm: verbForm)
    }
}





