//
//  DisclosureGroupMain.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/1/22.
//

import SwiftUI

struct DisclosureGroupMain: View {
    @State var isExpanded = false
    @State var isExpandedGuidelines = false
    @State var isExpandedModelBased = false
    @State var isExpandedPatternBased = false
    @State var isExpandedGeneralVerbs = false
    @State var isExpandedOddsAndEnds = false
    
    @Environment(\.verticalSizeClass)  var verticalSizeClass
    @Environment(\.horizontalSizeClass)  var horizontalSizeClass
    @Environment(\.dynamicTypeSize)  var typeSize
    
    var isLandscape: Bool {verticalSizeClass == .compact }
    
    var body: some View {

        VStack{
//            Text(isLandscape ? "I'm landscape" : "I'm portrait")
            DisclosureGroup("Feather Help", isExpanded: $isExpanded){
                DisclosureGroup("General guidelines", isExpanded: $isExpandedGuidelines){
                    Text("Feather is designed to help you learn how to conjugate Spanish verbs")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.yellow)
                }.background(.yellow)

                DisclosureGroup("Teach me", isExpanded: $isExpandedModelBased){
                    
                    Text("Teach me regular verbs.  Regular verbs are conjugated normally, without any patterns such as stem-changes.  Regular verbs belong to regular verb models: cortar, vender, vivir")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.orange)
                    Text("Teach me model verbs.  Verbs that belong to the same model conjugate identically in every tense, any person, even verb models which are irregular.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.orange)
                    Text("Teach me pattern verbs.  Verbs are selected based on their patterns, such as O to OU stem changing verbs.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.orange)
                }.background(.orange)
                DisclosureGroup("Pattern-based Verbs", isExpanded: $isExpandedPatternBased){
                    Text("Pattern-based verbs use the traditional verb patterns, such as stem-changing verbs, spell-changing verbs.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.green)
                }.background(.green)
                DisclosureGroup("General Verbs", isExpanded: $isExpandedGeneralVerbs){
                    Text("These exercises let you play with verbs without considering models and patterns.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.blue)
                }.background(.blue)
                DisclosureGroup("Odds and Ends", isExpanded: $isExpandedOddsAndEnds){
                    Text("These exercises work verbs that do not behave as typical verbs, like gustar, verbs describing weather, auxiliary verbs, etc")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.purple)
                }.background(.purple)
            }.padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(.gray)
                .foregroundColor(.black)
        }
    }
}

struct DisclosureGroupMain_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureGroupMain()
    }
}
