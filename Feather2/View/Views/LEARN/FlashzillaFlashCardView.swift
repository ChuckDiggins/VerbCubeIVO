//
//  FlashzillaFlashCardView.swift
//  Feather2
//
//  Created by Charles Diggins on 11/5/22.
//

import SwiftUI


extension View {
    func stacked(at position: Int, in total: Int)-> some View{
        let offset = Double(total - position)
        return self.offset(x:0, y: offset * 10)
    }
}

struct FlashCardsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var showingEditScreen = false
//    @State private var cards = Array<Card>(repeating: Card.example, count: 10)
    @State private var cards = [FilezillaCard]()
    @State var wrongCount = 0
    @State var correctCount = 0
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every:1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @State var isActive = true
    
    var body: some View {
        ZStack{
            Color(.blue)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    ExitButtonView()
                    Spacer()
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                }
                
                ZStack{
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index], correctCount: $correctCount, wrongCount: $wrongCount)
                        {
                            withAnimation {
                                removeCard(at: index)     // Flashzilla 9/15 at 10:30
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)  //limits access to top card
                        .accessibilityHidden(index < cards.count - 1 )  //limits voice-over to top card
                    }
                }
                .allowsHitTesting(timeRemaining>0)
                
                HStack{
                    Text("Wrong: \(wrongCount) ")
                    Spacer()
                    Text("Correct: \(correctCount) ")
                }
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
//            VStack{
//                HStack{
//                    Spacer()
//                    Button {
//                        showingEditScreen = true
//                    } label : {
//                        Image(systemName: "plus.circle")
//                            .padding()
//                            .background(.black.opacity(0.7))
//                            .clipShape(Circle())
//                    }
//
//                }
//                Spacer()
//            }
//            .foregroundColor(.white)
//            .font(.largeTitle)
//            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack{
                    Spacer()
                    HStack{
                        Button {
                            withAnimation{
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                    }
                    Spacer()
                    Button {
                        withAnimation{
                            removeCard(at: cards.count - 1)
                        }
                    } label: {
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Correct")
                    .accessibilityHint("Mark your answer as being correct")
                }
                
            }
        }
        .onReceive(timer) { time in
            guard isActive else {return}
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase){ newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
            
        }
        .onAppear{
            loadNewCards(languageViewModel: languageViewModel)
            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init) // Flashzilla 15/15 11:00
    }
    
    func loadNewCards(languageViewModel: LanguageViewModel){
        cards = languageViewModel.fillFilezillaFlashCards(maxCount: 25)
        saveData()
        
//        cards.removeAll()
//
//        if ( cards.isEmpty){
//            cards.append(FilezillaCard(prompt: "Conjugate conocer, subject yo, present tense", answer: "yo conozco"))
//            cards.append(FilezillaCard(prompt: "Conjugate conocer, subject tú, preterite tense", answer: "tú conociste"))
//            cards.append(FilezillaCard(prompt: "Conjugate comer, subject él, imperfect tense", answer: "él comía"))
//            saveData()
//        }
        
    }
    
    func saveData(){
        if let data = try? JSONEncoder().encode(cards){
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func loadData(){
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([FilezillaCard].self, from: data){
                cards = decoded
            }
        }
    }
    
    func removeCard(at index: Int){
        guard index >= 0 else {return}
        cards.remove(at:index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
//        cards = Array<Card>(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
}
