//
//  ScanMorphStructExtractInfo.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/10/22.
//

import Foundation
import JumpLinguaHelpers

enum VerbMorphType : String {
    case regularVerb = "Regular"
    case stemChangingVerb = "Stem-changing"
    case orthoChangingVerb = "Ortho-changing"
    case orthoStem = "Ortho and stem-changing"   //cocer
}

struct MorphInfo {
    var infinitive = ""
    var root = ""
    var stemFrom = ""
    var stemTo = ""
    var root2 = ""
    var orthoFrom = ""
    var orthoTo = ""
    var endingFrom = ""
    var endingTo = ""
    var verbMorphType = VerbMorphType.regularVerb
}

    
//add handling reflexive data soon
    
func extractMorphInfo(morphStruct: MorphStruct)->MorphInfo{
    var morphInfo = MorphInfo()
    var isRegular = true
    var isStem = false
    
    for i in 0..<morphStruct.getMorphStepCount(){
        let ms = morphStruct.getMorphStep(index: i)
        
        if ms.comment.contains("infinitive") {
            morphInfo.infinitive = ms.part1
            morphInfo.root = ms.part1
        }
            
        
        //regular verb
        if ms.comment.contains("the ending") || ms.comment.contains("the verb ending") {
            if isRegular {
                morphInfo.root = ms.part1
            }
            morphInfo.endingFrom = ms.part2
        }
        //processing stem
        if ms.comment.contains("grab the existing stem") {
            isRegular = false
            isStem = true
            morphInfo.root = ms.part1
            morphInfo.stemFrom = ms.part2
            morphInfo.verbMorphType = .stemChangingVerb
        }
        if ms.comment.contains("change the stem") {
            morphInfo.stemTo = ms.part2
        }
        if ms.comment.contains("replace with the ending") {
            morphInfo.endingTo = ms.part2
        }
        
        //processing ortho
        if ms.comment.contains("Grab this") {
            isRegular = false
            if !isStem {
                morphInfo.root = ms.part1
                morphInfo.orthoFrom = ms.part2
                morphInfo.verbMorphType = .orthoStem
            } else {
                morphInfo.verbMorphType = .orthoChangingVerb
            }
            morphInfo.orthoFrom = ms.part2
            
        }
        if ms.comment.contains("Replace with") {
            morphInfo.orthoTo = ms.part2
        }
        if ms.comment.contains("add the conjugate ending") {
            morphInfo.endingTo = ms.part2
        }
        
        //subjunctive imperfect tense
        if ms.comment.contains("preterite P3 form") {
            morphInfo.root = ms.part1
        }
           
        if ms.comment.contains("Remove the last 4 letters") {
            morphInfo.root = ms.part1
            morphInfo.endingFrom = ms.part2
        }
          
        if ms.comment.contains("Replace with the ending") {
            morphInfo.root = ms.part1
            morphInfo.endingTo = ms.part2
        }
          
    }
 99
    //extract root2, if exists
    
    if !(morphInfo.verbMorphType == .regularVerb) {
        var workingString = morphInfo.infinitive
        workingString.removeLast(morphInfo.endingFrom.count)
        workingString.removeLast(morphInfo.orthoFrom.count)
        workingString.removeFirst(morphInfo.root.count)
        workingString.removeFirst(morphInfo.stemFrom.count)
        morphInfo.root2 = workingString
    }
    return morphInfo
}

func printMorphInfo(mi : MorphInfo){
    print("printMorphInfo: \(mi.infinitive) = \(mi.root) + \(mi.stemFrom) + \(mi.root2) + \(mi.orthoFrom) +\(mi.endingFrom)")
    var toString = mi.root+mi.stemTo+mi.root2+mi.orthoTo+mi.endingTo
    var fromString = mi.root+mi.stemFrom+mi.root2+mi.orthoFrom+mi.endingFrom
    print(" .... from \(fromString) -> \(toString)")
}

