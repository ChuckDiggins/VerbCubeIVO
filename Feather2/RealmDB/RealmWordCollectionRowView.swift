//
//  RealmWordCollectionRowView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/7/22.
//

import SwiftUI
import RealmSwift

struct RealmWordCollectionRowView: View {
    @ObservedRealmObject var wordCollection : RealmWordCollection
    @FocusState var isFocused: Bool?
    @State private var showFlagPicker = false
    var body: some View {
        HStack{
            TextField("Word group", text: $wordCollection.collectionName)
                .focused($isFocused, equals: true)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Text("\(wordCollection.words.count) words")
        }
        .padding()
        .frame(height: 30)
    }
}


struct RealmWordCollectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        RealmWordCollectionRowView(wordCollection: RealmWordCollection(name: "my list", teacher: "me"))
    }
}
