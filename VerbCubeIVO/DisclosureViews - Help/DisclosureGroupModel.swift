//
//  DisclosureGroupModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/1/22.
//

import SwiftUI

struct DisclosureGroupModel: View {
    @State var isExpanded = false
    @State var isExpandedLearning = false
    @State var isExpandedQuizzes = false
    
    @Environment(\.verticalSizeClass)  var verticalSizeClass
    @Environment(\.horizontalSizeClass)  var horizontalSizeClass
    @Environment(\.dynamicTypeSize)  var typeSize
    
    var isLandscape: Bool {verticalSizeClass == .compact }
    
    var body: some View {

        VStack{
//            Text(isLandscape ? "I'm landscape" : "I'm portrait")
            DisclosureGroup("Model-Based Help", isExpanded: $isExpanded){
                DisclosureGroup("Learning", isExpanded: $isExpandedLearning){
                    Text("Model-based learning exercises show you how to used model-based verbs to learn verb conjugation.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.yellow)
                }.background(.yellow)
                DisclosureGroup("Quizzes", isExpanded: $isExpandedQuizzes){
                    Text("Model-based quizzes help you interactively learn model-based verb conjugation.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.orange)
                }.background(.orange)
            }.padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(.gray)
                .foregroundColor(.black)
        }
    }
}

struct DisclosureGroupModel_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureGroupModel()
    }
}
