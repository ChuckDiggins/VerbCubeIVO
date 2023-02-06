//
//  DisclosureGroupTeachMePatternVerbs.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/15/22.
//

import SwiftUI

struct DisclosureGroupMultipleChoiceSubjectVerb: View {
    @State var isExpanded = false
    @State var isExpandedGeneral = false
    @State var isExpandedChangeMode = false
    
    var body: some View {
        VStack{
            DisclosureGroup("Multiple Choice - Subject/Verb", isExpanded: $isExpanded){
                DisclosureGroup("General description", isExpanded: $isExpandedGeneral){
                    VStack{
                        Text("This screen simply presents you with a series of conjugation problems.")
                        Text("On the left you will see a person, such as \"nosotros\".")
                        Text("On the right is a column of conjugated verbs.")
                        Text("Each verb is conjugated with a different person.")
                        Text("Click on the correct verb.  You will be shown the next problem.")
                    }
                }.multilineTextAlignment(.leading)
                    .background(.orange)
                    .foregroundColor(.black)
                
                
                //                DisclosureGroup("Change mode", isExpanded: $isExpandedChangeMode){
                //                    VStack{
                //                        Text("Change mode determines how many things can change")
                //                        HStack{
                //                            Text("Person").bold()
                //                            Text("= person will change for each problem.")
                //                        }
                //                        Divider().frame(height:2).background(.yellow)
                //                        HStack{
                //                            Text("Person-Tense").bold()
                //                            Text("= person/tense change for each problem.")
                //                        }
                //                        Divider().frame(height:2).background(.yellow)
                //                        HStack{
                //                            Text("Person-Tense-Verb").bold()
                //                            Text("= person/tense/verb change for each problem.")
                //                        }
                //                    }.multilineTextAlignment(.leading)
                //                    .background(.yellow)}
                //                        .foregroundColor(.black)
                //
                //                }.modifier(DisclosureGroupModifier())
            }
            
        }
    }
}
    
    
    struct DisclosureGroupMultipleChoiceSubjectTense: View {
        @State var isExpanded = false
        @State var isExpandedGeneral = false
        @State var isExpandedChangeMode = false
        
        var body: some View {
            VStack{
                DisclosureGroup("Multiple Choice - Subject/Tense", isExpanded: $isExpanded){
                    DisclosureGroup("General description", isExpanded: $isExpandedGeneral){
                        VStack{
                            Text("This screen simply presents you with a series of conjugation problems.")
                            Text("On the left you will see a person, such as \"nosotros\".")
                            Text("On the right is a column of conjugated verbs.")
                            Text("Each verb is conjugated with a different tense.")
                            Text("Click on the correct verb.  You will be shown the next problem.")
                        }
                        .multilineTextAlignment(.leading)
                    }.background(.orange)
                        .foregroundColor(.black)
                    DisclosureGroup("Change mode", isExpanded: $isExpandedChangeMode){
                        VStack{
                            Text("Change mode determines how many things can change")
                            HStack{
                                Text("Person").bold()
                                Text("= person will change for each problem.")
                            }
                            Divider().frame(height:2).background(.yellow)
                            HStack{
                                Text("Person-Tense").bold()
                                Text("= person/tense change for each problem.")
                            }
                            Divider().frame(height:2).background(.yellow)
                            HStack{
                                Text("Person-Tense-Verb").bold()
                                Text("= person/tense/verb change for each problem.")
                            }
                        }.multilineTextAlignment(.leading)
                        
                    }.background(.yellow)
                        .foregroundColor(.black)
                    
                }
                .modifier(DisclosureGroupModifier())
            }
        }
    }
    
    struct DisclosureGroupMixAndMatch: View {
        @State var isExpanded = false
        @State var isExpandedGeneral = false
        @State var isExpandedChangeMode = false
        
        var body: some View {
            VStack{
                DisclosureGroup("Mix and Match", isExpanded: $isExpanded){
                    VStack{
                        Text("On the left are scrambled subjects.")
                        Text("On the right are scrambled verbs ")
                        Text("You must click on a subject.")
                        Text("Then click on a verb.  If correct, both will be disabled.")
                        Text("When you are a problem, click on the verb or tense buttons for new problem.")
                    } .multilineTextAlignment(.leading)
                        .background(.yellow)
                        .foregroundColor(.black)
                    
                }.modifier(DisclosureGroupModifier())
            }
            
        }
    }
    
    struct DisclosureGroupTesting: View {
        @State var isExpanded = false
        @State var isExpandedGeneral = false
        @State var isExpandedChangeMode = false
        
        var body: some View {
            VStack{
                DisclosureGroup("Fill-in Blanks and Multiple Choice", isExpanded: $isExpanded){
                    VStack{
                        Text("Fill-in Blanks and Multiple Choice")
                        Text("To move to another verb model you must pass these tests.")
                        Text("You must get over 90% correct.")
                        Text("If you get 4 wrong on this model,")
                        Text("the right/wrong counts will be reset.")
                    } .multilineTextAlignment(.leading)
                        .background(.yellow)
                        .foregroundColor(.black)
                    
                }.modifier(DisclosureGroupModifier())
            }
            
        }
    }
    struct DisclosureGroupDragAndDrop: View {
        @State var isExpanded = false
        @State var isExpandedGeneral = false
        @State var isExpandedChangeMode = false
        
        var body: some View {
            VStack{
                DisclosureGroup("Drag and Drop", isExpanded: $isExpanded){
                    VStack{
                        Text("The idea is to click (grab) a verb in the bottom part.")
                        Text("Then you drag the verb to the correct subject in the top part.")
                        Text("If correct, both will turn green.")
                        Text("If wrong, the screen will shake and your verb will be let lose.")
                        Text("Drag and Drop does keep score for you.")
                    } .multilineTextAlignment(.leading)
                        .background(.yellow)
                        .foregroundColor(.black)
                    
                }.modifier(DisclosureGroupModifier())
            }
            
        }
    }
    
    
    
    
    
