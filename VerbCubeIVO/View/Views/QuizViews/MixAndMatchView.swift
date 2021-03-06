//
//  MixAndMatchView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 5/8/22.
//

import SwiftUI
import JumpLinguaHelpers
import AVFoundation

struct MixMatchStruct: Identifiable, Hashable, Equatable{
    var id = UUID().uuidString
    var matchID : Int
    var person: Person
    var subjectString: String
    var verbString: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 15
    var isShowing: Bool = false
    var isMatched: Bool = false
    
    init(){
        self.matchID = 0
        self.person = .S1
        self.subjectString = "yo"
        self.verbString = "tengo"
    }
    
    init(matchID: Int, person: Person, subjectString: String, verbString: String){
        self.matchID = matchID
        self.person = person
        self.subjectString = subjectString
        self.verbString = verbString
    }
}

struct PersonMixStruct: Identifiable, Hashable, Equatable{
    var id = UUID().uuidString
    var person : Person
    var personString : String
}


//
//func displaySoundsAlert() {
//    let alert = UIAlertController(title: "Play Sound", message: nil, preferredStyle: UIAlertController.Style.alert)
//    for i in 1000...1010 {
//        alert.addAction(UIAlertAction(title: "\(i)", style: .default, handler: {_ in
//            AudioServicesPlayAlertSound(UInt32(i))
//            self.displaySoundsAlert()
//        }))
//    }
//    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//    self.present(alert, animated: true, completion: nil)
//}


struct MixAndMatchView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @State private var currentLanguage = LanguageType.Spanish
    @State var currentTense = Tense.present
    @State var currentVerb = Verb()
    @State var currentModelString = ""
    @State var currentVerbString = ""
    @State var currentTenseString = ""
    @State private var mixMatchList = [MixMatchStruct]()
    @State private var subjectStringList = [String]()
    @State private var matchStringList = [String]()
    @State private var verbStringList = [String]()
    @State private var isThisVerbAMatch = [false]
    @State private var isThisSubjectAMatch = [false]
    @State private var isThisSubjectDisabled = [false]
    @State private var isThisVerbDisabled = [false]
    @State private var verbMatchID = [false]
    @State private var subjectMatchID = [false]
    @State private var matchString = ""
    @State private var verbString = ""
    @State private var subjectString = ""
    @State private var mixIndex = 0
    @State private var matchIndex = 0
    @State var progressValue: Float = 0.0
    @State private var correctAnswerCount = 0
    @State private var totalCorrectCount = 0
    @State private var personMixString = [PersonMixStruct]()
    @State private var subjunctiveParticiple = ""
    @State private var isHelpExpanded = false
    @State private var allSubjects = false
    @State private var showAlert = false
    
    
    var body: some View {
        helpView()
        ZStack{
            Color("GeneralColor")
                .ignoresSafeArea()
            VStack{
                Text("Mix and Match").font(.title2).bold()
                setVerbAndTenseView()
                ZStack{
                    ProgressBar(value: $progressValue, barColor: .red).frame(height: 20)
                    Text("Correct \(correctAnswerCount) out of \(totalCorrectCount)").foregroundColor(.black)
                    
                }
                
                //
                .frame(width: 300, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 3)
                .onAppear{
                    
                    currentLanguage = languageViewModel.getCurrentLanguage()
                    currentTense = languageViewModel.getCurrentTense()
                    currentVerb = languageViewModel.getCurrentFilteredVerb()
                    currentVerbString = currentVerb.getWordAtLanguage(language: currentLanguage)
                    currentTenseString = currentTense.rawValue
                    fillPersonMixStruct()
                    fillMixMatchList()
                }.background( isThisVerbAMatch[matchIndex] && isThisSubjectAMatch[mixIndex] ? .green : .yellow)
                    .foregroundColor(.black)
                    .font(.body)
                
                
                
                Text("Click subject on left, click matching verb on right")
                    .foregroundColor(.black)
                    .background(.white)
                HStack{
                    
                    VStack{
                        
                        ForEach(subjectStringList.indices, id: \.self) { index in
                            MixCellButton(index: index, wordText: subjectStringList[index], matchText: matchStringList[index], matchID: 0,
                                          backgroundColor : isThisSubjectAMatch[index] ? .green: .yellow,
                                          disabled: isThisSubjectDisabled[index] ? true : false,
                                          function: getWordToMatch )
                        }
                    }
                    
                    VStack{
                        
                        ForEach(verbStringList.indices, id: \.self) { index in
                            MatchCellButton(index: index, wordText: verbStringList[index], matchID: 0, backgroundColor : isThisVerbAMatch[index] ? .green : .yellow,
                                            disabled: isThisVerbDisabled[index] ? true : false,
                                            function: isMatch)
                        }
                    }
                    
                }
                Spacer()
            }
            if showAlert {
                CustomAlertView(show: $showAlert )
            }
        }
        
    }
    
    func getAlert()->Alert{
        return Alert (
            title: Text("Congratulations"),
            message: Text("Click ok to move to next problem"),
            primaryButton: .cancel(),
            secondaryButton: .cancel()
        )
    }
    func helpView() -> some View {
        DisclosureGroup("Help", isExpanded: $isHelpExpanded){
            VStack{
                Text("Click on a subject in the left column.  It will turn ????")
                Text("Click on a correct matching verb form in the right column.  If correct, it will also turn ????")
                Text("Continue until all pairs are matched")
                Text("")
                
                Text("To change the list of verbs for this quiz, click on Verbs of a Feather button")
                //                    showVerbsOfAFeatherNavigationLink()
            }.background(.yellow)
                .foregroundColor(.black)
        }
    }
    
//
//    func showVerbsOfAFeatherNavigationLink()->some View{
//            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
//                Text("New Model")
//            }.font(.callout)
//                .padding(2)
//                .background(.linearGradient(colors: [.orange, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing))
//                .foregroundColor(.black)
//                .cornerRadius(4)
//    }
//
    
    func getSubjectStringAtPerson(person : Person)->String{
        return person.getSubjectString(language: languageViewModel.getCurrentLanguage(), subjectPronounType: languageViewModel.getSubjectPronounType())
    }
    
    func fillPersonMixStruct(){
        
        personMixString.removeAll()
        personMixString.append(PersonMixStruct(person: .S1, personString: getSubjectStringAtPerson(person : .S1)))
        personMixString.append(PersonMixStruct(person: .S2, personString: getSubjectStringAtPerson(person : .S2)))
        personMixString.append(PersonMixStruct(person: .S3, personString: getSubjectStringAtPerson(person : .S3)))
        personMixString.append(PersonMixStruct(person: .P1, personString: getSubjectStringAtPerson(person : .P1)))
        personMixString.append(PersonMixStruct(person: .P2, personString: getSubjectStringAtPerson(person : .P2)))
        personMixString.append(PersonMixStruct(person: .P3, personString: getSubjectStringAtPerson(person : .P3)))

    }
    
    func setSubjunctiveParticiple(){
        subjunctiveParticiple = ""
        if currentTense == .presentSubjunctive || currentTense == .imperfectSubjunctiveRA || currentTense == .imperfectSubjunctiveSE {
            subjunctiveParticiple = "que "
            if currentLanguage == .French {subjunctiveParticiple = "qui "}
        }
    }
    
    func fillMixMatchList(){
        mixMatchList.removeAll()
        for pms in personMixString {
            mixMatchList.append(MixMatchStruct(matchID: pms.person.getIndex(), person: pms.person, subjectString: pms.personString,
                                               verbString: languageViewModel.createAndConjugateAgnosticVerb(verb: currentVerb, tense: currentTense, person: pms.person)))
        }
        
        mixMatchList.shuffle()
        subjectStringList.removeAll()
        matchStringList.removeAll()
        isThisSubjectAMatch.removeAll()
        isThisSubjectDisabled.removeAll()
        
        for mm in mixMatchList {
            subjectStringList.append(subjunctiveParticiple + mm.subjectString)
            matchStringList.append(mm.verbString)
            isThisSubjectAMatch.append(false)
            isThisSubjectDisabled.append(false)
        }
        
        mixMatchList.shuffle()
        verbStringList.removeAll()
        isThisVerbAMatch.removeAll()
        isThisVerbDisabled.removeAll()
        for mm in mixMatchList {
            verbStringList.append(mm.verbString)
            isThisVerbAMatch.append(false)
            isThisVerbDisabled.append(false)
        }
        correctAnswerCount = 0
        totalCorrectCount = mixMatchList.count
        progressValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
        if correctAnswerCount == totalCorrectCount { showAlert.toggle() }
    }
    
    func getWordToMatch(index: Int, matchString: String){
        if isThisSubjectAMatch[mixIndex] && !isThisSubjectDisabled[mixIndex] {isThisSubjectAMatch[mixIndex] = false}
        self.mixIndex = index
        self.matchString = matchString
        subjectString = subjectStringList[index]
        isThisSubjectAMatch[mixIndex] = true
        verbString = ""
        //        print("mixIndex: \(mixIndex), getWordToMatch \(matchString)")
    }
    
    func isMatch(index: Int, verbString: String){
        //if subject string has content
        if subjectString.count>0 {
            self.matchIndex = index
            self.verbString = verbString
            if verbString == matchString {
                isThisVerbAMatch[index] = true
                isThisVerbDisabled[index] = true
                isThisSubjectAMatch[mixIndex] = true
                isThisSubjectDisabled[mixIndex] = true
                matchString = ""
                subjectString = ""
                self.verbString = ""
                AudioServicesPlayAlertSound(UInt32(1008))
            } else {
                AudioServicesPlayAlertSound(UInt32(1003))
            }
            
            correctAnswerCount = 0
            for match in isThisVerbAMatch {
                if match { correctAnswerCount += 1}
            }
            
            progressValue =  Float(correctAnswerCount) / Float(totalCorrectCount)
            if correctAnswerCount == totalCorrectCount { showAlert = true }
            else {showAlert = false}
        }
    }
    
    func fillPersonStringList()->[String]{
        let stringList = [String]()
        switch currentLanguage {
        case .Spanish:
            return subjectList.shuffled()
        case .French: return stringList
        default: return stringList
        }
        
    }
    
    func showNewVerbsButton()->some View{
        Button{
            languageViewModel.setFilteredVerbList(verbList: languageViewModel.getRandomEnglishVerbs(maxCount : 30))
            fillMixMatchList()
        } label: {
            Text("New Verbs")
        }
    }
        
    func setCurrentVerb(){
        languageViewModel.createAndConjugateCurrentFilteredVerb()
        currentTense = languageViewModel.getCurrentTense()
        currentVerb = languageViewModel.getCurrentFilteredVerb()
        
        //this sets up the initial invitation message to the user "Click here"
        currentTenseString = languageViewModel.getCurrentTense().rawValue
        currentVerbString = languageViewModel.getCurrentFilteredVerb().getWordAtLanguage(language: currentLanguage)
        currentModelString = languageViewModel.getRomanceVerb(verb: languageViewModel.getCurrentFilteredVerb()).getBescherelleInfo()
        setSubjunctiveParticiple()
        fillMixMatchList()
        correctAnswerCount = 0
    }
    
    func setVerbAndTenseView() -> some View {
        VStack {
            NavigationLink(destination: ListModelsView(languageViewModel: languageViewModel)){
                HStack{
                    Text("Verb model:")
                    Text(currentModelString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }
                .frame(width: 350, height: 30)
                .font(.callout)
                .padding(2)
                .background(Color.orange)
                .foregroundColor(.black)
                .cornerRadius(4)
            }.task {
                setCurrentVerb()
            }
            
            
            Button(action: {
                languageViewModel.setNextFilteredVerb()
                setCurrentVerb()
            }){
                HStack{
                    Text("Verb: ")
                    Text(currentVerbString)
                    Spacer()
                    Image(systemName: "rectangle.and.hand.point.up.left.filled")
                }.frame(width: 350, height: 30)
                    .font(.callout)
                    .padding(2)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(4)
            }
            
            
            //ChangeTenseButtonView()
            
            Button(action: {
                currentTenseString = languageViewModel.getNextTense().rawValue
                setCurrentVerb()
            }){
                Text("Tense: \(currentTenseString)")
                Spacer()
                Image(systemName: "rectangle.and.hand.point.up.left.filled")
            }
            .frame(width: 350, height: 30)
            .font(.callout)
            .padding(2)
            .background(Color.orange)
            .foregroundColor(.black)
            .cornerRadius(4)
            
        }
        
        .padding(3)
    }
    
    
}

struct MixAndMatchView_Previews: PreviewProvider {
    static var previews: some View {
        MixAndMatchView(languageViewModel: LanguageViewModel(language: .Spanish))
    }
}
