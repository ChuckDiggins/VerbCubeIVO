//
//  CellData.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/22/22.
//

import Foundation
import SwiftUI

class CellData {
    var cellString = ""
    var colorString = ""
    var cellColor = Color.white
    var isBlank = false
    
    init(cellString: String, cellColor: Color, colorString: String){
        self.cellString = cellString
        self.cellColor = cellColor
        self.colorString = colorString
    }
    
    init(cellString: String, cellColor: Color, colorString: String, isBlank: Bool){
        self.cellString = cellString
        self.cellColor = cellColor
        self.colorString = colorString
        self.isBlank = isBlank
    }
    
    init(){
        self.cellString = ""
        self.cellColor = Color.white
        self.colorString = Color.white.description
    }
}

class QuizCellData : ObservableObject {
    var i = 0
    var j = 0
    var cellString = ""
    var isBlank = false
//    @Published var isCorrect = true
    
    init(cellString: String){
        self.cellString = cellString
    }
    
    init(i: Int, j: Int, cellString: String, isBlank: Bool){
        self.i = i
        self.j = j
        self.cellString = cellString
        self.isBlank = isBlank
//        self.isCorrect = isCorrect
    }
    
    init(){
        self.cellString = ""
    }
}
