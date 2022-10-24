//
//  CollectionView.swift
//  CollectionView
//
//  Created by Charles Diggins on 1/29/22.
//

import SwiftUI
import JumpLinguaHelpers

struct CollectionView: View {
    @EnvironmentObject var cfModelView : CFModelView
    @State private var collectionManager = dWordCollectionManager()
    @State private var collectionList = [dWordCollection]()
    @State private var collectionNameList = [String]()
    @State private var currentCollection = dWordCollection()
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header:
                        HStack{
                            Text("Collections")
                            Image(systemName: "flame.fill")
                        }.font(.headline)
                        .foregroundColor(.orange)
                ){
                    ForEach(0..<collectionList.count) { i in
                        NavigationLink(destination:ShowCurrentCollectionContents(currentCollection: collectionList[i])){
                                Text(collectionNameList[i]).bold()
                        }.frame(height: 50)
                            .padding(5)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                    .listRowBackground(Color.yellow)
                }

            }
            .onAppear{
                collectionManager = cfModelView.getWordCollectionManager()
                fillCollectionList()
            }
            
            .listStyle(GroupedListStyle())
            .navigationTitle("Collection List")
            .navigationBarItems(
                leading: EditButton(),
                trailing: addButton)
            
        }.accentColor(.red)
    }
    
    struct ShowCurrentCollectionContents: View{
        @EnvironmentObject var cfModelView : CFModelView
        var currentCollection : dWordCollection
        @State private var wordType = WordType.adjective
        @State var m_words = Array<Word>()
        @State private var currentWordType = "Adjective"
        @State private var currentWordTypeCount = 0
        
        var gridItems = [GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible())]
        var wordTypeItems = [GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible())]
        var body: some View {
            VStack{
                Text("Word collection: \(currentCollection.collectionName)")
                HStack{
                    Text(currentWordType)
                    Text("Count: \(currentWordTypeCount)")
                }
                LazyVGrid(columns: wordTypeItems, spacing: 5){
                    WordTypeButton(wordText: "Adjective", backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                                   wordType: .adjective, function: getWordList )
                    WordTypeButton(wordText: "Adverb", backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                                   wordType: .adverb, function: getWordList )
                    WordTypeButton(wordText: "Conjunction", backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                                   wordType: .conjunction, function: getWordList )
                    WordTypeButton(wordText: "Noun", backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                                   wordType: .noun, function: getWordList )
                    WordTypeButton(wordText: "Preposition", backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                                   wordType: .preposition, function: getWordList )
                    WordTypeButton(wordText: "Verb", backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                                   wordType: .verb, function: getWordList )
                }
            }
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach ((0..<m_words.count), id: \.self){ index in
                        WordCellButton(wordText: m_words[index].spanish, backgroundColor: .yellow, foregroundColor: .black, fontSize: Font.subheadline/*, function: selectWord*/)
                    }
                }
            }
            Spacer()
        }
        
        func getWordList(wordType: WordType){
            m_words = currentCollection.getWords(wordType: wordType)
            setCurrentWordType(wordType: wordType)
        }
        
        func setCurrentWordType(wordType: WordType){
            currentWordType = "List:  " + wordType.rawValue + "s"
            currentWordTypeCount = m_words.count
        }
        
    }
    
    
    func fillCollectionList(){
        collectionList.removeAll()
        for collection in collectionManager.getCollectionList(){
            collectionList.append(collection)
            collectionNameList.append(collection.collectionName)
        }
    }
    func delete(indexSet: IndexSet){
//        fruits.remove(atOffsets: indexSet)
    }
    
    func move(indices: IndexSet,  newOffset: Int){
//        fruits.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    var addButton: some View {
        Button("Add Collection", action: {
            add()
        })
    }
    
    func add(){
        var wordList = [Word]()
        let wordType = WordType.conjunction
        wordList = cfModelView.getAgnosticWordList(wordType: wordType)
        let collection = dWordCollection(idNum: 3, collectionName: "Quick add as test", wordList: wordList )
        collectionManager.append(collection: collection)
        
    }

}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}

