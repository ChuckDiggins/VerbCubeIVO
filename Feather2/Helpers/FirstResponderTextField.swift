//
//  FirstResponderTextField.swift
//  Feather2
//
//  Created by Charles Diggins on 11/26/22.
//

import SwiftUI

struct FirstResponderTextField: UIViewRepresentable{
   
    
    @Binding var text: String
    let placeHolder: String
    
    class Coordinator: NSObject, UITextFieldDelegate{
        @Binding var text: String
        var becameFirstResponder = false
        
        init(text: Binding<String>){
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField)->Bool{
        true
    }
    
    func makeCoordinator()->Coordinator{
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context)-> some UIView{
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
    
}
