//
//  AudibleStyleView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 6/21/22.
//

import SwiftUI
import JumpLinguaHelpers

enum LessonType : String {
    case MBVC = "MBVC"
    case PBVC = "PBVC"
    case GNRL = "GNRL"
    case ODDS = "ODDS"
}

enum SpecialVerbType : String{
    case verbsLikeGustar = "Verbs like Gustar"  //paracer, quedar
    case weatherAndTime = "Weather and Time Verbs"
    case ThirdPersonOnly = "3rd Person Only Verbs"
    case auxiliaryVerbsInfinitives = "Auxiliary Verbs - infinitives"
    case auxiliaryVerbsGerunds = "Auxiliary Verbs - gerunds"
    case defective = "Defective"
    case normal = "Normal"
}

enum LessonNameEnum : String {
    case findModelForUserVerb = "Find Model for User Verb"
    case modelsOfAFeather  = "Models of a Feather"
    case modelsForPattern  = "Find Models for a Pattern"
    case verbsInModel = "Find Verbs in Model"
    case modelForGivenVerb  = "Find Model for Given Verb"
    case verbsWithVerbsModel = "Find Verb with Verb's Model"
    
    case verbsForGivenPattern = "Finds Verbs for a Given Pattern"
    case verbsWithVerbsPattern = "Find Verbs with Verb's Pattern"
    
    case verbCube = "Verb Cube"
    case rightAndWrong = "Conjugate Right and Wrong"
    case unconjugate = "Unconjugate"
    case mixAndMatch = "Mix & Match"
    case analyzeAnyVerb = "Analyze Any Verb"
    case verbMorph = "Verb Morph"
    
    case wordCollections = "Word Collections"
    case verbsLikeGustar = "Verbs like Gustar"
    case weatherAndTime = "Weather and Time Verbs"
    case ThirdPersonOnly = "3rd Person Only Verbs"
    case auxiliaryVerbs = "Auxiliary Verbs"
}



struct LessonTypeButton: View {
    var lessonText : String
    var backgroundColor: Color
    var foregroundColor: Color
    var fontSize : Font
    var lessonType : LessonType
    var function: (_ lessonType: LessonType) -> Void
    
    var body: some View {
        Button(action: {
            self.function(lessonType)
        }){
            Text(lessonType.rawValue)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
        .font(fontSize)
        
    }
}

struct LessonButton: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var lessonName : LessonNameEnum
    var backgroundColor: Color
    var foregroundColor: Color
    var fontSize : Font
    var function: (_ lessonName: LessonNameEnum) -> Void
    @State private var showingSheet = false
    
    var body: some View {
        Button(lessonName.rawValue){
            showingSheet.toggle()
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
        .font(fontSize)
//        .sheet(isPresented: $showingSheet){
//            switch lessonName {
//            case .findModelForUserVerb:
//                AgnosticWordView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern, word: "hello")
//
//            case .modelsOfAFeather:
//                AgnosticWordView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern, word: "hello")
//            default:
//                AgnosticWordView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern, word: "hello")
//            }
//        }
    }
}

struct AgnosticWordView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var multipleChoiceMode: MultipleChoiceMode
    @Environment(\.presentationMode) var presentationMode
    var word: String
    
    var body: some View {
        Button("Press to Dismiss"){
            presentationMode.wrappedValue.dismiss()
        } .padding(5)
            .background(Color.black)
            .foregroundColor(.yellow)
            .cornerRadius(8)
            .font(.subheadline)
            
        
        Text("Word \(word)")
        Spacer()
    }
}

struct AudibleStyleView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State var m_lessonList = [LessonNameEnum]()
    @State var showingSheet = false
    @State var activeLesson = LessonNameEnum.mixAndMatch
    @State  var currentLessonType = LessonType.MBVC
    private var lessonTypeItems = [GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible())]
    
    private var gridItems = [GridItem(.flexible()),
                             GridItem(.flexible()),
//                             GridItem(.flexible()),
                             GridItem(.flexible())]
    
    public init(languageViewModel: LanguageViewModel){
        self.languageViewModel = languageViewModel
    }
    
    var body: some View {
        VStack{
            Text(currentLessonType.rawValue)
            LazyVGrid(columns: lessonTypeItems, spacing: 5){
                LessonTypeButton(lessonText: LessonType.MBVC.rawValue, backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                               lessonType: .MBVC, function: loadLessonNames )
                LessonTypeButton(lessonText: LessonType.PBVC.rawValue, backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                               lessonType: .PBVC, function: loadLessonNames )
                LessonTypeButton(lessonText: LessonType.GNRL.rawValue, backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                               lessonType: .GNRL, function: loadLessonNames )
                LessonTypeButton(lessonText: LessonType.ODDS.rawValue, backgroundColor: .blue, foregroundColor: .yellow, fontSize: .system(size: 10),
                               lessonType: .ODDS, function: loadLessonNames )
            }
            
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 5){
                    ForEach ((0..<m_lessonList.count), id: \.self){ index in
                        LessonButton(languageViewModel: languageViewModel, lessonName: m_lessonList[index],  backgroundColor: .blue, foregroundColor: .black, fontSize: Font.subheadline, function: selectLesson)
                    }
                }
            }
        }

    }
    
    func selectLesson(lessonName: LessonNameEnum){
//        showingSheet.toggle()
            switch lessonName{
            case .findModelForUserVerb:
                AgnosticWordView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern, word: "hello")
//                    PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelForGivenVerb ))
            default:
                break
            }

    }
    
    func loadLessonNames(lessonType: LessonType){
        m_lessonList.removeAll()
        switch lessonType{
        case .MBVC:
            m_lessonList.append(.findModelForUserVerb)
            m_lessonList.append(.modelsOfAFeather)
            m_lessonList.append(.modelsForPattern)
        case .PBVC:
            m_lessonList.append(.verbsForGivenPattern)
            m_lessonList.append(.verbsWithVerbsPattern)
        case .GNRL:
            m_lessonList.append(.verbCube)
            m_lessonList.append(.rightAndWrong)
            m_lessonList.append(.unconjugate)
            m_lessonList.append(.mixAndMatch)
            m_lessonList.append(.analyzeAnyVerb)
            m_lessonList.append(.verbMorph)
        case .ODDS:
            m_lessonList.append(.wordCollections)
            m_lessonList.append(.verbsLikeGustar)
            m_lessonList.append(.weatherAndTime)
            m_lessonList.append(.ThirdPersonOnly)
            m_lessonList.append(.auxiliaryVerbs)
        }
    }
}

