//
//  ProgressBar.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/28/22.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    var barColor : Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(barColor)
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
