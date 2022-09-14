//
//  PhraseView.swift
//  PhraseView
//
//  Created by Charles Diggins on 1/30/22.
//

import SwiftUI
import JumpLinguaHelpers

struct PhraseView: View {
    @EnvironmentObject var cfModelView : CFModelView
    @State private var phraseManager = dPhraseManager()
    @State private var phraseList = [dCluster]()
    @State private var phraseNameList = [String]()
    @State private var currentPhrase = dCluster()
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header:
                        HStack{
                            Text("Phrases")
                            Image(systemName: "flame.fill")
                        }.font(.headline)
                        .foregroundColor(.orange)
                ){
                    ForEach(0..<phraseList.count) { i in
                        NavigationLink(destination:ShowCurrentPhraseContents(currentPhrase: phraseList[i])){
                                Text(phraseNameList[i]).bold()
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
                phraseManager = cfModelView.getPhraseManager()
                fillPhraseList()
            }
            
            .listStyle(GroupedListStyle())
            .navigationTitle("Named Phrase List")
            .navigationBarItems(
                leading: EditButton(),
                trailing: addButton)
            
        }.accentColor(.red)
    }
    
    struct ShowCurrentPhraseContents: View{
        var currentPhrase : dCluster
        
        var body: some View {
            VStack{
                Text("Phrase collection: \(currentPhrase.getClusterName())")
            }
                VStack{
                    ForEach (0..<currentPhrase.getClusterCount()){ i in
                        Text(currentPhrase.getCluster(index:i).getClusterType().rawValue)
                    }
                }.background(Color.red.opacity(0.3))
                    .padding()
            Spacer()
        }
    }
    
    func fillPhraseList(){
        phraseList.removeAll()
        
        for phrase in phraseManager.getClusterList(){
            phraseList.append(phrase)
            phraseNameList.append(phrase.getClusterName())
        }
    }
    
    func delete(indexSet: IndexSet){
        //        fruits.remove(atOffsets: indexSet)
    }
    
    func move(indices: IndexSet,  newOffset: Int){
        //        fruits.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    var addButton: some View {
        Button("Add Bundle", action: {add()})
    }
    
    func add(){
        //        fruits.append("Coconut")
    }
}

struct PhraseView_Previews: PreviewProvider {
    static var previews: some View {
        PhraseView()
    }
}
