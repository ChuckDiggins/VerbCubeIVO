//
//  VerbCubeDispatcher.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//  bruñir

import SwiftUI

struct AllNavigationLinks: View {
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
            ScrollView{
                Section{
                    NavigationLink(destination: MultiVerbMorphView(languageViewModel: languageViewModel)){
                        Text("Conjugate Verbs with Same Model")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                        Text("Verb Morphing")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .model)){
                        Text("Find Verbs with Same Model")
                    }.modifier(NavLinkModifier())
                    
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
                Section{
                    NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .pattern)){
                        Text("Find Pattern for User Verb")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
                        Text("Models for Pattern")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveGivenPattern)){
                        Text("Verbs with Given Pattern")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsWithSamePatternAsVerb)){
                        Text("Verbs with Verb's Pattern")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                        Text("VerbCube")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel)){
                        Text("Right & Wrong")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: UnconjugateView(languageViewModel: languageViewModel)){
                        Text("Unconjugate")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                        Text("Analyze User Verb")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                        Text("Verb Morphing")
                    }.modifier(NavLinkModifier())
                    
                    NavigationLink(destination:  ThreeVerbSimpleView(languageViewModel: languageViewModel))
                    {
                    Text("3 Verbs View")
                    } .modifier(NavLinkModifier())
                }
            }
        }
    }
}

struct VerbSeeWrapper: View {
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
                if languageViewModel.getStudentLevel().getLessonLevel() < 3 {
                    NavigationLink(destination:  ThreeVerbSimpleView(languageViewModel: languageViewModel))
                    {
                    Text("3 Verbs View")
                    } .modifier(NavLinkModifier())
                }
                
                if languageViewModel.getStudentLevel().getLessonLevel() ==  2  ||
                    languageViewModel.getStudentLevel().getLessonLevel() ==  4 ||
                    languageViewModel.getStudentLevel().getLessonLevel() ==  5
                {
                    NavigationLink(destination:  VerbCubeDirectorView(languageViewModel: languageViewModel))
                    {
                    Text("Verb Cubes")
                    } .modifier(NavLinkModifier())
                }
                
                
                if languageViewModel.getStudentLevel().getLessonLevel() > 0 {
                    NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentFilteredVerb(), residualPhrase: "", teachMeMode: .model))
                    {
                    Text("Conjugate your verbs")
                    }.modifier(NavLinkModifier())
                }
            }
        }.navigationTitle("Learn your verbs")
    }
}

struct VerbLearnWrapper: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var frameWidth = CGFloat(110)
    var frameHeight = CGFloat(200)
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            
            
            VStack{
                Text("Show Me Model Quizzes")
                    .font(.title2)
                HStack{
                    NavigationLink(destination: MixAndMatchView(languageViewModel: languageViewModel))
                    {
                    Text("Mix and Match")
                    }.frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .border(.red)
                    
                    NavigationLink(destination: DragDropVerbSubjectView(languageViewModel: languageViewModel))
                    {
                    Text("Drag and Drop")
                    
                    }.frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .border(.red)
                }
                HStack{
                    NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveVerbs))
                    {
                    VStack{
                        Text("Multiple Choice")
                        Text("Subject vs Verb")
                    }
                    }.frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .border(.red)

                    
                    NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveTenses))
                    {
                    VStack{
                        Text("Multiple Choice")
                        Text("Subject vs Tense")
                    }
                    }.frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .border(.red)

                }
            }
            
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
        .font(.headline)
        .padding()
    }
}

struct VerbTestWrapper: View {
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
          
struct VerbFindWrapper: View {
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
//                NavigationLink(destination: MultiVerbMorphView(languageViewModel: languageViewModel)){
//                    Text("Conjugate Verbs with Same Model")
//                }.modifier(NavLinkModifier())
//
//                NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
//                    Text("Verb Morphing")
//                }.modifier(NavLinkModifier())
//
                NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .model)){
                    Text("Find Verbs with Same Model")
                }.modifier(NavLinkModifier())

                NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
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
                NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .pattern)){
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
            
            NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                Text("Analyze User Verb")
            }.modifier(NavLinkModifier())
            
            NavigationLink(destination: VerbMorphView(languageViewModel: languageViewModel)){
                Text("Verb Morphing")
            }.modifier(NavLinkModifier())

        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TeachMeWrapper: View {
    @ObservedObject  var languageViewModel: LanguageViewModel
    var body: some View {
        VStack{
            
            NavigationLink(destination: TeachMeARegularVerb(languageViewModel: languageViewModel)){
                HStack{
                    Text("Teach me a regular verb")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.yellow)
                }
            }.modifier(ModelTensePersonButtonModifier())
            NavigationLink(destination: TeachMeAModelVerb(languageViewModel: languageViewModel)){
                HStack{
                    Text("Teach me a model verb")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.yellow)
                }
            }.modifier(ModelTensePersonButtonModifier())
            NavigationLink(destination: TeachMeAPatternVerb(languageViewModel: languageViewModel)){
                HStack{
                    Text("Teach me a pattern verb")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.yellow)
                }
            }.modifier(ModelTensePersonButtonModifier())
            
           

        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct OddJobsView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var backgroundColor = Color.purple
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            Image("FeatherInverted")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            VStack{
                Text("Odds and Ends")
                    .font(.title2)
                    .foregroundColor(Color("ChuckText1"))
                Spacer()
                
                NavigationLink(destination:  ThreeVerbSimpleView(languageViewModel: languageViewModel))
                {
                Text("3 Verbs View")
                    .frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .font(.headline)
                    .background(.linearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .cornerRadius(10)
                }
                .buttonStyle(.bordered)
                .tint(.primary)
                
                NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel)){
                    Text("Right and Wrong")
                }.modifier(ModelTensePersonButtonModifier())

//                NavigationLink(destination: QuizCubeView2(languageViewModel: languageViewModel, qchc: QuizCubeHandlerClass(languageViewModel: languageViewModel), useCellAlert: true )){
//                    Text("Open Quiz Cube")
//                }.frame(width: 200, height: 50)
//                    .padding(.leading, 10)
//                    .background(Color.orange)
//                    .cornerRadius(10)

                NavigationLink(destination: VerbCubeDirectorView(languageViewModel: languageViewModel)){
                                    Text("Verb Cube Director")
                                }.modifier(ModelTensePersonButtonModifier())
                
                NavigationLink(destination: QuizCubeDirectorView(languageViewModel: languageViewModel)){
                                    Text("Quiz Cube Director")
                                }.modifier(ModelTensePersonButtonModifier())
                
                
                
//                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .likeGustar)){
//                    Text("Verbs like gustar")
//                }.modifier(ModelTensePersonButtonModifier())
//
//                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .weather)){
//                    Text("Weather and Time")
//                }.modifier(ModelTensePersonButtonModifier())
//
//                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .thirdPersonOnly)){
//                    Text("3rd Person Only")
//                }.modifier(ModelTensePersonButtonModifier())
//
//                NavigationLink(destination: BehavioralVerbView(languageViewModel: languageViewModel, behaviorType: .auxiliary)){
//                    Text("Auxiliary Verbs")
//                }.modifier(ModelTensePersonButtonModifier())
//
                Spacer()
            }
        }
    }
}



