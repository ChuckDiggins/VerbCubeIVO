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


struct VerbSelectionWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @State var selectedCount = 0
    @State var selectedModelString = ""
    @State var selectedType = NewVerbModelType.undefined
    @State var regularVerbsCompleted = false
    @State var criticalVerbsCompleted = false
    @State var currentSelectedModelCompleted = false
    
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount, selectedNewVerbModelType: .Regular, selectedModelString: $selectedModelString ))
                    {
                    Text("Select Regular Verbs")
                    }.frame(width: 200, height: 45)
                        .background (regularVerbsCompleted ? .gray : .blue )
                        .foregroundColor (regularVerbsCompleted ? .black : .white )
                        .clipShape(Capsule())
                        .disabled(regularVerbsCompleted)
                    if regularVerbsCompleted { Text("✅").font(.title)}
                }
                
                HStack{
                    NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount, selectedNewVerbModelType: .Critical, selectedModelString: $selectedModelString ))
                    {
                    Text("Select Critical Verbs")
                    
                    }
                    .frame(width: 200, height: 45)
                    .background (criticalVerbsCompleted ? .gray : .blue )
                    .foregroundColor (criticalVerbsCompleted ? .black : .white )
                    .clipShape(Capsule())
                    .disabled(criticalVerbsCompleted)
                    if criticalVerbsCompleted { Text("✅").font(.title)}
                }
                
                NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount, selectedNewVerbModelType: .StemChanging1, selectedModelString: $selectedModelString ))
                {
                Text("Stem-changing models")
                }.buttonStyle(BlueButton())
                
               
                NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount,
                                                                  selectedNewVerbModelType: .SpellChanging1, selectedModelString: $selectedModelString ))
                {
                Text("Spell-changing models")
                }.buttonStyle(BlueButton())
                
                NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount,
                                                                  selectedNewVerbModelType: .Irregular, selectedModelString: $selectedModelString ))
                {
                Text("Irregular models")
                }.buttonStyle(BlueButton())
                
               
                Spacer()
            }
            .onAppear{
                setCompletedFlags()
//                print("AllVerbModelTypesView: \(vmecdm.vm.getVerbModelEntityCount())")
            }
            .onDisappear{
                selectedType = languageViewModel.getSelectedNewVerbModelType()
                if selectedType != .undefined && languageViewModel.getSelectedVerbModelList().count > 0 {
                    selectedModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
                }
            }
        }
    }
    func setCompletedFlags(){
        regularVerbsCompleted = false
        
        print("setCompletedFlags regularAR completed \(vmecdm.isCompleted(verbModelString: "regularAR"))")
        print("setCompletedFlags regularER completed \(vmecdm.isCompleted(verbModelString: "regularER"))")
        print("setCompletedFlags regularIR completed \(vmecdm.isCompleted(verbModelString: "regularIR"))")
        
        regularVerbsCompleted = vmecdm.isCompleted(verbModelString: "regularAR") &&
            vmecdm.isCompleted(verbModelString: "regularER") &&
            vmecdm.isCompleted(verbModelString: "regularIR")
        print("setCompletedFlags regularVerbsCompleted \(regularVerbsCompleted))")
        
        criticalVerbsCompleted = vmecdm.isCompleted(verbModelString: "estar")  &&
                vmecdm.isCompleted(verbModelString: "ser") &&
                vmecdm.isCompleted(verbModelString: "haber")  &&
                vmecdm.isCompleted(verbModelString: "hacer") &&
                vmecdm.isCompleted(verbModelString: "oír") &&
                vmecdm.isCompleted(verbModelString: "ir") &&
                vmecdm.isCompleted(verbModelString: "ver") &&
                vmecdm.isCompleted(verbModelString: "saber") &&
                vmecdm.isCompleted(verbModelString: "reír")
        
        if !languageViewModel.getSelectedVerbModelList().isEmpty {
            currentSelectedModelCompleted = vmecdm.isCompleted(verbModelString: languageViewModel.getSelectedVerbModelList()[0].modelVerb)
            selectedType = languageViewModel.getSelectedNewVerbModelType()
            var sptList = languageViewModel.getCurrentSpecialPatternTypeList()
            for spt in sptList{
                print("setCompletedFlags: \(spt.rawValue)")
            }
        }
    }
                
}
//struct VerbModelSelectionWrapper: View {
//    @EnvironmentObject var languageViewModel: LanguageViewModel
//    @Binding var selectedCount: Int
//    @Binding var selectedModelString : String
//    @State var selectedType = NewVerbModelType.undefined
//    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
//    @State var regularVerbsCompleted = false
//    @State var criticalVerbsCompleted = false
//
//    @State var verbsExistForAll3Endings = true
//    var body: some View {
//        ZStack{
//            Color("BethanyNavalBackground")
//                .ignoresSafeArea()
//
//            VStack{
////                NavigationLink(destination: TabBarVerbModelTypes(languageViewModel: languageViewModel, selectedCount: $selectedCount))
////                    {
////                    Text("Tab Bar Shell")
////                    } .modifier(NavLinkModifier())
//
//
//                Button{
//                    vmecdm.setAllSelected(flag: false)
//                    languageViewModel.setSelectedNewVerbModelType(selectedType: .Regular)
//                    vmecdm.setSelected(verbModelString: "regularAR", flag: true)
//                    vmecdm.setSelected(verbModelString: "regularER", flag: true)
//                    vmecdm.setSelected(verbModelString: "regularIR", flag: true)
//                    languageViewModel.fillSelectedVerbModelListAndPutAssociatedVerbsinFilteredVerbList(maxVerbCountPerModel:5)
//                    languageViewModel.initializeStudentScoreModel()
//                    selectedCount = vmecdm.vm.getSelectedModelEntityCount()
//                } label: {
//                    Text("Regular Verb Models")
//                }.buttonStyle(.bordered)
//                    .disabled(regularVerbsCompleted)
//
//                Button{
//                    vmecdm.setAllSelected(flag: false)
//                    languageViewModel.setSelectedNewVerbModelType(selectedType: .Critical)
//                    vmecdm.setSelected(verbModelString: "estar", flag: true)
//                    vmecdm.setSelected(verbModelString: "ser", flag: true)
//                    vmecdm.setSelected(verbModelString: "haber", flag: true)
//                    vmecdm.setSelected(verbModelString: "hacer", flag: true)
//                    vmecdm.setSelected(verbModelString: "oír", flag: true)
//                    vmecdm.setSelected(verbModelString: "ir", flag: true)
//                    vmecdm.setSelected(verbModelString: "ver", flag: true)
//                    vmecdm.setSelected(verbModelString: "saber", flag: true)
//                    vmecdm.setSelected(verbModelString: "reír", flag: true)
//                    languageViewModel.fillSelectedVerbModelListAndPutAssociatedVerbsinFilteredVerbList(maxVerbCountPerModel:10)
//                    languageViewModel.initializeStudentScoreModel()
//                    selectedCount = vmecdm.vm.getSelectedModelEntityCount()
//                } label: {
//                    Text("Critical Verb Models")
//                } .buttonStyle(.bordered)
//                    .disabled(criticalVerbsCompleted)
//
//                NavigationLink(destination: AllVerbModelTypesView(languageViewModel: languageViewModel, vmecdm: vmecdm, selectedCount: $selectedCount,
//                                        selectedNewVerbModelType: languageViewModel.getSelectedNewVerbModelType(),selectedModelString: $selectedModelString ))
//                    {
//                    Text("Select Model by Pattern")
//                    }.buttonStyle(.bordered)
//
//
//            }
//            .foregroundColor(Color("BethanyGreenText"))
//                .background(Color("BethanyNavalBackground"))
//                .font(.headline)
//                .padding()
//            .onAppear{
//                setCompletedFlags()
////                print("AllVerbModelTypesView: \(vmecdm.vm.getVerbModelEntityCount())")
//            }
//            .onDisappear{
//                selectedType = languageViewModel.getSelectedNewVerbModelType()
//                if selectedType != .undefined && languageViewModel.getSelectedVerbModelList().count > 0 {
//                    selectedModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
//                }
//            }
//        } .foregroundColor(Color("BethanyGreenText"))
//            .background(Color("BethanyNavalBackground"))
//            .font(.headline)
//            .padding()
//    }
//
//    func setCompletedFlags(){
//        regularVerbsCompleted = false
//        if vmecdm.isCompleted(verbModelString: "regularAR") &&
//            vmecdm.isCompleted(verbModelString: "regularER") &&
//            vmecdm.isCompleted(verbModelString: "regularIR") { regularVerbsCompleted = true }
//
//        criticalVerbsCompleted = false
//        if vmecdm.isCompleted(verbModelString: "estar")  &&
//                vmecdm.isCompleted(verbModelString: "ser") &&
//                vmecdm.isCompleted(verbModelString: "haber")  &&
//                vmecdm.isCompleted(verbModelString: "hacer") &&
//                vmecdm.isCompleted(verbModelString: "oír") &&
//                vmecdm.isCompleted(verbModelString: "ir") &&
//                vmecdm.isCompleted(verbModelString: "ver") &&
//                vmecdm.isCompleted(verbModelString: "saber") &&
//                vmecdm.isCompleted(verbModelString: "reír") { criticalVerbsCompleted = true}
//    }
//}

struct VerbSeeWrapper: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @State var verbsExistForAll3Endings = true
    var body: some View {
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            
            VStack{
                if languageViewModel.getSelectedVerbModelList().count > 0 {
                    NavigationLink(destination: ListVerbsForModelView(languageViewModel: languageViewModel, model:  languageViewModel.getSelectedVerbModelList()[0]))
                    {
                    Text("List current verbs")
                    }.buttonStyle(.bordered)
                }
                if verbsExistForAll3Endings {
                    NavigationLink(destination:  ThreeVerbSimpleView(languageViewModel: languageViewModel))
                    {
                    Text("3 Verbs View")
                    } .buttonStyle(.bordered)
                }
                if languageViewModel.getFilteredVerbs().count > 5 {
                    NavigationLink(destination:  VerbCubeDirectorView(languageViewModel: languageViewModel))
                    {
                    Text("Verb Cubes")
                    }.buttonStyle(.bordered)
                }
            
                NavigationLink(destination: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentFilteredVerb(), residualPhrase: "", teachMeMode: .model))
                {
                Text("Conjugate your verbs")
                }.buttonStyle(.bordered)
                
                NavigationLink(destination: RightWrongVerbView(languageViewModel: languageViewModel)){
                    Text("Right & Wrong")
                }.buttonStyle(.bordered)
                
                
                
            }.onAppear{
                verbsExistForAll3Endings = languageViewModel.computeVerbsExistForAll3Endings()
            }
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            .font(.headline)
            .padding()
        }.navigationTitle("See your verbs")
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
            VStack{
                HStack{
                    NavigationLink(destination: MixAndMatchView(languageViewModel: languageViewModel))
                    {
                    Text("Mix and Match")
                    }.frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .border(.red)
                    
                    NavigationLink(destination: DragDropVerbSubjectView(languageViewModel: languageViewModel ))
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
                NavigationLink(destination: FlashCardsView(languageViewModel: languageViewModel))
                {
                VStack{
                    Text("FlashCards")
                    Text("Quick Flash")
                }
                }.frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .border(.red)
                
                
//                NavigationLink(destination: FeatherVerbStepView(languageViewModel: languageViewModel)){
//                    Text("Feather Step")
//                }.modifier(NavLinkModifier())
//
//                NavigationLink(destination: FeatherVerbQuizMorphView(languageViewModel: languageViewModel)){
//                    Text("Feather Step 2")
//                }.modifier(NavLinkModifier())
                Spacer()
            }
            .navigationTitle("Learn your verbs")
            
        }
        .foregroundColor(Color("BethanyGreenText"))
        .background(Color("BethanyNavalBackground"))
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
            
            VStack{
                NavigationLink(destination: CombinedAlert(languageViewModel: languageViewModel, flashMode: .MultipleChoice, shown: $multipleChoiceShown)){
                    Text("Multiple Choice Test")
                }.modifier(BlueButtonModifier())
                
                NavigationLink(destination: CombinedAlert(languageViewModel: languageViewModel, flashMode: .TextField, shown: $textEditorShown)){
                    Text("Fill-in Blank")
                }.modifier(BlueButtonModifier())
            }.onAppear{
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
            }
            .padding(40)
            
        }.navigationTitle("Final Exams")
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
                    NavigationLink(destination: PatternRecognitionView( languageViewModel: languageViewModel, multipleChoiceMode: .IdentifyModelsThatHaveGivenPattern)){
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




