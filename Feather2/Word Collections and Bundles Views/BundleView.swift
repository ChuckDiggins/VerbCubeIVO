//
//  BundleView.swift
//  BundleView
//
//  Created by Charles Diggins on 1/29/22.
//

import SwiftUI
import JumpLinguaHelpers

struct BundleView: View {
    @EnvironmentObject var cfModelView : CFModelView
    @State private var bundleManager = dBundleManager()
    @State private var bundleList = [dBundle]()
    @State private var bundleNameList = [String]()
    @State private var bundleTeacherList = [String]()
    @State private var currentBundle = dBundle()

    var body: some View {
        NavigationView {
            List {
                Section(
                    header:
                        HStack{
                            Text("Bundles")
                            Image(systemName: "flame.fill")
                        }.font(.headline)
                        .foregroundColor(.orange)
                ){
                    ForEach(0..<bundleList.count) { i in
                        NavigationLink(destination:ShowCurrentBundleContents(currentBundle: bundleList[i])){
                                Text(bundleNameList[i]).bold()
                        }.frame(height: 50)
                            .padding(5)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                    .listRowBackground(Color.yellow)
                }
////                Section(header: Text("veggies")){
////                    ForEach(veggies, id:\.self) { veggie in
////                        Text(veggie.capitalized)
////                            .font(.subheadline)
////                            .foregroundColor(.white)
////                            .frame(maxWidth: .infinity, maxHeight: .infinity)
////                            .background(Color.red)
////                    }
////                }
            }
            .onAppear{
                bundleManager = cfModelView.getBundleManager()
                fillBundleList()
            }

            .listStyle(GroupedListStyle())
            .navigationTitle("Bundle List")
            .navigationBarItems(
                leading: EditButton(),
                trailing: addButton)

        }.accentColor(.red)
    }

    struct ShowCurrentBundleContents: View{
        var currentBundle : dBundle
////        @State var tenseStringList = [String]()
////        @State var collectionStringList = [String]()
////        @State var phraseStringList = [String]()

        var body: some View {
            VStack{
                Text("bundle: \(currentBundle.getBundleName())")
                Text("teacher: \(currentBundle.getTeacher())")
                Text("Tense count: \(currentBundle.getTenseList().count)")
                Text("Word collection count: \(currentBundle.getCollectionCount())")
                Text("Phrase count: \(currentBundle.getPhraseList().count)")
            }
            VStack{
                VStack{
                    Text("Tenses:").bold()
                    ForEach (0..<currentBundle.getTenseList().count){ i in
                        Text(currentBundle.getTense(index: i).rawValue)
                    }
                }.background(Color.red.opacity(0.3))
                    .padding()
                VStack{
                    Text("Word collections:").bold()
                    ForEach (0..<currentBundle.getCollectionCount()){ i in
                        Text(currentBundle.getWordCollection(index: i).collectionName)
                    }
                }.background(Color.green.opacity(0.3))
                    .padding()

                VStack{
                    Text("Phrase collections:").bold()
                    ForEach (0..<currentBundle.getPhraseCount()){ i in
                        Text(currentBundle.getPhrase(index: i).getClusterName())
                    }
                }.background(Color.blue.opacity(0.3))
                    .padding()
            }

            Spacer()
        }
    }

    func fillBundleList(){
        bundleList.removeAll()
        for bundle in bundleManager.m_bundleList{
            bundleList.append(bundle)
            bundleNameList.append(bundle.getBundleName())
            bundleTeacherList.append(bundle.getTeacher())
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

struct BundleView_Previews: PreviewProvider {
    static var previews: some View {
        BundleView()
    }
}
