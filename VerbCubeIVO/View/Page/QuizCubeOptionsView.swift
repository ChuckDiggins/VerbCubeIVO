//
//  VerbCubeOptionsView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/24/22.
//

import SwiftUI
import Dot
import JumpLinguaHelpers

enum quizLevel {
    case easy, medium, hard
}

struct QuizCubeOptionsView: View {
    @EnvironmentObject var languageEngine: LanguageEngine
    
    // MARK: - Observed
    @StateObject private var observed = Observed()
    
    // MARK: - Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - EnvironmentObjects
    
    // MARK: - StateObjects
    
    // MARK: - ObservedObjects
    
    // MARK: - States
    @State var activeQuizCubeConfiguration = ActiveVerbCubeConfiguration.PersonTense
    @State var quizCubeVerbs = [Verb]()
    @State var quizCubeTenses = [Tense]()
    @State var configSelected = ActiveVerbCubeConfiguration.PersonTense
    @State var presentToggle : Bool = true
    @State var preteriteToggle = true
    @State var imperfectToggle = true
    @State var futureToggle = true
    @State var conditionalToggle = true
    @State var show = false
    
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
            .onAppear {
                presentToggle = false
                didAppear() }
            .onDisappear { didDisappear() }
    }
}

// MARK: - Content
extension QuizCubeOptionsView {
    func content() -> some View {
        VStack{
            HStack{
                Text("Selected configuration:")
                Text(configSelected.getString())
            }
            Text("Present tense: \(presentToggle)")
            VStack{
                Toggle(isOn: $presentToggle, label: {Text("Present")})
                Toggle(isOn: $preteriteToggle, label: {Text("Preterite")})
                Toggle(isOn: $imperfectToggle, label: {Text("Imperfect")})
                Toggle(isOn: $futureToggle,  label: {Text("Future")})
                Toggle(isOn: $conditionalToggle,  label: {Text("Conditional")})
            }
            .toggleStyle(SwitchToggleStyle(tint: Color(.purple)))
            ConfigRadioButtons(selected: self.$configSelected)
            Spacer()
            Button(action: {
//                setTenses()
            }){
                Text("OK").padding(.vertical).padding(.horizontal, 25).foregroundColor(.white)
            }
            .background(
                LinearGradient(gradient: .init(colors:  [Color.black.opacity(0.2), Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing) )
            .clipShape(Capsule())

        }
        
    }
    
//    
}

// MARK: - Lifecycle
extension QuizCubeOptionsView {
    func didAppear() {
        
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension QuizCubeOptionsView {
    
}

// MARK: - Actions
extension QuizCubeOptionsView {
    
}

// MARK: - Helper Functions
extension QuizCubeOptionsView {
    
}


