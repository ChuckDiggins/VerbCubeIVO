//
//  SentenceView.swift
//  Feather2
//
//  Created by Charles Diggins on 12/30/22.
//

import SwiftUI
import JumpLinguaHelpers

struct SentenceView: View {
    var language: LanguageType
    var changeWord: () -> Void
    @ObservedObject var clauseModel: ClauseModel
    
    @State var wordIndex = 0
    
    var body: some View {
        //        GeometryReader{ geometry in
        VStack {
            ForEach((0..<clauseModel.maxLines), id:\.self ){ line in
                HStack{
                    ForEach(0..<clauseModel.singleIndexList[line].count, id: \.self){wordIndex in
                        Button(action: {
                            clauseModel.currentSingleIndex = wordIndex
                            clauseModel.newWordSelected[clauseModel.currentSingleIndex].toggle()
                            self.changeWord()
                        })
                        {
                        SentenceTextView(clauseModel: clauseModel, language: language, wordIndex: wordIndex)
                        }
                    }
                }.onAppear{
                }
            }
        }
        .padding(10)
        .border(Color.green)
        .background(Color.yellow)
        //        }
        
    }
}

struct SentenceTextView: View {
    @ObservedObject var clauseModel: ClauseModel
    var language: LanguageType
    var wordIndex : Int
    var highlightColor = Color.blue
    var normalColor = Color.black
    
    var body: some View {
        if language == .English {
            if wordIndex < clauseModel.englishSingleList.count {
                Text(clauseModel.englishSingleList[wordIndex].getProcessWordInWordStateData(language: language))
                    .font(.title2)
                    .foregroundColor(wordIndex == clauseModel.currentSingleIndex ? highlightColor : normalColor)
                    .background(clauseModel.backgroundColor[wordIndex])
            }
        } else {
            if wordIndex < clauseModel.singleList.count {
                Text(clauseModel.singleList[wordIndex].getProcessWordInWordStateData(language: language))
                    .font(.title2)
                    .foregroundColor(wordIndex == clauseModel.currentSingleIndex ? highlightColor : normalColor)
                    .background(clauseModel.backgroundColor[wordIndex])
            }
        }
    }
}
