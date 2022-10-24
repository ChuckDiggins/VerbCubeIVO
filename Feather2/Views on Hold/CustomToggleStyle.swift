//
//  CustomToggleStyle.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/25/22.
//

import SwiftUI

//struct CheckboxToggleStyle: ToggleStyle {
//    var isReversed = false
//    func makeBody(configuration: Configuration) -> some View {
//        HStack{
//            if !isReversed {
//                configuration.label
//            }
//            Button(action: {
//                configuration.isOn.toggle()
//            }){
//                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
//            }
//            .padding(10)
//            .font(.title3)
//            if isReversed {
//                configuration.label
//            }
//        }
//    }
//}
//
//struct CustomToggleStyle : ToggleStyle {
//    var basicSize = 60.0
//    var color: Color = .red
//    func makeBody(configuration: Configuration) -> some View {
//    
//            HStack{
//                configuration.label
//                Spacer()
//                Button {
//                    configuration.isOn.toggle()
//                } label: {
//                    ToggleItem(isOn: configuration.isOn, basicSize: basicSize, color: color)
//                }
//            }
//    }
//    
//    struct ToggleItem: View {
//        var isOn : Bool = false
//        var basicSize = 60.0
//        var color: Color
//        @State private var animationAmount = 1.0
//        
//        var body: some View {
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(color)
//                .frame(width: basicSize, height: basicSize/3.0)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(isOn ? color : color.opacity(0.2))
//                        .frame(width: basicSize/2.0, height: basicSize/3.0),
//                    alignment: isOn ? .trailing : .leading  )
//                .animation(
//                                    .easeInOut(duration: 1)
//                                        .repeatForever(autoreverses: false),
//                                    value: animationAmount
//                                )
//        }
//    }
//
//}
//
