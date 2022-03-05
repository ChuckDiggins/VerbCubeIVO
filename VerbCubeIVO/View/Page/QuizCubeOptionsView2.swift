//
//  QuizCubeOptionsView2.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/25/22.
//

import SwiftUI
//import Dot
import JumpLinguaHelpers

enum QuizCubeDifficulty : String {
    case easy, medium, hard, max
    static var quizCubeDifficultyAll = [QuizCubeDifficulty.easy, .medium, .hard, .max]
}

struct QuizCubeOptionsView2: View {
   
    @EnvironmentObject var languageEngine: LanguageEngine
//    @EnvironmentObject var quizCubeWatcher: QuizCubeWatcher
    
    // MARK: - Observed
//    @StateObject private var observed = Observed()
    
    // MARK: - Environments
    @Environment(\.dismiss) private var dismiss
//    @State var activeQuizCubeConfiguration = ActiveVerbCubeConfiguration.PersonTense
    @State var quizCubeVerbs = [Verb]()
    @State var quizCubeTenses = [Tense]()
    @State var configSelected = ActiveVerbCubeConfiguration.PersonTense
    @State var quizCubeVerb = Verb()
    @State var tenseToggle = [false, false, false, false, false]
    @State var quizCubeTense = Tense.present
    @State var quizCubePerson = Person.S1
    @State var quizLevel = QuizCubeDifficulty.easy
    
    var body: some View {
        ScrollView {
            QuizLevel(quizLevel: $quizLevel)
            ConfigRadioButtons(selected: self.$configSelected)
            .toggleStyle(SwitchToggleStyle(tint: Color(.purple)))
            if configSelected == .PersonTense || configSelected == .TensePerson {
                withAnimation { VerbRadioButtons(selectedVerb: $quizCubeVerb) }
            }
            if configSelected == .VerbTense || configSelected == .TenseVerb {
                PersonRadioButtons(selectedPerson: quizCubePerson)
            }
            if configSelected == .VerbPerson || configSelected == .PersonVerb {
                TenseRadioButtons(selectedTense: quizCubeTense)
            }
            Spacer()
            HStack{
                NavigationLink(destination: QuizCubeView2(languageEngine: languageEngine, qchc: QuizCubeHandlerClass(languageEngine: languageEngine))){
                    Text("Open Quiz Cube")
                }.frame(width: 200, height: 50)
                    .padding(.leading, 10)
                    .background(Color.orange)
                    .cornerRadius(10)

            }
        }.onAppear{
        }
    }
    
    func fillTenseToggles(){
        for t in quizCubeTenses {
            if t == .present { tenseToggle[0] = true }
            if t == .preterite { tenseToggle[1] = true }
            if t == .imperfect { tenseToggle[2] = true }
            if t == .future { tenseToggle[3] = true }
            if t == .conditional { tenseToggle[4] = true }
        }
    }
    func setTenses(){
        quizCubeTenses.removeAll()
        if tenseToggle[0] {quizCubeTenses.append(.present)}
        if tenseToggle[1] {quizCubeTenses.append(.preterite) }
        if tenseToggle[2] {quizCubeTenses.append(.imperfect)}
        if tenseToggle[3] {quizCubeTenses.append(.future)}
        if tenseToggle[4] {quizCubeTenses.append(.conditional)}
        if quizCubeTenses.count > 0{
            languageEngine.setQuizTenseList(list: quizCubeTenses)
        }
    }
    
    func setConfiguration(){
        languageEngine.setQuizCubeConfiguration(config: configSelected)
    }
    
    func setVerb(){
        languageEngine.setQuizCubeVerb(verb: quizCubeVerb)
    }
    
    func processUserChoices(){
        setTenses()
        setConfiguration()
        setVerb()
        switch configSelected {
        case .PersonTense, .TensePerson:
            languageEngine.setQuizCubeVerb(verb: quizCubeVerb)
        case .VerbPerson, .PersonVerb:
            languageEngine.setQuizCubeTense(tense: quizCubeTense)
        case .VerbTense, .TenseVerb:
            languageEngine.setQuizCubePerson(person: quizCubePerson)
        case .None:
            break
        }
//
    }
}

struct QuizLevel : View {
    @EnvironmentObject var languageEngine: LanguageEngine
    @Binding var quizLevel : QuizCubeDifficulty
    var quizLevelList = QuizCubeDifficulty.quizCubeDifficultyAll
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    Text("Select the difficulty for your QuizCube:")
                    HStack{
                        Text("You selected:")
                        Text("\(quizLevel.rawValue)").bold()
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(quizLevelList, id: \.self){ ql in
                    Button(action: {
                        quizLevel = ql
                        languageEngine.setQuizLevel(quizLevel: quizLevel)
                    }) {
                        Text("\(ql.rawValue)")
                            .font(.caption)
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 12, height: 12)
                            if self.quizLevel == ql {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.yellow)
        .cornerRadius(30)
    }
}

struct VerbRadioButtons : View {
    @EnvironmentObject var languageEngine: LanguageEngine
    
    @Binding var selectedVerb: Verb

    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    HStack{
                        NavigationLink(destination: VerbSelectionView()){
                            Text("Select")
                        }.frame(width: 50, height: 20)
                            .padding(.leading, 10)
                            .background(Color.orange)
                            .cornerRadius(10)
                        Text("Select one verb for your QuizCube:")
                        HStack{
                            Text("Your selection:")
                            Text("\(selectedVerb.getWordAtLanguage(language: languageEngine.getCurrentLanguage()))").bold()
                        }
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(languageEngine.getQuizVerbs(), id: \.self){ verb in
                    Button(action: {
                        selectedVerb = verb
                        languageEngine.setQuizCubeVerb(verb: verb)
                    }) {
                        Text(verb.getWordAtLanguage(language: languageEngine.getCurrentLanguage()))
                            .font(.caption)
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 12, height: 12)
                            if selectedVerb == verb {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.green)
        .cornerRadius(30)
    }
}


struct TenseRadioButtons : View {
    @EnvironmentObject var languageEngine: LanguageEngine
    @State var selectedTense : Tense
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    Text("Select one tense for your QuizCube")
                    HStack{
                        Text("Your selection:")
                        Text("\(selectedTense.rawValue)").bold()
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(languageEngine.getQuizTenseList(), id: \.self){ tense in
                    Button(action: {
                        selectedTense = tense
                        languageEngine.setQuizCubeTense(tense: tense)
                    }) {
                        Text("\(tense.rawValue)")
                            .font(.caption)
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 12, height: 12)
                            if self.selectedTense == tense {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.orange)
        .cornerRadius(30)
    }
}

struct PersonRadioButtons : View {
    @EnvironmentObject var languageEngine: LanguageEngine
    @State var selectedPerson : Person
    var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    Text("Select one person for your QuizCube:")
                    HStack{
                        Text("Your selection:")
                        Text("\(selectedPerson.getMaleString())").bold()
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(personList, id: \.self){ person in
                    Button(action: {
                        selectedPerson = person
                        languageEngine.setQuizCubePerson(person: person)
                    }) {
                        Text("\(person.getMaleString())")
                            .font(.caption)
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 12, height: 12)
                            if self.selectedPerson == person {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 12, height: 12)
                            }
                        }
                    }
                }
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.yellow)
        .cornerRadius(30)
    }
}




struct ConfigRadioButtons : View {
    @EnvironmentObject var languageEngine: LanguageEngine
    @Binding var selected : ActiveVerbCubeConfiguration
    @State var selectedConfigurationString = ActiveVerbCubeConfiguration.PersonTense.getString()
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                HStack{
                    Text("QuizCube configuration:")
                    Text("\(selectedConfigurationString)").bold()
                }.foregroundColor(.black)
                Divider()
                ForEach(ActiveVerbCubeConfiguration.configAll, id: \.self){ config in
                    
                    Button(action: {
                        selected = config
                        selectedConfigurationString = config.getString()
                        languageEngine.setQuizCubeConfiguration(config: selected)
                    }) {
                        Text(config.getString()).font(.caption)
                        //                        .font( self.selected = config ? Font.bold : Font.caption)
                        Spacer()
                        ZStack{
                            
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 12, height: 12)
                            if self.selected == config {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 12, height: 12)
                            }
                        }
                    }
                }
                
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.white)
        .cornerRadius(30)
            
    }
}


struct QuizCubeOptionsView2_Previews: PreviewProvider {
    static var previews: some View {
        QuizCubeOptionsView2()
    }
}
