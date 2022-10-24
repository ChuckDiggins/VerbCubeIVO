//
//  QuizCubeCellView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 2/21/22.
//

import SwiftUI
import JumpLinguaHelpers


struct QuizCubeCellView: View {
    
//    I need a correct array in languageEngine ... I cannot use the one in vcci
    
    // MARK: - Environments
    
    // MARK: - EnvironmentObjects
    
    // MARK: - StateObjects
//    @StateObject private var answerCellObject = AnswerCell()
    
    // MARK: - ObservedObjects
    var vcci : VerbCubeCellInfo
    var showAnswer = false
    
    // MARK: - States
    
    
    @State  var columnWidth : CGFloat
    @State var cellData : QuizCellData
    var useAlert : Bool
 
    @State var foregroundColor = Color.black
    @State var backgroundColor = Color.white
    @State var defaultBackgroundColor = Color.white
   
    
    // MARK: - Bindings
    
    // MARK: - Properties
    
    // MARK: - AppStorage
    
    // MARK: - FocusState
    enum FocusedField: Hashable {
        case name
    }
    
    @FocusState private var focusedField: FocusedField?
    
    @State private var emptyText = ""
    @State private var studentAnswer = ""
    @State private var showActionSheet = false
    @State private var isShown = false
    @State private var selectedString = ""
    
    let subjectStr = "yo"
    let tenseStr = "present"
    let verbStr = "acabar"
    let correctAnswer = "acabo"
    let buttonStrList = ["acabas", "acabamos", "acabaro", "acabo", "acaba"]
   
    // MARK: - Body
    var body: some View {
        ZStack{
            VStack{
                Button(action:{
                    if useAlert {
                        isShown = true
                        alertView()
                        
                    } else {
                        //                    popupMenuView
                    }
                }){
                    TextField("", text: cellData.isBlank ? $studentAnswer : $cellData.cellString,
                              onCommit: {
                        studentAnswer = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: studentAnswer)
                        if studentAnswer == cellData.cellString {
                            backgroundColor = .green
                        } else {
                            backgroundColor = .yellow
                        }
                    } )
                    .frame(width: columnWidth, height: 30, alignment: .center)
                    .background(cellData.isBlank ? backgroundColor : defaultBackgroundColor)    //this is where to make this cleaner
                    .foregroundColor(foregroundColor)
                    .border(Color.black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .disabled(!useAlert)
                    .font(.footnote)
                    
//                    PopupButtonView(instruction: (subjectStr, tenseStr, verbStr), correctAnswer: correctAnswer, selectionString: buttonStrList, isShown: $isShown, selectedString: $selectedString)
                }.onAppear{
                    didAppear()
                }
                .onDisappear { didDisappear() }
                .actionSheet(isPresented: $showActionSheet, content: getBetterActionSheet)
            }
//            PopupButtonView(instruction: (subjectStr, tenseStr, verbStr), correctAnswer: correctAnswer, selectionString: buttonStrList, isShown: $isShown, selectedString: $selectedString)
        }
    }
    
    func getActionSheet() -> ActionSheet{
        return ActionSheet(title: Text("This is the title of the action sheet"))
    }
    
    func getBetterActionSheet() -> ActionSheet{
        let button1: ActionSheet.Button = .default(Text("conozco"))
        let button2: ActionSheet.Button = .default(Text("conoces"))
        let button3: ActionSheet.Button = .default(Text("conocen"))
        let button4: ActionSheet.Button = .destructive(Text("Die!"))
        return ActionSheet(
            title: Text("Verb conjugation"),
            message: Text("Click on the correct conjugation"),
            buttons: [button1, button2, button3, button4])
    }
    
    }



// MARK: - Content
extension QuizCubeCellView {
    func content() -> some View {
        Text("hello there")
    }
}

struct TextFieldModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
        
    }
}

// MARK: - Lifecycle
extension QuizCubeCellView {
    func didAppear() {
    }
    
    func didDisappear() {
        
    }
}

// MARK: - Supplementary Views
extension QuizCubeCellView {
        
    
//    func poppupView(isShown: Bool){
//        let subjectStr = "yo"
//        let tenseStr = "present"
//        let verbStr = "acabar"
//        let correctAnswer = "acabo"
//        let buttonStrList = ["acabas", "acabamos", "acabaro", "acabo", "acaba"]
//        PopupButtonView(instruction: (subjectStr, tenseStr, verbStr), correctAnswer: correctAnswer, selectionString: buttonStrList, isShown: $isShown, selectedString: $selectedString)
//    }
        
    func alertView(){
//        @Binding var studentAnswer : String
        
        print("alertView: \(vcci.verb.getWordAtLanguage(language: .Spanish)): cellString: \(cellData.cellString)")
        let alert = UIAlertController(title: "Verb: \(vcci.verb.getWordAtLanguage(language: .Spanish)) ", message: "Subject \(vcci.person.getMaleString()), \(vcci.tense.rawValue) tense", preferredStyle: .alert)
        
        alert.addTextField{ studentAnswer in
            studentAnswer.returnKeyType = .done
//            studentAnswer.returnKeyType = .continue
//            studentAnswer.returnKeyType = .go
            studentAnswer.placeholder = "answer here "
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ (_) in
            studentAnswer = alert.textFields![0].text!
            studentAnswer = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: studentAnswer)
            if studentAnswer == cellData.cellString {
                backgroundColor = .green
            } else {
                backgroundColor = .yellow
            }
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ (_) in
            print ("Cancel clicked")
        }
            
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
        })
    }
}

// MARK: - Popover

extension QuizCubeCellView {
}

// MARK: - Helper Functions
extension QuizCubeCellView {
    
}
