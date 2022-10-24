//
//  ModelVerbTenseView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 7/6/22.
//

import SwiftUI
import JumpLinguaHelpers

class ModelVerbTensePersonObject: ObservableObject {
    @Published var currentModelString = ""
    @Published var currentVerbString = ""
    @Published var currentTenseString = ""
    @Published var currentPersonString = ""
    init(currentModelString: String, currentVerbString: String, currentTenseString: String, currentPersonString: String){
        self.currentModelString = currentModelString
        self.currentVerbString = currentVerbString
        self.currentTenseString = currentTenseString
        self.currentPersonString = currentPersonString
    }
    init(){
        self.currentModelString = ""
        self.currentVerbString = ""
        self.currentTenseString = ""
        self.currentPersonString = ""
    }
    
    
}

struct VerbTenseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var mvtp : ModelVerbTensePersonObject
    @State private var isPushed = false

    var setCurrentVerb: () -> Void
    var body: some View {
        VStack {
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                setCurrentVerb()
            }){
                HStack{
                    Text("Verb: ")
                    Text(mvtp.currentVerbString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }.frame(width: 350, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(4)
            }
            Button(action: {
                mvtp.currentTenseString = languageViewModel.getNextTense().rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(mvtp.currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }
            .frame(width: 350, height: 30)
            .font(.callout)
            .padding(2)
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(4)
            
        }
    }
}

struct ModelVerbTenseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var mvtp : ModelVerbTensePersonObject
    @State private var isPushed = false

    var setCurrentVerb: () -> Void
    var body: some View {
        VStack {
            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                HStack{
                    Text("Verb model:")
                    Text(mvtp.currentModelString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
            }.task {
                setCurrentVerb()
            }

            
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                setCurrentVerb()
            }){
                HStack{
                    Text("Verb: ")
                    Text(mvtp.currentVerbString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }.frame(width: 350, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(4)
            }
            
            
            //ChangeTenseButtonView()
            
            Button(action: {
                mvtp.currentTenseString = languageViewModel.getNextTense().rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(mvtp.currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }
            .frame(width: 350, height: 30)
            .font(.callout)
            .padding(2)
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(4)
            
        }
    }
}

//struct ModelVerbTenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModelVerbTenseView()
//    }
//}
