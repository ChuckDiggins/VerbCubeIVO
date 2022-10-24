//
//  CFModelView.swift
//  ContextFree
//
//  Created by Charles Diggins on 4/4/21.
//

import Foundation
import JumpLinguaHelpers

class CFModelView: ObservableObject {
    private var cfModel : CFModel?
    private var language : LanguageType
    
    private var activeCluster = dCluster()
    private var activeWordType =  WordType.ambiguous
    private var currentWordType : WordType
    
    init(language: LanguageType){
        currentWordType = activeWordType
        self.language = language
        cfModel = CFModel(language: language)
    }
    
    func getModel()->CFModel{
        return cfModel!
    }
    
    func setCurrentClusterAndWordTypeForFilling(cluster: dCluster, wordType: WordType){
        activeCluster = cluster
        activeWordType = wordType
    }
    
    func setActiveCluster(cluster: dCluster){
        activeCluster = cluster
        
        let ct = activeCluster.getClusterType()
        activeWordType = getWordType(clusterType: ct)
    }
    
    func getActiveCluster()->dCluster{
        return activeCluster
    }
    
    func getActiveWordType()->WordType{
        activeWordType = getWordType(clusterType: activeCluster.getClusterType())
        return activeWordType
    }
    
    func getParser()->WordStringParser{
        return cfModel!.getParser()
    }
    func createNewModel(language: LanguageType){
        //cfModel = CFModel(language: language)
    }
    
    func getVerbModel(language: LanguageType)->VerbModelConjugation{
        return (cfModel?.getVerbModel(language: language))!
    }
    
    func getRandomWordList()->RandomWordLists{
        return (cfModel?.getRandomWordLists())!
    }
    
    func getWordStringParser()->WordStringParser{
        return (cfModel?.getWordStringParser())!
    }
    
    func getRandomAgnosticSentence(clause: dIndependentAgnosticClause, rft: RandomPhraseType){
        cfModel?.getRandomAgnosticSentence(clause: clause, rft: rft)
    }

    func getRandomSentenceObject()->RandomSentence{
        return (cfModel?.getRandomSentenceObject())!
    }
    
    func analyzeAndCreateBVerb_SPIFE(language: LanguageType, verbPhrase: String)->(isValid: Bool, verb: BVerb){
        return cfModel!.analyzeAndCreateBVerb_SPIFE(language: language, verbPhrase: verbPhrase)
    }

    func  getWordCount(wordType: WordType)->Int{
        return cfModel!.getWordCount(wordType: wordType)
    }
    
    func getListWord(index: Int, wordType: WordType)->Word{
        return  cfModel!.getListWord(index: index, wordType: wordType)
    }
    
    func appendJsonVerb(jsonVerb: JsonVerb)->Int{
        return 5
    }
 
    func append(spanishVerb : RomanceVerb, frenchVerb: RomanceVerb ){
       cfModel!.append(spanishVerb: spanishVerb, frenchVerb : frenchVerb)
    }

    func getCurrentLanguage()->LanguageType{
        return cfModel!.m_currentLanguage
    }

    func getRandomAgnosticSentence()->dIndependentAgnosticClause{
        return cfModel!.getRandomAgnosticSentence()
    }
  
    func getModifierList(wordType: WordType)->Array<Word>{
        return cfModel!.getModifierList(wordType: wordType)
    }
    
    func getAgnosticWordList(wordType: WordType)->Array<Word>{
        return cfModel!.getAgnosticWordList(wordType: wordType)
    }
    
    func getAgnosticWorkingWordList(wordType: WordType)->Array<Word>{
        return cfModel!.getAgnosticWorkingWordList(wordType: wordType)
    }
    
    func getNounList()->Array<Word>{
        return cfModel!.getNounList()
    }
    
    func getVerbList()->Array<Word>{
        return cfModel!.getVerbList()
    }
    
    func getVerbCount()->Int{
        return cfModel!.getVerbCount()
    }
    
   

    func getNextPerson(currentPerson:Person)->Person{
        return cfModel!.getNextPerson(currentPerson: currentPerson)
    }
    
    func getRandomPerson()->Person{
        return cfModel!.getRandomPerson()
    }
    
    func getRandomTense()->Tense{
        return cfModel!.getRandomTense()
    }
    
    func getNextTense()->Tense{
        return cfModel!.getNextTense()
    }
    
    func getPreviousTense()->Tense{
        return cfModel!.getPreviousTense()
    }
    
    func getGrammarLibrary()->CFGrammarLibrary{
        return cfModel!.getGrammarLibrary()
    }
    
//
//    func getRandomSubjPronounSentence()->dIndependentClause{
//        return cfModel!.getRandomSubjPronounSentence()
//    }
//
//    func createIndependentClause(clauseString: String)->dIndependentClause{
//        return cfModel!.createIndependentClause(clauseString: clauseString)
//    }
    
    func getBundleManager()->dBundleManager{
        return cfModel!.lessonBundlePhraseCollectionManager.bundleManager
       }
   
       func getPhraseManager()->dPhraseManager{
           return cfModel!.lessonBundlePhraseCollectionManager.phraseManager
       }
   
    func getWordCollectionManager()->dWordCollectionManager{
        return cfModel!.lessonBundlePhraseCollectionManager.wordCollectionManager
    }

    func getJsonWordCollectionManager()->JSONCollectionManager{
        return cfModel!.lessonBundlePhraseCollectionManager.jsonWordCollectionManager
    }
}
