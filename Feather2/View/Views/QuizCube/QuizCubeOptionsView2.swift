//
//  QuizCubeOptionsView2.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/25/22.
//

import SwiftUI
import JumpLinguaHelpers

enum QuizCubeDifficulty : String {
    case easy, medium, hard, max
    static var quizCubeDifficultyAll = [QuizCubeDifficulty.easy, .medium, .hard, .max]
}

struct QuizCubeOptionsView2: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    
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
    @State var alertToggle = false
    @State var isQuizCubeActive = false
    @State var selectedTab: Int = 0
    @State var configurationChoiceString = ""
    var body: some View {
        VStack{
            Text("Current settings:")
            Text("Configuration = \(configSelected.getString())")
            Text(configurationChoiceString)
            Text("Quiz difficulty level = \(quizLevel.rawValue)")
            if alertToggle {
                Text("Quiz interaction type = Use alerts")}
            else {
                Text("Quiz interaction type = Use text editor")}
            Text("Active verb count: \(languageViewModel.getFilteredVerbs().count)")
        }
        NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .pattern)){
            Text("Verbs of a Feather")
        }.frame(width: 150, height: 50)
            .padding(.leading, 10)
            .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
            .cornerRadius(10)
            .foregroundColor(.yellow)

        TabView (selection: $selectedTab) {
            ConfigView(languageViewModel: languageViewModel, configSelected: $configSelected,
                       quizCubeVerb: $quizCubeVerb, quizCubeTense: $quizCubeTense, quizCubePerson: $quizCubePerson, configurationChoiceString: $configurationChoiceString)
                .tabItem{
                    Image(systemName: "doc.text.fill")
                    Text("Config")
                }.tag(0)
            QuizLevelView(languageViewModel: languageViewModel, quizLevel: $quizLevel)
                .tabItem{
                    Image(systemName: "flag.fill")
                    Text("QuizLevel")
                }.tag(2)
            AlertToggleView(alertToggle: $alertToggle)
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Alert")
                }.tag(1)
            
            
        }
        HStack{
            NavigationLink(destination: QuizCubeView2(languageViewModel: languageViewModel, qchc: QuizCubeHandlerClass(languageViewModel: languageViewModel), useCellAlert: alertToggle ), isActive: $isQuizCubeActive){
                Text("Open Quiz Cube")
            }.frame(width: 200, height: 50)
                .padding(.leading, 10)
                .background(Color.orange)
                .cornerRadius(10)

        }
        Spacer()
        
    }
    struct ConfigView : View {
        @ObservedObject var languageViewModel: LanguageViewModel
        @Binding var configSelected : ActiveVerbCubeConfiguration
        @Binding var quizCubeVerb : Verb
        @Binding var quizCubeTense : Tense
        @Binding var quizCubePerson : Person
        @Binding var configurationChoiceString: String
        
        var body: some View {
            VStack{
                
                ConfigRadioButtons(languageViewModel: languageViewModel, selected: self.$configSelected)
                    .toggleStyle(SwitchToggleStyle(tint: Color(.purple)))
                if configSelected == .PersonTense || configSelected == .TensePerson {
                    withAnimation { VerbRadioButtons(languageViewModel: languageViewModel, selectedVerb: $quizCubeVerb, configurationChoiceString: $configurationChoiceString) }
                }
                if configSelected == .VerbTense || configSelected == .TenseVerb {
                    PersonRadioButtons(languageViewModel: languageViewModel, selectedPerson: quizCubePerson, configurationChoiceString: $configurationChoiceString)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: 1.0
                        )
                }
                if configSelected == .VerbPerson || configSelected == .PersonVerb {
                    TenseRadioButtons(languageViewModel: languageViewModel, selectedTense: quizCubeTense, configurationChoiceString: $configurationChoiceString)
                }
            }
        }
    }
    
    struct AlertToggleView : View {
        @Binding var alertToggle : Bool
        var body: some View {
            HStack{
                Toggle(isOn: $alertToggle){  Text("Quiz mode").padding(5).background(Color.purple)  }
                Text("Mode:")
                Text(alertToggle ? "Use alerts" : "Use text edit").background(Color.purple).padding()
                Spacer()
            }
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
            languageViewModel.setQuizTenseList(list: quizCubeTenses)
        }
    }
    
    func setConfiguration(){
        languageViewModel.setQuizCubeConfiguration(config: configSelected)
    }
    
    func setVerb(){
        languageViewModel.setQuizCubeVerb(verb: quizCubeVerb)
    }
    
    func processUserChoices(){
        setTenses()
        setConfiguration()
        setVerb()
        switch configSelected {
        case .PersonTense, .TensePerson:
            languageViewModel.setQuizCubeVerb(verb: quizCubeVerb)
        case .VerbPerson, .PersonVerb:
            languageViewModel.setQuizCubeTense(tense: quizCubeTense)
        case .VerbTense, .TenseVerb:
            languageViewModel.setQuizCubePerson(person: quizCubePerson)
        case .None:
            break
        }
//
    }
}

struct QuizLevelView : View {
//    @EnvironmentObject var languageEngine: LanguageEngine
    @ObservedObject  var languageViewModel: LanguageViewModel
    
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
                        languageViewModel.setQuizLevel(quizLevel: quizLevel)
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
    
//    @EnvironmentObject var languageEngine: LanguageEngine
    @ObservedObject  var languageViewModel: LanguageViewModel
    @Binding var selectedVerb: Verb
    @Binding var configurationChoiceString: String

    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            
//            VStack(alignment: .leading, spacing: 2){
                ScrollView(){
                    ForEach(languageViewModel.getFilteredVerbs(), id: \.self){ verb in
                        Button(action: {
                            selectedVerb = verb
                            languageViewModel.setQuizCubeVerb(verb: verb)
                            createSelectedConfiguationString()
                        }) {
                            Text(verb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))
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
//        }
        .onAppear{
            selectedVerb = languageViewModel.getVerbCubeVerb(index: 0)
            createSelectedConfiguationString()
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.green)
        .cornerRadius(30)
    }
    
    func createSelectedConfiguationString(){
        configurationChoiceString = "SelectedVerb: \(selectedVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage()))"
    }
}


struct TenseRadioButtons : View {
    @ObservedObject   var languageViewModel: LanguageViewModel
    @State var selectedTense : Tense
    @Binding var configurationChoiceString: String
    
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
                ForEach(languageViewModel.getQuizTenseList(), id: \.self){ tense in
                    Button(action: {
                        selectedTense = tense
                        languageViewModel.setQuizCubeTense(tense: tense)
                        configurationChoiceString = "Selected tense: \(selectedTense.rawValue)"
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
            }.onAppear{
                selectedTense = languageViewModel.getQuizCubeTense()
                createSelectedConfiguationString()
            }
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.orange)
        .cornerRadius(30)
    }
    func createSelectedConfiguationString(){
        configurationChoiceString = "SelectedTense: \(selectedTense.rawValue)"
    }
}

struct PersonRadioButtons : View {
//    @EnvironmentObject var languageEngine: LanguageEngine
    @ObservedObject  var languageViewModel: LanguageViewModel
    @State var selectedPerson : Person
    @Binding var configurationChoiceString: String
    
    var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    Text("Select one person for your QuizCube:")
                    HStack{
                        Text("Your selection:")
                        Text("\(selectedPerson.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3))").bold()
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(personList, id: \.self){ person in
                    Button(action: {
                        selectedPerson = person
                        languageViewModel.setQuizCubePerson(person: person)
                        createSelectedConfiguationString()
                    }) {
                        Text("\(person.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3))")
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
            }.onAppear{
                selectedPerson = languageViewModel.getQuizCubePerson()
                createSelectedConfiguationString()
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal,25)
//        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.yellow)
        .cornerRadius(30)
    }
    
    func createSelectedConfiguationString(){
        configurationChoiceString = "SelectedPerson: \(selectedPerson.getSubjectString(language: languageViewModel.getCurrentLanguage(), gender : languageViewModel.getSubjectGender(), verbStartsWithVowel: false, useUstedForm: languageViewModel.useUstedForS3))"
    }

}



struct ConfigRadioButtons : View {
//    @EnvironmentObject var languageEngine: LanguageEngine
    @ObservedObject  var languageViewModel: LanguageViewModel
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
                        languageViewModel.setQuizCubeConfiguration(config: selected)
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


