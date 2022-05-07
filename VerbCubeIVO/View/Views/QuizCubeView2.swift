//
//  QuizCubeViewNew.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/4/22.
//

import SwiftUI

import SwiftUI

import JumpLinguaHelpers


struct QuizCubeView2: View {
//    @ObservedObject var languageEngine: LanguageEngine
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var qchc : QuizCubeHandlerClass
    @State var useCellAlert : Bool

    var body: some View {
//        NavigationView{
            VStack(spacing: 0){
                ShowCube(qchc: qchc, useCellAlert: useCellAlert)
            }.navigationBarTitle("Quiz Cube - \(qchc.vcDimension1.rawValue) v \(qchc.vcDimension2.rawValue)")
                
//        }
    }
    
    struct ShowCube: View {
        var qchc : QuizCubeHandlerClass
        var useCellAlert : Bool
        var body: some View {
            VStack (spacing: 0){
                Text("Click on empty cell and type in your answer. Push return. Wrong=🟨, Right=🟩")
                CreateLineOfHeaderCells(qchc: qchc)
                CreateGridOfConjugatedCells(qchc: qchc, useCellAlert: useCellAlert)
            }
        }
    }
    
    struct CreateLineOfHeaderCells: View {
        var qchc : QuizCubeHandlerClass
        var body: some View {
            //show the verb conjugations here
            HStack(spacing: 0){
                //first cell is actually a button
                
                VerbCubeCellView(cellColor: .yellow, columnWidth: CGFloat(600/qchc.getHeaderStringList().count), cellString: qchc.getCornerWord())
                
                //these cells are the headers
                
                ForEach(qchc.getHeaderStringList(), id:\.self) { str in
                    VerbCubeCellView(cellColor: .green, columnWidth: CGFloat(600/qchc.getHeaderStringList().count), cellString: str)
                }
                Spacer()
            }
            
        }
    }
    
    struct CreateGridOfConjugatedCells: View {
        var qchc : QuizCubeHandlerClass
        var useCellAlert : Bool
        var body: some View {
            VStack(spacing: 0){
                ForEach((0..<qchc.conjStringArrayDimension1), id:\.self) { index in
                    HStack(spacing: 0){
                        VerbCubeCellView(cellColor: .blue, columnWidth: CGFloat(600/qchc.getHeaderStringList().count), cellString: qchc.getFirstColumnStringValue(i: index) )
                        ForEach((0..<qchc.conjStringArrayDimension2), id:\.self) {jndex in
                            QuizCubeCellView(vcci: qchc.getVerbCubeCellInfo(i: index, j: jndex),
                                                        columnWidth: CGFloat(600/qchc.getHeaderStringList().count),
                                             cellData: qchc.getCellData(i: index, j: jndex), useAlert: useCellAlert)
                        }
                        Spacer()
                    }
                }
            }
        }
    }

    
}


extension QuizCubeView2 {
    
    func fillVerbCubeConjugatedStrings(){
        qchc.fillCellData()
    }

}

