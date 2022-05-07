//
//  VerbSelectionView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/5/22.
//

import SwiftUI
import JumpLinguaHelpers

enum VerbSelectionType : String {
    case model = "Verbs by Model"
    case pattern = "Verbs by Pattern"
    case ar = "AR verbs (Spanish only)"
    case er = "ER verbs"
    case ir = "IR verbs"
    case oir = "OIR verbs (French only)"
}

struct VerbSelectionView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    @State private var verbSelectionType = VerbSelectionType.model
    
    @State private var model = 58
    @State private var pattern = SpecialPatternType.e2ie
    var backgroundColor = Color.yellow
    var foregroundColor = Color.black
    var fontSize = Font.callout
    var maxListCount = 20
    @State private var currentModelList = [RomanceVerbModel]()
    @State private var currentPatternList = [SpecialPatternType]()
    @State private var currentVerbList = [Verb]()
    @State private var currentModel : RomanceVerbModel?
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .onAppear{
            currentLanguage = languageViewModel.getCurrentLanguage()
            currentModelList = fillCommonModelList()
            currentModel = currentModelList[0]
            currentVerbList = fillVerbsBelongingToModel(model: currentModel!)
        }

    }

//struct VerbSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerbSelectionView()
//    }
//}

    func fillCommonModelList()->[RomanceVerbModel]{
        return languageViewModel.getCommonVerbModelList()
    }
    
    func fillVerbsBelongingToModel(model: RomanceVerbModel)->[Verb]{
        return  languageViewModel.findVerbsOfSameModel(targetID: model.id)
        
    }

}

