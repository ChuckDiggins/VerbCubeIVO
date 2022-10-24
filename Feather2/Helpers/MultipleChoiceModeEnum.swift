//
//  MultipleChoiceModeEnum.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/13/22.
//

import SwiftUI

enum MultipleChoiceMode : String {
    case IdentifyVerbsBelongingToModel = "Verbs in Model"
    case IdentifyModelsThatHaveGivenPattern = "Models for Pattern"
    case IdentifyVerbsThatHaveGivenPattern = "Verbs with Same Pattern"
    case IdentifyVerbsThatHaveSameModelAsVerb = "Verbs for Same Model"
    case IdentifyVerbsWithSamePatternAsVerb = "Verbs for Pattern"
    case IdentifyModelForGivenVerb = "Model for Given Verb"
    case CreateVerbForGivenModel = "Create a Verb"
    
    func getTitle()->String{
        switch self{
        case .IdentifyVerbsBelongingToModel:
            return "Verbs in Model"
        case .IdentifyModelsThatHaveGivenPattern:
            return "Models for Pattern"
        case .IdentifyVerbsThatHaveGivenPattern:
            return "Verbs with Same Pattern"
        case .IdentifyVerbsThatHaveSameModelAsVerb:
            return "Verbs for Same Model"
        case .IdentifyVerbsWithSamePatternAsVerb:
            return "Verbs for Pattern"
        case .IdentifyModelForGivenVerb:
            return "Model for Given Verb"
        case .CreateVerbForGivenModel:
            return "Create a Verb"
        }
    }
    
    func getSubTitle()->String{
        switch self{
        case .IdentifyVerbsBelongingToModel:
            return "Which verbs belong to model:"
        case .IdentifyModelsThatHaveGivenPattern:
            return "Which models contain pattern:"
        case .IdentifyVerbsThatHaveGivenPattern:
            return "Which verbs have same pattern as:"
        case .IdentifyVerbsThatHaveSameModelAsVerb:
            return "Which verbs belong to same model as:"
        case .IdentifyVerbsWithSamePatternAsVerb:
            return "Which verbs have the same pattern as:"
        case .IdentifyModelForGivenVerb:
            return "Which model contains verb:"
        case .CreateVerbForGivenModel:
            return "Create a Verb"
        }
        
    }
}
