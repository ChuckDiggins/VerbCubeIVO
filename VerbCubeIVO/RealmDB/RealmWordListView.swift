//
//  RealmWordListView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/7/22.
//

import SwiftUI
import RealmSwift

struct RealmWordListView: View {
    @ObservedRealmObject var wordCollection: RealmWordCollection
    @State private var name = ""
    @FocusState private var isFocused: Bool?
    
    var body: some View {
        VStack{
            HStack {
                TextField("New word", text: $name)
                    .focused($isFocused, equals: true)
                    .textFieldStyle(.roundedBorder)
                Spacer()
                Button{
                    let newWord = RealmWord(spanish: name, french: "", english: "", wordType: .verb)
                    $wordCollection.words.append(newWord)
                    name = ""
                    isFocused = nil
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(name.isEmpty)
            }
            .padding()
            List{
                ForEach(wordCollection.words){ word in
                    Text(word.spanish)
                }
                .onDelete(perform: $wordCollection.words.remove)
                .onMove(perform: $wordCollection.words.move)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .animation(.default, value: wordCollection.words)
        .navigationTitle(wordCollection.collectionName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                EditButton()
            }
            ToolbarItemGroup(placement: .keyboard){
                HStack{
                    Spacer()
                    Button{
                        isFocused = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }
}


struct RealmWordListView_Previews: PreviewProvider {
    static var previews: some View {
        RealmWordListView(wordCollection: RealmWordCollection())
    }
}
