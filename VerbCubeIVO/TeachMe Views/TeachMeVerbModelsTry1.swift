//
//  TeachMeVerbModels.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/5/22.
//

import SwiftUI

enum FeatherModel: String, Hashable, CaseIterable {
    case model = "🚗"
    case tense = "📉"
    case person = "👦🏼"
    case exercises = "🚵🏻‍♂️"
    case none = "❌"
    
    //    static var random: Self {
    //        Self.allCases.randomElement()!
    //    }
    
    static var all = [FeatherModel.model, tense, person, exercises, none]
    
    static var random: Self {
        Self.allCases.randomElement()!
    }
    
    public func getIndex()->Int{
        switch self{
        case .model: return 0
        case .tense: return 1
        case .person: return 2
        case .exercises: return 3
        case .none: return 4
        }
    }
    
    var color: Color {
        switch self {
        case .model:
            return .yellow
        case .tense:
            return .orange
        case .person:
            return .pink
        case .exercises:
            return .red
        case .none:
            return .black
        }
    }
    
    var name: String {
        switch self {
        case .model:
            return "Model"
        case .tense:
            return "Tense"
        case .person:
            return "Person"
        case .exercises:
            return "Exercises"
        case .none:
            return "None"
        }
    }
}

extension FeatherModel: Identifiable {
    var id: String { self.rawValue }
}

struct TeachMeModelView2<Link: View>: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    let model: FeatherModel
    var nextLink:  ((FeatherModel) -> Link)? = nil
    
    var body: some View {
        ZStack {
            model.color.opacity(0.2).ignoresSafeArea(.all)
            VStack {
                switch model{
                case .model:
                    List{
                        NavigationLink(destination: SelectModelView(languageViewModel: languageViewModel)){
                            VStack{
                                Text("Current model: \(languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo())")
                                Text("")
                            }
                        }

                    }
                case .tense:
                    Text("Current tense: \(languageViewModel.getCurrentVerbModel().modelVerb)")
                    NavigationLink(destination: SelectTenseView(languageViewModel: languageViewModel)){
                        Text("Select a new verb tense")
                    }
                case .person: Text("Select a person")
                case .exercises: Text("Select an exercise")
                case .none: Text("Finished")
                }
                Spacer()
                nextLink?(getNextLink())
            }
        }
        .navigationTitle("\(model.name)")
    }
    
    func getNextLink()->FeatherModel{
        let index = model.getIndex()
        var nextIndex = index + 1
        if nextIndex >= FeatherModel.all.count {
            nextIndex = 0
        }
        return FeatherModel.all[nextIndex]
    }
    
    func getPreviousLink()->FeatherModel{
        let index = model.getIndex()
        var prevIndex = index - 1
        if prevIndex < 0 { prevIndex = FeatherModel.all.count-1}
        return FeatherModel.all[prevIndex]
    }
}

struct SelectModelView: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var currentModelString = ""
    
    var body: some View {
        VStack{
            VStack{
                Text("Language: \(languageViewModel.getCurrentLanguage().rawValue)")
                Text("Feather Flow Mode: \(languageViewModel.getFeatherFlowMode().rawValue)")
            }.background(.yellow)
                .padding()

            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                HStack{
                    Text("Verb model:")
                    Text(currentModelString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
            }.task {
                setCurrentVerb()
            }
            Text("Select new model here!")
            Spacer()
        }
    }
    
    func setCurrentVerb(){
        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
    }
}

struct TeachMeVerbModels: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TeachMeVerbModels_Previews: PreviewProvider {
    static var previews: some View {
        TeachMeVerbModels()
    }
}
