//
//  HouseView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingDetailView = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Second View"), isActive: $isShowingDetailView) {EmptyView()}
                Text("This is the home screen")
                    .navigationBarTitle("Circle menus")
                    .navigationBarItems(trailing: Button(action: {
                        self.isShowingDetailView = true
                    }) {
                        Text("push")
                    }
                    )
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
