//
//  TabStackContainerView.swift
//  TabStackContainer
//
//  Created by Charles Diggins on 2/17/22.
//

import SwiftUI
import Dot
import SFSafeSymbols

struct TabsStackContainer: View {
    
    @ObservedObject var tabs: Tabs
    @EnvironmentObject private var toastManager: ToastManager
    @EnvironmentObject private var languageEngine: LanguageEngine
    @State private var isImagePickerViewPresented = false
    @State private var sourceType: UIImagePickerController.SourceType? = nil
    
    var body: some View {
        TabsStack(tabs, pages: { tag in
            switch tag {
            case 0:
                EmptyView()
//                GeneralVerbCubeView(vccsh: VerbCubeConjugatedStringHandler(languageEngine: languageEngine, d1: .Person, d2: .Tense))
            case 1:
                EmptyView()
//                GeneralVerbCubeView(VerbCubeConjugatedStringHandler(languageEngine: languageEngine, d1: .Verb, d2: .Person))
            case 2:
                ProfileView()
            default: EmptyView()
            }
        }, items: { tag in
            switch tag {
            case 0:
                Image(systemSymbol: .square)
                    .imageScale(.large)
                    .foregroundColor(.red)
            case 1:
                Image(systemSymbol: .flag)
                    .font(.largeTitle)
                    .foregroundColor(.red)
            case 2:
                Image(systemSymbol: .personFill)
                    .imageScale(.large)
                    .foregroundColor(.red)
            default: EmptyView()
            }
        }, background: {
            Color.systemWhite.ignoresSafeArea()
        } )
            .onAppear{
                
            }
    }
}
