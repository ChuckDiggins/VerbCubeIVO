//
//  ModelCountView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/21/22.
//

import SwiftUI

import JumpLinguaHelpers
//import Charts

//thank you, Indently

struct ShowSegmentedModelTypePicker: View {
    @Binding var selectedType : VerbModelType
    
    init(_ selectedType: Binding<VerbModelType>){
        self._selectedType = selectedType
        UISegmentedControl.appearance().selectedSegmentTintColor = .green
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    var body: some View{
        VStack{
            Picker("Select model type", selection: $selectedType){
                ForEach(VerbModelType.mainVerbModelTypes, id:\.self){ Text($0.rawValue)}
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
                
        }
    }
}

struct ShowSegmentedVerbEndingPicker: View {
    @Binding var selectedVerbEnding : VerbEnding
    
    init(_ selectedVerbEnding: Binding<VerbEnding>){
        self._selectedVerbEnding = selectedVerbEnding
//        UISegmentedControl.appearance().selectedSegmentTintColor = .green
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
   
    
    var body: some View{
        VStack{
            Picker("Select verb ending", selection: $selectedVerbEnding){
                ForEach(VerbEnding.spanishMainVerbTypes, id:\.self){ Text($0.rawValue)}
            }.pickerStyle(.segmented)
                .padding()
        }
    }
}


struct ModelVerbChartView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm = VerbModelEntityCoreDataManager()
//    @ObservedObject var vm = VerbModelEntityCoreData()
    @State private var selectedType = VerbModelType.regular
    @State private var selectedVerbEnding = VerbEnding.ALL
    
    @ObservedObject var homemadeBarChartMgr = HomemadeBarChartManager()
    @State private var currentLanguage = LanguageType.Spanish
    
    var body: some View {
        VStack {
            ShowSegmentedModelTypePicker($selectedType)
                
            ShowSegmentedVerbEndingPicker($selectedVerbEnding)
                

            showCurrentVerbModel
            HomemadeBarChartView(languageViewModel: languageViewModel, vmecdm: vmecdm, homemadeBarChartMgr: homemadeBarChartMgr, selectedType: $selectedType, selectedVerbEnding: $selectedVerbEnding)
        }.onAppear{
            let mpsList = getModelPatternStructListAtSelectedTypeAndEnding()
            homemadeBarChartMgr.createBarList(mpsList: mpsList, maxCount: 100)
            homemadeBarChartMgr.modelString = "regularAR"
        }
        .onDisappear{
            languageViewModel.setCurrentVerbModel(model: homemadeBarChartMgr.selectedModel)
//            setSpecialFlags()
            languageViewModel.setVerbsExistForAll3Endings(flag: verbsExistForAll3Endings())
            languageViewModel.fillVerbCubeAndQuizCubeLists()
            
        }
        .onChange(of: selectedVerbEnding){ type in
            let mpsList = getModelPatternStructListAtSelectedTypeAndEnding()
            homemadeBarChartMgr.createBarList(mpsList: mpsList, maxCount: 100)
        }
        .onChange(of: selectedType){ type in
            let mpsList = getModelPatternStructListAtSelectedTypeAndEnding()
            homemadeBarChartMgr.createBarList(mpsList: mpsList, maxCount: 100)
        }
        
    }
    
    func verbsExistForAll3Endings()->Bool{
        let vamslu = VerbAndModelSublistUtilities()
        let ARcount = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), ending: .AR,  language: languageViewModel.getCurrentLanguage()).count
        let ERcount = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), ending: .ER,  language: languageViewModel.getCurrentLanguage()).count
        let IRcount = vamslu.getVerbSublistAtVerbEnding(inputVerbList: languageViewModel.getFilteredVerbs(), ending: .IR,  language: languageViewModel.getCurrentLanguage()).count
        
        if ARcount > 0 && ERcount > 0 && IRcount > 0 { return true}
        return false
    }
    
    func getModelPatternStructListAtSelectedTypeAndEnding()->[ModelPatternStruct]{
        var currentModelList = languageViewModel.getVerbModelGroupManager().getVerbModelListAtVerbEnding(name: selectedType.rawValue, verbEnding: selectedVerbEnding)
        return VerbAndModelSublistUtilities().getModelPatternStructListSortedByTheirVerbCount(languageViewModel: languageViewModel, inputModelList: currentModelList)
    }
    
}
        
        

extension ModelVerbChartView {
    private var showCurrentVerbModel: some View {
        Text("Selected model: \(homemadeBarChartMgr.modelString)")
    }
    
//    private var showVerbEndingTypes: some View {
//        HStack{
//            Button{
//                currentVerbEnding = .AR
//                homemadeBarChartMgr.createBarList(mpsList: languageViewModel.getModelPatternStructList(ending: currentVerbEnding), maxCount: 10)
//            } label: {
//                HStack{
//                    Text("AR")
//                        .frame(width: 50, height: 30)
//                        .foregroundColor(.white)
//                        .background(currentVerbEnding == .AR ? .red : Color("BethanyPurpleButtons"))
//                        .shadow(radius: 3)
//                }
//            }
//            Button{
//                currentVerbEnding = .ER
//                homemadeBarChartMgr.createBarList(mpsList: languageViewModel.getModelPatternStructList(ending: currentVerbEnding), maxCount: 10)
//            } label: {
//                HStack{
//                    Text("ER")
//                        .frame(width: 50, height: 30)
//                        .background(currentVerbEnding == .ER ? .red : Color("BethanyPurpleButtons"))
//                        .foregroundColor(.white)
//                        .shadow(radius: 3)
//                }
//            }
//
//            Button{
//                currentVerbEnding = .IR
//                homemadeBarChartMgr.createBarList(mpsList: languageViewModel.getModelPatternStructList(ending: currentVerbEnding), maxCount: 10)
//            } label: {
//                HStack{
//                    Text("IR")
//                        .frame(width: 50, height: 30)
//                        .background(currentVerbEnding == .IR ? .red : Color("BethanyPurpleButtons"))
//                        .foregroundColor(.white)
//                        .shadow(radius: 3)
//                }
//            }
//        }
//        .foregroundColor(Color("BethanyGreenText"))
//        .background(Color("BethanyNavalBackground"))
//        .padding(5)
//        .border(Color("ChuckText1"))
//    }
}

