//
//  VerbCubeDispatcher.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//  bruñir

import SwiftUI


struct ModelLearnWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemPink),
                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack{
                NavigationLink(destination: MultiVerbMorphView(languageViewModel: languageViewModel)){
                    Text("Conjugate Verbs with Same Model")
                }.modifier(NavLinkModifier())
                        
                NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                    Text("Verb Morphing")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: VerbsOfAFeather(languageViewModel: languageViewModel, featherMode: .model)){
                    Text("Find Verbs with Same Model")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: AnalyzeMyVerbView(languageViewModel: languageViewModel)){
                    Text("Analyze User Verb")
                }.modifier(NavLinkModifier())            
            }
        }.navigationTitle("Model-based Learning")
    }
}

struct ModelQuizWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemPink),
                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack{

                NavigationLink(destination: FeatherVerbStepView(languageViewModel: languageViewModel)){
                    Text("Model Verb Step")
                }.modifier(NavLinkModifier())
//
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
                    Text("Models for Pattern")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsBelongingToModel)){
                    Text("Verbs in Model")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelForGivenVerb)){
                    Text("Model for Given Verb")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveSameModelAsVerb)){
                    Text("Verbs for Same Model")
                }.modifier(NavLinkModifier())
                
            }
            
        }.navigationTitle("Model-based Quizzes")
    }
}


          
struct PatternLearnWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemPink),
                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack{
                NavigationLink(destination: VerbsOfAFeather(languageViewModel: languageViewModel, featherMode: .pattern)){
                    Text("Find Pattern for User Verb")
                }.modifier(NavLinkModifier())
            }
        }
    }
}

struct PatternQuizWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [
                Color(.systemYellow),
                Color(.systemPink),
                Color(.systemPurple),
            ]),
                           startPoint: .top,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack{
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
                    Text("Models for Pattern")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveGivenPattern)){
                    Text("Verbs with Given Pattern")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsWithSamePatternAsVerb)){
                    Text("Verbs with Verb's Pattern")
                }.modifier(NavLinkModifier())
            }
        }.navigationTitle("Pattern-based Verbs")
    }
}


struct NavLinkModifier : ViewModifier {
    func body(content: Content) -> some View{
        content
            .padding(.leading, 10)
            .padding(10)
            .frame(width: 300, height: 50)
            .background(.black)
            .border(Color.white, width: 2)
            .cornerRadius(25)
            .foregroundColor(.yellow)
        //                    .buttonStyle(.bordered)
            .tint(.yellow)
        
        
    }
    
}

struct GeneralVerbLearnWrapper: View {
    @ObservedObject  var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                Text("VerbCube")
            }.modifier(NavLinkModifier())

            NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel)){
                Text("Right & Wrong")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: UnconjugateView(languageViewModel: languageViewModel)){
                Text("Unconjugate")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: AnalyzeMyVerbView(languageViewModel: languageViewModel)){
                Text("Analyze User Verb")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                Text("Verb Morphing")
            }.modifier(NavLinkModifier())

        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GeneralVerbQuizWrapper: View {
    @ObservedObject  var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            
            NavigationLink(destination: MixAndMatchView(languageViewModel: languageViewModel)){
                Text("Mix & Match")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveVerbs)){
                Text("Multiple Choice - Subject/Verbs")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveTenses)){
                Text("Multiple Choice - Subject/Tenses")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                Text("Verb Morph View")
            }.modifier(NavLinkModifier())
            
            
//            Text("Quiz Cube")
//            HStack{
//                NavigationLink(destination: QuizCubeOptionsView2(languageViewModel: languageViewModel)){
//                    Text("Quiz Cube")
//                }.frame(width: 100, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct OddJobsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var backgroundColor = Color.purple
    var body: some View {
        ZStack{
            backgroundColor
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            VStack{
                Text("Odds and Ends")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: WordCollectionScreen(languageViewModel: languageViewModel)){
                    Text("Word collections")
                }.modifier(NavLinkModifier())
                
                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .likeGustar)){
                    Text("Verbs like gustar")
                }.modifier(NavLinkModifier())

                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .weather)){
                    Text("Weather and Time")
                }
                .modifier(NavLinkModifier())
                
                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .thirdPersonOnly)){
                    Text("3rd Person Only")
                }.modifier(NavLinkModifier())

                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .auxiliary)){
                    Text("Auxiliary Verbs")
                }
                .modifier(NavLinkModifier())
                Spacer()
            }
        }
    }
}



