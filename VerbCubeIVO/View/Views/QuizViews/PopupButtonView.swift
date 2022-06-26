//
//  PopupButtonView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/21/22.
//

import SwiftUI
import PhotosUI

//struct PopupButtonView: View {
//
//    let screenSize = UIScreen.main.bounds
//    var instruction: (subjectStr: String, tenseStr: String, verbStr:String)
//    var correctAnswer : String
//    @State private var selectedItem: Int = 0
//    @State var selectionString: [String]
//    @Binding var isShown: Bool
//    @Binding var selectedString: String
//    var onDone: (String) ->Void = { _ in }
//
//    var body: some View {
//        VStack{
//            Text("Select correct form for")
//            Text("Subject: \(instruction.subjectStr)")
//            Text("Tense: \(instruction.tenseStr)")
//            Text("Verb: \(instruction.verbStr)")
//            Picker("Answer", selection: $selectedItem){
//                ForEach(0..<selectionString.count, id: \.self){ index in
//                    Text(selectionString[index]).tag(index)
//                }
//            }
//            Text("selectedItem: \(selectedItem) - \(selectionString[selectedItem])")
//                .background(correctAnswer == selectionString[selectedItem] ? .green : .yellow)
//                .foregroundColor(.black)
//
//            HStack{
//                Button("Done"){
//                    self.isShown = false
//                    self.onDone(self.selectedString)
//                }
//            }
//        }
//        .padding()
//        .frame(width: screenSize.width * 0.5, height: screenSize.height * 0.6)
//        .onAppear{
//            selectionString.insert("click me", at: 0)
//        }
//    }
//
//}

//struct PopupButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopupButtonView(instruction: ("yo", "present", "acabarse"), correctAnswer: "acabo", selectionString: ["acabas", "acabamos", "acabao", "acabo"], isShown: false, selectedString: "")
//    }
//}
