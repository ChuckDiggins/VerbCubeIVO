//
//  LanguageEngineStudentLevel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/7/22.
//

import Foundation
import JumpLinguaHelpers

extension LanguageEngine{
   
    func setStudentLevel1001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.present]
    }
    
    func setStudentLevel1002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        
        tenseList = [Tense.present]
    }
    
    func setStudentLevel1003(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present]
    }
    
    func setStudentLevel1004(){
        clearFilteredVerbList()
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.preterite]
    }
    
    func setStudentLevel1005(){
        clearFilteredVerbList()
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.imperfect]
    }
    
    func setStudentLevel1006(){
        clearFilteredVerbList()
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        tenseList = [Tense.conditional, .future]
    }
    
    func setStudentLevel2001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel2002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel2003(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel2004(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ser", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacer", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "haber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ver", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "oír", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "saber", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel3001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.presentSubjunctive, Tense.imperfectSubjunctiveRA, Tense.imperfectSubjunctiveSE]
    }
    
    func setStudentLevel3002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.presentPerfect, Tense.pastPerfectSubjunctiveRA, Tense.pastPerfectSubjunctiveSE]
    }
    
    func setStudentLevel3003(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "comprar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "estudiar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hablar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "esperar", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acabar", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "beber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "aprender", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "deber", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "correr", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sorprender", language: getCurrentLanguage()))
        
        addVerbToFilteredList(verb: findVerbFromString(verbString: "abrir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "añadir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "escribir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "vivir", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "permitir", language: getCurrentLanguage()))
        tenseList = [Tense.imperative]
    }
    
    func setStudentLevel4001(){
        let stemChangingCommonSpanish = [SpecialPatternType.e2i, .e2ie, .i2í, .o2ue, .u2uy, .u2ú,]
       for pattern in stemChangingCommonSpanish{
           currentPatternList.append(pattern)
       }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel4002(){
        currentPatternList.removeAll()
        let orthoChangingCommonSpanish = [SpecialPatternType.a2aig, .c2zc, .c2z, .g2j, .gu2g,]
       for pattern in orthoChangingCommonSpanish{
           currentPatternList.append(pattern)
       }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel4003(){
        currentPatternList.removeAll()
        let stemChangingPreteriteSpanish = [SpecialPatternType.e2i, .o2u, .u2uy]
        for pattern in stemChangingPreteriteSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel4004(){
        currentPatternList.removeAll()
        let stemChangingUncommonSpanish = [SpecialPatternType.e2y, .e2ye, .i2ie, .o2u, .o2hue, .u2ue,]
        for pattern in stemChangingUncommonSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }

    
    func setStudentLevel4005(){
        currentPatternList.removeAll()
        let orthoChangingUncommonSpanish = [SpecialPatternType.cab2quep, .c2g, .c2qu, .c2zg, .ec2ig, .g2gu,
         .gu2gü, .l2lg, .o2oig, .n2ng, .qu2c, .z2c]
        for pattern in orthoChangingUncommonSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }

    func setStudentLevel4006(){
        currentPatternList.removeAll()
        let stemChangingUncommonSpanish = [SpecialPatternType.e2y, .e2ye, .i2ie, .o2u, .o2hue, .u2ue,]
        for pattern in stemChangingUncommonSpanish{
            currentPatternList.append(pattern)
        }
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }

    
    func setStudentLevel5001(){
        clearFilteredVerbList()
        currentModelListAll.removeAll()
        loadCommonARModels()
        loadCommonERModels()
        loadCommonIRModels()
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
        currentModelListAll = currentModelListAR
    }
    
    func loadCommonARModels(){
        currentModelListAR.removeAll()
        currentModelListAR.append(getModelAtModelWord(modelWord: "airar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "encontrar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "enraizar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "regar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "sacar"))
        
        for model in currentModelListAR {
            appendToFilteredVerbList(verbList: findVerbsOfSameModel(targetID: model.id))
        }
        
    }
    
    func loadCommonERModels(){
        currentModelListER.removeAll()
        currentModelListER.append(getModelAtModelWord(modelWord: "parecer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "defender"))
        currentModelListER.append(getModelAtModelWord(modelWord: "creer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "coger"))
        currentModelListER.append(getModelAtModelWord(modelWord: "cocer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "volver"))
        currentModelListER.append(getModelAtModelWord(modelWord: "mover"))
    }
    
    func loadCommonIRModels(){
        currentModelListIR.removeAll()
        currentModelListIR.append(getModelAtModelWord(modelWord: "adquirir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "dirigir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "influir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "lucir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "pedir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "predecir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "sentir"))
    }
    
    func setStudentLevel5002(){
        currentModelListAR.removeAll()
        currentModelListER.removeAll()
        currentModelListIR.removeAll()
        currentModelListAll.removeAll()
        currentModelListAll.append(getModelAtModelWord(modelWord: "dar"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "estar"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "haber"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "hacer"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "oír"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "oler"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "raer"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "salir"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "ser"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "saber"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "tener"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "venir"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "ver"))
        currentModelListAll.append(getModelAtModelWord(modelWord: "ir"))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]

        //create composite verb list since each model will only have a few verbs
        
        
        
        clearFilteredVerbList()
        for model in currentModelListAll {
            appendToFilteredVerbList(verbList: findVerbsOfSameModel(targetID: model.id))
        }
        
    }
    
    func setStudentLevel5003(){
        loadUncommonARModels()
        loadUncommonERModels()
        loadUncommonIRModels()
        
        //create  verb list since each model will only have a few verbs
        
        currentModelListAll.removeAll()
        clearFilteredVerbList()
        let model = currentModelListAR[0]
        appendToFilteredVerbList(verbList: findVerbsOfSameModel(targetID: model.id))

        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    //uncommon verb models
    
    func loadUncommonARModels(){
        currentModelListAR.removeAll()
        currentModelListAR.append(getModelAtModelWord(modelWord: "actuar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "ahincar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "airar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "andar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "aullar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "avergonzar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "colgar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "desosar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "empezar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "forzar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "guiar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "jugar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "pagar"))
        currentModelListAR.append(getModelAtModelWord(modelWord: "trocar"))
    }
    
    func loadUncommonERModels(){
        currentModelListER.removeAll()
        currentModelListER.append(getModelAtModelWord(modelWord: "caber"))
        currentModelListER.append(getModelAtModelWord(modelWord: "caer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "mecer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "placer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "poder"))
        currentModelListER.append(getModelAtModelWord(modelWord: "querer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "roer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "satisfacer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "tañer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "traer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "valer"))
        currentModelListER.append(getModelAtModelWord(modelWord: "yacer"))
    }
    
    func loadUncommonIRModels(){
        currentModelListIR.removeAll()
        currentModelListIR.append(getModelAtModelWord(modelWord: "adquirir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "asir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "bruñir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "decir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "delinquir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "discernir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "dormir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "elegir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "erguir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "pudrir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "podrir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "prohibir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "reñir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "reunir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "salir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "seguir"))
        currentModelListIR.append(getModelAtModelWord(modelWord: "zurcir"))
    }
    
    func setStudentLevel5004(){
        clearFilteredVerbList()
        filteredVerbList = verbList
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel5005(){
        clearFilteredVerbList()
        filteredVerbList = verbList
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel5006(){
        clearFilteredVerbList()
        filteredVerbList = verbList
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel6001(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "atreverse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "referirse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "acostarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "irse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "sentirse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "darse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "quedarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "ponerse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "imaginarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "llamarse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "hacerse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "creerse", language: getCurrentLanguage()))
        addVerbToFilteredList(verb: findVerbFromString(verbString: "verse", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel6002(){
        clearFilteredVerbList()
        addVerbToFilteredList(verb: findVerbFromString(verbString: "darse con", language: getCurrentLanguage()))
        tenseList = [Tense.present, .preterite, .imperfect, .conditional, .future]
    }
    
    func setStudentLevel6003(){
    }
    
    func setStudentLevel6004(){
    }
    
    func setStudentLevel6005(){
    }

    func setStudentLevel(level: StudentLevel){
        studentLevel = level
        switch studentLevel {
        case .level1001:
            setStudentLevel1001()
        case .level1002:
            setStudentLevel1002()
        case .level1003:
            setStudentLevel1003()
        case .level1004:
            setStudentLevel1004()
        case .level1005:
            setStudentLevel1005()
        case .level1006:
            setStudentLevel1006()
        case .level2001:
            setStudentLevel2001()
        case .level2002:
            setStudentLevel2002()
        case .level3001:
            setStudentLevel3001()
        case .level3002:
            setStudentLevel3002()
        case .level3003:
            setStudentLevel3003()
        case .level4001:
            setStudentLevel4001()
        case .level4002:
            setStudentLevel4002()
        case .level4003:
            setStudentLevel4003()
        case .level5001:
            setStudentLevel5001()
        case .level5002:
            setStudentLevel5002()
        case .level5003:
            setStudentLevel5003()
        case .level5004:
            setStudentLevel5004()
        case .level6001:
            setStudentLevel6001()
        case .level6002:
            setStudentLevel6002()
        case .level6003:
            setStudentLevel6003()
        case .level6004:
            setStudentLevel6004()
        case .level6005:
            setStudentLevel6005()
        
        case .level2003:
            setStudentLevel2003()
        case .level2004:
            setStudentLevel2004()
        case .level4004:
            setStudentLevel4004()
        case .level4005:
            setStudentLevel4005()
        case .level4006:
            setStudentLevel4006()
        case .level5005:
            setStudentLevel5005()
        case .level5006:
            setStudentLevel5006()
        }
    }
    
    func getStudentLevel()->StudentLevel{
        studentLevel
    }
    
    func setLessonCompleted(sl: StudentLevel){
        studentLevelCompletion.setLessonCompletionMode(sl: sl, lessonCompletionMode: .completed )
        //set all previous lessoms completed
        //set next level lessons open
    }
    
    func setLessonCompletionMode(sl: StudentLevel, lessonCompletionMode: LessonCompletionMode){
        studentLevelCompletion.setLessonCompletionMode(sl: sl, lessonCompletionMode: lessonCompletionMode )
    }
    
    func getLessonCompletionMode(sl: StudentLevel)->LessonCompletionMode{
        studentLevelCompletion.getLessonCompletionMode(sl: sl)
    }
    
}
