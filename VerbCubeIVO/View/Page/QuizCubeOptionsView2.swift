//
//  QuizCubeOptionsView2.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/25/22.
//

import SwiftUI
//import Dot
import JumpLinguaHelpers

struct QuizCubeOptionsView2: View {
   
    @EnvironmentObject var languageEngine: LanguageEngine
    
    // MARK: - Observed
//    @StateObject private var observed = Observed()
    
    // MARK: - Environments
    @Environment(\.dismiss) private var dismiss
    @State var activeQuizCubeConfiguration = ActiveVerbCubeConfiguration.PersonTense
    @State var quizCubeVerbs = [Verb]()
    @State var quizCubeTenses = [Tense]()
    @State var configSelected = ActiveVerbCubeConfiguration.PersonTense
    @State var tenseToggle = [false, false, false, false, false]
    
    var body: some View {
        VStack{
            ConfigRadioButtons(selected: self.$configSelected)
            //TenseToggles(tenseToggle: $tenseToggle)
            .toggleStyle(SwitchToggleStyle(tint: Color(.purple)))
            if configSelected == .PersonTense || configSelected == .TensePerson {
                withAnimation { VerbRadioButtons(verbList: languageEngine.getQuizVerbs()) }
            }
            if configSelected == .VerbTense || configSelected == .TenseVerb {
                PersonRadioButtons()
            }
            if configSelected == .VerbPerson || configSelected == .PersonVerb {
                TenseRadioButtons()
            }
            
            
            Spacer()
            Button(action: {
                setTenses()
                if languageEngine.getTenseList().count < 1 {
                    Alert(title: Text("No tenses found!"))
                } else {
                    dismiss()
                }
                    
            }){
                Text("OK").padding(.vertical).padding(.horizontal, 25).foregroundColor(.white)
            }
            .background(
                LinearGradient(gradient: .init(colors:  [Color.black.opacity(0.2), Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing) )
            .clipShape(Capsule())

        }.onAppear{
            quizCubeTenses = languageEngine.getQuizTenseList()
            fillTenseToggles()
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
}

struct TenseToggles : View {
    @Binding var tenseToggle: [Bool]
//    @Binding var presentToggle: Bool
//
    var body : some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(spacing: 4){
                Toggle(isOn: $tenseToggle[0], label: {Text("Present")})
                Toggle(isOn: $tenseToggle[1], label: {Text("Preterite")})
                Toggle(isOn: $tenseToggle[2], label: {Text("Imperfect")})
                Toggle(isOn: $tenseToggle[3],  label: {Text("Future")})
                Toggle(isOn: $tenseToggle[4],  label: {Text("Conditional")})
            }
            .padding(horizontal: 12, vertical: 6)
            //        .toggleStyle(CheckboxToggleStyle())
            .toggleStyle(CustomToggleStyle(basicSize: 40))
            .font(.caption)
        }
        .padding(.vertical)
        .padding(.horizontal,25)
        //        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15)
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(30)
    }
}

struct VerbRadioButtons : View {
    @EnvironmentObject var languageEngine: LanguageEngine
    let verbList : [Verb]
    
    @State var selected = Verb()
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    Text("Select one verb for your QuizCube:")
                    HStack{
                        Text("Your selection:")
                        Text("\(selected.getWordAtLanguage(language: languageEngine.getCurrentLanguage()))").bold()
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(verbList, id: \.self){ verb in
                    Button(action: {
                        selected = verb
                    }) {
                        Text(verb.getWordAtLanguage(language: languageEngine.getCurrentLanguage()))
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 18, height: 18)
                            if self.selected == verb {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 18, height: 18)
                            }
                        }
                    }
                }
                Divider()
                Text("Your QuizCube will test you for all persons and all tenses, but only your selected verb").multilineTextAlignment(.center)
            }
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
    @State var selectedTense = Tense.present
    
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
                    }) {
                        Text("\(tense.rawValue)")
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 18, height: 18)
                            if self.selectedTense == tense {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 18, height: 18)
                            }
                        }
                    }
                }
                Divider()
                Text("Your QuizCube will test you for all persons and all active verbs, but only your selected tense").multilineTextAlignment(.center)
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
    @State var selected = Person.S1
    var personList = [Person.S1, .S2, .S3, .P1, .P2, .P3]
    
    var body: some View {
        ZStack{
            Image("white cube").frame(width: 100, height:100).opacity(0.3)
            VStack(alignment: .leading, spacing: 2){
                VStack{
                    Text("Select one person for your QuizCube:")
                    HStack{
                        Text("Your selection:")
                        Text("\(selected.getMaleString())").bold()
                    }
                }.foregroundColor(.black)
                Divider()
                ForEach(personList, id: \.self){ person in
                    Button(action: {
                        selected = person
                    }) {
                        Text("\(person.getMaleString())")
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 18, height: 18)
                            if self.selected == person {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 18, height: 18)
                            }
                        }
                    }
                }
                Divider()
                Text("Your QuizCube will test you for all tenses and all active verbs, but only your selected person").multilineTextAlignment(.center)
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
                    }) {
                        Text(config.getString())
                        //                        .font( self.selected = config ? Font.bold : Font.caption)
                        Spacer()
                        ZStack{
                            
                            Circle().fill(Color.red.opacity(0.5)).frame(width: 18, height: 18)
                            if self.selected == config {
                                Circle().fill(Color.blue.opacity(0.5)).frame(width: 18, height: 18)
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
