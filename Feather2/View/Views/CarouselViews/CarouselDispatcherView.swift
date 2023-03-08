//
//  CarouselDispatcherWithImagesView.swift
//  CarouselTest
//
//  Created by Charles Diggins on 2/2/23.
//

import SwiftUI


struct ExerciseStruct: Identifiable, Hashable {
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    var id = UUID().uuidString
    var mode : ExerciseMode
    var image : Image
    init(_ mode: ExerciseMode, _ image: Image){
        self.mode = mode
        self.image = image
    }
}

struct ShowSegmentedVerbOrModelModePicker: View {
    @EnvironmentObject var languageViewModel: LanguageViewModel
    @Binding var currentVerbOrModelMode: VerbOrModelMode
    var verbOrModelModeList : [ VerbOrModelMode ]

    init(_ currentVerbOrModelMode: Binding<VerbOrModelMode>, verbOrModelModeList: [ VerbOrModelMode ]){
        self.verbOrModelModeList = verbOrModelModeList
        self._currentVerbOrModelMode = currentVerbOrModelMode
        UISegmentedControl.appearance().selectedSegmentTintColor = .green
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }

    var body: some View{
        VStack{
            Picker("Select Verb or Model Mode", selection: $currentVerbOrModelMode){
                ForEach(verbOrModelModeList , id:\.self){ Text($0.rawValue)}
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
        }.onChange(of: currentVerbOrModelMode){ _ in
            switch currentVerbOrModelMode {
            case .verbMode:
                languageViewModel.setToVerbMode()
            case .modelMode:
                languageViewModel.setToVerbModelMode()
            }
            print("changing verb or model mode to: \(currentVerbOrModelMode.rawValue)")
        }
    }
}
struct NavStackCarouselDispatcherView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("VerbOrModelMode") var verbOrModelMode = "NA"
    @AppStorage("V2MChapter") var currentV2mChapter = "nada 2"
    @AppStorage("V2MLesson") var currentV2mLesson = "nada 3"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "nada 4"
    
    @State var currentVerbOrModelMode = VerbOrModelMode.modelMode
    @State var verbOrModelModeList = [VerbOrModelMode.verbMode, .modelMode]
    @State var selectedCount = 0
    @State var verbsExistForAll3Endings = true
    @State var selected  = false
    @State private var exerciseMgr = ExerciseDataManager(.verbMode, .Select, .normal)
    @State private var imageLength = CGFloat(125)
    @State private var multipleChoiceShown = true
    @State private var textEditorShown = true
    @State private var exerciseStructList = [
//        ExerciseStruct(.SelectModel, Image("SELECTModels")),
        ExerciseStruct(.Select, Image("SELECT")),
        ExerciseStruct(.Explore, Image("EXPLORE")),
        ExerciseStruct(.Learn, Image("LEARN")),
        ExerciseStruct(.Test, Image("TEST")),
    ]
    
    var body: some View {
        
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            //            Image("FeatherInverted")
            //                .resizable()
            //                .scaledToFit()
                .ignoresSafeArea(.all)
                .opacity(0.4)
            NavigationStack(path: $router.path){
                ShowSegmentedVerbOrModelModePicker($currentVerbOrModelMode, verbOrModelModeList: verbOrModelModeList)
                List{
                    ForEach(exerciseStructList){ exercise in
                        NavigationLink(value: exercise){
                            HStack{
                                exercise.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: imageLength, height: imageLength)
                                    .border(Color("ChuckText1"))
                                Text(exercise.mode.rawValue)
                            }
                        }
                    }
                }
                .navigationTitle( currentVerbOrModelMode == .modelMode ? "Verb Model: \(currentVerbModelString)" : "\(currentV2mChapter), \(currentV2mLesson)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: ExerciseStruct.self){ exercise in
                    ExploreCarouselView(languageViewModel: languageViewModel, exerciseManager: ExerciseDataManager(languageViewModel.getVerbOrModelMode(), exercise.mode, .normal), selected: $selected)
                }
                
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        NavigationLink(destination: FindMyVerbDispatcher(languageViewModel: languageViewModel ))
                        {
                        Label("Find", systemImage: "magnifyingglass")
                        }
                        NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel ))
                        {
                        Label("Settings", systemImage: "gear")
                        }
                    }
                }
                
                .fullScreenCover(isPresented: $selected, content: {
                    switch languageViewModel.getCurrentExercise().title{
                        //Select
                    case "Realidades 1":
                        TextBookView2(languageViewModel: languageViewModel)
                    case "Challenging Lessons":
                        TextBookViewChuck(languageViewModel: languageViewModel)
                    case "Verb Model List": VerbModelListView(languageViewModel: languageViewModel, vmecdm: vmecdm)
//                    case "Verb Model List": VerbModelLessonView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                    case "Verb Models": AllModelsView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                    case "Verb Dictionary": DictionaryView(languageViewModel: languageViewModel, vmecdm: vmecdm, selected: $selected )
                    case "Show Current Verbs": ListVerbsForModelView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                        //Explore
                    case "3 Verbs View": ThreeVerbSimpleView(languageViewModel: languageViewModel)
                    case "Verb Cube": VerbCubeDirectorView(languageViewModel: languageViewModel)
                    case "Verb Conjugation": SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentFilteredVerb(), residualPhrase: "", multipleVerbFlag: true)
                    case "Verb Morphing":
                        if languageViewModel.isModelMode() && languageViewModel.getFilteredVerbs().count > 1{
                            MultiVerbMorphView(languageViewModel: languageViewModel)
                        }
                        else {
                            VerbMorphView(languageViewModel: languageViewModel)
                        }
                    case "Right and Wrong":
                         RightWrongVerbView(languageViewModel: languageViewModel)
                    case "Explore Verbs Like Gustar": VerbsLikeGustarView(languageViewModel: languageViewModel)
                    case "Explore Auxiliary Verbs": AuxiliaryPhraseView(languageViewModel: languageViewModel, specialVerbType: languageViewModel.getStudyPackage().specialVerbType)
                    case "Explore Normal Verbs": NormalPhraseView(languageViewModel: languageViewModel, specialVerbType: languageViewModel.getStudyPackage().specialVerbType)
                        //Learn
                    case "Mix and Match": MixAndMatchView(languageViewModel: languageViewModel)
                    case "Drag and Drop": DragDropVerbSubjectView(languageViewModel: languageViewModel )
                    case "Subject vs Verb": MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveVerbs)
                    case "Subject vs Tense": MultipleChoiceView(languageViewModel: languageViewModel, multipleChoiceType: .oneSubjectToFiveTenses)
                    case "Flash Cards": FlashCardsView(languageViewModel: languageViewModel)
                        //Test
                    case "Multiple Choice Test": CombinedAlert(languageViewModel: languageViewModel, flashMode: .MultipleChoice, shown: $multipleChoiceShown)
                    case "Fill-in Blanks Test": CombinedAlert(languageViewModel: languageViewModel, flashMode: .TextField, shown: $textEditorShown)
                    default: SimpleVerbConjugation(languageViewModel: languageViewModel, verb: languageViewModel.getCurrentFilteredVerb(), residualPhrase: "", multipleVerbFlag: true)
                    }
                })
                .background(Color("BethanyNavalBackground"))
                .foregroundColor(Color("BethanyGreenText"))
                //                .frame(width: geometry.size.width, alignment: .leading)
                .padding(2)
                .cornerRadius(6)
                
            }
            .onAppear{
                languageViewModel.setVerbModelEntityCoreDataManager(vmecdm: vmecdm)
                if !languageViewModel.verbOrModelModeInitialized() {
                    let savedMode = verbOrModelMode
                    languageViewModel.setStudyPackageTo(currentV2mChapter, currentV2mLesson)
                    languageViewModel.setVerbModelTo(languageViewModel.findModelForThisVerbString(verbWord: currentVerbModelString))
                    languageViewModel.setVerbOrModelMode(savedMode)
                    languageViewModel.setVerbOrModelModeInitialized()
                }
                selectedCount = languageViewModel.getSelectedVerbModelList().count
                currentVerbOrModelMode = languageViewModel.getVerbOrModelMode()
                verbsExistForAll3Endings = languageViewModel.computeVerbsExistForAll3Endings()
                
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
        .foregroundColor(Color("BethanyGreenText"))
        .font(.headline)
        .padding()
        
        
    }
}



