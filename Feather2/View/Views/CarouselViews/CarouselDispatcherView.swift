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

struct NavStackCarouselDispatcherView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var vmecdm: VerbModelEntityCoreDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedCount = 0
    @State var selectedModelString = ""
    @State var verbsExistForAll3Endings = true
    @State var selected  = false
    @State private var exerciseMgr = ExerciseDataManager(.Select, .normal)
    @State private var imageLength = CGFloat(125)
    @State private var multipleChoiceShown = true
    @State private var textEditorShown = true
    @State private var exerciseStructList = [
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
                Text("Verbs!").font(.title2)
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
                .navigationTitle(languageViewModel.isModelMode() ? "Model: \(languageViewModel.getStudyPackage().lesson)" : "Lesson: \(languageViewModel.getStudyPackage().lesson)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: ExerciseStruct.self){ exercise in
                    ExploreCarouselView(languageViewModel: languageViewModel, exerciseManager: ExerciseDataManager(exercise.mode, .normal), selected: $selected)
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
                    case "Verb Model List": VerbModelListView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                    case "Verb Models": AllModelsView(languageViewModel: languageViewModel, vmecdm: vmecdm)
                    case "Verb Dictionary": DictionaryView(languageViewModel: languageViewModel, vmecdm: vmecdm, selected: $selected )
                    case "Show Current Verbs": ListVerbsForModelView(languageViewModel: languageViewModel, model:  languageViewModel.getSelectedVerbModelList()[0])
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
                selectedCount = languageViewModel.getSelectedVerbModelList().count
                print("NavStackCarouselDispatcherView:  selectedCount = \(selectedCount)")
                if languageViewModel.getSelectedNewVerbModelType() != .undefined && languageViewModel.getSelectedVerbModelList().count > 0 {
                    selectedModelString = languageViewModel.getSelectedVerbModelList()[0].modelVerb
                } else {
                    selectedModelString = "No model selected"
                }
                verbsExistForAll3Endings = languageViewModel.computeVerbsExistForAll3Endings()
                languageViewModel.fillFlashCardsForProblemsOfMixedRandomTenseAndPerson()
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
        .foregroundColor(Color("BethanyGreenText"))
        .font(.headline)
        .padding()
        
        
    }
}



