//
//  DragDropVerbSubjectView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 4/1/22.
//

import SwiftUI
import AVFoundation

import JumpLinguaHelpers

struct DragDropVerbSubjectView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    // Mark: properties
    @State var progress : CGFloat = 0
    @State var verbWordsFrom: [DragDrop2Word] = wordMatch
    @State var subjectWordsTo: [DragDrop2Word] = wordMatch
    
    // Mark: Custom Grid Arrays
    //for drag part
    @State var shuffledRows: [[DragDrop2Word]] = []
    //for drop part
    @State var rows: [[DragDrop2Word]] = []
    
    @State var animateWrongText : Bool = false
    @State var droppedCount : CGFloat = 0
    @State var droppedCountInt = 0
    @State var tenseList = [Tense]()
    @State var currentTense = Tense.present
    @State var currentVerb = Verb()
    @State var currentPerson = Person.S1
    @State var verbWordList = [String]()
    @State var currentVerbString = ""
    @State var currentTenseString = ""
    @State var width = 0.0
    var subjectList = ["yo", "tú", "usted", "nosotros", "ellos", "ellas", "vosotros", "él", "ella", "ustedes", "nosotras", "vosotras"]
    var personList = [Person.S1, .S2, .S3, .P1, .P3, .P3, .P2, .S3, .S3, .P3, .P1, .P2]
    @State var speechModeActive = false
    
    var body: some View {
        ZStack{
//            Color("BethanyNavalBackground")
//                .ignoresSafeArea()
            
            
            VStack{
                ExitButtonViewWithSpeechIcon(setSpeechModeActive: setSpeechModeActive)
                
                NavBar()
//              Text("Drag and Drop: Verbs to Subjects   ")
                
                HStack{
                    Button{
                        loadNewProblem()
                    } label: {
                        HStack{
                            VStack{
                                Text("Verb: \(currentVerbString)")
                                Text("Tense: \(currentTenseString)" )
                            }
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.yellow)
                        }
                    }.modifier(DragAndDropButtonModifier())
                }.frame(width: 350, height: 50)

                // Mark: Drag Drop Area
                DropArea()
                    .padding(.vertical, 15)
                    .border(.yellow)
                DragArea()
                    .padding(.vertical, 15)
                    .border(.red)
                Spacer()
            }.padding()
                .foregroundColor(Color("BethanyGreenText"))
        }
        .onAppear{
            currentVerb = languageViewModel.getCurrentFilteredVerb()
            fillTenseList()
            loadNewProblem()
            
//            if rows.isEmpty{
//                //first creating shuffled one
//                //then creating normal one
//                verbWordsFrom = verbWordsFrom.shuffled()
//                shuffledRows = generateGridFrom()
//                verbWordsFrom = wordMatch
//                rows = generateGridTo()
//            }
            
        }
        .offset(x: animateWrongText ? -30 : 0)
        
        
    }
    func setSpeechModeActive(){
        speechModeActive.toggle()
        if speechModeActive {
            if speechModeActive {
                textToSpeech(text : "speech mode is active", language: .English)
            } else {
                textToSpeech(text : "speech mode has been turned off", language: .English)
            }
                
        }
    }
    
    func fillTenseList(){
        tenseList.removeAll()
        for tense in languageViewModel.getTenseList(){
            let tenseIndex =  tense.getIndex()
            //is simple indicative?
            if tenseIndex < 6 {
                tenseList.append(tense)
            }
            //or simple subjunctive
            else if tenseIndex >= Tense.presentSubjunctive.getIndex() && tenseIndex <= Tense.imperfectSubjunctiveSE.getIndex() {
                tenseList.append(tense)
            }
        }
    }
    func loadNewProblem(){
        currentVerb = languageViewModel.getRandomVerb()
        currentVerbString = currentVerb.getWordAtLanguage(language: languageViewModel.getCurrentLanguage())
        let tempTenseList = tenseList.shuffled()
        currentTense = tempTenseList[0]
        currentTenseString = currentTense.rawValue
        verbWordList.removeAll()
        
        for person in personList {
            let coreVerb = languageViewModel.getCoreVerb(verb: currentVerb)
            verbWordList.append(languageViewModel.createAndConjugateAgnosticVerb(verb: coreVerb, tense: currentTense, person: person))
        }
        var tempChallenge = fillNewDragDropWords(subjectList: subjectList, verbWordList: verbWordList)
        var newChallenge = tempChallenge.shuffled()
        verbWordsFrom = newChallenge
        subjectWordsTo = newChallenge
        verbWordsFrom = verbWordsFrom.shuffled()
        shuffledRows = generateGridFrom()
        verbWordsFrom = wordMatch
        rows = generateGridTo()
        droppedCount = 0
        droppedCountInt = 0
        progress = 0
    }
    
    // Mark: Drop area
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 6){
            ForEach($rows, id: \.self){ $row in
                HStack(spacing: 10){
                    ForEach($row){$item in
                        Text(item.valueFrom)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, 8)
                            .padding(.horizontal, item.padding)  //variable
                        
                        //                            .opacity(item.isShowing ? 1 : 0)
                            .background(){
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.15))
                                    .border(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                            .background(){
                                //if item is dropped into the correct place
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1 : 0)
                                    .background(item.isShowing ? .green : .clear)
                            }
                            .border(.yellow)
                        // Mark: adding the drop operation here
                            .onDrop(of: [.url], isTargeted: .constant(false)){
                                providers in
                                if let first = providers.first{
                                    let _ = first.loadObject(ofClass: URL.self){
                                        value, error in
                                        guard let url = value else{return}
                                        currentPerson = getPerson(personString: item.valueFrom)
                                        if replaceAccentWithDoubleLetter(characterArray: item.valueTo) == "\(url)"{
                                            droppedCount += 1
                                            droppedCountInt = droppedCountInt
                                            //                                            print("onDrop: \(item)")
                                            let progress = (droppedCount / CGFloat(subjectWordsTo.count))
                                            languageViewModel.incrementStudentCorrectScore(verb: currentVerb, tense: currentTense, person: currentPerson)
                                            let answerText =  item.valueFrom + item.valueTo
                                            if speechModeActive {
                                                textToSpeech(text: answerText, language: .Spanish)
                                            }
                                                   
                                            withAnimation{
                                                item.isShowing = true
                                                updateShuffledArray(ddWord: item)
                                                self.progress = progress
                                            }
                                        }
                                        //animating when wrong text is dropped
                                        else {
                                            animateView()
                                            languageViewModel.incrementStudentWrongScore(verb: currentVerb, tense: currentTense, person: currentPerson)
                                        }
                                        
                                    }
                                }
                                
                                return false
                            }
                    }
                }
                if rows.last != row {
                    Divider()
                }
            }
        }.foregroundColor(Color("BethanyGreenText"))
    }
    
    func getPerson(personString: String)->Person{
        switch (languageViewModel.getCurrentLanguage()){
        case .Spanish:
            if personString == "yo" { return .S1}
            if personString == "tú" { return .S2}
            if personString == "el" || personString == "ella" || personString == "usted" { return .S3}
            if personString == "nosotros" { return .P1}
            if personString == "vosotros" { return .P2}
            if personString == "ellos" || personString == "ellas" || personString == "ustedes" { return .P3}
        case .French:
            if personString == "yo" { return .S1}
            if personString == "tú" { return .S2}
            if personString == "el" || personString == "ella" || personString == "usted" { return .S3}
            if personString == "nosotros" { return .P1}
            if personString == "vosotros" { return .P2}
            if personString == "ellos" || personString == "ellas" || personString == "ustedes" { return .P3}
        case .English:
            if personString == "I" { return .S1}
            if personString == "you" { return .S2}
            if personString == "he" || personString == "she" || personString == "it" { return .S3}
            if personString == "we" { return .P1}
            if personString == "they" { return .P3}
        default:
            return .S1
        }
        return .S1
    }
    
    
    func areEqualStrings(str1: String, str2: String)->Bool{
        if str1 == str2 {return true}
        return false
    }
    
    @ViewBuilder
    func DragArea()->some View{
        VStack(spacing: 6){
            ForEach(shuffledRows, id: \.self){ row in
                HStack(spacing: 10){
                    ForEach(row){item in
                        Text(item.valueTo)
                            .font(.system(size: item.fontSize))
                            .foregroundColor(Color("BethanyGreenText"))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 3)
                            .background(){
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                            .border(.red)
                        // Mark: adding drag here
                            .onDrag{
                                return .init(contentsOf: URL(string: replaceAccentWithDoubleLetter(characterArray: item.valueTo)))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background(){
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                        
                    }
                }
                if shuffledRows.last != row {
                    Divider()
                }
            }
        }
    }
    
    // Mark: Custom Nav Bar
    @ViewBuilder
    func NavBar()->some View{
        ZStack{
            HStack(spacing: 25){
                GeometryReader{proxy in
                    ZStack(alignment: .leading){
                        Capsule()
                            .fill(.gray.opacity(0.25))
                        Capsule()
                            .fill(.green)
                            .frame(width: proxy.size.width * progress)
                    }
                }.frame(height: 20)
                
                
            }
            Text("Number completed: \(Int(droppedCount)) out of \(subjectList.count)")
                .frame(height: 20)
                .foregroundColor(.red)
        }
    }
    
    func incrementStudentCorrectScore(){
        languageViewModel.incrementStudentCorrectScore(verb: currentVerb, tense: currentTense, person: currentPerson)
//        languageViewModel.getStudentScoreModel().incrementVerbScore(value: currentVerb, correctScore: 1, wrongScore: 0)
//        languageViewModel.getStudentScoreModel().incrementTenseScore(value: currentTense, correctScore: 1, wrongScore: 0)
//        languageViewModel.getStudentScoreModel().incrementPersonScore(value: currentPerson, correctScore: 1, wrongScore: 0)
    }
    
    func incrementStudentWrongScore(){
        languageViewModel.incrementStudentWrongScore(verb: currentVerb, tense: currentTense, person: currentPerson)
//        languageViewModel.getStudentScoreModel().incrementVerbScore(value: currentVerb, correctScore: 0, wrongScore: 1)
//        languageViewModel.getStudentScoreModel().incrementTenseScore(value: currentTense, correctScore: 0, wrongScore: 1)
//        languageViewModel.getStudentScoreModel().incrementPersonScore(value: currentPerson, correctScore: 0, wrongScore: 1)
    }
    
    
    //Mark: Generating custom grid columns
    func generateGridFrom()->[[DragDrop2Word]]{
        //Step 1
        //Identifying each text width and updating it into State Variable
        for item in verbWordsFrom.enumerated(){
            let textSize = textSize(ddWord: item.element) + 30
            verbWordsFrom[item.offset].textSize = textSize
        }
        var gridArray: [[DragDrop2Word]] = []
        var tempArray: [DragDrop2Word] = []
        
        //currentWidth
        var currentWidth: CGFloat = 0
        //-30 -> Horizontal padding
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in verbWordsFrom {
            currentWidth += character.textSize
            if currentWidth < totalScreenWidth {
                tempArray.append(character)
            } else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        // checking exhaust
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        return gridArray
    }
    
    //Mark: Generating custom grid columns
    func generateGridTo()->[[DragDrop2Word]]{
        //Step 1
        //Identifying each text width and updating it into State Variable
        for item in subjectWordsTo.enumerated(){
            let textSize = textSize(ddWord: item.element) + 25
            subjectWordsTo[item.offset].textSize = textSize
        }
        var gridArray: [[DragDrop2Word]] = []
        var tempArray: [DragDrop2Word] = []
        
        //currentWidth
        var currentWidth: CGFloat = 0
        //-30 -> Horizontal padding
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in subjectWordsTo {
            currentWidth += character.textSize
            if currentWidth < totalScreenWidth {
                tempArray.append(character)
            } else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        // checking exhaust
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        return gridArray
    }
    
    //identifying the text size
    func textSize(ddWord: DragDrop2Word)->CGFloat{
        let font = UIFont.systemFont(ofSize: ddWord.fontSize)
        let attributes = [NSAttributedString.Key.font : font]
        let size = (ddWord.valueFrom as NSString).size(withAttributes: attributes)
        //horizontal padding
        return size.width + (ddWord.padding * 2) + 15
    }
    
    // Mark: Updating the shuffled array (bottom)
    func updateShuffledArray(ddWord: DragDrop2Word){
        for index in shuffledRows.indices {
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == ddWord.id {
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    // Mark: animating wrong text view
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2))
        {
        animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ){
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2))
            {
            animateWrongText = false
            }
        }
        
    }
}

//struct DragDropVerbSubjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        DragDropVerbSubjectView()
//    }
//}
