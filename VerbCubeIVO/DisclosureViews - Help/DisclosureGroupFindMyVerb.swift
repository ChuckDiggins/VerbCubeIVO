//
//  DisclosureGroupTeachMeModelVerbs.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/15/22.
//

import SwiftUI

struct DisclosureGroupFindMyVerb: View {
    @State var isExpanded = false
    
    var body: some View {
        VStack{
            DisclosureGroup("         Find My Verb", isExpanded: $isExpanded){
                VStack{
                    Text("The \"Find Verbs\" screens accept typed in verbs.")
                    Text("Typed in verbs can be hypothetical, such as \"xyzeguir\".")
                    Divider().frame(height:2).background(.yellow)
                    HStack{
                        Text("Find Verbs with Same Model").bold()
                        Text("scans the library and finds all verbs that have the same model as your input verb.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    HStack{
                        Text("Find Verbs with Same Pattern").bold()
                        Text("scans the library and finds all verbs that have the same pattern as your input verb.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    HStack{
                        Text("Analyze User Verb").bold()
                        Text("will find and provide conjugation information about your input verb.")
                    }
                    Divider().frame(height:2).background(.yellow)
                    VStack{
                        HStack{
                            Text("Unconjugate").bold()
                            Text("takes a conjugated verb and finds any verb person, tense, verb .")
                        }
                        Text(" ")
                        HStack{
                            Text("If you input \"tengo\", ")
                            Text("Unconjugate will return \"yo, present tense, tener\" ")
                        }
                    }
                }
                .multilineTextAlignment(.leading)
                .background(.yellow)
            }
            .modifier(DisclosureGroupModifier())
        }
    }
}
