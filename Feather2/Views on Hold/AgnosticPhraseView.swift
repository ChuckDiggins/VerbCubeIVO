//
//  AgnosticPhraseView.swift
//  Feather2
//
//  Created by Charles Diggins on 12/30/22.
//

import SwiftUI

//
//  PhasesInAgnosticOrSingleLanguageView.swift
//  PhasesInAgnosticOrSingleLanguageView
//
//  Created by Charles Diggins on 1/21/22.
//

import SwiftUI
import JumpLinguaHelpers

struct AgnosticPhraseView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    var featherPhraseType : FeatherPhraseType
    @State var maxDisplayLines = 1
    @State var singleIndexList = [[Int]]()
    @State var singleList = [dSingle]()
    @State var singleStringList = [String]()
    @State var phraseStringList = [String]()
    @State var phraseColorList = [Color]()
    @State var wordTypeList = [String]()
    @State var newWordSelected = [Bool]()
    @State var backgroundColor = [Color]()
    @State var currentSingleIndex = 0
    @State var currentVerbString = ""
    @State var phraseIndexMapping = [PhraseIndexMapping]()
    
    //@State private var currentLanguageString = ""
    @State var currentTense = Tense.preterite
    @State private var currentPerson = Person.S3
    @State private var sentenceString: String = ""
    
    @State private var englishSingleList = [dSingle]()
    @State var m_clause = dIndependentAgnosticClause()
    @State var m_englishClause = dIndependentAgnosticClause()
    @State var m_clauseManipulation : ClauseManipulation?
    
    @State var defaultBackgroundColor = Color.yellow
    @State var highlightBackgroundColor = Color.black
    
    //@State private var newWordSelected = false
    
    @State var m_randomSentence : FeatherSentenceHandler!
    
    @State var hasClause = false
    @State private var isSubject = false
    @State var showWorkSheet = false
    
    @State var spanishActivated  = true
    @State var frenchActivated = false
    @State var englishActivated = false
    
    
    @State private var selectedPhraseIndex = 4
    @State var clauseModel = ClauseModel()
    
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                VStack{
                    Text("Phrase type: \(featherPhraseType.rawValue)").font(.subheadline)
                }
                .labelsHidden()
                .font(.subheadline)
                .padding(10)
                
                VStack(alignment: .center){
                    Text("Current verb: \(currentVerbString)")
                    Button(action: {
                        generateRandomTense()
                    }){
                        HStack {
                            Text("Tense: \(currentTense.rawValue)")
                        }
                    }
                }.buttonStyle(.borderedProminent)
                VStack {
                    if ( hasClause ){
                        if ( spanishActivated ){
                            SentenceView(language: .Spanish, changeWord: {self.changeWord()}, clauseModel: clauseModel)}
                        if ( frenchActivated ){
                            SentenceView(language: .French, changeWord: {self.changeWord()}, clauseModel: clauseModel)}
                        if ( englishActivated ){
                            SentenceView(language: .English, changeWord: {self.changeWord()}, clauseModel: clauseModel)
                        }
                    }
                }.onAppear{
                    singleIndexList = Array(repeating: Array(repeating: 0, count: 10), count: 5)
                    singleIndexList[1][0] = 1
                    singleIndexList[2][0] = 2
                    m_clauseManipulation = ClauseManipulation(m_clause: m_clause)
//                    languageViewModel.createNewCFModel(language: .Agnostic)
                    currentTense = languageViewModel.getNextTense()
                    createRandomClause()
                    m_randomSentence = languageViewModel.getRandomSentenceObject()
                    hasClause.toggle()
                }
                .padding(10)
                .border(Color.green)
                .background(Color.white)
                VStack{
                    HStack(alignment: .center){
                        Spacer()
                        Button(action: {createRandomClause( )}) {
                            Text("Randomize")
                                .buttonStyle(.borderedProminent)
                        }
                        Spacer()
                    }
                }
                .padding()
            }
            .padding()
        }//geometryReader
    }
    
    func changeWord(){
        let single = singleList[clauseModel.currentSingleIndex]
        currentPerson = languageViewModel.getRandomPerson()
        m_clause.setTense(value: currentTense)
        m_clause.setPerson(value: currentPerson)
        isSubject = single.m_sentenceData.isSubject
        print("changeWord before: tense=\(currentTense.rawValue), person=\(currentPerson.getMaleString())")
        m_clauseManipulation!.changeWordInClause(languageViewModel: languageViewModel, single: single, isSubject: isSubject)
        m_clauseManipulation!.handleFrenchContractions(singleList: m_clause.getSingleList())
        currentPerson = m_clause.getPerson()
        currentTense = m_clause.getTense()
        print("changeWord after: tense=\(currentTense.rawValue), person=\(currentPerson.getMaleString())")
        sentenceString = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .Spanish, tense: currentTense, person: currentPerson)
        sentenceString = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .French, tense: currentTense, person: currentPerson)
        sentenceString = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .English, tense: currentTense, person: currentPerson)
        updateCurrentSentenceViewStuff()
    }
    
    func generateRandomTense(){
        currentTense = languageViewModel.getNextTense()
        print("generateRandomTense before: tense=\(currentTense.rawValue), person=\(currentPerson.getMaleString())")
        sentenceString = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .Spanish, tense: currentTense, person: currentPerson)
        sentenceString = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .French, tense: currentTense, person: currentPerson)
        sentenceString = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .English, tense: currentTense, person: currentPerson)
        print("generateRandomTense after: tense=\(currentTense.rawValue), person=\(currentPerson.getMaleString())")
        updateCurrentSentenceViewStuff()
    }
    
    func createRandomClause(){
        let tense = currentTense
        if languageViewModel.getTenseList().count>1{
            while tense == currentTense {
                currentTense = languageViewModel.getRandomTense()
            }
        }
        print("createRandomClause before: tense=\(currentTense.rawValue), person=\(currentPerson.getMaleString())")
        languageViewModel.getRandomAgnosticSentence(clause: m_clause, fpt: .subjectPronounVerb)
        m_clause.setHeadNounAndHeadVerb()
        let currentPerson = m_clause.getPerson()
        let ss  = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .Spanish, tense: currentTense, person: currentPerson)
//        print("Spanish phrase: \(ss)")
        print("createRandomClause after: tense=\(currentTense.rawValue), person=\(currentPerson.getMaleString())")
        let fs  = m_clause.setTenseAndPersonAndCreateNewSentenceString(language: .French, tense: currentTense, person: currentPerson)
//        print("French phrase: \(fs)")
        
        m_englishClause.copy(inClause: m_clause)
        m_englishClause.convertRomancePhraseOrderToEnglishPhraseOrder()
        let es  = m_englishClause.setTenseAndPersonAndCreateNewSentenceString(language: .English, tense: currentTense, person: currentPerson)
//        print("English phrase: \(es)")
        updateCurrentSentenceViewStuff()
    }
    
    
    func updateCurrentSentenceViewStuff(){
        
        var letterCount = 0
        var singleCount = 0
        backgroundColor.removeAll()
        singleList.removeAll()
        singleList = m_clause.getSingleList()
        englishSingleList = m_englishClause.getSingleList()
        currentSingleIndex = clauseModel.currentSingleIndex
        singleStringList = m_clause.getSingleStringList(language: .Spanish)
        wordTypeList = m_clause.getWordTypeList()
        phraseStringList = m_clause.getParentPhraseTypeList()
        
        //AgnosticPhraseMapping
        for i in 0..<phraseStringList.count {
            phraseColorList.append(.green)
            let pim = PhraseIndexMapping(cfs : singleList[i].getWordType(), agnosticIndex: i, spanishIndex: i, englishIndex: i, frenchIndex: i)
            phraseIndexMapping.append(pim)
        }
    
        for single in singleList {
            letterCount += single.getProcessWordInWordStateData(language: .Spanish).count + 1
            singleCount += 1
            if letterCount > 30 {break}
        }
        
        //up to three lines
        
        for i in 0..<3  { singleIndexList[i].removeAll() }
        
        newWordSelected.removeAll()
        
        maxDisplayLines = 1
        for i in 0 ..< singleCount {
            singleIndexList[0].append(i)
            newWordSelected.append(false)
            backgroundColor.append(defaultBackgroundColor)
        }
        
        if singleCount < singleList.count {maxDisplayLines = 2}
        
        for i in singleCount ..< singleList.count {
            singleIndexList[1].append(i)
            newWordSelected.append(false)
            backgroundColor.append(defaultBackgroundColor)
        }
        
        clauseModel.set(currentSingleIndex: currentSingleIndex,
                                  maxLines: maxDisplayLines,
                                  singleIndexListForEachLine: singleIndexList,
                                  singleList: singleList, englishSingleList: englishSingleList,
                                  newWordSelected: newWordSelected,
                                  backGroundColor: backgroundColor)
        
        var currentVerbString = m_clause.getHeadVerb().getWordStringAtLanguage(language: languageViewModel.currentLanguage)
        //backgroundColor[currentSingleIndex] = highlightBackgroundColor
    }
    
//    func processSentence2(){
//        m_clause = cfModelView.getAgnosticRandomSubjPronounSentence()
//        sentenceString = m_clause.createNewSentenceString(language: .Spanish)
//        singleList = m_clause.getSingleList()
//    }
//
    
    
    struct ClauseWorkSheet: View {
        @Environment(\.presentationMode) var presentationMode
        @State var m_clause : dIndependentAgnosticClause
        @State var singleStringList : [String]
        @State var phraseStringList : [String]
        @State var phraseColorList : [Color]
        @State var wordTypeList : [String]
        
        var colors: [Color] = [.blue, .yellow, .green]
        var gridItems = [GridItem(.fixed(20.0)),
                         GridItem(.flexible()),
                         GridItem(.flexible()),
                         GridItem(.fixed(30.0))]
        var languageGridItems = [GridItem(.flexible()),
                         GridItem(.flexible()),
                         GridItem(.flexible())]
        
        var body: some View {
            ZStack(alignment: .topLeading){
                Color.gray
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.green)
                            .font(.largeTitle)
                            .padding(20)
                    })
                    LazyVGrid(columns: languageGridItems, spacing: 5){
                        FeatherWordCell(thisLanguage: .English, wordText: "English", backgroundColor: .gray, foregroundColor: .yellow, fontSize: .system(size: 20),
                                 function: fillStringLists )
                        FeatherWordCell(thisLanguage: .Spanish, wordText: "Spanish", backgroundColor: .gray, foregroundColor: .yellow, fontSize: .system(size: 20),
                                 function: fillStringLists)
                        FeatherWordCell(thisLanguage: .French, wordText: "French", backgroundColor: .gray, foregroundColor: .yellow, fontSize: .system(size: 20),
                                 function: fillStringLists)
                    }
                    Text("Agnostic clause items")
                    //NavigationView {
                    ScrollView{
                        LazyVGrid(columns: gridItems, spacing: 5){
                            ForEach ((0..<singleStringList.count), id: \.self){ index in
                                FeatherWordCellButton(wordText: "\(index)", backgroundColor: .blue, foregroundColor: .black, fontSize: Font.subheadline)
                                FeatherWordCellButton(wordText: singleStringList[index], backgroundColor: .yellow, foregroundColor: .black, fontSize: Font.subheadline)
                                FeatherWordCellButton(wordText: phraseStringList[index], backgroundColor: phraseColorList[index], foregroundColor: .black, fontSize: Font.subheadline)
                                FeatherWordCellButton(wordText: wordTypeList[index], backgroundColor: .green, foregroundColor: .black, fontSize: Font.subheadline)
                            }
                        }
                        //}.navigationBarTitle("Clause items")
                    }
                    
                }
            }
        }
        
        func fillStringLists(language: LanguageType){
            singleStringList = m_clause.getSingleStringList(language: language)
            wordTypeList = m_clause.getWordTypeList()
            phraseStringList = m_clause.getParentPhraseTypeList()
            phraseColorList.removeAll()
            for i in 0 ..< phraseStringList.count {
                if phraseStringList[i] == "NP" { phraseColorList.append(.green) }
                else if phraseStringList[i] == "VP" { phraseColorList.append(.blue) }
                else if phraseStringList[i] == "PP" { phraseColorList.append(.yellow) }
                else { phraseColorList.append(.yellow) }
            }
        }
        
        
        struct DrawingConstants {
            static let cardSize: CGFloat = 60
            static let opacity: CGFloat = 0.6
            static let fontSize: CGFloat = 32.0
        }

        
    }
    

}

struct FeatherWordCell: View {
    var thisLanguage: LanguageType
    //var m_clause: dIndependentAgnosticClause
    var wordText : String
    var backgroundColor: Color
    var foregroundColor: Color
    var fontSize : Font
    var function: (_ language: LanguageType) -> Void

    var body: some View {
        Button(wordText){
            function(thisLanguage)
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
        .font(fontSize)

    }


}

struct FeatherWordCellButton: View {
    //var language : LanguageType
    //var word: Word
    var wordText : String
    var backgroundColor: Color
    var foregroundColor: Color
    var fontSize : Font
    //var function: (_ word: Word) -> Void
    @State private var showingSheet = false

    var body: some View {
        Button(wordText)
        {
//            showingSheet.toggle()
        }
//        .rotationEffect(Angle.degrees(showingSheet ? 360 : 0))
//                .animation(Animation.easeInOut)
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
        .font(fontSize)


        //        .sheet(isPresented: $showingSheet){
        //            switch word.wordType {
        //            case .adjective:
        //                AgnosticWordView(word: word)
        //            case .verb:
        //                AgnosticVerbView(word: word)
        //            default:
        //                AgnosticWordView(word: word)
        //            }

    }
}

//struct PhrasesInAgnosticOrSingleLanguageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhrasesInAgnosticOrSingleLanguageView()
//    }
//}
