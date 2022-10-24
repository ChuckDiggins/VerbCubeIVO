//
//  VerbCubeOptionsView+Observed.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/24/22.
//

import Combine
import SwiftUI
import Dot

extension QuizCubeOptionsView {
    class Observed: ObservedObservableObject {
        
        // MARK: - Published
        @Published var isActive: Bool = false
        
    }
}

