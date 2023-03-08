//
//  VerbModelLessonView.swift
//  Feather2
//
//  Created by chuckd on 2/21/23.
//

import SwiftUI
import JumpLinguaHelpers

struct VerbModelLessonView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @ObservedObject var vmecdm: VerbModelEntityCoreDataManager
    @State var currentVerbModelLesson = VerbModelLesson("", [RomanceVerbModel]())
    @State var verbModelLessonList = [VerbModelLesson]()
    @State var vmlIndex = 0
    @State var verbModelType = VerbModelType.Lesson
    @State var selectedModel = RomanceVerbModel()
    @State var showSheet = false
    
    var body: some View {
        ExitButtonView()
        Button{
            switchVerbModelType()
        } label :{
            Text("Verb Model Type: \(verbModelType.rawValue)")
        }
        
        Button{
            nextVerbModelLesson()
        } label :{
            Text("Model lesson: \(currentVerbModelLesson.description)")
        }
        ScrollView{
            VStack{
                ForEach(currentVerbModelLesson.verbModelList) { vm in
                    Button{
                        selectedModel = vm
                        languageViewModel.setTemporaryVerbModel(verbModel: vm)
                        print("Selected model: \(selectedModel.modelVerb), vm = \(vm.modelVerb)")
                        showSheet.toggle()
                    } label: {
                        HStack{
                            Text("Verb: ")
                            Text("\(vm.modelVerb) \(languageViewModel.findVerbsOfSameModel(targetID: vm.id).count)")
                            Spacer()
                            Text(languageViewModel.isCompleted(verbModel: vm) ? "✅" : "🔳")
                            
                        }.frame(width: 300, height: 40).background(.black).foregroundColor(.yellow)
                    }
                }
            }
        }.onAppear{
            verbModelLessonList = languageViewModel.getVerbModelLessonList()
            currentVerbModelLesson = verbModelLessonList[0]
        }
        .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            .fullScreenCover(isPresented: $showSheet, content: {
                ListVerbsForModelView(languageViewModel: languageViewModel, vmecdm: vmecdm, verbModel: selectedModel, showSelectButton: true)
            })
        
    }
    
    func switchVerbModelType(){
        
    }
    
    func nextVerbModelLesson(){
        if ( vmlIndex >= 0 && vmlIndex < verbModelLessonList.count-1){
            vmlIndex += 1
        } else {
            vmlIndex = 0
        }
        currentVerbModelLesson = verbModelLessonList[vmlIndex]
    }
    
    
    
}

//struct VerbModelLessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerbModelLessonView(languageViewModel: LanguageViewModel())
//    }
//}
