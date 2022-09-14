//
//  SwiftUIView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/26/22.
//

import SwiftUI

//struct Flashcard<Front, Back>: View where Front: View, Back: View {
//    var front: (_ entered: Bool) -> Front
//    var back: () -> Back
//    
//    @State var flipped: Bool = false
//    @State var completed: Bool = false
//    
//    @State var flashcardRotation = 0.0
//    @State var contentRotation = 0.0
//    
//    init(@ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
//        self.front = front
//        self.back = back
//    }
//    
//    var body: some View {
//        ZStack {
//            if flipped {
//                back()
//            } else {
//                front(completed)
//            }
//        }
//        .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
//        .padding()
//        .frame(height: 200)
//        .frame(maxWidth: .infinity)
//        .background(Color.yellow)
//        .overlay(
//            Rectangle()
//                .stroke(Color.black, lineWidth: 2)
//        )
//        .padding()
//        .onTapGesture {
//            flipFlashcard()
//        }
//        .rotation3DEffect(.degrees(flashcardRotation), axis: (x: 0, y: 1, z: 0))
//    }
//    
//    func flipFlashcard() {
//        let animationTime = 0.5
//        withAnimation(Animation.linear(duration: animationTime)) {
//            flashcardRotation += 180
//        }
//        
//        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)) {
//            contentRotation += 180
//            flipped.toggle()
//        }
//    }
//}
//
//struct  VerbConjugationBlank: View {
//    var correctAnswer : String
//    @State var studentAnswer = ""
//    @State var completed : Bool
//    
//    var body: some View {
//        VStack{
//            TextField("Answer:", text: $studentAnswer)
//        }
//    }
//}
//

