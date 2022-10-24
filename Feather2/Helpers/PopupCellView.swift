//
//  PopupCellView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/5/22.
//

import SwiftUI
import JumpLinguaHelpers

class PopupCellData : ObservableObject {
    var verbString : String
    var tenseString : String
    var personString : String
    var correctAnswerString : String
    
    init(verbString: String, tenseString: String, personString: String, correctAnswerString: String ){
        self.verbString = verbString
        self.tenseString = tenseString
        self.personString = personString
        self.correctAnswerString = correctAnswerString
    }
    
    init(){
        self.verbString = "v"
        self.tenseString = "t"
        self.personString = "p"
        self.correctAnswerString = "c"
    }
    
    func setData(verbString: String, tenseString: String, personString: String, correctAnswerString: String ){
        self.verbString = verbString
        self.tenseString = tenseString
        self.personString = personString
        self.correctAnswerString = correctAnswerString
    }
    
}

struct PopupCellView: View {
    @ObservedObject var popupCellData : PopupCellData
    @State  var columnWidth : CGFloat
    var useAlert : Bool
    @State  var isBlank : Bool
    
    @State  var isShown = false
    @State var foregroundColor = Color.black
    @State var backgroundColor = Color.white
    @State var defaultBackgroundColor = Color.white
    @State var studentAnswerString = ""
    @State var editable = false
    
    var body: some View {
        Button(action:{
            if useAlert {
                isShown = true
                alertView()
                
            } else {
                //                    popupMenuView
            }
        }){
            if editable {
                TextField("", text: isBlank ? $studentAnswerString : $popupCellData.correctAnswerString,
                          onCommit: {
                    studentAnswerString = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: studentAnswerString)
                    if studentAnswerString == popupCellData.correctAnswerString {
                        backgroundColor = .green
                    } else {
                        backgroundColor = .yellow
                    }
                } )
                .frame(width: columnWidth, height: 30, alignment: .center)
                .background(isBlank ? backgroundColor : defaultBackgroundColor)    //this is where to make this cleaner
                .foregroundColor(foregroundColor)
                .border(Color.black)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .disabled(!useAlert)
                .font(.footnote)
            }
            else {
                Text(popupCellData.correctAnswerString)
            }
        }
    }
    
    func alertView(){
//        @Binding var studentAnswer : String
        
        print("alertView: \(popupCellData.verbString): cellString: \(popupCellData.correctAnswerString)")
        let alert = UIAlertController(title: "Verb: \(popupCellData.verbString) ", message: "Subject \(popupCellData.personString), \(popupCellData.tenseString) tense", preferredStyle: .alert)
        
        alert.addTextField{ studentAnswer in
            studentAnswer.returnKeyType = .done
//            studentAnswer.returnKeyType = .continue
//            studentAnswer.returnKeyType = .go
            studentAnswer.placeholder = "answer here "
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ (_) in
            studentAnswerString = alert.textFields![0].text!
            studentAnswerString = VerbUtilities().removeLeadingOrFollowingBlanks(characterArray: studentAnswerString)
            if studentAnswerString == popupCellData.correctAnswerString {
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
