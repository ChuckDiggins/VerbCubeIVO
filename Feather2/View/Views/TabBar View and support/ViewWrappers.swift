//
//  VerbCubeDispatcher.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/15/22.
//  bruñir

import SwiftUI
import JumpLinguaHelpers

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct GrayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct ModelSelectionWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @State var selected = true
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            Image("FeatherInverted")
//                .resizable()
//                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.4)
            VStack{
                Text("Verb Selection").font(.title2)
               
                NavigationLink(destination: TextBookView2(languageViewModel: languageViewModel))
                {
                Text("Realidades 1")
                }.modifier(OtherBlueButtonModifier())
                
                NavigationLink(destination: VerbModelListView(languageViewModel: languageViewModel, vmecdm: vmecdm))
                {
                Text("Verb Model List")
                }.modifier(OtherBlueButtonModifier())
//
//                NavigationLink(destination: StudyPackageView(languageViewModel: languageViewModel))
//                {
//                Text("Study packages")
//                }.frame(width: 200, height: 45)
//                    .background ( .blue )
//                    .foregroundColor ( .white )
//                    .clipShape(Capsule())
                
                NavigationLink(destination: AllModelsView(languageViewModel: languageViewModel, vmecdm: vmecdm))
                {
                Text("Verb Models")
                }.modifier(OtherBlueButtonModifier())
                

                NavigationLink(destination: DictionaryView(languageViewModel: languageViewModel, vmecdm: vmecdm, selected: $selected)){
                    Text("Verb Dictionary")
                }.modifier(OtherBlueButtonModifier())
                
                if languageViewModel.getSelectedVerbModelList().count > 0 {
                    NavigationLink(destination: ListVerbsForModelView(languageViewModel: languageViewModel, vmecdm: vmecdm, verbModel:  languageViewModel.getSelectedVerbModelList()[0]))
                    {
                    Text("List Current Verbs")
                    }.modifier(OtherBlueButtonModifier())
                }
                
//                NavigationLink(destination: TextBookView3(languageViewModel: languageViewModel))
//                {
//                Text("Chuck 1 - Advanced verbs")
//                }.frame(width: 300, height: 45)
//                    .background ( .blue )
//                    .foregroundColor ( .white )
//                    .clipShape(Capsule())
            }
        }
        .foregroundColor(Color("BethanyGreenText"))
        .font(.headline)
        .padding()
    }
}

struct VerbSeeCarousel: View {
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
        }
    }
}
struct VerbSeeWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @State var verbsExistForAll3Endings = true
    @State var exploreFlag = false
    @State var rightWrongFlag = false
    @State var verbCubeFlag = false
    @State var threeVerbFlag = false
    @State var conjugateVerbsFlag = false
    var buttonSide = CGFloat(125)
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            Image("FeatherInverted")
            //                .resizable()
            //                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.4)
            VStack{
                Text("Verb Explore").font(.title2)
                
                if verbsExistForAll3Endings && languageViewModel.getStudyPackage().specialVerbType == .normal{
                    NavigationLink(destination: ThreeVerbSimpleView(languageViewModel: languageViewModel))
                    {
                    Text("3 Verbs 1")
                    }.modifier(OtherBlueButtonModifier())
                }
                
                if languageViewModel.getFilteredVerbs().count > 0 && languageViewModel.getStudyPackage().specialVerbType == .normal {
                    NavigationLink(destination: VerbCubeDirectorView(languageViewModel: languageViewModel))
                    {
                    Text("Verb Cube")
                    }.modifier(OtherBlueButtonModifier())
                }
                
                if languageViewModel.getFilteredVerbs().count > 0 && languageViewModel.getStudyPackage().specialVerbType == .normal {
                  
                    NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentFilteredVerb(), residualPhrase: "", multipleVerbFlag: true))
                    {
                    Text("Verb Conjugation")
                    }.modifier(OtherBlueButtonModifier())
                }
                
                NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel))
                {
                Text("Right and Wrong")
                }.modifier(OtherBlueButtonModifier())
                
                VStack{
                    
                    
                    switch languageViewModel.getStudyPackage().specialVerbType{
                        
                    case .verbsLikeGustar:
                        NavigationLink(destination: VerbsLikeGustarView(languageViewModel: languageViewModel))
                        {
                        Text("Exploree Verbs like Gustar")
                        }.modifier(OtherBlueButtonModifier())
                    case .auxiliaryVerbsInfinitives, .auxiliaryVerbsGerunds:
                        NavigationLink(destination: AuxiliaryPhraseView(languageViewModel: languageViewModel, specialVerbType: languageViewModel.getStudyPackage().specialVerbType))
                        {
                        Text("Explore Aux Verbs + Inf")
                        }.modifier(OtherBlueButtonModifier())
                    default:
                        NavigationLink(destination: NormalPhraseView(languageViewModel: languageViewModel, specialVerbType: languageViewModel.getStudyPackage().specialVerbType))
                        {
                        Text("Explore Normal Verbs")
                        }.modifier(OtherBlueButtonModifier())
                        
                    }
                    
                    
                    
                }.onAppear{
                    verbsExistForAll3Endings = languageViewModel.computeVerbsExistForAll3Endings()
                    let svt = languageViewModel.getStudyPackage().specialVerbType
                    print(svt.rawValue)
                }
                .foregroundColor(Color("BethanyGreenText"))
                //            .background(Color("BethanyNavalBackground"))
                .font(.headline)
                .padding()
            }.navigationTitle("See your verbs")
            
            
        }
        
    }
}

struct VerbLearnWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    var frameWidth = CGFloat(110)
    var frameHeight = CGFloat(200)
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            Image("FeatherInverted")
//                .resizable()
//                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.4)
            VStack{
                Text("Verb Learn").font(.title2)
                HStack{
                    NavigationLink(destination: MixAndMatchView(languageViewModel: languageViewModel))
                    {
                    Text("Mix and Match")
                    }.modifier(SquareBlueButtonModifier())
                    
                    NavigationLink(destination: DragDropVerbSubjectView(languageViewModel: languageViewModel ))
                    {
                    Text("Drag and Drop")
                    
                    }.modifier(SquareBlueButtonModifier())
                }
                HStack{
                    NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveVerbs))
                    {
                    VStack{
                        Text("Multiple Choice")
                        Text("Subject vs Verb")
                    }
                    }.modifier(SquareBlueButtonModifier())

                    
                    NavigationLink(destination: MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveTenses))
                    {
                    VStack{
                        Text("Multiple Choice")
                        Text("Subject vs Tense")
                    }
                    }.modifier(SquareBlueButtonModifier())

                }
                NavigationLink(destination: FlashCardsView(languageViewModel: languageViewModel))
                {
                VStack{
                    Text("FlashCards")
                    Text("Quick Flash")
                }
                }.modifier(SquareBlueButtonModifier())
                
                
//                NavigationLink(destination: FeatherVerbStepView(languageViewModel: languageViewModel)){
//                    Text("Feather Step")
//                }.modifier(NavLinkModifier())
//
//                NavigationLink(destination: FeatherVerbQuizMorphView(languageViewModel: languageViewModel)){
//                    Text("Feather Step 2")
//                }.modifier(NavLinkModifier())
            }
            
        }
        .foregroundColor(Color("BethanyGreenText"))
        .font(.headline)
        .padding()
    }
}

struct VerbTestWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @State var multipleChoiceShown = true
    @State var textEditorShown = true
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            Image("FeatherInverted")
//                .resizable()
//                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.4)
            VStack{
                Text("Verb Test").font(.title2)
                VStack{
                    
                    NavigationLink(destination: CombinedAlert(languageViewModel: languageViewModel, flashMode: .MultipleChoice, shown: $multipleChoiceShown)){
                        Text("Multiple Choice Test")
                    }.modifier(OtherBlueButtonModifier())
                    
                    NavigationLink(destination: CombinedAlert(languageViewModel: languageViewModel, flashMode: .TextField, shown: $textEditorShown)){
                        Text("Fill-in Blank")
                    }.modifier(OtherBlueButtonModifier())
                }
            }.onAppear{
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
            }
            .padding(40)
            
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
        .font(.headline)
        .padding()
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
                NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .model)){
                    Text("Find Verbs with Same Model")
                }.modifier(NavLinkModifier())

                NavigationLink(destination: AnalyzeUserVerbView(languageViewModel: languageViewModel)){
                    Text("Analyze User Verb")
                }.modifier(NavLinkModifier())

                
            }
        }.navigationTitle("Find Stuff")
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            .font(.headline)
            .padding()
    }
}

enum StatusDisplayMode {
    case verbs, models, types1, types2
    
    public func getName()->String{
        switch self{
        case .verbs: return "Verbs"
        case .models: return "Models"
        case .types1: return "Status"
        case .types2: return "Status"
        }
    }
}


struct ShowSegmentedModelStatusPicker: View {
    @Binding var displayMode : StatusDisplayMode
    var displayModeList : [ StatusDisplayMode ]?
    
    init(_ displayMode: Binding<StatusDisplayMode>){
        self._displayMode = displayMode
        UISegmentedControl.appearance().selectedSegmentTintColor = .green
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    var body: some View{
        VStack{
            Picker("Select model type", selection: $displayMode){
                ForEach(displayModeList!, id:\.self){ Text($0.getName())}
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
        }
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

struct ButtonStyleModifier : ViewModifier {
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
                
                Spacer()
            }
        }
    }
}

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
//                    NavigationLink(destination: PatternRecognitionView( languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
//                        Text("Models for Pattern")
//                    }.modifier(NavLinkModifier())
//
//                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsBelongingToModel)){
//                        Text("Verbs in Model")
//                    }.modifier(NavLinkModifier())
//
//                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelForGivenVerb)){
//                        Text("Model for Given Verb")
//                    }.modifier(NavLinkModifier())
//
//                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveSameModelAsVerb)){
//                        Text("Verbs for Same Model")
//                    }.modifier(NavLinkModifier())
                }
                Section{
                    NavigationLink(destination: FindVerbsView(languageViewModel: languageViewModel, featherMode: .pattern)){
                        Text("Find Pattern for User Verb")
                    }.modifier(NavLinkModifier())
                    
//                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
//                        Text("Models for Pattern")
//                    }.modifier(NavLinkModifier())
//
//                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsThatHaveGivenPattern)){
//                        Text("Verbs with Given Pattern")
//                    }.modifier(NavLinkModifier())
//
//                    NavigationLink(destination: PatternRecognitionView(languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyVerbsWithSamePatternAsVerb)){
//                        Text("Verbs with Verb's Pattern")
//                    }.modifier(NavLinkModifier())
                    
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




