//
//  WordCollectionListView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/7/22.
//

import SwiftUI
import RealmSwift

struct WordCollectionListView: View {
    @ObservedResults(RealmWordCollection.self) var wordCollections
    @FocusState private var isFocused: Bool?
    @State var presentAlert = false
    
    var body: some View {
        NavigationView{
            VStack{
                if wordCollections.isEmpty {
                    Text("Tap on the \(Image(systemName: "plus.circle.fill")) button above to create a new word collection.")
                } else {
                    List {
                        ForEach(wordCollections.sorted(byKeyPath: "collectionName")){ wc in
                            NavigationLink{
                                RealmWordListView(wordCollection: wc)
                            } label: {
                                RealmWordCollectionRowView(wordCollection: wc, isFocused: _isFocused)
                            }
                        }
                        .onDelete(perform: deleteWordCollection)
//                        .onMove(perform: $countries.move)
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                }
                Spacer()
            }
            .animation(.default, value: wordCollections)
            .navigationTitle("Word Collections")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        $wordCollections.append(RealmWordCollection())
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
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
        .alert("You must remove all the words in this word list", isPresented: $presentAlert, actions: {})
    }
    func deleteWordCollection(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        let selectedWordCollection = Array(wordCollections.sorted(byKeyPath: "collectionName"))[index]
        guard selectedWordCollection.words.isEmpty else {
            presentAlert.toggle()
            return
        }
        $wordCollections.remove(selectedWordCollection)
    }
}

struct WordCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        WordCollectionListView()
    }
}
