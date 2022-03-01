//
//  GeneralVerbCubeView+Observed.swift
//  GeneralVerbCube
//
//  Created by Charles Diggins on 2/16/22.
//

import Combine
import SwiftUI
import Dot

extension VerbCubeView {
    class Observed: ObservedObservableObject {
        
        // MARK: - Published
        @Published var isActive: Bool = false
        
    }
}

