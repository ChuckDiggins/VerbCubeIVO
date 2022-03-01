//
//  GeneralVerbCubeView.swift
//  GeneralVerbCube
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import Dot

struct GeneralVerbCubeView: View {
    
    // MARK: - Observed
//    @StateObject private var observed = Observed()
    
    // MARK: - Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - EnvironmentObjects
    @EnvironmentObject private var languageEngine: LanguageEngine
    
    // MARK: - StateObjects
    
    
    // MARK: - ObservedObjects
    
    // MARK: - States
    public var vccsh : VerbCubeConjugatedStringHandler
    
    // MARK: - Bindings
    
    // MARK: - Properties
    public var verbCount = 0
    
    // MARK: - AppStorage
    
    // MARK: - FocusState
    enum FocusedField: Hashable {
        case name
    }
    
    @FocusState private var focusedField: FocusedField?
    
    // MARK: - Body
    var body: some View {
        content()
            .onAppear {  didAppear() }
            .onDisappear { didDisappear() }
    }
}

// MARK: - Content
extension GeneralVerbCubeView {
    func content() -> some View {
        ShowCube(vccsh: vccsh)
        .padding()
    }
}

// MARK: - Lifecycle
extension GeneralVerbCubeView {
    func didAppear() {
        
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension GeneralVerbCubeView {
    
    struct ShowCube: View {
        var vccsh : VerbCubeConjugatedStringHandler
        var body: some View {
            VStack {
                if vccsh.isCreated {
                    CreateLineOfHeaderCells(vccsh: vccsh)
                    CreateGridOfConjugatedCells(vccsh: vccsh)
                }
            }
        }
    }
    
    struct CreateLineOfHeaderCells: View {
        var vccsh : VerbCubeConjugatedStringHandler
        var body: some View {
            //show the verb conjugations here
            HStack(spacing: 0){
                //first cell is actually a button
                
                VerbCubeCellView(cellColor: .yellow, cellString: vccsh.getCornerWord())
                
                //these cells are the headers
                
                ForEach(vccsh.getHeaderStringList(), id:\.self) { str in
                    VerbCubeCellView(cellColor: .green, cellString: str)
                }
                Spacer()
            }
            
        }
    }
    
    struct CreateGridOfConjugatedCells: View {
        var vccsh : VerbCubeConjugatedStringHandler
        
        var body: some View {
            VStack(spacing: 0){
                ForEach((0..<vccsh.conjStringArrayDimension1), id:\.self) { index in
                    HStack(spacing: 0){
                        VerbCubeCellView(cellColor: .blue, cellString: vccsh.getFirstColumnStringValue(i: index) )
                        ForEach((0..<vccsh.conjStringArrayDimension2), id:\.self) {jndex in
                            InteractiveVerbCubeCellView(vcci: vccsh.getVerbCubeCellInfo(i: index, j: jndex),
                                                        cellString: vccsh.getConjugateString(i: index, j: jndex),
                                                      backgroundColor: getComputedBackgroundColor(showVerbType: vccsh.getShowVerbType(i: index, j: jndex))   )
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
}

// MARK: - Actions
extension GeneralVerbCubeView {
}

// MARK: - Helper Functions
extension GeneralVerbCubeView {
}
