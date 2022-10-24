//
//  WordTypeEnum.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/23/22.
//

import Foundation

enum ShowVerbType : String {
    case STEM, ORTHO, IRREG, SPECIAL, REFLEXIVE, PHRASAL, NONE
}

enum FocusEnum: String, Hashable {
    case p1, p2, p3, p4, p5, p6
    
    public func getIndex()->Int{
        switch self {
        case .p1: return 0
        case .p2: return 1
        case .p3: return 2
        case .p4: return 3
        case .p5: return 4
        case .p6: return 5
        }
    }
    
    public var index: Int { FocusEnum.all.firstIndex(of: self) ?? 0 }
    public static var all = [p1, p2, p3, p4, p5, p6]
}

func findFocusEnumByIndex(by index: Int) -> FocusEnum? {
    let focusValue = FocusEnum.all.first(where: { $0.index == index })
    return focusValue
}

func setNextFocusEnum(by index: Int) -> FocusEnum? {
    var targetIndex = index + 1
    if targetIndex > 5 { targetIndex = 0 }
    return FocusEnum.all.first(where: { $0.index == targetIndex })
}
