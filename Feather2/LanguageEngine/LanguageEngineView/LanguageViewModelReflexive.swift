//
//  LanguageViewModelReflexive.swift
//  Feather2
//
//  Created by Charles Diggins on 5/16/23.
//

import SwiftUI
import JumpLinguaHelpers

extension LanguageViewModel{
    func getReflexiveVerbManager()->ReflexiveVerbManager{
        languageEngine.getReflexiveVerbManager()
    }
}
