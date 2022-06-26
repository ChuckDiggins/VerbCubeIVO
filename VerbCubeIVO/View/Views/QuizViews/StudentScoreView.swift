//
//  StudentScoreView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/27/22.
//

import SwiftUI
import JumpLinguaHelpers

struct StudentScoreView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var studentScoreModel : StudentScoreModel
    @State private var verbScoreList = [VerbScore]()
    @State private var tenseScoreList = [TenseScore]()
    @State private var personScoreList = [PersonScore]()
    @State private var modelScoreList = [ModelScore]()
    @State private var patternScoreList = [PatternScore]()
    @State private var currentScoreType = StudentScoreEnum.verb
    
    var body: some View {
        VStack{
            Button{
                switch currentScoreType{
                case .verb: currentScoreType = .tense
                case .tense: currentScoreType = .person
                case .person: currentScoreType = .verb
                    
                case .model: currentScoreType = .tense
                case .pattern: currentScoreType = .tense
                }
            } label: {
                Text(currentScoreType.rawValue)
                    .frame(width: 150, height: 50)
                    .padding(.leading, 10)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                    .foregroundColor(.yellow)
                
            }
            
            switch currentScoreType {
            case .verb: VerbScoreView(languageViewModel: languageViewModel, verbScoreList: verbScoreList)
            case .tense: TenseScoreView(languageViewModel: languageViewModel, tenseScoreList: tenseScoreList)
            case .person: PersonScoreView(languageViewModel: languageViewModel, personScoreList: personScoreList)
            case .model: ModelScoreView(languageViewModel: languageViewModel, modelScoreList: modelScoreList)
            case .pattern: PatternScoreView(languageViewModel: languageViewModel, patternScoreList: patternScoreList)
            }
            Spacer()
            
        }.onAppear{
            verbScoreList = studentScoreModel.getScores(studentScoreEnum: .verb) as! [VerbScore]
            tenseScoreList = studentScoreModel.getScores(studentScoreEnum: .tense) as! [TenseScore]
            personScoreList = studentScoreModel.getScores(studentScoreEnum: .person) as! [PersonScore]
        }
        
    }
}

struct StudentScoreView_Previews: PreviewProvider {
    static var previews: some View {
        StudentScoreView(languageViewModel: LanguageViewModel(language: .Spanish), studentScoreModel: StudentScoreModel())
    }
}

struct VerbScoreView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var verbScoreList : [VerbScore]
    var body: some View {
        VStack{
            List{
                Section(
                    header:
                        HStack{
                            Text("Verbs")
                        }.font(.headline)
                        .foregroundColor(.black)
                ){
                    ForEach(0 ..< verbScoreList.count, id: \.self){ index in
                        HStack{
                            Text("\(verbScoreList[index].value.getWordAtLanguage(language: languageViewModel.currentLanguage))")
                            Spacer()
                            Text("correct = \(verbScoreList[index].correctScore)")
                            Text("wrong = \(verbScoreList[index].wrongScore)")
                        }.foregroundColor(.black)
                            .font(.caption)
                    }.listRowBackground(Color.yellow)
                }
            }
            .environment(\.defaultMinListRowHeight, 12)
        }
    }
}

struct TenseScoreView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var tenseScoreList : [TenseScore]
    var body: some View {
        VStack{
            List{
                Section(
                    header:
                        HStack{
                            Text("Tenses")
                        }.font(.headline)
                        .foregroundColor(.black)
                ){
                    ForEach(0 ..< tenseScoreList.count, id: \.self){ index in
                        HStack{
                            Text("\(tenseScoreList[index].value.rawValue)")
                            Spacer()
                            Text("correct = \(tenseScoreList[index].correctScore)")
                            Text("wrong = \(tenseScoreList[index].wrongScore)")
                        }.foregroundColor(.black)
                            .font(.caption)
                    }.listRowBackground(Color.orange)
                }
            }
            .environment(\.defaultMinListRowHeight, 12)
        }
    }
}

struct PersonScoreView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var personScoreList : [PersonScore]
    var body: some View {
        VStack{
            List{
                Section(
                    header:
                        HStack{
                            Text("Persons")
                        }.font(.headline)
                        .foregroundColor(.black)
                ){
                    ForEach(0 ..< personScoreList.count, id: \.self){ index in
                        HStack{
                            Text("\(personScoreList[index].value.getMaleString())")
                            Spacer()
                            Text("correct = \(personScoreList[index].correctScore)")
                            Text("wrong = \(personScoreList[index].wrongScore)")
                        }.foregroundColor(.black)
                            .font(.caption)
                    }.listRowBackground(Color.pink)
                }
            }
            .environment(\.defaultMinListRowHeight, 12)  
        }
    }
}

struct ModelScoreView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var modelScoreList : [ModelScore]
    var body: some View {
        VStack{
            Text("Models")
        }
    }
}

struct PatternScoreView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var patternScoreList : [PatternScore]
    var body: some View {
        VStack{
            Text("Patterns")
        }
    }
}
