//
//  VerbChartView.swift
//  Feather2
//
//  Created by Charles Diggins on 11/23/22.
//

import SwiftUI
import Charts

struct VerbCount: Identifiable{
    let id = UUID()
    let name: String
    let count: Int
}

struct VerbCountType2: Identifiable{
    let id = UUID()
    let name: String
    let count1: Int
    let count2: Int
}

struct VerbChart2View: View {
    @State var verbCounts : [VerbCountType2]
    
    var body: some View {
        Chart(verbCounts){vc in
            BarMark(x: .value("Verb status", vc.name),
                    y: .value("Count", vc.count1))
            .annotation(position: .top) {
                Text("\(vc.count1)")
                    .font(.caption)
            }
            BarMark(x: .value("Verb status", vc.name),
                    y: .value("Count", -vc.count2))
            .annotation(position: .bottom) {
                Text("\(vc.count2)")
                    .font(.caption)
            }
//            .foregroundStyle(by: .value("Verb status", vc.name))
            RuleMark(y: .value("Line", 0))
                .lineStyle(StrokeStyle(dash: [15.0, 5.0]))
                .foregroundStyle(.red)
        }
        .chartPlotStyle { plotArea in
            plotArea
                .frame(height: 150)
                .frame(width: 350)
                .background(Color(.secondarySystemBackground))
        }
        .onAppear{
            
        }
    }
}

struct VerbChartView: View {
    @State var verbCounts : [VerbCount]

    var body: some View {
        Chart(verbCounts){vc in
            BarMark(x: .value("Verb status", vc.name),
                    y: .value("Count", vc.count))
            .foregroundStyle(by: .value("Verb status", vc.name))
            .annotation(position: .top) {
                Text("\(vc.count)")
                    .font(.caption)
            }
        }
        
        .chartPlotStyle { plotArea in
            plotArea
                .frame(height: 150)
                .frame(width: 350)
                .background(Color(.secondarySystemBackground))
        }
        .onAppear{
            
        }
    }
}

//struct VerbChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerbChartView()
//    }
//}
