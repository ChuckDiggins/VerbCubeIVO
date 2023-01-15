//
//  dAgnosticIndependentClause.swift
//  ContextFree
//
//  Created by Charles Diggins on 6/25/21.
//  added to Verbs of a Feather on 12/30/22
//

import Foundation
import JumpLinguaHelpers

public class dIndependentAgnosticClause : dClause{
    public var grammarLibrary = CFGrammarLibrary()
    public var frenchGrammarLibrary = CFGrammarLibrary()
    public var originalSentenceString = String()
    public var processedSentenceString = ""
    //var dataList = Array<SentenceData>()
    //var clauseList = Array<WordRuleManager>()
    public var currentWordRuleIndex = 0
    //var sentence = dSentence()
    public var headNoun = dCluster(word: Word(), clusterType: .UNK)
    public var headVerb = dCluster(word: Word(), clusterType: .UNK)
    public var m_cfMorphStruct = CFMorphStruct()
    
    public var workingSingleList = [dSingle]()
    
    public override init(){
        super.init()
//        print("\nNew dIndependentAgnosticClause")
    }
//    func appendCluster(cluster: dCluster){
//        //let ct = cluster.getClusterType()
//        sentence.appendCluster(cluster: cluster)
//    }
    
    public func initializeMorphStructs(){
        m_cfMorphStruct.clear()
    }
    
    public func copy(inClause :dIndependentAgnosticClause){
        clearClusterList()
        for cluster in inClause.getClusterList() {
            appendCluster(cluster: cluster)
        }
        setHeadNounAndHeadVerb()
    }
    
    public func convertRomancePhraseOrderToEnglishPhraseOrder(){
        let cfMap = ContextFreeMapping()
        //let newSentence = dSentence()
        let newCluster = dCluster()
        
        for cluster in getClusterList() {
            switch cluster.getClusterType() {
            case .NP:
                let c = cluster as! dNounPhrase
                newCluster.appendCluster(cluster: cfMap.fromRomanceNPToEnglishNP(fromNP: c))
            case .PP:
                let c = cluster as! dPrepositionPhrase
                newCluster.appendCluster(cluster: cfMap.fromRomancePPToEnglishPP(fromPP: c))
            case .VP:
                let c = cluster as! dVerbPhrase
                newCluster.appendCluster(cluster: cfMap.fromRomanceVPToEnglishVP(fromVP: c))
            default:
                newCluster.appendCluster(cluster: cluster)
            }
            
        }
        setClusterList(clusterList: newCluster.getClusterList())
    }
    
    public func getCompositeSentenceString(language: LanguageType, targetFunction: ContextFreeFunction)
                     ->(targetSingleList: [dSingle], gender: Gender, number: Number, person: Person, targetString: String) {
        //var workingSingleList = [dSingle]()
        //var singleListBefore = Array<dSingle>()  //pre target
        //var singleListAfter = Array<dSingle>()  //after target

        // first find the start index of the target function
        
        var gender = Gender.masculine
        var number = Number.singular
        var person = Person.S3
        var targetSingleList = Array<dSingle>()
        var targetString = ""
        
        for cluster in getClusterList(){
            print ("getCompositeSentenceString: Top level \(cluster)")
            
            switch cluster.getClusterType() {
            case .NP:
                let nounPhrase = cluster as! dNounPhrase
                if nounPhrase.getClusterFunction() == targetFunction {
                    targetSingleList = nounPhrase.getSingleList(inputSingleList: targetSingleList)
                    gender = nounPhrase.getGender()
                    number = nounPhrase.getNumber()
                    person = nounPhrase.getPerson()
                }
            case .VP:
                let verbPhrase = cluster as! dVerbPhrase
                for vc in verbPhrase.getClusterList() {
                    print ("... sub level \(vc)")
                    if vc.getClusterType() == .PP {
                        let prepPhrase = vc as! dPrepositionPhrase
                        if prepPhrase.getClusterFunction() == targetFunction {
                            targetSingleList = prepPhrase.getSingleList(inputSingleList: targetSingleList)
                            gender = prepPhrase.getGender()
                            number = prepPhrase.getNumber()
                            person = prepPhrase.getPerson()
                            break
                        }
                    }
                    else if vc.getClusterType() == .NP {
                        let nounPhrase = vc as! dNounPhrase
                        if nounPhrase.getClusterFunction() == targetFunction {
                            targetSingleList = nounPhrase.getSingleList(inputSingleList: targetSingleList)
                            gender = nounPhrase.getGender()
                            number = nounPhrase.getNumber()
                            person = nounPhrase.getPerson()
                            break
                        }
                    }
                }
            default: continue
            }
        }
        for single in targetSingleList{
            targetString += single.getWordStringAtLanguage(language: language) + " "
        }
                         
        return (targetSingleList, gender, number, person, targetString)
    }
    
    public func processInfo(){
        print("dIndependentAgnosticClause: cluster count = \(getClusterList().count)")
        for cluster in getClusterList(){
            switch cluster.getClusterType() {
            case .Adj, .AdjCls, .Adv, .AMB, .Art, .C, .comma,
                 .Det, .Num, .PersPro, .P, .V, .AuxV, .UNK :
                continue
            case .NP:
                let c = cluster as! dNounPhrase
                c.processInfo()
                if c.m_isSubject {
                    setPerson(value: c.getPerson())
                }
            case .PP:
                let c = cluster as! dPrepositionPhrase
                c.processInfo()
            case .VP:
                let c = cluster as! dVerbPhrase
                c.processInfo()
            default: break
            }
        }
    }
    
    public func setTenseAndPersonAndCreateNewSentenceString(language: LanguageType, tense: Tense, person: Person)->String{
//        print("entering setTenseAndPersonAndCreateNewSentenceString: language= \(language.rawValue), tense=\(tense.rawValue), person=\(person.rawValue)")
        if ( headVerb.getClusterType() != .UNK){
            let hvp = headVerb as! dVerbPhrase
            hvp.setTense(value: tense)
            hvp.setPerson(value: person)
//            print("after: setTenseAndPersonAndCreateNewSentenceString: language= \(language.rawValue), tense=\(hvp.getTense().rawValue), person=\(hvp.getPerson().rawValue)")
        }
        
        if ( headNoun.getClusterType() != .UNK){
            let hnp = headNoun as! dNounPhrase
            hnp.setPerson(value: person)
            hnp.m_isSubject = true
        }
        
        return createNewSentenceString(language: language)
    }
    

    
    public func createNewSentenceString(language: LanguageType)->String{
        var sentenceString = getReconstructedSentenceString(language: language)
        sentenceString = VerbUtilities().makeSentenceByEliminatingExtraBlanksAndDoingOtherStuff(characterArray: sentenceString)
        return sentenceString
    }

    public func getReconstructedSentenceString(language: LanguageType)->String {
        var ss = ""
        var str = ""
    
        for cluster in getClusterList() {
            let type = cluster.getClusterType()
            switch type {
            case .NP:
                let c = cluster as! dNounPhrase
                c.reconcileForLanguage(language: language)  //informs all member clusters of number, gender, etc
                str = c.getStringAtLanguage(language: language)
            case .PP:
                let c = cluster as! dPrepositionPhrase
                str = c.getStringAtLanguage(language: language)
            case .VP:
                let c = cluster as! dVerbPhrase
//                print("verb cluster tense = \(c.getTense().rawValue), person = \(c.getPerson().rawValue)")
                str = c.getStringAtLanguage(language: language)
            default:
                str = ""
                
            }
            ss += str + " "
            
        }
        
        return ss
    }
    
    public func setHeadNounAndHeadVerb(){
        for cluster in getClusterList(){
            //for now assume that the first NP is the head noun
            if cluster.getClusterType() == .NP {
                //print("setting head noun phrase")
                headNoun = cluster
                break
            }
        }
        
        for cluster in getClusterList(){
            if cluster.getClusterType() == .VP {
                //print("setting head verb phrase")
                headVerb = cluster
                break
            }
        }
        informHeadVerb()
    }
    
    //this has the head NP inform the head VP about person
    
    public func hasHeadVerb()->Bool{
        if headVerb.getClusterType() == .V || headVerb.getClusterType() == .VP {return true}
        return false
        
    }
    
    public func getHeadVerb()->Word{
        headVerb.m_clusterWord
    }
    
    public func hasHeadNoun()->Bool{
        if headNoun.getClusterType() == .N || headNoun.getClusterType() == .NP {return true}
        return false
    }
    
    public func informHeadVerb(){
        if hasHeadVerb() && hasHeadNoun() {
            let hvp = headVerb as! dVerbPhrase
            if  headNoun.getClusterType() == .N || headNoun.getClusterType() == .PersPro {hvp.setPerson(value: headNoun.getPerson())}
            else if headNoun.getClusterType() == .NP {
                let hnp = headNoun as! dNounPhrase
                //let npPerson = hnp.getPerson()
                hvp.setPerson(value: hnp.getPerson())
                setGender(value: hnp.getGender())
                setPerson(value: hnp.getPerson())
            }
        }
    }
    
        
    public func getWordString(language: LanguageType, single: dSingle)->String{
        if single.isPersonalPronounType(){
            let ppSingle = single as! dPersonalPronounSingle
            return ppSingle.getWordStringAtLanguage(language: language)
        }
        return single.getProcessWordInWordStateData(language: language) + " "
    }
    
    public func getSingleList()->[dSingle]{
        var singleList = [dSingle]()
        var clusterIndex = 0
        //let count = sentence.getClusterList().count
        
        for cluster in getClusterList(){
            switch cluster.getClusterType() {
            case .Adj, .AdjCls, .Adv, .AMB, .Art, .C, .comma,
                 .Det, .Num, .PersPro, .P, .V, .AuxV, .UNK :
                let single = cluster as! dSingle
                print("clusterIndex \(clusterIndex): \(single.getProcessWordInWordStateData(language: .Spanish))")
                singleList.append(single)
            case .NP:
                let c = cluster as! dNounPhrase
                //c.dumpClusterInfo(str: "getSingleList NP:")
                singleList = c.getSingleList(inputSingleList: singleList)
            case .PP:
                let c = cluster as! dPrepositionPhrase
                singleList = c.getSingleList(inputSingleList: singleList)
            case .VP:
                let c = cluster as! dVerbPhrase
                singleList = c.getSingleList(inputSingleList: singleList)
            default: break
            }
            clusterIndex += 1
        }
        return singleList
    }
    
    public func getSingleStringList(language: LanguageType)->[String]{
        var singleStringList = [String]()
        for single in getSingleList(){
            singleStringList.append(single.getProcessWordInWordStateData(language: language))
        }
        return singleStringList
    }
 
    public func getWordTypeList()->[String]{
        var wordTypeList = [String]()
        for single in getSingleList(){
            wordTypeList.append(single.getWordType().rawValue)
        }
        return wordTypeList
    }
 
    public func getParentPhraseTypeList()->[String]{
        var phraseTypeList = [String]()
        for single in getSingleList(){
            let clusterType = single.getParentClusterType()
            phraseTypeList.append(clusterType.rawValue)
        }
        return phraseTypeList
    }

    
    //working singles - for use in morphing sentences
    
    public func setWorkingSingleList(singleList: [dSingle]){
        workingSingleList = singleList
    }
    
    public func getWorkingSingleList()->[dSingle]{
        return workingSingleList
    }
    
    public func dumpWorkingSingleList(language: LanguageType, showPronounTypes:Bool){
        let workingSingleList = getWorkingSingleList()
        print("dumpWorkingSingleList: ")
        for index in 0 ..< workingSingleList.count {
            let single = workingSingleList[index]
            if showPronounTypes {
                let ptype = single.getPronounType().rawValue
               print("\(index).\(getWordString(language: language, single: single)), \(ptype)")
            }
            else{
               print("\(index).\(getWordString(language: language, single: single))")
            }
        }
    }
    
    //extracting pronoun phrase data
    
    
    public func dumpNounPhraseData(){
        for cluster in getClusterList(){
            switch cluster.getClusterType() {
            case .NP:
                let c = cluster as! dNounPhrase
                c.dumpClusterInfo(str: "dumpNounPhraseData:")
            default: break
            }
        }
    }
    
    
    
    public func getPronoun(language: LanguageType, type : PronounType)->Pronoun{
        switch type{
        case .SUBJECT: return getSubjectPronoun(language: language)
        case .DIRECT_OBJECT: return getDirectObjectPronoun(language: language)
        case .INDIRECT_OBJECT: return getIndirectObjectPronoun(language: language)
        default: return Pronoun()
        }
    }
    
    public func getPronounString(language: LanguageType, type : PronounType)->String{
        let pronoun = getPronoun(language: language, type: type)
        switch language {
        case .Spanish:
            let sp = pronoun as! SpanishPronoun
            return sp.getForm(gender: getGender(), person: getPerson())
        case .French:
            let fr = pronoun as! FrenchPronoun
            return fr.getForm(gender: getGender(), person: getPerson())
        case .English:
            let en = pronoun as! EnglishPronoun
            return en.getForm(gender: getGender(), person: getPerson())
        default:
            return ""
        }
    }
    
    public func getSubjectPronoun(language: LanguageType)->Pronoun
    {
        if ( headNoun.getClusterType() == .UNK){
            setHeadNounAndHeadVerb()
        }
        if headNoun.getClusterType() != .UNK{
            let hnp = headNoun as! dNounPhrase
            return hnp.getEquivalentPronoun(language: language, type : .SUBJECT)
        }
        return Pronoun()
    }
    
    public func getDirectObjectPronoun(language: LanguageType)->Pronoun{
        let hvp = headVerb as! dVerbPhrase
        if hvp.hasClusterFunction(fn: .DirectObject){
            let c = hvp.getClusterAtFunction(fn: .DirectObject)
            let dp = c as! dPhrase
            return dp.getEquivalentPronoun(language: language, type : .DIRECT_OBJECT)
        }
        return Pronoun()
    }
    
    public func getIndirectObjectPronoun(language: LanguageType)->Pronoun{
        let hvp = headVerb as! dVerbPhrase
        if hvp.hasClusterFunction(fn: .DirectObject){
            let c = hvp.getClusterAtFunction(fn: .IndirectObject)
            let dp = c as! dPhrase
            return dp.getEquivalentPronoun(language: language, type : .INDIRECT_OBJECT)
        }
        return Pronoun()
    }
    

    public func getSubjectPronounStringA(language: LanguageType)->String{
        let pronoun = getSubjectPronoun(language: language)
        switch language {
        case .Spanish:
            let sp = pronoun as! SpanishPronoun
            return sp.getForm(gender: getGender(), person: getPerson())
        case .French:
            let fr = pronoun as! FrenchPronoun
            return fr.getForm(gender: getGender(), person: getPerson())
        case .English:
            let en = pronoun as! EnglishPronoun
            return en.getForm(gender: getGender(), person: getPerson())
        default:
            break
        }
        return ""
    }
    
    
    public func getDirectObjectPronounString(language: LanguageType)->String{
        let hvp = headVerb as! dVerbPhrase
        if hvp.hasClusterFunction(fn: .DirectObject){
            let c = hvp.getClusterAtFunction(fn: .DirectObject)
            let dp = c as! dPhrase
            return dp.getEquivalentPronounString(language: language, type : .DIRECT_OBJECT)
        }
        return ""
    }
    
    public func getIndirectObjectPronounString(language: LanguageType)->String{
        let hvp = headVerb as! dVerbPhrase
        if hvp.hasClusterFunction(fn: .IndirectObject){
            let c = hvp.getClusterAtFunction(fn: .IndirectObject)
            let dp = c as! dPhrase
            return dp.getEquivalentPronounString(language: language, type : .INDIRECT_OBJECT)
        }
        return ""
    }
    
    /*
    func getPronounString(language: LanguageType, phrase: dPhrase, fn: ContextFreeFunction)->String{
        return phrase.getEquivalentPronounString(language: language, fn: fn)
    }
 */

}
