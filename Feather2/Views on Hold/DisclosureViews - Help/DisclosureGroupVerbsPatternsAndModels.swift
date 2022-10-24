//
//  DisclosureGroupModel.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/1/22.
//

import SwiftUI

struct DisclosureGroupVerbsPatternsAndModels: View {
    @State var isExpanded = false
    
    var body: some View {
        VStack{
            DisclosureGroup("Verbs, Patterns and Models", isExpanded: $isExpanded){
                VStack{
                    
                    Text("Provides six different exercises:")
                    Divider().frame(height:2).background(.yellow)
                    HStack(spacing:0){
                        Text("Models for Pattern:").bold().background(.yellow)
                        Text("identify models that contain the target pattern.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    HStack(spacing:0){
                        Text("Verbs in Model:").bold().background(.yellow)
                        Text("identify verbs that belong to the target model.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    HStack(spacing:0){
                        Text("Model for a Given Verb:").bold().background(.yellow)
                        Text("find the model which contains the target verb.")
                    }
                }
                VStack{
                    Divider().frame(height:2).background(.yellow)
                    HStack(spacing:0){
                        Text("Verbs for the Same Model:").bold().background(.yellow)
                        Text("identify verbs that have the same model as the target verb")
                    }
                    Divider().frame(height:2).background(.yellow)
                    HStack(spacing:0){
                        Text("Verbs for Pattern:").bold().background(.yellow)
                        Text("find verbs that have the same pattern as the target verb.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    HStack(spacing:0){
                        Text("Verbs with Same Pattern:").bold().background(.yellow)
                        Text("find verbs that have the target pattern.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    Text("🙈 Allows you to peek at the correct answers").bold()
                }
                
                .multilineTextAlignment(.leading)
            }
            .modifier(DisclosureGroupModifier())
        }
    }
}
