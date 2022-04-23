//
//  View Extensions.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/20/22.
//

import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
