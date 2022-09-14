//
//  Disclosure Beginner Level 1 .swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/23/22.
//

import SwiftUI

struct Disclosure1001: View {
    @State var isExpanded = false
    
    var body: some View {
        VStack{
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: { ShowLevel1001() },
                label: {
                    Button("Level 1001 details"){
                        withAnimation{
                            isExpanded.toggle()
                        }
                    }
                }
            )
        }
    }
}


struct ShowLevel1001: View {
    var body: some View {
        VStack{
            Text("1 Simple Tense").font(.title3)
                .foregroundColor(Color("ChuckText1"))
                .padding(horizontal: 20, vertical: 5)
            VStack{
                Text("present tense")
            }
            
            VStack{
                Text("3 Regular Verbs").font(.title3)
                    .foregroundColor(Color("ChuckText1"))
                    .padding(horizontal: 20, vertical: 0)
                VStack{
                    Button{
                        
                    } label: {
                        Text("comprar")
                    }
                    
                    Button{
                        
                    } label: {
                        Text("vender")
                    }
                    Button{
                        
                    } label: {
                        Text("vivir")
                    }
                }
            }.padding(10)
            
        }
        .background(Color("BethanyNavalBackground"))
        .foregroundColor(Color("BethanyGreenText"))
        .padding(horizontal: 50, vertical: 0)
        .border(.green)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .secondarySystemFill), style: StrokeStyle(lineWidth: 1)))
    }
}

struct Disclosure1002: View {
    @State var isExpanded = false
    
    var body: some View {
        VStack{
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: { ShowLevel1002() },
                label: {
                    Button("Level 1002 details"){
                        withAnimation{
                            isExpanded.toggle()
                        }
                    }
                }
            )
        }
    }
}

struct ShowLevel1002: View {
    var body: some View {
        VStack{
            Text("Tenses:").font(.title3).foregroundColor(Color("ChuckText1"))
            VStack{
                Text("present tense")
            }
            Text("15 Regular Verbs").font(.title3).foregroundColor(Color("ChuckText1"))
            VStack{
                Button{
                    
                } label: {
                    Text("5 AR verbs")
                }
                
                Button{
                    
                } label: {
                    Text("5 ER verbs")
                }
                Button{
                    
                } label: {
                    Text("5 IR verbs")
                }
            }
            
            
        }
        .background(Color("BethanyNavalBackground"))
        .foregroundColor(Color("BethanyGreenText"))
        .padding(25)
    }
}

struct Disclosure1003: View {
    @State var isExpanded = false
    
    var body: some View {
        VStack{
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: { ShowLevel1003() },
                label: {
                    Button("Level 1003 details"){
                        withAnimation{
                            isExpanded.toggle()
                        }
                    }
                }
            )
        }
    }
}

struct ShowLevel1003: View {
    var body: some View {
        VStack{
            Text("Tenses:").font(.title3).foregroundColor(Color("ChuckText1"))
            VStack{
                Text("present tense")
            }
            Text("Irregular verbs").font(.title3).foregroundColor(Color("ChuckText1"))
            List{
                Text("ser")
                Text("estar")
                Text("ver")
                Text("oír")
                Text("ir")
            }
            
            
        }
        .background(Color("BethanyNavalBackground"))
        .foregroundColor(Color("BethanyGreenText"))
        .padding(25)
    }
}


