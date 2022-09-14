//
//  TeachMeVerbPatterns.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 8/5/22.
//

import SwiftUI

enum FeatherPattern: String, Hashable, CaseIterable {
    case pattern = "Select a verb pattern"
    case tense = "Select the tense you want to work on"
    case person = "Select male or female subject pronouns"
    case exercises = "Choose an verb pattern exercise"
    case none = "Exit the Flow"
    
    //    static var random: Self {
    //        Self.allCases.randomElement()!
    //    }
    
    static var all = [pattern, tense, person, exercises, none]
    
    public func getIndex()->Int{
        switch self{
        case .pattern: return 0
        case .tense: return 1
        case .person: return 2
        case .exercises: return 3
        case .none: return 4
        }
    }
    
    var color: Color {
        switch self {
        case .pattern:
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
        case .pattern:
            return "Pattern"
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

extension FeatherPattern: Identifiable {
    var id: String { self.rawValue }
}

struct TeachMePatternView<Link: View>: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    let pattern: FeatherPattern
    @State var currentPatternString = ""
    
    var nextLink:  ((FeatherPattern) -> Link)? = nil
    
    var body: some View {
        ZStack {
            pattern.color.opacity(0.2).ignoresSafeArea(.all)
            VStack {
                switch pattern{
                case .pattern:
                    NavigationLink(destination: SelectPatternView(languageViewModel: languageViewModel)){
                        Text("Select verb pattern")
                    }
                case .tense: Text("Select a tense")
                case .person: Text("Select a person")
                case .exercises: Text("Select an exercise")
                case .none: Text("Finished")
                }
                Spacer()
                nextLink?(getNextLink())
            }
        }
        .navigationTitle("\(pattern.name)")
    }
    
    func getNextLink()->FeatherPattern{
        let index = pattern.getIndex()
        var nextIndex = index + 1
        if nextIndex >= FeatherPattern.all.count {
            nextIndex = 0
        }
        return FeatherPattern.all[nextIndex]
    }
    
    func getPreviousLink()->FeatherPattern{
        let index = pattern.getIndex()
        var prevIndex = index - 1
        if prevIndex < 0 { prevIndex = FeatherPattern.all.count-1}
        return FeatherPattern.all[prevIndex]
    }
    
    func setCurrentVerb(){
        currentPatternString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
    }
}

struct SelectPatternView: View{
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            Text("Holder:  Select pattern here!")
        }
    }
}


struct TeachMeVerbPatterns: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TeachMeVerbPatterns_Previews: PreviewProvider {
    static var previews: some View {
        TeachMeVerbPatterns()
    }
}
