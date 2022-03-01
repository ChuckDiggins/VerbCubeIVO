//
//  ProfileView.swift
//  Profile
//
//  Created by Charles Diggins on 2/17/22.
//

import SwiftUI
import Dot

struct ProfileView: View {
    
    // MARK: - Observed
    @StateObject private var observed = Observed()
    
    // MARK: - Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - EnvironmentObjects
    
    // MARK: - StateObjects
    
    // MARK: - ObservedObjects
    
    // MARK: - States
    
    // MARK: - Bindings
    
    // MARK: - Properties
    
    // MARK: - AppStorage
    
    // MARK: - FocusState
    enum FocusedField: Hashable {
        case name
    }
    
    @FocusState private var focusedField: FocusedField?
    
    // MARK: - Body
    var body: some View {
        content()
            .onAppear { didAppear() }
            .onDisappear { didDisappear() }
    }
}

// MARK: - Content
extension ProfileView {
    func content() -> some View {
        VStack {
            Text("Hello, ProfileView!")
        }
        .padding()
    }
}

// MARK: - Lifecycle
extension ProfileView {
    func didAppear() {
        
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension ProfileView {
    
}

// MARK: - Actions
extension ProfileView {
    
}

// MARK: - Helper Functions
extension ProfileView {
    
}
