//
//  DisclosureGroupPreferences.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/1/22.
//

import SwiftUI

struct DisclosureGroupPreferences: View {
    @State var isExpanded = false
    @State var isExpandedTenses = false
    @State var isExpandedSpeechMode = false
    @State var isExpandedSubjectType = false
    
    
    @Environment(\.verticalSizeClass)  var verticalSizeClass
    @Environment(\.horizontalSizeClass)  var horizontalSizeClass
    @Environment(\.dynamicTypeSize)  var typeSize
    
    var isLandscape: Bool {verticalSizeClass == .compact }
    
    var body: some View {

        VStack{
//            Text(isLandscape ? "I'm landscape" : "I'm portrait")
            DisclosureGroup("Preferences Help", isExpanded: $isExpanded){
                DisclosureGroup("Tenses", isExpanded: $isExpandedTenses){
                    Text("Pick the tenses you want to work with on all the windows that use tenses.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.yellow)
                }.background(.yellow)
                   

                DisclosureGroup("Speech Mode", isExpanded: $isExpandedSpeechMode){
                    Text("Several exercises in Feather provide step-by-step instructions.  When Speech mode is active, Feather will provide the instructions out loud.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.orange)
                }.background(.orange)
                DisclosureGroup("Subject Type", isExpanded: $isExpandedSubjectType){
                    Text("When male informal is used, subject pronouns such as él and nosotros will be used.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.green)
                    Text("When female informal is used, subject pronouns such as ella and nosotras will be used.")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(.green)
                }.background(.green)
            }
            .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(.gray)
                .foregroundColor(.black)
        }
    }
        
}

struct DisclosureGroupPreferences_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureGroupPreferences()
    }
}
