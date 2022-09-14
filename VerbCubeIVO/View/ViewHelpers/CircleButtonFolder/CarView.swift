//
//  CarView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

struct CarView: View {
    var body: some View {
        ZStack{
            Color(.blue)
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "car.fill").font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}


struct CarView_Previews: PreviewProvider {
    static var previews: some View {
        CarView()
    }
}
