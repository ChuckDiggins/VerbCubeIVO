//
//  InteractiveVerbCubeCellView.swift
//  InteractiveVerbCubeCell
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import JumpLinguaHelpers


struct InteractiveVerbCubeCellView: View {
    
    // MARK: - Environments
    
    // MARK: - EnvironmentObjects
    
    // MARK: - StateObjects
    
    // MARK: - ObservedObjects
    var showAnswer = false

//    @ObservedObject var vcci : VerbCubeCellInfo
    var vcci : VerbCubeCellInfo
    
    // MARK: - States
    var columnWidth : CGFloat

    var cellData : CellData
//    var backgroundColor : Color
//    var cellString : String
    var foregroundColor = Color.black
   
    
    // MARK: - Bindings
    
    // MARK: - Properties
    
    // MARK: - AppStorage
    
    // MARK: - FocusState
    
    // MARK: - Body
    var body: some View {
            Button(action:{
//                alertView()
            }){
                Text(cellData.cellString)
                    .frame(width: columnWidth, height: 30, alignment: .center)
                    .background(cellData.cellColor)
                    .foregroundColor(foregroundColor)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.footnote)

            }.onAppear{didAppear()}
            .onDisappear { didDisappear() }
        }
            
    }

// MARK: - Content
extension InteractiveVerbCubeCellView {
    func content() -> some View {
        Text("hello there")
    }
}

// MARK: - Lifecycle
extension InteractiveVerbCubeCellView {
    func didAppear() {
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension InteractiveVerbCubeCellView {
    func alertView(){
        let alert = UIAlertController(title: "Verb: \(vcci.verb.getWordAtLanguage(language: .Spanish)) ", message: "Subject \(vcci.person.getMaleString()), \(vcci.tense.rawValue) tense", preferredStyle: .alert)
//        print("cellWord = \(cellData.cellString), cell color = \(cellData.cellColor), cell colorString = \(cellData.colorString)")
        
        let ok = UIAlertAction(title: "OK", style: .default){ (_) in
        }
        alert.addAction(ok)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            //do something here
        })
    }
}

// MARK: - Actions
extension InteractiveVerbCubeCellView {
    
}

// MARK: - Helper Functions
extension InteractiveVerbCubeCellView {
    
}
