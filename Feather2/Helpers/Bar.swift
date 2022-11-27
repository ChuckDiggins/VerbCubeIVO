//
//  Bar.swift
//  Feather2
//
//  Created by Charles Diggins on 11/25/22.
//

import SwiftUI
import JumpLinguaHelpers

enum VerbModelStatus : String {
    case Active
    case Selected
    case Completed
}

class HomemadeBarChartManager : ObservableObject {
    @Published var homemadeBars : [Bar]
    @Published var selectedModel = RomanceVerbModel()
    @Published var modelString =  "critical"
    
    init(){
        homemadeBars = [Bar]()
    }
    
    func clearBars(){
        homemadeBars.removeAll()
    }
    
    func createBarList(mpsList : [ModelPatternStruct], maxCount: Int){
        homemadeBars.removeAll()
        for mps in mpsList {
            let bar = Bar(model: mps.model, count: mps.count, color: .green, status: .Active)
            homemadeBars.append(bar)
            if homemadeBars.count >= maxCount { break }
        }
        if homemadeBars.count > 0 {
            selectedModel = homemadeBars[0].model
        }
    }
    
    func setBarList(barList: [Bar]){
        homemadeBars = barList
        if homemadeBars.count > 0 {
            selectedModel = homemadeBars[0].model
        }
    }
    
    func getSelectedModel()->RomanceVerbModel{
        selectedModel
    }
    
    func addBar(model: RomanceVerbModel, count: Int, color: Color, status: VerbModelStatus){
        let bar = Bar(model: model, count: count, color: color,  status: status)
        homemadeBars.append(bar)
    }
    
    func append(_ bar: Bar){
        homemadeBars.append(bar)
    }
    
    func getBars()->[Bar]{
        //        print("HomemadeBarChartManager: getBars: count \(homemadeBars.count)")
        return homemadeBars
    }
    
    func setStatus(modelString: String, status: VerbModelStatus){
        for index in 0 ..< homemadeBars.count{
            if homemadeBars[index].model.modelVerb == modelString{
                homemadeBars[index].status = status
                return
            }
        }
    }
    
    
    func getBarCount()->Int{
        return homemadeBars.count
    }
}



struct Bar: Identifiable {
    let id = UUID()
    var model : RomanceVerbModel
    var count: Int
    var color: Color
    var status: VerbModelStatus
}

