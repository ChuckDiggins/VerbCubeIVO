//
//  TenseSelectionView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/11/22.
//

import SwiftUI
import JumpLinguaHelpers



struct TenseSelectionView: View {
    enum TenseMode: String {
        case Indicative, Subjunctive
    }
    
    struct TenseThing{
        var tense: Tense
        var id = UUID()
        var isSelected: Bool = false
    }
    
    @ObservedObject var languageViewModel: LanguageViewModel
//    @Binding var tenseList: [Tense]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.dismiss) private var dismiss
    
    @State var indicativeTenses: [TenseThing] = [
        TenseThing(tense : .present),
        TenseThing(tense : .imperfect),
        TenseThing(tense : .preterite),
        TenseThing(tense : .future),
        TenseThing(tense : .conditional)
    ]
    
    @State var subjunctiveTenses: [TenseThing] = [
        TenseThing(tense : .imperative),
        TenseThing(tense: .presentSubjunctive),
        TenseThing(tense: .imperfectSubjunctiveRA),
        TenseThing(tense: .imperfectSubjunctiveSE)
    ]
//    @State var imperative = TenseThing(tense : .imperative)
    
    @State var indicativePerfectTenses: [TenseThing] = [
        TenseThing(tense: .presentPerfect),
        TenseThing(tense: .pastPerfect),
        TenseThing(tense: .preteritePerfect),
        TenseThing(tense: .conditionalPerfect),
        TenseThing(tense: .futurePerfect)
    ]
    @State var indicativeProgressiveTenses: [TenseThing] = [
        TenseThing(tense: .presentProgressive),
        TenseThing(tense: .imperfectProgressive),
        TenseThing(tense: .conditionalProgressive),
        TenseThing(tense: .futureProgressive)
    ]
    
    @State var subjunctivePerfectTenses: [TenseThing] = [
        TenseThing(tense: .presentPerfectSubjunctive),
        TenseThing(tense: .pastPerfectSubjunctiveRA),
        TenseThing(tense: .pastPerfectSubjunctiveSE)
    ]
    
    
    @State private var enabled = false
    @State private var fontSize = Font.caption
    @State private var indicativeOrSubjunctive = TenseMode.Indicative
    @State private var modeList = [TenseMode.Indicative, .Subjunctive]
    
    var body: some View{
        
        VStack{
            Picker("Mode", selection: $indicativeOrSubjunctive){
                ForEach(modeList , id:\.self){ Text($0.rawValue)}
            }.pickerStyle(SegmentedPickerStyle())
                .padding()

            switch indicativeOrSubjunctive {
            case .Indicative:
                VStack{
                    HStack{
                        List{
                            ForEach(0..<indicativeTenses.count, id: \.self){ index in
                                
                                Button{
                                    indicativeTenses[index].isSelected.toggle()
                                } label: {
                                    Text(indicativeTenses[index].tense.rawValue)
                                        .foregroundColor(indicativeTenses[index].isSelected ? .yellow : Color("BethanyGreenText"))
                                        .background(indicativeTenses[index].isSelected ? .black : Color("BethanyNavalBackground"))
                                }
                            }
                        }
                        List{
                            ForEach(0..<indicativePerfectTenses.count, id: \.self){ index in
                                Button{
                                    indicativePerfectTenses[index].isSelected.toggle()
                                } label: {
                                    Text(indicativePerfectTenses[index].tense.rawValue)
                                        .foregroundColor(indicativePerfectTenses[index].isSelected ? .yellow : Color("BethanyGreenText"))
                                        .background(indicativePerfectTenses[index].isSelected ? .black : Color("BethanyNavalBackground"))
                                }
                            }
                        }
                    }
                    List{
                        ForEach(0..<indicativeProgressiveTenses.count, id: \.self){ index in
                            Button{
                                indicativeProgressiveTenses[index].isSelected.toggle()
                            } label: {
                                Text(indicativeProgressiveTenses[index].tense.rawValue)
                                    .foregroundColor(indicativeProgressiveTenses[index].isSelected ? .yellow : Color("BethanyGreenText"))
                                    .background(indicativeProgressiveTenses[index].isSelected ? .black : Color("BethanyNavalBackground"))
                            }
                        }
                    }
                }
            case .Subjunctive:
//                Button{
//                    imperative.isSelected.toggle()
//                } label: {
//                    Text(imperative.tense.rawValue).font(.caption)
//                        .foregroundColor(imperative.isSelected ? .yellow : Color("BethanyGreenText"))
//                        .background(imperative.isSelected ? .black : Color("BethanyNavalBackground"))
//                }
//                
                HStack{
                    List{
                        ForEach(0..<subjunctiveTenses.count, id: \.self){ index in
                            Button{
                                subjunctiveTenses[index].isSelected.toggle()
                            } label: {
                                Text(subjunctiveTenses[index].tense.rawValue)
                                    .foregroundColor(subjunctiveTenses[index].isSelected ? .yellow : Color("BethanyGreenText"))
                                    .background(subjunctiveTenses[index].isSelected ? .black : Color("BethanyNavalBackground"))
                            }
                        }
                    }
                    List{
                        ForEach(0..<subjunctivePerfectTenses.count, id: \.self){ index in
                            Button{
                                subjunctivePerfectTenses[index].isSelected.toggle()
                            } label: {
                                Text(subjunctivePerfectTenses[index].tense.rawValue)
                                    .foregroundColor(subjunctivePerfectTenses[index].isSelected ? .yellow : Color("BethanyGreenText"))
                                    .background(subjunctivePerfectTenses[index].isSelected ? .black : Color("BethanyNavalBackground"))
                            }
                        }
                    }
                }
                
            }
            
            HStack{
                Button(action: {
                    saveTenses()
                    self.mode.wrappedValue.dismiss()
                }){
                    Text("Save")
                }.modifier(BlueButtonModifier())
                
                
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }){
                    Text("Don't save")
                }.modifier(RedButtonModifier())
            }
            
        }.font(.caption)
        .background(Color("BethanyNavalBackground"))
        .foregroundColor(Color("BethanyGreenText"))
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
    
    func fillTenses(){
        let tenseList = languageViewModel.getTenseList()
        
        for tense in tenseList {
            var tenseFound = false
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
                for index in 0..<indicativeProgressiveTenses.count {
                    if ( indicativeProgressiveTenses[index].tense == tense ){
                        indicativeProgressiveTenses[index].isSelected = true
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
            
//            if ( !tenseFound ){
//                if ( imperative.tense == tense ){
//                    imperative.isSelected = true
//                    tenseFound = true
//                }
//            }
            //print("\(tense) was found \(tenseFound) ")
        }
    }
    
    func saveTenses(){
        //var tenseManager = TenseManager()
        
        var tempTenseList = [Tense]()
        for index in 0..<indicativeTenses.count {
            if ( indicativeTenses[index].isSelected ){tempTenseList.append(indicativeTenses[index].tense)}
        }
        for index in 0..<subjunctiveTenses.count {
            if ( subjunctiveTenses[index].isSelected ){tempTenseList.append(subjunctiveTenses[index].tense)}
        }
        for index in 0..<indicativePerfectTenses.count {
            if ( indicativePerfectTenses[index].isSelected ){tempTenseList.append(indicativePerfectTenses[index].tense)}
        }
        for index in 0..<indicativeProgressiveTenses.count {
            if ( indicativeProgressiveTenses[index].isSelected ){tempTenseList.append(indicativeProgressiveTenses[index].tense)}
        }
        for index in 0..<subjunctivePerfectTenses.count {
            if ( subjunctivePerfectTenses[index].isSelected ){tempTenseList.append(subjunctivePerfectTenses[index].tense)}
        }
//        if ( imperative.isSelected ){tempTenseList.append(imperative.tense)}
        
        if ( tempTenseList.count > 0 ){
            languageViewModel.setTenses(tenseList : tempTenseList )
        }
//        tenseList = tempTenseList
    }
}


//struct TenseSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TenseSelectionView(languageViewModel: LanguageViewModel(language: .))
//    }
//}
