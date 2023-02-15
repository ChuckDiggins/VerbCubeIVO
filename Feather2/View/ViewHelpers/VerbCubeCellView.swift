//
//  VerbCubeCellViewView.swift
//  VerbCubeCellView
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI

struct VerbCubeCellView: View {
    
    // MARK: - Environments
    
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
    var cellColor : Color
    
//    @State private var columnWidth : CGFloat = 100
    var columnWidth : CGFloat
    
//    @State var cellString : String  //this doesn't update
    var cellString : String
    @State var foregroundColor = Color.white
    @State var backgroundColor = Color.green
    
    var body: some View {
        Text(cellString)
            .frame(width: columnWidth, height: 26, alignment: .center)
            .background(cellColor.opacity(0.9))
            .foregroundColor(Color.black)
            .border(Color.black)
            .font(.caption)
    }
}

// MARK: - Content
extension VerbCubeCellView {
    func content() -> some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .padding()
    }
}

// MARK: - Lifecycle
extension VerbCubeCellView{
    func didAppear() {
        
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension VerbCubeCellView{
    
}

// MARK: - Actions
extension VerbCubeCellView{
    
}

// MARK: - Helper Functions
extension VerbCubeCellView {
    
}



