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
                Text("Congratulations!")

                Button{
                    withAnimation{show.toggle()}
                } label: {
                    VStack{
                        Text("Next problem")
                    }.padding()
                }
            } .frame(minWidth: 0, maxWidth: 350)
                .frame(height: 200)
                .foregroundColor(.white)
                .padding(.horizontal)
                .font(.headline)
                .background(.blue)
                .cornerRadius(10)
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
