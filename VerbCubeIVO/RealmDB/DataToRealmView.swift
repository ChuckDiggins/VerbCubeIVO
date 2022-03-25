//
//  DataToRealmView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/21/22.
//

import SwiftUI
import RealmSwift

enum DataToRealmMode : String {
    case wordCollections
    case bundles
    case phrases
    case verbs
    case nouns
    case adjectives
}


struct DataToRealmView: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    
    let dataToRealmList = [
        DataToRealmMode.wordCollections,
        DataToRealmMode.bundles,
        DataToRealmMode.phrases,
        DataToRealmMode.verbs,
    ]
    
    var body: some View {
//        NavigationView {
            VStack{
                List(){
                    ForEach(dataToRealmList, id: \.self) { dr in
                        Button(action: {
                            convertToRealm(mode: dr)
                        }){
                            HStack{
                                Text("Mode: ")
                                Text(dr.rawValue)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }.listStyle(.plain)
            }.navigationTitle("Data to Realm Mode")
            .onAppear{
                createWordCollection()
//                retrieveWordCollections()
            }
//        }
    }
    
    func convertToRealm(mode: DataToRealmMode){
        print("converting \(mode.rawValue) to Realm")
    }
    
    func retrieveWordCollection(){
        let realm = languageViewModel.getRealm()
        // Get all contacts in Los Angeles, sorted by street address
        let realmWordCollection = realm.objects(RealmWordCollection.self)
            .where {
                $0.collectionName == "SomeVerbPhrases"
            }
            .sorted(byKeyPath: "word.spanish")
        print("Word Collection words: \(realmWordCollection)")
    }
    
    func retrieveNamedWordCollection(wcName: String){
        let realm = languageViewModel.getRealm()
        // Get all contacts in Los Angeles, sorted by street address
        let realmWordCollection = realm.objects(RealmWordCollection.self)
            .where {
                $0.collectionName == wcName
            }
            .sorted(byKeyPath: "word.spanish")
        print("Word Collection words: \(realmWordCollection)")
    }
    
    func createWordCollection(){
        let realm = languageViewModel.getRealm()
        
        try! realm.write {
            let wcList = languageViewModel.getWordCollections()
            
            for wc in wcList {
                let rwc = RealmWordCollection(name: wc.collectionName, teacher: "")
                for i in 0..<wc.getWordCount() {
                    let w = wc.getWord(index: i)
                    rwc.appendRealmWord(rw: RealmWord(spanish: w.spanish, french: w.french, english: w.english, wordType: .verb))
                }
//                let words = rwc.getWords()
                print("\nword collection: \(rwc.collectionName) created")
//                for w in words {
//                    print("Word \(w.spanish), \(w.french), \(w.french), wordType: \(w.wordType.rawValue)")
//                }
                let realmWordCollection = realm.objects(RealmWordCollection.self)
                    .where {
                        $0.collectionName == rwc.collectionName
                    }
                    .sorted(byKeyPath: "word.spanish")
                print("Word Collection words: \(realmWordCollection)")
            }
            
            
        }
    }
    
    func createWordCollection2(){
        let realm = try! Realm()
        try! realm.write {
            let word = RealmWord()
            word.spanish = "estar"
            word.english = "be"
            word.french = "avoir"
            word.wordType = word.getWordType(wordTypeString: "verb")
            let collection = RealmWordCollection(name: "first wc", teacher: "Morton", word: word)
            let word2 = RealmWord()
            word2.spanish = "tener"
            word2.english = "have"
            word2.french = "tendre"
            word2.wordType = word.getWordType(wordTypeString: "verb")
            collection.appendRealmWord(rw: word2)
            let words = collection.getWords()
            for w in words {
                print("Word \(w.spanish), \(w.french), \(w.french), wordType: \(w.wordType.text)")
            }
        }
    }

}


struct DataToRealmView_Previews: PreviewProvider {
    static var previews: some View {
        DataToRealmView()
    }
}
