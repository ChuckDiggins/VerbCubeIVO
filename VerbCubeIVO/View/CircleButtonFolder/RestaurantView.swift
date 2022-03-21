//
//  RestaurantView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//

import SwiftUI

struct RestaurantView: View {
    var body: some View {
        let first = Restaurant(name: "Joe's")
        let second = Restaurant(name: "Mary's")
        let third = Restaurant(name: "Murphy's")
        let restaurants = [first, second, third]
        
        NavigationView {
            List(restaurants) { restaurant in
                RestaurantRow(restaurant:restaurant).padding()
            }
            .navigationBarTitle("Restaurants")
        }
        
    }
}

struct Restaurant: Identifiable{
    var id = UUID()
    var name: String
}


struct RestaurantRow : View {
    var restaurant: Restaurant
    var body: some View {
        HStack{
            Text("Come and eat at ")
            Text(restaurant.name)
        }
        
    }
    
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView()
    }
}
