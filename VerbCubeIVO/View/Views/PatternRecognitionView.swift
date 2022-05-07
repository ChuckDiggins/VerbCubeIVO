//
//  PatternRecognitionView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/23/22.
//

import SwiftUI
import JumpLinguaHelpers

enum MultipleChoiceMode : String {
    case IdentifyVerbsBelongingToModel = "Identify verbs belonging to this model:"
    case IdentifyModelsThatHaveGivenPattern = "Identify models that have this pattern:"
    case IdentifyVerbsThatHaveGivenPattern = "Identify verbs that have this pattern"
    case IdentifyVerbsThatHaveSameModelAsVerb = "Identify verbs that have same model as"
    case IdentifyVerbsWithSamePatternAsVerb = "Identify verbs that have the same pattern as:"
    case IdentifyModelForGivenVerb = "Identify the model for this verb:"
    case CreateVerbForGivenModel = "Create a verb for this model:"
    
    func getTitle()->String{
        switch self{
        case .IdentifyVerbsBelongingToModel:
            return "Verbs in Model"
        case .IdentifyModelsThatHaveGivenPattern:
            return "Models for Pattern"
        case .IdentifyVerbsThatHaveGivenPattern:
            return "Verbs with Same Pattern"
        case .IdentifyVerbsThatHaveSameModelAsVerb:
            return "Verbs for Same Model"
        case .IdentifyVerbsWithSamePatternAsVerb:
            return "Verbs for Pattern"
        case .IdentifyModelForGivenVerb:
            return "Model for Given Verb"
        case .CreateVerbForGivenModel:
            return "Create a Verb"
        }
        
    }
}

struct MultipleChoiceStruct : Identifiable, Hashable {
    var id = UUID()
    var answer : String
    var isCorrect = false
    var studentClicked = false
    
//    public init(){
//        self.answer = ""
//    }
//
//    public init(answer: String){
//        self.answer = answer
//    }
//
//    public init(answer: String){
//        self.answer = answer
//    }
}

struct MultipleChoiceWordCellButton: View {
    @State var mcs : MultipleChoiceStruct
    var foregroundColor: Color
    var fontSize : Font
    //var function: (_ word: Word) -> Void
    
    var body: some View {
        Button(mcs.answer){
            mcs.studentClicked.toggle()
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(mcs.studentClicked && mcs.isCorrect ? .green : .yellow)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
        .font(fontSize)
    }
}

struct PatternRecognitionView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    @State var multipleChoiceList = [MultipleChoiceStruct]()
    @State private var model = 58
    @State private var pattern = SpecialPatternType.e2ie
    @State private var mcs = MultipleChoiceStruct(answer : "")
    @State private var headerStringPart1 = ""
    @State private var headerStringPart2 = ""
    var multipleChoiceMode : MultipleChoiceMode
    var backgroundColor = Color.yellow
    var foregroundColor = Color.black
    var fontSize = Font.callout
    var maxListCount = 20
    @State var showMeCorrectAnswers = false
    @State var totalCorrectCount = 0
    @State var correctAnswerCount = 0
    @State var problemInstruction = "Select the answers"
    @State var correctMessageString = "Correct"
    @State var moreInfoString = "Correct"
    @State var showGreen = false
    @State var progressValue: Float = 0.0
    
    var body: some View {
        //        NavigationView{
        VStack{
            let gridFixSize = CGFloat(100.0)
            let gridItems = [GridItem(.fixed(gridFixSize)),
                             GridItem(.fixed(gridFixSize)),
                             //                                         GridItem(.fixed(gridFixSize)),
                             GridItem(.fixed(gridFixSize))]
            
            let filterGridItems = [GridItem(.flexible()),
                                   GridItem(.flexible())]
            
            Button{
                createAProblem()
            } label: {
                
                Text("New problem")
                    .bold()
                    .frame(width: 200, height: 30)
                    .foregroundColor(.indigo)
                    .background(.linearGradient(colors: [.mint, .white], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(radius: 3)
                    .padding(10)
            }
            
            Text(problemInstruction)
                .bold()
                .frame(width: 500, height: 30)
                .font(.title)
                .foregroundColor(.indigo)
                .background(.linearGradient(colors: [.black, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 3)
                .padding(10)
            
            ProgressBar(value: $progressValue).frame(height: 20)
            Text(correctMessageString)
                .bold()
                .frame(width: 500, height: 30)
                .font(correctAnswerCount<totalCorrectCount ? .title : .title2)
                .foregroundColor(.indigo)
                .background(correctAnswerCount<totalCorrectCount ? .green : .red)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 3)
                .padding(10)
            
            VStack{
                Text(headerStringPart1)
                    .background(.black)
                    .font(.callout)
                Text(headerStringPart2)
                    .frame(width: 200, height: 30)
                    .background(.white)
                    .foregroundColor(.red)
                    .font(.title)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Button{
                    showMeCorrectAnswers.toggle()
                } label: {
                    Text(showMeCorrectAnswers ? "Sneak peek on 🐵" : "Sneak peek off 🙈")
                        .bold()
                        .frame(width: 250, height: 30)
                        .font(.title)
                        .foregroundColor(.black)
                        .background(showMeCorrectAnswers ? .green : .yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(radius: 3)
                        .padding(10)
                }
                
            }
            .padding(10)
            
            
            LazyVGrid(columns: filterGridItems, spacing: 5){
                ForEach (0..<multipleChoiceList.count, id: \.self){ i in
                    //                    ForEach( multipleChoiceList, id: \.self ){ id in
                    //                       MultipleChoiceWordCellButton(mcs: mcs, foregroundColor: foregroundColor, fontSize: fontSize )
                    Button(multipleChoiceList[i].answer){
                        multipleChoiceList[i].studentClicked.toggle()
                        computeCorrectAnswerCount()
                    }
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                    .background( (showMeCorrectAnswers && multipleChoiceList[i].isCorrect) || (!showMeCorrectAnswers && multipleChoiceList[i].studentClicked && multipleChoiceList[i].isCorrect) ? .green : .yellow )
                    .foregroundColor(foregroundColor)
                    .cornerRadius(8)
                    .font(fontSize)
                }
                
            }
            Spacer()
        }
        
        .onAppear{
            currentLanguage = languageViewModel.getCurrentLanguage()
            createAProblem()
        }
        
        //            }
        
    }
    
    
    func computeCorrectAnswerCount(){
        correctAnswerCount = 0
        for mcs in multipleChoiceList{
            if mcs.isCorrect && mcs.studentClicked { correctAnswerCount += 1 }
        }
        progressValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
        correctMessageString = "Congratuations!"
        if correctAnswerCount < totalCorrectCount {
            correctMessageString = "Correct \(correctAnswerCount) out of \(totalCorrectCount)"
        }
        
        //show alert
    }
    
    func createAProblem(){
        correctAnswerCount = 0
        progressValue = 0.0
        switch multipleChoiceMode {
        case .IdentifyVerbsBelongingToModel: fillIdentifyVerbsBelongingToModel()
        case .IdentifyModelsThatHaveGivenPattern:fillIdentifyModelsThatHaveGivenPattern()
        case .IdentifyVerbsThatHaveGivenPattern:fillIdentifyVerbsThatHaveGivenPattern()
            
        case .IdentifyVerbsThatHaveSameModelAsVerb:fillIdentifyVerbsThatHaveSameModelAsVerb()
        case .IdentifyVerbsWithSamePatternAsVerb:fillIdentifyVerbsWithSamePatternAsVerb()
            
        case .IdentifyModelForGivenVerb:fillIdentifyModelForGivenVerb()
        case .CreateVerbForGivenModel:fillAnswerArray()
        }
        
        totalCorrectCount = 0
        for mc in multipleChoiceList {
            if mc.isCorrect {totalCorrectCount += 1}
        }
        computeCorrectAnswerCount()
        problemInstruction = multipleChoiceMode.getTitle()
    }
    
    func fillIdentifyVerbsBelongingToModel(){
        let vu = VerbUtilities()
        var rvmList = languageViewModel.getCommonVerbModelList().shuffled()
        let primaryVerbModel = rvmList[0]
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = primaryVerbModel.modelVerb
        moreInfoString = "Model ID = \(primaryVerbModel.id)"
        
        var verbEnding = VerbEnding.AR
        switch currentLanguage {
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: primaryVerbModel.modelVerb)
            verbEnding = result.verbEnding
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: primaryVerbModel.modelVerb)
            verbEnding = result.verbEnding
        default: break
        }
        
        //get list of verbs from model with same verb ending as primary model
        rvmList.removeFirst()
        var verbEndingModelList = languageViewModel.getModelsWithSameVerbEndingInModelList(verbEnding: verbEnding, modelList: rvmList)
        if verbEndingModelList.isEmpty {
            verbEndingModelList = languageViewModel.getModelsWithVerbEnding(verbEnding: verbEnding)
        }
        let wrongVerbList = languageViewModel.findVerbsOfSameModel(targetID: verbEndingModelList[0].id)
        
        let verbList = languageViewModel.findVerbsOfSameModel(targetID: primaryVerbModel.id)
        multipleChoiceList.removeAll()
        for verb in verbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage), isCorrect: true))
        }
        for verb in wrongVerbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage)))
        }
        
        let extras = multipleChoiceList.count - maxListCount
        if extras > 0 {
            multipleChoiceList = multipleChoiceList.dropLast(extras)
        }
        multipleChoiceList.shuffle()
    }
    
    func fillIdentifyVerbsThatHaveSameModelAsVerb(){
        let vu = VerbUtilities()
        var rvmList = languageViewModel.getCommonVerbModelList().shuffled()
        let primaryVerbModel = rvmList[0]
        
        var verbEnding = VerbEnding.AR
        switch currentLanguage {
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: primaryVerbModel.modelVerb)
            verbEnding = result.verbEnding
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: primaryVerbModel.modelVerb)
            verbEnding = result.verbEnding
        default: break
        }
        
        //get list of verbs from model with same verb ending as primary model
        rvmList.removeFirst()
        var verbEndingModelList = languageViewModel.getModelsWithSameVerbEndingInModelList(verbEnding: verbEnding, modelList: rvmList)
        if verbEndingModelList.isEmpty {
            verbEndingModelList = languageViewModel.getModelsWithVerbEnding(verbEnding: verbEnding)
        }
        let wrongVerbList = languageViewModel.findVerbsOfSameModel(targetID: verbEndingModelList[0].id)
        
        var verbList = languageViewModel.findVerbsOfSameModel(targetID: primaryVerbModel.id)
        verbList.shuffle()
        let targetVerb = verbList[0]
        verbList.removeFirst()
        
        multipleChoiceList.removeAll()
        for verb in verbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage), isCorrect: true))
        }
        for verb in wrongVerbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage)))
        }
        
        let extras = multipleChoiceList.count - maxListCount
        if extras > 0 {
            multipleChoiceList = multipleChoiceList.dropLast(extras)
        }
        multipleChoiceList.shuffle()
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = targetVerb.getWordAtLanguage(language: currentLanguage)
        if languageViewModel.isVerbType(verb: targetVerb, verbType: .STEM){moreInfoString = "Stem changing"}
        else if languageViewModel.isVerbType(verb: targetVerb, verbType: .ORTHO){moreInfoString = "Spell changing"}
        else { moreInfoString = "Model verb is \(primaryVerbModel.modelVerb)"}
    }
    
    func fillIdentifyModelsThatHaveGivenPattern(){
        var modelList = [RomanceVerbModel]()
        let patternList = SpecialPatternType.stemChangingCommonSpanish.shuffled()
        let primaryPattern = patternList[0]
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = primaryPattern.rawValue
        moreInfoString = "Stem changing"
        
        let primaryPatternStruct = SpecialPatternStruct(tense:.present, spt: primaryPattern)
        modelList = languageViewModel.getModelsOfPattern(verbList: languageViewModel.getVerbList(), thisPattern: primaryPatternStruct)
        multipleChoiceList.removeAll()
        for model in modelList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: model.modelVerb, isCorrect: true))
        }
        let secondaryPattern = patternList[1]
        let secondaryPatternStruct = SpecialPatternStruct(tense:.present, spt: secondaryPattern)
        modelList = languageViewModel.getModelsOfPattern(verbList: languageViewModel.getVerbList(), thisPattern: secondaryPatternStruct)
        for model in modelList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: model.modelVerb))
        }
        
        let extras = multipleChoiceList.count - maxListCount
        if extras > 0 {
            multipleChoiceList = multipleChoiceList.dropLast(extras)
        }
        multipleChoiceList.shuffle()
    }
    
    func fillIdentifyVerbsWithSamePatternAsVerb(){
        //select a random pattern
        
        let patternList = SpecialPatternType.stemChangingCommonSpanish.shuffled()
        let primaryPattern = patternList[0]
        
        
        //find verbs with this pattern
        multipleChoiceList.removeAll()
        var verbList = languageViewModel.getVerbsOfPattern(verbList: languageViewModel.getVerbList(), thisPattern: SpecialPatternStruct(tense: .present, spt: primaryPattern))
        //pull the first verb from shuffled verbList and remove it from the verbList
        verbList.shuffle()
        var targetVerb = verbList[0]
        verbList.removeFirst()
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = targetVerb.getWordAtLanguage(language: currentLanguage)
        
        multipleChoiceList.removeAll()
        for verb in verbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage), isCorrect: true))
        }
        
        //find verbs that do not have this pattern
        let otherVerbList = languageViewModel.getVerbsOfDifferentPattern(verbList: languageViewModel.getVerbList(), thisPattern: SpecialPatternStruct(tense: .present, spt: primaryPattern))
        for verb in otherVerbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage)))
        }
        multipleChoiceList.shuffle()
        let extras = multipleChoiceList.count - maxListCount
        if extras > 0 {
            multipleChoiceList = multipleChoiceList.dropLast(extras)
        }
        
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = targetVerb.getWordAtLanguage(language: currentLanguage)
        moreInfoString = primaryPattern.rawValue
        
    }
    
    func fillIdentifyVerbsThatHaveGivenPattern(){
        //select a random pattern
        
        let patternList = SpecialPatternType.stemChangingCommonSpanish.shuffled()
        let primaryPattern = patternList[0]
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = primaryPattern.rawValue
        moreInfoString = "Select all that pertain"
        
        //find verbs with this pattern
        multipleChoiceList.removeAll()
        let verbList = languageViewModel.getVerbsOfPattern(verbList: languageViewModel.getVerbList(), thisPattern: SpecialPatternStruct(tense: .present, spt: primaryPattern))
        for verb in verbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage), isCorrect: true))
        }
        
        //find verbs that do not have this pattern
        let otherVerbList = languageViewModel.getVerbsOfDifferentPattern(verbList: languageViewModel.getVerbList(), thisPattern: SpecialPatternStruct(tense: .present, spt: primaryPattern))
        for verb in otherVerbList {
            multipleChoiceList.append(MultipleChoiceStruct(answer: verb.getWordAtLanguage(language: currentLanguage)))
        }
        multipleChoiceList.shuffle()
        let extras = multipleChoiceList.count - maxListCount
        if extras > 0 {
            multipleChoiceList = multipleChoiceList.dropLast(extras)
        }
        
    }
    
    func fillIdentifyModelForGivenVerb(){
        let vu = VerbUtilities()
        var rvmList = languageViewModel.getCommonVerbModelList().shuffled()
        let primaryVerbModel = rvmList[0]
        
        //get a random verb from library that belongs to primaryVerbModel
        var targetVerbList = languageViewModel.findVerbsOfSameModel(targetID: primaryVerbModel.id)
        targetVerbList.shuffle()
        var targetVerb = targetVerbList[0]
        //find a target ver which is not the model verb, if any
        for v in targetVerbList{
            if v.getWordAtLanguage(language: currentLanguage) != primaryVerbModel.modelVerb{
                targetVerb = v
                break
            }
        }
        headerStringPart1 = multipleChoiceMode.rawValue
        headerStringPart2 = targetVerb.getWordAtLanguage(language: currentLanguage)
        if languageViewModel.isVerbType(verb: targetVerb, verbType: .STEM){moreInfoString = "Stem changing"}
        else if languageViewModel.isVerbType(verb: targetVerb, verbType: .ORTHO){moreInfoString = "Spell changing"}
        else { moreInfoString = "Model verb is \(primaryVerbModel.modelVerb)"}
        
        //get the verb ending for the primaryVerbModel so we can look for other model with the same ending
        var verbEnding = VerbEnding.AR
        switch currentLanguage {
        case .Spanish:
            let result = vu.analyzeSpanishWordPhrase(testString: primaryVerbModel.modelVerb)
            verbEnding = result.verbEnding
        case .French:
            let result = vu.analyzeFrenchWordPhrase(phraseString: primaryVerbModel.modelVerb)
            verbEnding = result.verbEnding
        default: break
        }
        
        //get list of verbs from model with same verb ending as primary model
        rvmList.removeFirst()
        
        let verbEndingModelList = languageViewModel.getModelsWithVerbEnding(verbEnding: verbEnding)
        
        var compositeModelString = "\(primaryVerbModel.id): \(primaryVerbModel.modelVerb)"
        multipleChoiceList.removeAll()
        multipleChoiceList.append(MultipleChoiceStruct(answer: compositeModelString, isCorrect: true))
        for model in verbEndingModelList {
            if model.id != primaryVerbModel.id {
                compositeModelString = "\(model.id): \(model.modelVerb)"
                multipleChoiceList.append(MultipleChoiceStruct(answer: compositeModelString))
            }
        }
        
        let extras = multipleChoiceList.count - maxListCount
        if extras > 0 {
            multipleChoiceList = multipleChoiceList.dropLast(extras)
        }
        multipleChoiceList.shuffle()
    }
    
    func fillAnswerArray(){
        multipleChoiceList.removeAll()
        multipleChoiceList.append(MultipleChoiceStruct(answer: "estar"))
        multipleChoiceList.append(MultipleChoiceStruct(answer: "tender"))
        multipleChoiceList.append(MultipleChoiceStruct(answer: "encontrar", isCorrect: true))
        multipleChoiceList.append(MultipleChoiceStruct(answer: "finguir"))
        multipleChoiceList.append(MultipleChoiceStruct(answer: "conseguir"))
        multipleChoiceList.append(MultipleChoiceStruct(answer: "tener"))
    }
}

//struct PatternRecognitionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatternRecognitionView(multipleChoiceMode: .IdentifyVerbsBelongingToModel)
//    }
//}
