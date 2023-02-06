//
//  QuizCubeCounter.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/4/22.
//

//import Foundation

//class QuizCubeWatcher : ObservableObject{
//   var quizCorrectChanged = false
//    var quizCubeCorrectBuffer = [[Bool]]()
//    var quizCellDimension1 = 0
//    var quizCellDimension2 = 0
//
//    func setQuizCorrectBufferDimensions(d1: Int, d2: Int)
//    {
//        quizCellDimension1 = d1
//        quizCellDimension2 = d2
//    }
//
//    func getQuizCorrectCount()->Int{
//        var count = 0
//        for i in 0 ..< quizCellDimension1{
//            for j in 0 ..< quizCellDimension2{
//                if quizCubeCorrectBuffer[i][j] { count += 1 }
//            }
//        }
//        return count
//    }
//
//    func getQuizCellCount()->Int{
//        return quizCellDimension1 * quizCellDimension2
//    }
//
//    func setQuizCorrectAt(i: Int, j: Int, isCorrect: Bool){
//        quizCorrectChanged = true
//        quizCubeCorrectBuffer[i][j] = isCorrect
//    }
//
//    func getQuizCorrectAt(i: Int, j: Int)->Bool{
//        return quizCubeCorrectBuffer[i][j]
//    }
//
//    func toggleQuizCorrect(){
//        quizCorrectChanged.toggle()
//    }
//}
