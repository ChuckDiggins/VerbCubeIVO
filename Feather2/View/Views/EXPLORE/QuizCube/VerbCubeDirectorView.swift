//
//  VerbCubeDirectorView.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 9/6/22.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbCubeDirectorView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
        var body: some View {
            
            let maxHeight : CGFloat = 100
            HStack{
                Button(action: {
                    router.reset()
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .font(.title2)
                        .padding(20)
                })
                Spacer()
                VStack{
                    Text("The Verb Cube").font(.largeTitle).bold()
                    Text("6 Dimensions of Conjugation").font(.headline).bold()
                }
                Spacer()
            }
            
                NavigationStack {
                    HStack{
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Person, d2: .Verb))){

                            VStack{
                                Text("1")
                                Text("Person v Verb").bold()
                                Text("Variable: Tense")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.red)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Person))){
                            VStack{
                                Text("2")
                                Text("Verb v Person").bold()
                                Text("Variable: Tense")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.red)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                    }
                    
                    HStack{
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Verb, d2: .Tense))){
                            VStack{
                                Text("3")
                                Text("Verb v Tense").bold()
                                Text("Variable: Person")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.blue)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Tense, d2: .Verb))){
                            VStack{
                                Text("4")
                                Text("Tense v Verb").bold()
                                Text("Variable: Person")
                            }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.blue)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                        
                    }
                    HStack{
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Tense, d2: .Person))){
                        VStack{
                            Text("5")
                            Text("Tense v Person").bold()
                            Text("Variable: Verb")
                        }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                        NavigationLink(destination: VerbCubeView(languageViewModel: languageViewModel, vccsh: VerbCubeConjugatedStringHandlerStruct(languageViewModel: languageViewModel, d1:  .Person, d2: .Tense))){
                        VStack{
                            Text("6")
                            Text("Person v Tense").bold()
                            Text("Variable: Verb")
                        }
                        }.frame(width: 150, height: maxHeight, alignment: .center)
                            .padding(.leading, 10)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                //}.navigationTitle("The VerbCube")
                }.font(.caption)
                .onAppear{
//                    AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
//                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
//                    UINavigationController.attemptRotationToDeviceOrientation()
                    
                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                }
            Spacer()
        }
    }


//struct VerbCubeDirectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerbCubeDirectorView()
//    }
//}
