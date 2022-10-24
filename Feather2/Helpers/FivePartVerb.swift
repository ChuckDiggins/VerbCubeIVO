//
//  FivePartVerb.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/13/22.
//

import Foundation

enum  StringChangeEnum : String {
    case startWithInfinitive = "Start with infinitive"
    case conjugationComplete = "Conjugation complete"
    
    case removingLetter = "Removing letter"
    case appendingLetter = "Appending letter"
    case insertingLetter = "Inserting letter"
    
    case removeStem = "Removing stem"
    case appendStem = "Appending stem" //could be more than one letter - "ei"
    
    case removeOrtho = "Removing ortho"
    case appendOrtho = "Appending ortho"  //could be more than one letter - "zc"
    
    case removingEnding = "Removing ending"
    case endingRemoved = "Ending removed"
    case appendEnding = "Appending ending"  //could be more than one letter - "amos"
    case endingAttached = "Ending attached"
    
    case invalid = "Sorry.  Cannot edit this part of the verb"
    case unknown = "Unknown"
}


enum FiveWordPartEnum {
    case root, stemFrom, root2, orthoFrom, endingFrom, stemTo, orthoTo, endingTo
}

//note: all words must have at least a root and an ending
//      a verb like destorcer will have all five
//      a stem-changing verb like defender will have root+stem+root2+ending  

struct FivePartVerbStruct{
    var stringChangeType : StringChangeEnum
    var root : String   //root      destorcer - dest
    var stemFrom : String   //stem      destorcer - o
    var stemTo : String   //stemTo      destorcer - ue
    var root2 : String   //root2     destorcer - r
    var orthoFrom : String   //ortho     destorcer - c
    var orthoTo : String   //ortho     destorcer - z
    var endingFrom : String   //ending    destorcer - er
    var endingTo : String   //ending    destorcer - o
    var orthoReplaced : Bool = false
    var stemReplaced : Bool = false
    var endingReplaced : Bool = false
    var workingStem = ""
    var workingOrtho = ""
    var workingEnding = ""
    var infinitive = ""
    
    init(){
        infinitive = ""
        stringChangeType = .unknown
        root = ""
        stemFrom = ""
        stemTo = ""
        root2 = ""
        orthoFrom = ""
        orthoTo = ""
        endingFrom = ""
        endingTo = ""
    }
    
    init(stringChangeType: StringChangeEnum, root: String, stem: String, stemTo: String, root2: String, ortho: String, orthoTo: String, ending: String, endingTo: String){
        self.stringChangeType = stringChangeType
        self.root = root
        self.stemFrom = stem
        self.stemTo = stemTo
        self.root2 = root2
        self.orthoFrom = ortho
        self.orthoTo = orthoTo
        self.endingFrom = ending
        self.endingTo = ending
        self.infinitive = root+stemFrom+root2+orthoFrom+endingFrom
        workingStem = stemFrom
        workingOrtho = orthoFrom
        workingEnding = endingFrom
    }
    
    init(stringChangeType: StringChangeEnum, morphInfo: MorphInfo){
        self.stringChangeType = stringChangeType
        self.root = morphInfo.root
        self.stemFrom = morphInfo.stemFrom
        self.stemTo = morphInfo.stemTo
        self.root2 = morphInfo.root2
        self.orthoFrom = morphInfo.orthoFrom
        self.orthoTo = morphInfo.orthoTo
        self.endingFrom = morphInfo.endingFrom
        self.endingTo = morphInfo.endingTo
        workingStem = stemFrom
        workingOrtho = orthoFrom
        workingEnding = endingFrom
    }
    
    public func getFullWord()->String{
        return root + stemFrom + root2 + orthoFrom + endingFrom
    }
    
    public func getFullConjugatedWord()->String{
        return root + stemTo + root2 + orthoTo + endingTo
    }
    
    public func getVerbPart(part: FiveWordPartEnum)->String{
        switch part{
        case .root:  return root
        case .stemFrom:  return stemFrom
        case .root2: return root2
        case .orthoFrom: return orthoFrom
        case .endingFrom: return endingFrom
        case .stemTo: return stemTo
        case .orthoTo: return orthoTo
        case .endingTo: return endingTo
        }
    }
    
    mutating func appendStem(stem: String){
        if stemReplaced { return }  //don't do anything else
        stringChangeType = .appendStem
        self.workingStem += stem
        if workingStem == stemTo { stemReplaced = true}
    }
    
    mutating func removeStem(){
        stringChangeType = .removeStem
        self.workingStem = ""
        stemReplaced = false
    }
    
    mutating func appendOrtho(ortho: String){
        if orthoReplaced { return }  //don't do anything else
        stringChangeType = .appendOrtho
        workingOrtho += ortho
        if workingOrtho == orthoTo { orthoReplaced = true}
    }
    
    mutating func removeOrtho(){
        stringChangeType = .removeOrtho
        self.workingOrtho = ""
        orthoReplaced = false
    }
    
    mutating func appendEnding(endingStr : String){
        if endingReplaced { return }  //don't do anything else
        stringChangeType = .appendEnding
        self.workingEnding += endingStr
        if workingEnding == endingTo { endingReplaced = true}
    }
    
    //this is the user interactively removing the "r" in the ending
    mutating func removingEnding(){
        stringChangeType = .removingEnding
        if workingEnding.count == 2 { workingEnding.removeLast() }
        endingReplaced = false
    }
    
    //this is removing the entire ending
    mutating func removeEnding(){
        stringChangeType = .endingRemoved
        workingEnding = ""
        endingReplaced = false
    }
    
    mutating func setInfinitive(infinitive: String){
        self.infinitive = infinitive
    }
    
    func getInfinitive()->String{
        return root+stemFrom+root2+orthoFrom+endingFrom
    }
    
    func getConjugatedForm()->String{
        return root+stemTo+root2+orthoTo+endingTo
    }
    
    public func printThyself(){
        print("  \(stringChangeType.rawValue), \(root) + \(stemFrom) + \(root2) + \(orthoFrom) + \(endingFrom)")
    }
}
