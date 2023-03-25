//
//  WalkthroughWelcomeToModel.swift
//  Feather2
//
//  Created by chuckd on 3/20/23.
//

import SwiftUI

var totalModelWalkthroughPages = 3
struct WalkthroughWelcomeToModel: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    
    @AppStorage("modelWalkThrough") var modelWalkThroughPage = 1
    var body: some View{
        ZStack{
            if modelWalkThroughPage == 1{
                VerbModelListView(languageViewModel: languageViewModel, vmecdm: vmecdm)
            }
            
            if modelWalkThroughPage == 2{
                MultiVerbMorphView(languageViewModel: languageViewModel)
            }
        }
    }
    
}

struct WalkthroughWelcomeToModel_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughWelcomeToModel()
    }
}
