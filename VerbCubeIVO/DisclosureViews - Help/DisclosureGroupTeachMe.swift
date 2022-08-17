//
//  DisclosureGroupTeachMeGeneralVerbs.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/15/22.
//

import SwiftUI

struct DisclosureGroupTeachMeARegularVerb: View {
    @State var isExpanded = false
    @State var isExpandedMore = false
    @State var isExpandedMore2 = false
    
    var body: some View {
        VStack{
            DisclosureGroup("Teach Me a General Verb", isExpanded: $isExpanded){
                Divider().frame(height:2).background(.yellow)
                DisclosureGroup("General description", isExpanded: $isExpandedMore){
                    VStack{
                        Text("Regular verbs belong to regular verb models named after their \"model verbs\": cortar, vender, vivir")
                        Divider().frame(height:2).background(.yellow)
                        Text("Because regular verbs are the most common verbs, their models will contain many verbs")
                        Divider().frame(height:2).background(.yellow)
                        Text("Regular verbs in a group are conjugated identically.  They are conjugated normally, without any patterns such as stem-changes.")
                    }
                    .multilineTextAlignment(.leading)
                }
                    .foregroundColor(.black)
                Divider().frame(height:2).background(.yellow)
                DisclosureGroup("4 Steps", isExpanded: $isExpandedMore2){
                    VStack{
                        HStack{
                            Text("Step 1:").bold()
                            Text("Select a tense.  You can change this later."  )
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 2:").bold()
                            Text("Select a verb ending: AR, ER, or IR.  AR verbs are the most common.  When you change the verb ending, the sample verbs in Step 3 will change.  ")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 3:").bold()
                            Text("Select a verb.  The default verb is the first verb loaded in the current model.  You can cycle through the verbs by clicking the Verb: button.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 4:").bold()
                            Text("This will link you to the next screen called Simple Verb Conjugation.  You can see your sample verb conjugated in any tense.  Click on the bottom button to see your verb conjugated step by step.")
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
                    .foregroundColor(.black)
            }
            .modifier(DisclosureGroupModifier())
        }
    }
}

struct DisclosureGroupTeachMeAModelVerb: View {
    @State var isExpanded = false
    @State var isExpandedMore = false
    @State var isExpandedMore2 = false
    
    var body: some View {
        VStack{
            DisclosureGroup("Teach Me A Model Verb", isExpanded: $isExpanded){
                Divider().frame(height:2).background(.yellow)
                DisclosureGroup("Verb Models", isExpanded: $isExpandedMore){
                    VStack{
                        Text("Spanish verbs are divided into 89 verb models")
                        Divider().frame(height:2).background(.yellow)
                        Text("Each verb model is represented by a model verb.  For example, the encontrar model includes are verbs which are conjugated identically to encontrar.")
                    }
                    .multilineTextAlignment(.leading)
                }
                    .foregroundColor(.black)
                Divider().frame(height:2).background(.yellow)
                DisclosureGroup("4 Steps", isExpanded: $isExpandedMore2){
                    VStack{
                        HStack{
                            Text("Step 1:").bold()
                            Text("Select a tense.  You can change this later.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 2:").bold()
                            Text("Select a verb model by clicking on the button.  You can select from models ending in AR, ER and IR.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 3:").bold()
                            Text("Select a verb.  The default verb is the first verb loaded in the current model.  You can cycle through the verbs by clicking the Verb: button.  If there is only one verb in the current model, the verb will not change.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 4:").bold()
                            Text("This will link you to the next screen called Simple Verb Conjugation.  You can see your sample verb conjugated in any tense.  Click on the bottom button to see your verb model conjugated step by step.  This will conjugate several verbs at once.")
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
                    .foregroundColor(.black)
            }.modifier(DisclosureGroupModifier())
        }
    }
}

struct DisclosureGroupTeachMeAPatternVerb: View {
    @State var isExpanded = false
    @State var isExpandedMore = false
    @State var isExpandedMore2 = false
    
    var body: some View {
        VStack{
            DisclosureGroup("Teach Me A Pattern Verb", isExpanded: $isExpanded){
                Divider().frame(height:2).background(.yellow)
                DisclosureGroup("Verb Patterns", isExpanded: $isExpandedMore){
                    VStack{
                        Text("Verb patterns refer to verbs that have irregular conjugation.")
                        Divider().frame(height:2).background(.yellow)
                        Text("For example, verb \"querer\" has an \"e-ie\" stem-changing pattern in present tense.")
                    }
                    .multilineTextAlignment(.leading)
                }
                    .foregroundColor(.black)
                Divider().frame(height:2).background(.yellow)
                DisclosureGroup("4 Steps", isExpanded: $isExpandedMore2){
                    VStack{
                        HStack{
                            Text("Step 1:").bold()
                            Text("Select a tense.  You can change this later.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 2:").bold()
                            Text("Select a verb pattern by clicking on the button.  First time, no pattern has been selected.  Click the button to select from a variety of stem-changing patterns.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 3:").bold()
                            Text("Select a verb within that pattern.  The default verb is the first verb loaded in the current pattern.  You can cycle through the verbs by clicking the Verb: button.  If there is only one verb in the current pattern, the verb will not change.")
                        }
                        Divider().frame(height:2).background(.yellow)
                        HStack{
                            Text("Step 4:").bold()
                            Text("This will link you to the next screen called Simple Verb Conjugation.  You can see your sample verb conjugated in any tense.  Click on the bottom button to see your verb conjugated step by step.  (Unlike model verbs, pattern verbs do not conjugate identically.)")
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
                    .foregroundColor(.black)
            }.modifier(DisclosureGroupModifier())
        }
    }
}

