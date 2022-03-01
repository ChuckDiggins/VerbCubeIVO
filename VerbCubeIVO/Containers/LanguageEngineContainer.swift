//
//  LanguageEngineContainer.swift
//  LanguageEngineContainer
//
//  Created by Charles Diggins on 2/16/22.
//

import SwiftUI
import Dot

struct LanguageEngineContainer: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension LanguageEngineContainer {
    class Navigation: ObservableObject {
        
        enum Page {
            case profile
            case editProfile
            case imagePicker(image: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType)
        }
        
        @Published var flow = NavigationFlow<Page>(root: .profile)
    }
}

