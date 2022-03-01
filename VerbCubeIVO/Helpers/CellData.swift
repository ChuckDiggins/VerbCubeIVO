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
    
    init(cellString: String, cellColor: Color, colorString: String){
        self.cellString = cellString
        self.cellColor = cellColor
        self.colorString = colorString
    }
    init(){
        self.cellString = ""
        self.cellColor = Color.white
        self.colorString = Color.white.description
    }
}
