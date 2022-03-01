//
//  ProfileView+Observed.swift
//  Profile
//
//  Created by Charles Diggins on 2/17/22.
//

import Combine
import SwiftUI
import Dot

extension ProfileView {
    class Observed: ObservedObservableObject {
        
        // MARK: - Published
        @Published var isActive: Bool = false
        
    }
}

