//
//  ClauseModel.swift
//  Feather2
//
//  Created by Charles Diggins on 12/30/22.
//

import SwiftUI
import JumpLinguaHelpers

class  ClauseModel: ObservableObject {
    @Published var currentSingleIndex: Int
    @Published var maxLines = 1
    @Published var singleIndexList : [[Int]]
    @Published var singleList : [dSingle]
    @Published var englishSingleList : [dSingle]
    @Published var newWordSelected : [Bool]
    @Published var backgroundColor : [Color]
    
    init(currentSingleIndex: Int, maxLines: Int, singleIndexListForEachLine: [[Int]],
         singleList : [dSingle],
         englishSingleList : [dSingle],
         newWordSelected : [Bool], backGroundColor : [Color]){
        self.currentSingleIndex = currentSingleIndex
        self.singleIndexList = singleIndexListForEachLine
        self.singleList = singleList
        self.englishSingleList = englishSingleList
        self.newWordSelected = newWordSelected
        self.backgroundColor = backGroundColor
        self.maxLines = maxLines
    }
    
    init(){
        self.currentSingleIndex = 0
        self.singleIndexList = [[Int]]()
        self.singleList = [dSingle]()
        self.englishSingleList = [dSingle]()
        self.newWordSelected = [Bool]()
        self.backgroundColor = [Color]()
        self.maxLines = 0
    }
    
    func set(currentSingleIndex: Int, maxLines: Int,
             singleIndexListForEachLine: [[Int]],
             singleList : [dSingle],
             englishSingleList : [dSingle],
             newWordSelected : [Bool],
             backGroundColor : [Color]){
        self.currentSingleIndex = currentSingleIndex
        self.singleIndexList = singleIndexListForEachLine
        self.singleList = singleList
        self.englishSingleList = englishSingleList
        self.newWordSelected = newWordSelected
        self.backgroundColor = backGroundColor
        self.maxLines = maxLines
    }
    
}

