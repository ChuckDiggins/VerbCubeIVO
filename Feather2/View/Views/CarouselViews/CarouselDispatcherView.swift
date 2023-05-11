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
    @Binding var currentVerbOrModelMode: LessonModelSpecialsMode
    @Binding var selectImageString : String
    var verbOrModelModeList : [ LessonModelSpecialsMode ]
    @State var currentLanguageString = "Agnostic"

    init(_ currentVerbOrModelMode: Binding<LessonModelSpecialsMode>, _ selectImageString : Binding<String>,
         verbOrModelModeList: [ LessonModelSpecialsMode ]){
        self.verbOrModelModeList = verbOrModelModeList
        self._selectImageString = selectImageString
        self._currentVerbOrModelMode = currentVerbOrModelMode
        UISegmentedControl.appearance().selectedSegmentTintColor = .green
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }

    var body: some View{
        VStack{
            Button{
//                languageViewModel.setNextLanguage()
//                currentLanguageString = languageViewModel.getCurrentLanguage().rawValue
            } label: {
                Text(currentLanguageString)
            }
            Picker("Select Mode", selection: $currentVerbOrModelMode){
                ForEach(verbOrModelModeList , id:\.self){ Text($0.rawValue)}
            }.pickerStyle(SegmentedPickerStyle())
//                .padding()
        }.onChange(of: currentVerbOrModelMode){ _ in
            switch currentVerbOrModelMode {
            case .lessonMode:
                languageViewModel.installCurrentStudyPackage()
                languageViewModel.setToLessonMode()
                selectImageString = "SELECT Verb Lesson"
            case .modelMode:
                languageViewModel.setToVerbModelMode()
                selectImageString = "SELECT Verb Model"
            case .specialsMode:
                languageViewModel.setToSpecialsMode()
                languageViewModel.installCurrentSpecialsPackage()
                selectImageString = "SELECT Special Mode"
            }
            
//            print("changing verb or model mode to: \(currentVerbOrModelMode.rawValue)")
        }
        .onAppear{
            currentLanguageString = languageViewModel.getCurrentLanguage().rawValue
        }
    }
}
struct NavStackCarouselDispatcherView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("Language") var languageString = "Spanish"
    @AppStorage("VerbOrModelMode") var verbOrModelModeString = "Lessons"
    @AppStorage("V2MChapter") var currentV2mChapter = "Chapter 3A"
    @AppStorage("V2MLesson") var currentV2mLesson = "AR, ER, IR verbs"
    @AppStorage("CurrentVerbModel") var currentVerbModelString = "encontrar"
    @AppStorage("CurrentSpecialsOption") var currentSpecialsOptionString = "Auxiliary - Gerund"
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("Explanation Page") var explanationPage = 7
    @AppStorage("Selection Lesson Page") var selectionLessonPage = 7
    @AppStorage("Selection Model Page") var selectionModelPage = 8
    @AppStorage("Explore Page") var explorePage = 8
    @AppStorage("Learn Page") var learnPage = 7
    @AppStorage("Test Page") var testPage = 7
    
    @State var currentVerbOrModelMode = LessonModelSpecialsMode.modelMode
    @State var verbOrModelModeList = [LessonModelSpecialsMode.lessonMode, .modelMode, .specialsMode]
    @State var selectedCount = 0
    @State var verbsExistForAll3Endings = true
    @State var selected  = false
    @State private var exerciseMgr = ExerciseDataManager(.lessonMode, .Select, .normal, true)
    @State private var imageLength = CGFloat(125)
    @State private var multipleChoiceShown = true
    @State private var textEditorShown = true
    @State private var selectImageString = "SELECT verb lesson"
    @State private var isLoading = false
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
                ShowSegmentedVerbOrModelModePicker($currentVerbOrModelMode, $selectImageString, verbOrModelModeList: verbOrModelModeList)
                List{
                    ForEach(exerciseStructList){ exercise in
                        NavigationLink(value: exercise){
                            HStack{
                                getCurrentSelectImage(exercise)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: imageLength, height: imageLength)
                                    .border(Color("ChuckText1"))
                                Text(exercise.mode.rawValue)
                            }
                        }
                    }
                }
                .navigationTitle(getCurrentModeString())
//                .navigationBarTitleDisplayMode(.automatic)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: ExerciseStruct.self){ exercise in
                    ExploreCarouselView(languageViewModel: languageViewModel, exerciseManager: ExerciseDataManager(languageViewModel.getVerbOrModelMode(), exercise.mode, languageViewModel.getSpecialVerbType(), languageViewModel.hasSimpleTenses()), selected: $selected )
                }
                .navigationBarItems(
                    leading:
                        HStack(spacing:0){
                            NavigationLink(destination: PreferencesView(languageViewModel: languageViewModel ))
                            {
                            Label("Settings", systemImage: "p.circle")
                            }
                            NavigationLink(destination: TutorialsView())
                            {
                            Label("Tutorials", systemImage: "graduationcap")
                            }
                        }.font(.caption),
                    trailing:
                        HStack(spacing:0){
                            NavigationLink(destination: FindMyVerbDispatcher(languageViewModel: languageViewModel ))
                            {
                            Label("Find", systemImage: "magnifyingglass")
                            }
                            NavigationLink(destination: TenseSelectionView(languageViewModel: languageViewModel ))
                            {
                            Label("Tenses", systemImage: "t.circle")
                            }
                        }.font(.caption)
                    
                )
//
////                        Button{
////                            explanationPage = 1
////                        } label: {
////                            Label("Settings", systemImage: "questionmark.folder")
////                        }
//                }
                
                .fullScreenCover(isPresented: $selected, content: {
                    
                    switch languageViewModel.getCurrentExercise().title{
                        //Select
                    case "Spanish I Textbook":
                        TextBookView2(languageViewModel: languageViewModel)
                    case "Challenging Lessons":
                        TextBookViewChuck(languageViewModel: languageViewModel)
                    case "Extras":
                        SpecialsView(languageViewModel: languageViewModel)
                    case "Verb Model List": VerbModelListView(languageViewModel: languageViewModel, vmecdm: vmecdm)
//                    case "Verb Model List": VerbModelLessonView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                    case "Verb Models": AllModelsView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                    case "Verb Dictionary": DictionaryView(languageViewModel: languageViewModel, vmecdm: vmecdm, selected: $selected )
                    case "Show Current Verbs": ListVerbsForModelView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                        //Explore
                    case "3 Verbs View": ThreeVerbSimpleView(languageViewModel: languageViewModel)
                    case "Verb Cube": VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Person, d2: .Verb))
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
                    case "Explore Auxiliary Verbs": AuxiliaryPhraseView(languageViewModel: languageViewModel)
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
            
        }
        .onAppear{
            languageViewModel.setVerbModelEntityCoreDataManager(vmecdm: vmecdm)
            
            if !languageViewModel.verbCountsExistInCoreData() {
                loadFromCoreData()
            } else {
                languageViewModel.getAllVerbCountsFromCoreData()
            }
            
            if !languageViewModel.verbOrModelModeInitialized() {
                let savedMode = verbOrModelModeString
                languageViewModel.setStudyPackageTo(currentV2mChapter, currentV2mLesson)
                languageViewModel.setVerbModelTo(languageViewModel.findModelForThisVerbString(verbWord: currentVerbModelString))
                languageViewModel.setVerbOrModelMode(savedMode)
                languageViewModel.setVerbOrModelModeInitialized()
            }
            selectedCount = languageViewModel.getSelectedVerbModelList().count
            currentVerbOrModelMode = languageViewModel.getVerbOrModelMode()
            verbsExistForAll3Endings = languageViewModel.computeVerbsExistForAll3Endings()
            switch currentVerbOrModelMode {
            case .lessonMode:
                selectImageString = "SELECT Verb Lesson"
            case .modelMode:
                selectImageString = "SELECT Verb Model"
            case .specialsMode:
                selectImageString = "SELECT Special Mode"
            }
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        .foregroundColor(Color("BethanyGreenText"))
        .font(.headline)
        .padding()
        
        
    }
    func getCurrentModeString()->String{
        switch currentVerbOrModelMode{
        case .modelMode: return "Model: \(currentVerbModelString)"
        case .lessonMode: return "\(currentV2mLesson)"
        case .specialsMode: return "\(currentSpecialsOptionString)"
        }
    }
    
    func getCurrentSelectImage(_ exercise: ExerciseStruct)->Image{
        var currentImage = exercise.image
        if ( exercise.mode == .Select ){
            currentImage = Image(selectImageString)
        }
//        print("getCurrentSelectImage: selectImageString = \(selectImageString)")
        return currentImage
    }
    
    func loadFromCoreData(){
        isLoading = true
        print("is loading")
        languageViewModel.setAllVerbCountsInCoreData()
        print("finished loading")
        isLoading = false
    }
    
}

struct LoadingView : View {
    var body: some View{
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                .scaleEffect(3)
        }
    }
}


