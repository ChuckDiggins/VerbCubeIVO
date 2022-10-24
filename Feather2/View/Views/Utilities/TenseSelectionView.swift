//
//  TenseSelectionView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import SwiftUI
import JumpLinguaHelpers

struct TenseSelectionView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var indicativeTenses: [TenseThing] = [
        TenseThing(tense : .present),
        TenseThing(tense : .imperfect),
        TenseThing(tense : .preterite),
        TenseThing(tense : .future),
        TenseThing(tense : .conditional)
    ]
    
    @State var subjunctiveTenses: [TenseThing] = [
        TenseThing(tense: .presentSubjunctive),
        TenseThing(tense: .imperfectSubjunctiveRA),
        TenseThing(tense: .imperfectSubjunctiveSE)
    ]
    
    @State var indicativePerfectTenses: [TenseThing] = [
        TenseThing(tense: .presentPerfect),
        TenseThing(tense: .pastPerfect),
        TenseThing(tense: .preteritePerfect),
        TenseThing(tense: .conditionalPerfect),
        TenseThing(tense: .futurePerfect)
    ]
    
    @State var subjunctivePerfectTenses: [TenseThing] = [
        TenseThing(tense: .presentPerfectSubjunctive),
        TenseThing(tense: .pastPerfectSubjunctiveRA),
        TenseThing(tense: .pastPerfectSubjunctiveSE)
    ]
    
    @State var imperative = TenseThing(tense : .imperative)
    @State private var enabled = false
    @State private var allSimpleTenses = false
    @State private var allPerfectTenses = false
    @State private var allSubjunctiveTenses = false
    @State private var allPerfectSubjunctiveTenses = false
    @State private var fontSize = Font.caption
    var body: some View{
        
        VStack{
            
            Section (header: Text("Indicative tenses")){
                HStack{
                    List{
                        Section(
                            header:
                                Button(action: {
                                    toggleAllIndicativeTenses()
                                    allSimpleTenses.toggle()
                                }){
                                    Text("Toggle simple tenses")
                                        .font(fontSize)
                                        .foregroundColor(.white)
                                        .background(allSimpleTenses ? .linearGradient(colors: [.red, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing) : .linearGradient(colors: [.blue, .red], startPoint: .bottomLeading, endPoint: .topTrailing))
                                        .padding(.horizontal, 10)
                                }
                            
                        ){
                            ForEach(0..<indicativeTenses.count, id: \.self){ index in
                                HStack {
                                    Button(action: {
                                        indicativeTenses[index].isSelected = indicativeTenses[index].isSelected ? false : true
                                    }) {
                                        HStack{
                                            if indicativeTenses[index].isSelected {
                                                Image(systemName: "checkmark.square.fill")
                                                    .foregroundColor(.green)
                                                    .animation(.default, value: enabled)
                                            } else {
                                                Image(systemName: "square")
                                                    .foregroundColor(.primary)
                                                    .animation(.default, value: enabled)
                                            }
                                            Text(indicativeTenses[index].tense.rawValue)
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    }
                    List{
                        Section(
                            header:
                                Button(action: {
                                    toggleAllIndicativePerfectTenses()
                                    allPerfectTenses.toggle()
                                }){
                                    Text("Toggle perfect tenses")
                                        .font(fontSize)
                                        .foregroundColor(.white)
                                        .background(allPerfectTenses ? .linearGradient(colors: [.red, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing) : .linearGradient(colors: [.blue, .red], startPoint: .bottomLeading, endPoint: .topTrailing))
                                        .padding(.horizontal, 10)
                                }
                            
                        ){
                            ForEach(0..<indicativePerfectTenses.count, id: \.self){ index in
                                HStack {
                                    Button(action: {
                                        indicativePerfectTenses[index].isSelected = indicativePerfectTenses[index].isSelected ? false : true
                                    }) {
                                        HStack{
                                            if indicativePerfectTenses[index].isSelected {
                                                Image(systemName: "checkmark.square.fill")
                                                    .foregroundColor(.green)
                                                    .animation(.default, value: enabled)
                                            } else {
                                                Image(systemName: "square")
                                                    .foregroundColor(.primary)
                                                    .animation(.default, value: enabled)
                                            }
                                            Text(indicativePerfectTenses[index].tense.rawValue)
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    }
                    
                }//HStack
                .font(.caption)
            } //Section Indicative
            
            HStack {
                Button(action: {
                    imperative.isSelected = imperative.isSelected ? false : true
                }) {
                    HStack{
                        if imperative.isSelected {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.green)
                                .animation(.default, value: enabled)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.primary)
                                .animation(.default, value: enabled)
                        }
                        Text(imperative.tense.rawValue)
                    }
                }.background(Color.yellow)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 50)
            }
            Spacer()
            
            Section (header: Text("Subjunctive tenses")){
                HStack{
                    List{
                        Section(
                            header:
                                Button(action: {
                                    toggleAllSubjunctiveTenses()
                                    allSubjunctiveTenses.toggle()
                                }){
                                    Text("Toggle Simple tenses")
                                        .font(fontSize)
                                        .foregroundColor(.white)
                                        .background(allSubjunctiveTenses ? .linearGradient(colors: [.red, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing) : .linearGradient(colors: [.blue, .red], startPoint: .bottomLeading, endPoint: .topTrailing))
                                        .padding(.horizontal, 10)
                                }
                            
                        ){
                            ForEach(0..<subjunctiveTenses.count, id: \.self){ index in
                                HStack {
                                    Button(action: {
                                        subjunctiveTenses[index].isSelected = subjunctiveTenses[index].isSelected ? false : true
                                    }) {
                                        HStack{
                                            if subjunctiveTenses[index].isSelected {
                                                Image(systemName: "checkmark.square.fill")
                                                    .foregroundColor(.green)
                                                    .animation(.default, value: enabled)
                                            } else {
                                                Image(systemName: "square")
                                                    .foregroundColor(.primary)
                                                    .animation(.default, value: enabled)
                                            }
                                            Text(subjunctiveTenses[index].tense.rawValue)
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    }
                    List{
                        Section(
                            header:
                                Button(action: {
                                    toggleAllSubjunctivePerfectTenses()
                                    allPerfectSubjunctiveTenses.toggle()
                                }){
                                    Text("Toggle Simple tenses")
                                        .font(fontSize)
                                        .foregroundColor(.white)
                                        .background(allPerfectSubjunctiveTenses ? .linearGradient(colors: [.red, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing) : .linearGradient(colors: [.blue, .red], startPoint: .bottomLeading, endPoint: .topTrailing))
                                        .padding(.horizontal, 10)
                                }
                            
                        ){
                            ForEach(0..<subjunctivePerfectTenses.count, id: \.self){ index in
                                HStack {
                                    Button(action: {
                                        subjunctivePerfectTenses[index].isSelected = subjunctivePerfectTenses[index].isSelected ? false : true
                                    }) {
                                        HStack{
                                            if subjunctivePerfectTenses[index].isSelected {
                                                Image(systemName: "checkmark.square.fill")
                                                    .foregroundColor(.green)
                                                    .animation(.default, value: enabled)
                                            } else {
                                                Image(systemName: "square")
                                                    .foregroundColor(.primary)
                                                    .animation(.default, value: enabled)
                                            }
                                            Text(subjunctivePerfectTenses[index].tense.rawValue)
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    }
                    
                }//HStack
                //Spacer()
                .font(.caption)
            } //Section Subjunctive
            
            
            Button(action: {
                self.mode.wrappedValue.dismiss()
            }){
                Text("Don't save")
            }
            
        }
        .onAppear{
            fillTenses()
        }.environment(\.defaultMinListRowHeight, 10)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                saveTenses()
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
                Text("Save tenses")
            })
        //VStack
        
    }
    
    func toggleAllIndicativeTenses(){
        var item = TenseThing(tense : .present)
        for index in 0..<indicativeTenses.count {
            item = indicativeTenses[index]
            //print("Before toggle \(item) is selected \(item.isSelected)" )
            item.isSelected.toggle()
            //print("After toggle \(item) is selected \(item.isSelected)" )
            indicativeTenses[index] = item
        }
    }
    
    func toggleAllIndicativePerfectTenses(){
        var item = TenseThing(tense : .present)
        for index in 0..<indicativePerfectTenses.count {
            item = indicativePerfectTenses[index]
            //print("Before toggle \(item) is selected \(item.isSelected)" )
            item.isSelected.toggle()
            //print("After toggle \(item) is selected \(item.isSelected)" )
            indicativePerfectTenses[index] = item
        }
    }
    
    
    func toggleAllSubjunctiveTenses(){
        var item = TenseThing(tense : .present)
        for index in 0..<subjunctiveTenses.count {
            item = subjunctiveTenses[index]
            //print("Before toggle \(item) is selected \(item.isSelected)" )
            item.isSelected.toggle()
            //print("After toggle \(item) is selected \(item.isSelected)" )
            subjunctiveTenses[index] = item
        }
    }
    
    func toggleAllSubjunctivePerfectTenses(){
        var item = TenseThing(tense : .present)
        for index in 0..<subjunctivePerfectTenses.count {
            item = subjunctivePerfectTenses[index]
            //print("Before toggle \(item) is selected \(item.isSelected)" )
            item.isSelected.toggle()
            //print("After toggle \(item) is selected \(item.isSelected)" )
            subjunctivePerfectTenses[index] = item
        }
    }
    
    func fillTenses(){
        let tenseList = languageViewModel.getTenseList()
        
        var tenseFound = false
        for tense in tenseList {
            for index in 0..<indicativeTenses.count {
                if ( indicativeTenses[index].tense == tense ){
                    indicativeTenses[index].isSelected = true
                    tenseFound = true
                    break
                }
            }
            
            if ( !tenseFound ){
                for index in 0..<subjunctiveTenses.count {
                    if ( subjunctiveTenses[index].tense == tense ){
                        subjunctiveTenses[index].isSelected = true
                        tenseFound = true
                        break
                    }
                }
            }
            
            if ( !tenseFound ){
                for index in 0..<indicativePerfectTenses.count {
                    if ( indicativePerfectTenses[index].tense == tense ){
                        indicativePerfectTenses[index].isSelected = true
                        tenseFound = true
                        break
                    }
                }
            }
            
            if ( !tenseFound ){
                for index in 0..<subjunctivePerfectTenses.count {
                    if ( subjunctivePerfectTenses[index].tense == tense ){
                        subjunctivePerfectTenses[index].isSelected = true
                        tenseFound = true
                        break
                    }
                }
            }
            if ( !tenseFound ){
                if ( imperative.tense == tense ){
                    imperative.isSelected = true
                    tenseFound = true
                }
            }
            //print("\(tense) was found \(tenseFound) ")
        }
    }
    
    func saveTenses(){
        //var tenseManager = TenseManager()
        
        var tenseList = [Tense]()
        
        
        for index in 0..<indicativeTenses.count {
            if ( indicativeTenses[index].isSelected ){tenseList.append(indicativeTenses[index].tense)}
        }
        for index in 0..<subjunctiveTenses.count {
            if ( subjunctiveTenses[index].isSelected ){tenseList.append(subjunctiveTenses[index].tense)}
        }
        for index in 0..<indicativePerfectTenses.count {
            if ( indicativePerfectTenses[index].isSelected ){tenseList.append(indicativePerfectTenses[index].tense)}
        }
        for index in 0..<subjunctivePerfectTenses.count {
            if ( subjunctivePerfectTenses[index].isSelected ){tenseList.append(subjunctivePerfectTenses[index].tense)}
        }
        if ( imperative.isSelected ){tenseList.append(imperative.tense)}
        
        if ( tenseList.count > 0 ){
            languageViewModel.setTenses(tenseList : tenseList )
        }
    }
}

struct TenseThing{
    var tense: Tense
    var id = UUID()
    var isSelected: Bool = false
}


//struct TenseSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TenseSelectionView(languageViewModel: LanguageViewModel(language: .))
//    }
//}
