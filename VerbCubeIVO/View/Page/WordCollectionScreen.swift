//
//  WordCollectionScreen.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/8/22.
//

import SwiftUI

struct WordCollectionScreen: View {
//    @ObservedObject var languageEngine : LanguageEngine
    @ObservedObject var languageViewModel: LanguageViewModel
    
//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    @State var selected = false
//    var function: (_ verbEndings: [VerbIDEnding]) -> Void
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topLeading){
                Color.yellow
                    .edgesIgnoringSafeArea(.all)
//            VStack{
//            HStack{
//                Button(action: {
//                    if languageEngine.getFilteredVerbs().count < 5 {
//                        Alert(title: Text("Filtered verb count is less than 5.  Select more verbs."))
//                    } else {
//                        saveAndExit()
//                    }
//                    
//                }){
//                    Text("Save").padding(.vertical).padding(.horizontal, 25).foregroundColor(.white)
//                }
//                Button(action: {
//                    print("filtered verb count = \(languageEngine.getFilteredVerbs().count)")
//                    dismiss()
//                }){
//                    Text("Cancel").padding(.vertical).padding(.horizontal, 25).foregroundColor(.white)
//                }
//            }
                VStack {
                    ForEach(languageViewModel.getWordCollectionList(), id:\.self){wc in
                        if languageViewModel.getWordCollectionCount(wc: wc, wordType: .verb) > 5 {
                            Button(action: {
                                languageViewModel.copyWordCollectionToFilteredList(wordCollection: wc)
                                saveAndExit()
                            }){
                                Text("\(wc.collectionName)")
                                Spacer()
                                Text("Verb count: \(languageViewModel.getWordCollectionCount(wc: wc, wordType: .verb))")
                            }
                            .font(.callout)
                            .background(.yellow)
                            .foregroundColor(.black)
                        }
                    }
                    Spacer()
            }
//            }
            }.navigationTitle("Word Collections")
            
        } .accentColor(.red)
    }
    
    func saveAndExit(){
        languageViewModel.fillVerbCubeLists()
        languageViewModel.setPreviousCubeBlockVerbs()
        languageViewModel.fillQuizCubeVerbList()
        languageViewModel.fillQuizCubeBlock()
        dismiss()
    }
}

//struct WordCollectionScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        WordCollectionScreen(languageEngine: LanguageEngine(), function: <#([VerbIDEnding]) -> Void#>)
//    }
//}
