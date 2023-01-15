//
//  StudyPackageStruct.swift
//  Feather2
//
//  Created by Charles Diggins on 12/8/22.
//

import SwiftUI
import JumpLinguaHelpers

class StudyPackageClass: Identifiable{
    var id = UUID()
    
    var name: String = ""
    var tenseList : [Tense]
    var verbStringList : [String]
    var preferredVerbList = [Verb]()
    var verbModelStringList : [String]
    var verbModelList = [RomanceVerbModel]()
    var isActive = false
    var chapter = ""
    var lesson = ""
    var verbCount = 10
    var createdFromVerbToModel = true
    var specialVerbType = SpecialVerbType.normal
    
    init(){
        self.name = ""
        self.verbStringList = [String]()
        self.verbModelStringList = [String]()
        self.verbModelList = [RomanceVerbModel]()
        self.tenseList = [.present]
    }
    
    init(name: String, verbModelStringList: [String], tenseList: [Tense], chapter: String, lesson: String){
        self.name = name
        self.tenseList = tenseList
        self.verbModelStringList = verbModelStringList
        self.verbModelList = [RomanceVerbModel]()
        self.verbStringList = [String]()
        self.chapter = chapter
        self.lesson = lesson
    }
    
    init(name: String, verbStringList: [String], tenseList: [Tense]){
        self.name = name
        self.tenseList = tenseList
        self.verbStringList = verbStringList
        self.verbModelList = [RomanceVerbModel]()
        self.verbModelStringList = [String]()
    }
    
    func getVerbModelStringList()->[String]{
        verbModelStringList
    }
    
    func convertVerbModelStringsToVerbModels(languageEngine: LanguageEngine){
        for vms in verbModelStringList {
            let vm = languageEngine.findModelForThisVerbString(verbWord: vms)
            verbModelList.append(vm)
        }
    }
    
    func convertVerbStringsToVerbs(languageEngine: LanguageEngine){
        for vs in verbStringList {
            let verb = languageEngine.findVerbFromString(verbString: vs, language: languageEngine.getCurrentLanguage())
            preferredVerbList.append(verb)
        }
    }
    
    
    func setVerbModelList(vml: [RomanceVerbModel]){
        verbModelList = vml
    }
    
    func getVerbModelList()->[RomanceVerbModel]{
        verbModelList
    }
    
    func getTenseList()->[Tense]{
        tenseList
    }
    
    func setActive(){
        isActive = true
    }
    
    func setInactive(){
        isActive = false
    }
    
    func getVerbCount()->Int{
        verbCount
    }
    
    func isPackageActive()->Bool{
        isActive
    }
    
    func isThisPackage(vm: [RomanceVerbModel])->Bool{
        if vm == verbModelList { return true }
        return false
    }
    
    func putTextBookAndLesson(chapter: String, lesson: String){
        self.chapter = chapter
        self.lesson = lesson
    }
    
    func getTextBookAndLesson()->(String, String){
        return (chapter, lesson)
    }
}

struct ShowSegmentedStudyPackagePicker: View {
    @Binding var studyPackageManager : StudyPackageManager
    var studyPackageManagerList : [ StudyPackageManager ]

    init(_ studyPackageManager: Binding<StudyPackageManager>, studyPackageManagerList: [ StudyPackageManager ]){
        self.studyPackageManagerList = studyPackageManagerList
        self._studyPackageManager = studyPackageManager
        UISegmentedControl.appearance().selectedSegmentTintColor = .green
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }

    var body: some View{
        VStack{
            Picker("Select Study Package Group", selection: $studyPackageManager){
                ForEach(studyPackageManagerList , id:\.self){ Text($0.name)}
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
        }
    }
}

struct StudyPackageManager : Hashable {
    func hash(into hasher: inout Hasher){
        hasher.combine(name)
    }
    
    static func == (lhs: StudyPackageManager, rhs: StudyPackageManager) -> Bool {
        lhs.name == rhs.name
    }
    
    var name : String
    var studyPackageList = [StudyPackageClass]()
    
    mutating func append(_ sp: StudyPackageClass){
        studyPackageList.append(sp)
    }
    
    func getCount()->Int{
        studyPackageList.count
    }
    
    func getList()->[StudyPackageClass]{
        studyPackageList
    }
    
    
    func getStudyPackageAtVerbModelList(vml: [RomanceVerbModel])->(Bool, StudyPackageClass) {
        for sp in studyPackageList {
            if sp.verbModelList.count == vml.count{
                var matchCount = 0
                for vm in vml {
                    for spVm in sp.verbModelList {
                        if vm == spVm { matchCount += 1}
                    }
                }
                if matchCount == sp.verbModelList.count {
                    return (true, sp)
                }
            }
        }
        return (false, StudyPackageClass())
    }
}

struct StudyPackageView: View {
    @ObservedObject var languageViewModel: LanguageViewModel
    @Environment(\.dismiss) private var dismiss
    @State var currentLanguage = LanguageType.Agnostic
    @State var studyPackageManagerList = [StudyPackageManager]()
    @State var studyPackageManager = StudyPackageManager(name: "")
    @State var currentStudyPackage = StudyPackageClass()
    @State var studyPackageList = [StudyPackageClass]()
    
    @State var studyPackageName = ""
    @State var verbListPart1 = [Verb]()
    @State var verbListPart2 = [Verb]()
    @State var tenseListPart1 = [Tense]()
    @State var tenseListPart2 = [Tense]()
    
    var backgroundColor = Color.yellow
    var foregroundColor = Color.black
    var fontSize = Font.caption
    @State var selectTenses = false
    
    var body: some View {
        let gridFixSize = CGFloat(150.0)
        
        let gridItems = [GridItem(.fixed(gridFixSize)),
//                         GridItem(.fixed(gridFixSize)),
                         GridItem(.fixed(gridFixSize)),]
        Text("Study package group").font(.title3)
        ShowSegmentedStudyPackagePicker($studyPackageManager, studyPackageManagerList: studyPackageManagerList)
        ZStack{
            Color("BethanyNavalBackground")
                .ignoresSafeArea()
            VStack{
                VStack{
                    LazyVGrid(columns: gridItems, spacing: 5){
                        ForEach(studyPackageManager.studyPackageList){sp in
                            Button{
                                showPackageInfo(sp)
                            } label: {
                                HStack{
                                    Text(sp.name)
                                    Spacer()
                                }
                            }.frame(height: 35)
                                .background( sp.isPackageActive() ? backgroundColor : Color("BethanyNavalBackground"))
                                .foregroundColor(sp.isPackageActive() ? foregroundColor : Color("BethanyGreenText"))
                                .font(fontSize)
                                .padding(3)
                                .cornerRadius(8)
                                .border(Color("BethanyGreenText"))
                                
                        }
                    }.padding(25)
                }.border(.red)
                HStack{
                    Button{
                        installCurrentPackage()
                        dismiss()
                    } label: {
                        Text("Install \(studyPackageName)")
                    }.modifier(BlueButtonModifier())
                    Button{
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }.modifier(RedButtonModifier())
                }.padding(10)
                VStack{
                    VStack{
                        Text("Verbs").foregroundColor(Color("ChuckText1"))
                        VStack{
                            HStack{
                                ForEach(verbListPart1, id:\.self){verb in
                                    Text(verb.getWordAtLanguage(language: currentLanguage))
                                }
                            }
                            HStack{
                                ForEach(verbListPart2, id:\.self){verb in
                                    Text(verb.getWordAtLanguage(language: currentLanguage))
                                }
                            }
                        }
                    }.font(.callout)
                    .padding(10)
                    Divider().frame(height:2).background(.yellow)
                        VStack{
                            Button{
                                selectTenses.toggle()
                            } label: {
                                if tenseListPart1.count == 1 {
                                    Text("Tense")
                                } else {
                                    Text("Tenses")
                                }
                            }.foregroundColor(Color("ChuckText1"))
                            .padding(3)
                            .border(.yellow)
                            VStack{
                                HStack{
                                    ForEach(tenseListPart1, id:\.self){tense in
                                        Text(tense.rawValue)
                                    }
                                }
                                HStack{
                                    ForEach(tenseListPart2, id:\.self){tense in
                                        Text(tense.rawValue)
                                    }
                                }
                            }
                        }.font(.callout)
                        .padding(10)
                }
//                .background(.orange).opacity(0.3)
                .frame(width: 350)
                .border(.red)
                Spacer()
            }.onAppear{
                currentLanguage = languageViewModel.getCurrentLanguage()
                studyPackageManagerList = languageViewModel.getStudyPackageManagerList()
                studyPackageManager = studyPackageManagerList[0]
                studyPackageList = studyPackageManagerList[0].studyPackageList
                currentStudyPackage = studyPackageList[0]
                showPackageInfo(currentStudyPackage)
            }
//            .fullScreenCover(isPresented: $selectTenses, content: {
//                TenseSelectionView(languageViewModel: languageViewModel, tenseList: $tenseListPart1)
//            })
            .foregroundColor(Color("BethanyGreenText"))
            .background(Color("BethanyNavalBackground"))
            
        }
        
        
    }
    
    func computeTenseLists(tenseList: [Tense]){
        tenseListPart1.removeAll()
        tenseListPart2.removeAll()
        if tenseList.count > 4 {
            let part1Count = tenseList.count / 2
            for i in 0 ..< part1Count {
                tenseListPart1.append(tenseList[i])
            }
            for i in part1Count ..< tenseList.count {
                tenseListPart2.append(tenseList[i])
            }
        } else {
            tenseListPart1 = tenseList
        }
    }
    
    func installCurrentPackage(){
        languageViewModel.computeSelectedVerbModels()
        languageViewModel.computeCompletedVerbModels()
        languageViewModel.installStudyPackage(sp: currentStudyPackage)
    }
    
    func showPackageInfo(_ sp: StudyPackageClass){
        for studyPackage in studyPackageManager.studyPackageList { studyPackage.setInactive() }
        
        studyPackageName = sp.name
        verbListPart1.removeAll()
        verbListPart2.removeAll()
        if sp.preferredVerbList.count > 6 {
            let part1Count = sp.preferredVerbList.count / 2
            
            for i in 0 ..< part1Count {
                verbListPart1.append(sp.preferredVerbList[i])
            }
            for i in part1Count ..< sp.preferredVerbList.count {
                verbListPart2.append(sp.preferredVerbList[i])
            }
        } else {
            verbListPart1 = sp.preferredVerbList
        }
        
        computeTenseLists(tenseList: sp.tenseList)
        sp.setActive()
        currentStudyPackage = sp
    }
    

//    mutating func addStudyPackage(name: String, verbModelStringList: [String], tenseList: [Tense]){
//        let sp = StudyPackageClass(name: name, verbModelStringList: verbModelStringList, tenseList: tenseList)
//        sp.convertVerbModelStringsToVerbModels(languageEngine: languageViewModel.languageEngine)
//        sp.createdFromVerbToModel = true
//        studyPackageList.append(sp)
//    }
}
