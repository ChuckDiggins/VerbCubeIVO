//
//  BescherelleActiveVerbConjugation.swift
//  VIperSpanish 2
//
//  Created by Charles Diggins on 3/11/21.
//

//Chuck Nov 25
import Foundation
import JumpLinguaHelpers

public class ActiveVerbConjugationSpanish {
    var perfectVerb = [[String]]()  //Spanish ... haber
    var progressiveVerb = [[String]]() //Spanish ... estar
    var specialVerbsFilled = false
    //var bescherelleModelConjugation = BescherelleModelConjugation()
    var p3PreteriteVerbWord = ""

    //this is so much easier than trying to construct these verbs on the fly
    // plus, there is no morphing history to deal with
    
    // .... if they care they can l
    public func fillHaberAndEstar(){
        perfectVerb = [
            ["he", "has", "ha", "hemos", "habéis", "han"],
            ["había", "habías", "había", "habíamos","habíais","habían"],
            ["hube", "hubiste", "hubo", "hubimos", "hubisteis", "hubieron"],
            ["habré", "habrás", "habrá", "habremos", "habréis", "habrán"],
            ["habría", "habrías", "habría", "habríamos", "habríais", "habrían"],
            ["haya", "hayas", "haya", "hayamos", "hayais", "hayan" ],
            ["hubiera", "hubieras", "hubiera", "hubiéramos", "hubierais", "hubieran"],
            ["hubiese", "hubieses", "hubiese", "hubiésemos", "hubieseis", "hubiesen"]
        ]
        progressiveVerb = [
            ["estoy", "estás", "está", "estamos", "estáis", "están"],
            ["estaba", "estabas", "estábamos", "estaba", "estaba", "estaba"],
            ["estaré", "estarás", "estará", "estaremos", "estaréis", "estarán" ],
            ["estaría", "estarías", "estaría", "estaríamos", "estaríais", "estarían" ]
        ]
        specialVerbsFilled = true
    }

    public func getPerfectVerb(tense: Tense, person: Person)->String {
        if !specialVerbsFilled {fillHaberAndEstar()}
        let tenseIndex = tense.getPerfectIndex()
        let personIndex = person.getIndex()
        return perfectVerb[tenseIndex][personIndex]
    }
        
    public func getProgressiveVerb(tense: Tense, person: Person)->String {
        if !specialVerbsFilled {fillHaberAndEstar()}
        let tenseIndex = tense.getProgressiveIndex()
        let personIndex = person.getIndex()
        return progressiveVerb[tenseIndex][personIndex]
    }
    
    //indicative and subjunctive
    
    public  func createInitialMorphSteps(verb: BSpanishVerb, person : Person, conjugateEntirePhrase: Bool)->MorphStruct
    {
    var workingMorphStruct = verb.getMorphStruct(person: person)
    let preposition = verb.m_residualPhrase
    var pronounString = ""
    var morphStep = MorphStep()
    var hasPhrase = false
    
    workingMorphStruct.clear()
    if conjugateEntirePhrase {
        workingMorphStruct.clear()
        
        
        morphStep.verbForm = verb.m_verbWord
        if verb.isReflexive() {
            morphStep.verbForm += "se"
            hasPhrase = true
        }
        if verb.hasPreposition() {
            morphStep.verbForm += " " + preposition
            hasPhrase = true
        }
        if hasPhrase {
            morphStep.comment = "Start with the verb phrase:" + " " + verb.getPhrase()
        } else {
            morphStep.comment = "Start with the infinitive:" + " " + verb.getPhrase()
        }
        workingMorphStruct.append(morphStep : morphStep)
        
        if  verb.isReflexive() {
            pronounString = Pronoun().getReflexive(language: .Spanish, person: person, startsWithVowelSound: false) + " "
            
            //if S3 or P3, then pronoun 'se' does not have to change
            
            if  person != .S3 && person != .P3 {
                var morphStep = MorphStep()
                morphStep.comment = "Convert reflexive pronoun 'se' to correct person '\(pronounString)'"
                morphStep.verbForm = verb.m_verbWord + pronounString + "  " + preposition
                workingMorphStruct.append(morphStep : morphStep)
            }
            
            morphStep = MorphStep()
            morphStep.comment = "Move the pronoun '" + pronounString + "' to front of verb"
            morphStep.verbForm = pronounString + " " + verb.m_verbWord
            workingMorphStruct.append(morphStep : morphStep)
        }
    }
    else {
        morphStep.comment = "Start with verb infinitive " + " " + verb.m_verbWord
        morphStep.verbForm = verb.m_verbWord
        workingMorphStruct.append(morphStep : morphStep)
    }
    return workingMorphStruct
    }

    public func conjugateThisImperativeForm(verb : BSpanishVerb, person : Person, conjugateEntirePhrase : Bool ) -> MorphStruct {
        switch(person){
        case .S1:
            var ms = MorphStruct(person: .S1)
            var word = verb.m_verbWord
            word.removeLast()
            var morphStep = MorphStep()
            morphStep.comment = "There is no command form for first person singular -> I"
            morphStep.verbForm = ""
            ms.append(morphStep: morphStep)
            return ms
        case .S2: return conjugateThisSimpleIndicativeNew(verb: verb, tense: .present, person: .S3, conjugateEntirePhrase: false)
        case .S3: return conjugateThisSimpleIndicativeNew(verb: verb, tense: .presentSubjunctive, person: .S3, conjugateEntirePhrase: false)
        case .P1: return conjugateThisSimpleIndicativeNew(verb: verb, tense: .presentSubjunctive, person: .P1, conjugateEntirePhrase: false)
        case .P2:
            var ms = MorphStruct(person: .S1)
            var word = verb.m_verbWord
            word.removeLast()
            var morphStep = MorphStep()
            morphStep.verbForm = word+"d"
            ms.append(morphStep: morphStep)
            return ms
        case .P3: return conjugateThisSimpleIndicativeNew(verb: verb, tense: .presentSubjunctive, person: .P3, conjugateEntirePhrase: false)
        }
    }
    
    public func conjugateThisSimpleIndicativeNew(verb : BSpanishVerb, tense : Tense, person : Person , conjugateEntirePhrase : Bool ) -> MorphStruct {
    
        var verbConjugated = false
        let p3PreteriteVerbForm = verb.getP3PreteriteForm()
        let preposition = ""
        
        BSpanishVerbExtras().restoreMorphStructs(verb: verb)
        
        //this is where we decide whether to use standard, stem or pretStem morphStruct
        
        var workingMorphStruct = verb.getMorphStruct(tense: tense, person: person)
        
//        if person == .S1 { verb.dumpMorphStruct(morphStruct: workingMorphStruct, comment: "conjugateThisSimpleIndicativeNew")}
//        
//        if ( person == .S1 && verb.isStemChanging()){
//            verb.dumpMorphStruct(morphStruct: workingMorphStruct,
//                                 comment: "conjugateThisSimpleIndicativeNew - working struct - person \(person.getMaleString())")
//        }
                  
        if ( verb.m_replacementVerbInfinitive.count > 0  && (tense == .future || tense == .conditional )){
            workingMorphStruct = replaceVerbInfinitive(inputMorphStruct : workingMorphStruct, baseInfinitive: verb.m_baseVerbInfinitive,
                                                       replacementInfinitive: verb.m_replacementVerbInfinitive)
        }
        
        
        let verbWord = workingMorphStruct.finalVerbForm()
        
        //var ms = MorphStruct(person: person)
        
        if ( verb.m_specialModel != SpecialSpanishVerbModel.none ){
            workingMorphStruct = IrregularVerbsSpanish().getIrregularFormSpecial(inputMorphStruct : workingMorphStruct, verb : verb, preposition : "",
                                                                   specialVerbModel : verb.m_specialModel,
                                                                   tense : tense, person : person)
            //print("tense \(tense), person \(person) -- \(workingMorphStruct.finalVerbForm())")
            workingMorphStruct.isIrreg = true
            if workingMorphStruct.isComplete() {return workingMorphStruct}
        }
        
        //if this verb has a verb model at this tense/person, then conjugate it ... otherwise it's regular
        let replaceForm = verb.hasReplaceForm(tense: tense, person: person)
        if ( replaceForm.0.count > 0 ){
            return StemChangingConjugation().createStemConjugatedForm(inputMorphStruct : workingMorphStruct, verb: verb, tense: tense, person : person, stemFrom: replaceForm.0, stemTo : replaceForm.1)
        }
        
//        let replaceEndingForm = verb.hasReplaceEndingForm(tense: tense, person: person)
//        if ( replaceEndingForm.0.count>0 ){
//            return RegularSpanishVerb().replaceEndingForm(inputMorphStruct : workingMorphStruct, from: replaceEndingForm.0, to : replaceEndingForm.1)
//        }
//
        
        //can we intercept the stem-changing infinitive here?
        let result = verb.hasStemSingleForm(tense: tense, person: person)
        if ( result.0 != "" ){
            //do the stem change first
            workingMorphStruct = StemChangingConjugation().createStemConjugatedForm(inputMorphStruct : workingMorphStruct, verb: verb, tense: tense, person : person, stemFrom: result.0, stemTo : result.1)
            //then if there is any ortho, do it here
            if verb.isOrthoPresent(tense: tense, person: person) {
                let from = verb.m_orthoPresentFrom
                let to = verb.m_orthoPresentTo
                workingMorphStruct = RegularSpanishVerb().createStemOrthoForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, orthoFrom: from, orthoTo: to)
            }
            if verb.isOrthoPresentSubjunctive(tense: tense, person: person){
                let from = verb.m_orthoPresentSubjunctiveFrom
                let to = verb.m_orthoPresentSubjunctiveTo
                workingMorphStruct = RegularSpanishVerb().createStemOrthoForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, orthoFrom: from, orthoTo: to)
            }
            workingMorphStruct = RegularSpanishVerb().attachRegularVerbEnding(morphStruct: workingMorphStruct, tense: tense, person: person, verbEnding: verb.m_verbEnding)
            verbConjugated = true
            return workingMorphStruct
        }
        
        //stem changing - but don't go yet, check for ortho present
        if verb.isStemChanging() {
            if (tense == .present || tense == .presentSubjunctive) && verb.isPersonStem(person: person) {
                //do the stem change first
                workingMorphStruct = StemChangingConjugation().createStemConjugatedForm(inputMorphStruct : workingMorphStruct, verb: verb, tense: tense, person : person, stemFrom: verb.m_stemFrom, stemTo : verb.m_stemTo)
                //then if there is any ortho, do it here
                if verb.isOrthoPresent(tense: tense, person: person){
                    let from = verb.m_orthoPresentFrom
                    let to = verb.m_orthoPresentTo
                    workingMorphStruct = RegularSpanishVerb().createStemOrthoForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, orthoFrom: from, orthoTo: to)
                }
                if verb.isOrthoPresentSubjunctive(tense: tense, person: person){
                    let from = verb.m_orthoPresentSubjunctiveFrom
                    let to = verb.m_orthoPresentSubjunctiveTo
                    workingMorphStruct = RegularSpanishVerb().createStemOrthoForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, orthoFrom: from, orthoTo: to)
                }
                workingMorphStruct = RegularSpanishVerb().attachRegularVerbEnding(morphStruct: workingMorphStruct, tense: tense, person: person, verbEnding: verb.m_verbEnding)
                verbConjugated = true
                
                return workingMorphStruct
            }
        }
        
        
        //preterite specific stem conjugations
        if ( tense == .preterite ){
            if ( verb.isPretStemChanging() ){
                workingMorphStruct =  StemChangingConjugation().createStemConjugatedForm(inputMorphStruct : workingMorphStruct, verb: verb, tense: tense, person : person, stemFrom : verb.m_pretStemFrom, stemTo : verb.m_pretStemTo)
                workingMorphStruct = StemChangingConjugation().attachPretStemEnding(inputMorphStruct: workingMorphStruct,  person: person)
                verbConjugated = true
            }
            else if ( verb.isPretStem2Changing() && verb.isPersonPretStem2(person: person)){
                workingMorphStruct =   StemChangingConjugation().createStemConjugatedForm(inputMorphStruct : workingMorphStruct, verb: verb, tense: tense, person : person, stemFrom : verb.m_pretStem2From, stemTo : verb.m_pretStem2To)
                workingMorphStruct = StemChangingConjugation().attachPretStem2Ending(inputMorphStruct: workingMorphStruct, person: person)
                verbConjugated = true
            }
            else if ( verb.isPretStem3Changing() && verb.isPersonPretStem3(person: person)){
                workingMorphStruct = StemChangingConjugation().createPretStem3ConjugatedForm(inputMorphStruct : workingMorphStruct, verbWord : verbWord, person : person)
                verbConjugated = true
            }
            
            let replaceEndingForm = verb.hasReplaceEndingForm(tense: tense, person: person)
            if ( replaceEndingForm.0.count>0 ){
                workingMorphStruct = RegularSpanishVerb().replaceForm(inputMorphStruct : workingMorphStruct, person: person, from: replaceEndingForm.0, to : replaceEndingForm.1)
            }
            if verbConjugated {
                return workingMorphStruct
            }
            
        }
        
        if verb.isOrthoPreterite(tense: tense, person: person) {
            let from = verb.m_orthoPreteriteFrom
            let to = verb.m_orthoPreteriteTo
            return RegularSpanishVerb().createRegularOrthoForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, orthoFrom: from, orthoTo: to)
        }
        
        if verb.isOrthoPresent(tense: tense, person: person){
            let from = verb.m_orthoPresentFrom
            let to = verb.m_orthoPresentTo
            return RegularSpanishVerb().createRegularOrthoForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, orthoFrom: from, orthoTo: to)
        }
        
        let replaceEndingForm = verb.hasReplaceEndingForm(tense: tense, person: person)
        if ( replaceEndingForm.0.count>0 ){
            return RegularSpanishVerb().replaceEndingForm(inputMorphStruct : workingMorphStruct, from: replaceEndingForm.0, to : replaceEndingForm.1)
        }
        
        if verbConjugated {
            return workingMorphStruct
        }
        else {
            //treat this verb as a "regular" verb
        
            return RegularSpanishVerb().createRegularForm(verbEnding : verb.m_verbEnding, inputMorphStruct : workingMorphStruct, verbWord : verbWord, preposition : preposition, tense : tense, person : person, p3PreteriteVerbForm: p3PreteriteVerbForm)
        }
    }

    public func replaceVerbInfinitive(inputMorphStruct : MorphStruct, baseInfinitive : String, replacementInfinitive : String)-> MorphStruct{
            
        var workingMorphStruct = inputMorphStruct
        let base = baseInfinitive
        var verbWord = inputMorphStruct.finalVerbForm()
        
        var morphStep = MorphStep()
        morphStep.isFutureStem = true
        morphStep.comment = "Grab base infinitive ->\(base)"
        morphStep.verbForm = verbWord
        workingMorphStruct.append(morphStep : morphStep)
            
        //strip it out
            
        verbWord = String(verbWord.dropLast(base.count))
            
        morphStep = MorphStep()
        morphStep.comment = "Replace infinitive with this form ->\(replacementInfinitive)"
        morphStep.verbForm = verbWord + replacementInfinitive
        workingMorphStruct.append(morphStep : morphStep)
        return workingMorphStruct
    }
    
    public  func conjugateThisCompoundVerb(verb : BSpanishVerb, tense : Tense, person : Person , conjugateEntirePhrase : Bool ) -> MorphStruct {
        let preposition = ""
        
        var auxiliaryVerb = ""
        var participle = ""
         
        if tense.isProgressive() {
            auxiliaryVerb = self.getProgressiveVerb(tense: tense, person: person)
            participle = verb.m_gerund
        } else {
            auxiliaryVerb = self.getPerfectVerb(tense: tense, person: person)
            participle = verb.m_pastParticiple
        }

        var pronounString = ""
        //when verb is reflexive and/or has a verb phrase sitting after the verb
        var workingMorphStruct = createInitialMorphSteps(verb: verb, person: person, conjugateEntirePhrase: conjugateEntirePhrase)
        var morph = MorphStep()

//        if verb.isReflexive() {
//            pronounString = Pronoun().getReflexive(language: .Spanish, person: person, startsWithVowelSound: false) + " "
//        }
        
        //preposition = " " + verb.m_residualPhrase
        
        var ss = pronounString + participle
        
        if tense.isProgressive(){morph.comment = "replace with present participle " + participle}
        else { morph.comment = "replace with past participle " + participle }
        
        morph.verbForm = ss + preposition
        workingMorphStruct.append(morphStep: morph)
        
        morph = MorphStep()
        morph.isFinalStep = true
        
        if tense.isProgressive() {   morph.comment = "Insert correct form of verb estar ..." + auxiliaryVerb }
            else {  morph.comment = "Insert correct form of verb haber ..." + auxiliaryVerb }
            
        ss = pronounString + auxiliaryVerb + " " + participle
        morph.verbForm = ss + preposition
        workingMorphStruct.append(morphStep: morph)

        return workingMorphStruct
    }
    
}
