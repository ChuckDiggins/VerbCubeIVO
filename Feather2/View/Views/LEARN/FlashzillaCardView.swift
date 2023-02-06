//
//  FlashzillaCardView.swift
//  Feather2
//
//  Created by Charles Diggins on 11/5/22.
//

import SwiftUI

struct FilezillaCard : Encodable, Decodable {
    let prompt: String
    let answer: String
    
    static let example = FilezillaCard(prompt: "Conjugate conocer, subject yo, present tense", answer: "yo conozco")
}

struct CardView: View {
    let card : FilezillaCard
    @Binding var correctCount : Int
    @Binding var wrongCount : Int
    var removal: (() -> Void)? = nil
    
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var isShowingAnswer = false
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width/50)))
                    )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            VStack{
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.title3)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width/5)) )
        .offset(x:offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width/50)))
        .accessibilityAddTraits(.isButton)  //declares that this can be seen as a button
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            feedback.notificationOccurred(.success)
                            correctCount += 1
                        } else {
                            feedback.notificationOccurred(.error)
                            wrongCount += 1
                        }
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture{
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
        
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: FilezillaCard.example, correctCount: Binding<0>, wrongCount: Binding<0>)
//    }
//}

