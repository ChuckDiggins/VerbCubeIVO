//
//  CustomActionSheet.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/3/22.
//

import SwiftUI

struct CustomActionSheet: View {
    @State var show1 = false
    var body: some View {
        VStack(spacing: 15){
            Toggle(isOn: self.$show1){
                Text("notifications")
            }
        }
        .background(Color.green)
        .padding(.horizontal)
            .padding(.top, 20)
            .cornerRadius(25)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomActionSheet()
    }
}
