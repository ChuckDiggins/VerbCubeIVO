//
//  ToggleItem.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/25/22.
//

import SwiftUI

struct ToggleItemA: View {
    var isOn : Bool = false
    var basicSize = 60.0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(Color.red)
            .frame(width: basicSize, height: basicSize/3.0)
            overlay(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.red)
                    .frame(width: basicSize/2.0, height: basicSize/3.0),
                alignment: isOn ? .trailing : .leading
                )
    }
}

struct ToggleItem_Previews: PreviewProvider {
    static var previews: some View {
        ToggleItemA()
    }
}
