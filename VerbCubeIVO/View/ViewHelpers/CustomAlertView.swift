//
//  CustomAlertView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/23/22.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var show : Bool
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack(spacing: 25){
//                Image("Feather")
                Text("Congratulations!")
                    .font(.title)
                    .foregroundColor(.pink)
                    .padding()
                Button{
                    withAnimation{show.toggle()}
                } label: {
                    Text("Next problem")
                        .padding()
                }
            }
        }
        .frame(width: 200, height: 100)
        .background(.black)
        .foregroundColor(.white)
    }
}

//struct CustomAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomAlertView(show: true)
//    }
//}
