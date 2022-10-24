////
////  DataController.swift
////  Feather2
////
////  Created by Charles Diggins on 10/8/22.
////
//
import CoreData
import Foundation

class VerbModelEntityCoreData: ObservableObject{
    @Published var container: NSPersistentContainer
    @Published var savedVerbModelEnties: [VerbModelEntity] = []
    
    init(){
        container = NSPersistentContainer(name: "VerbModelContainer")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("Error loading core data: \(error)")
                return
            } else {
                print("CoreData View Model Container was created correctly.")
            }
        }
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        fetchVerbModelEntities()
    }
    
    func getEmptyVerbModelEntity()->VerbModelEntity{
        let emptyModelEntity =  VerbModelEntity(context: container.viewContext)
        emptyModelEntity.modelName = "null"
        emptyModelEntity.isActive = false
        emptyModelEntity.hasBeenCompleted = false
        clearEmptyVerbModelEntities()  //for some reason, creating the emptyModel gets saved
        return emptyModelEntity
    }
    
    func clearEmptyVerbModelEntities(){
        for model in savedVerbModelEnties {
            if model.modelName == "null" {
                container.viewContext.delete(model)
            }
        }
        saveData()
    }
    
    func verbModelEntityIsUnique(verbModelString: String)->Bool{
        if getVerbModelEntityCount() == 0 { return true }
        for m in savedVerbModelEnties {
            if verbModelString == m.modelName {
                return false
            }
        }
        return true
    }
    
    func fetchVerbModelEntities(){
        let request = NSFetchRequest<VerbModelEntity>(entityName: "VerbModelEntity")
        do {
            savedVerbModelEnties = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }

    func getVerbModelEntityCount()->Int{
        fetchVerbModelEntities()
        return savedVerbModelEnties.count
    }
    
    func addVerbModelEntity(name: String, isActive: Bool){
        let newModel = VerbModelEntity(context: container.viewContext)
        newModel.modelName = name
        newModel.isActive = isActive
        newModel.isSelected = false
        newModel.hasBeenCompleted = false
        saveData()
    }
//
    func getVerbModelEntityAtVerbModelString(verbModelString: String)->VerbModelEntity{
        fetchVerbModelEntities()
        //set all models inActive
        for m in savedVerbModelEnties {
            if verbModelString == m.modelName {
                return m
            }
        }
        return getEmptyVerbModelEntity()
    }
    
    func clearAllVerbModelEntities(){
        for model in savedVerbModelEnties {
            container.viewContext.delete(model)
        }
        saveData()
    }

    func saveData(){
        do{
            try container.viewContext.save()
            fetchVerbModelEntities()
        } catch let error {
            print("Error saving \(error)")
        }
    }
    //completion logic ................................................
    
    func toggleVerbModelEntityCompleted(model: VerbModelEntity){
        model.hasBeenCompleted.toggle()
        fetchVerbModelEntities()
        if ( model.hasBeenCompleted ){
            model.isActive = false
            model.isSelected = false
        } else {
            model.isActive = true
            model.isSelected = false
        }
        saveData()

    }

    func toggleVerbModelEntityCompleted(verbModelString: String){
        toggleVerbModelEntityCompleted(model: getVerbModelEntityAtVerbModelString(verbModelString: verbModelString))
    }


    func setVerbModelEntityCompleted(model: VerbModelEntity){
        model.hasBeenCompleted = true
        saveData()
    }

    func getCompletedVerbModelEntityStringList()->[String]{
        fetchVerbModelEntities()
        var modelStringList = [String]()
        for m in savedVerbModelEnties {
            if m.hasBeenCompleted {
                modelStringList.append(m.modelName ?? "No model name")
            }
        }
        return modelStringList
    }

    func getActiveVerbModelEntityStringList()->[String]{
        fetchVerbModelEntities()
        var modelStringList = [String]()
        for m in savedVerbModelEnties {
            if m.isActive {
                modelStringList.append(m.modelName ?? "No model name")
            }
        }
        return modelStringList
    }

    func hasVerbModelEntityBeenCompleted(verbModelString: String)->Bool{
        fetchVerbModelEntities()
        return getVerbModelEntityAtVerbModelString(verbModelString: verbModelString).hasBeenCompleted
    }
    
    func setAllVerbModelEntitiesToActive(){
        fetchVerbModelEntities()
        for m in savedVerbModelEnties {
            m.isActive = true
            m.isSelected = false
            m.hasBeenCompleted = false
        }
        saveData()
    }
    
    
    //active logic ................................................
    
    func isVerbModelEntitySelected(verbModelString: String)->Bool{
        fetchVerbModelEntities()
        return getVerbModelEntityAtVerbModelString(verbModelString: verbModelString).isSelected
    }
    
    func toggleVerbModelEntitySelected(verbModelString: String){
        toggleVerbModelEntitySelected(model: getVerbModelEntityAtVerbModelString(verbModelString: verbModelString))
    }
    
    func toggleVerbModelEntitySelected(model: VerbModelEntity){
        fetchVerbModelEntities()
        model.isSelected.toggle()
        if ( model.isSelected ){
            model.isActive = false
            model.hasBeenCompleted = false
        } else {
            model.isActive = true
            model.hasBeenCompleted = false
        }
        saveData()
    }
    
    //active logic ................................................
    
    func isVerbModelEntityActive(verbModelString: String)->Bool{
        fetchVerbModelEntities()
        return getVerbModelEntityAtVerbModelString(verbModelString: verbModelString).isActive
    }
    
    func setVerbModelEntityActive(verbModelString: String){
        var model = getVerbModelEntityAtVerbModelString(verbModelString: verbModelString)
        model.isActive = true
        model.isSelected = false
        model.hasBeenCompleted = false
        saveData()
    }
                                
    func toggleVerbModelEntityActive(model: VerbModelEntity){
        fetchVerbModelEntities()
        //set all models inActive
//        for m in savedVerbModelEnties {
//            m.isActive = false
//        }
        model.isActive.toggle()
        if ( model.isActive ){
            model.isSelected = false
            model.hasBeenCompleted = false
        } else {
            model.isSelected = true
            model.hasBeenCompleted = false
        }
        saveData()
    }
    
    func toggleVerbModelEntityActive(verbModelString: String){
        toggleVerbModelEntityActive(model: getVerbModelEntityAtVerbModelString(verbModelString: verbModelString))
    }

    func getActiveVerbModelEntity()->VerbModelEntity{
        fetchVerbModelEntities()
        //set all models inActive
        for m in savedVerbModelEnties {
            if m.isActive { return m }
        }
        let model = savedVerbModelEnties.first ?? getEmptyVerbModelEntity()
        toggleVerbModelEntityActive(model: model)
        return model
    }

    func deleteVerbModelEntity(indexSet: IndexSet){
        guard let index = indexSet.first else {return }
        let model = savedVerbModelEnties[index]
        container.viewContext.delete(model)
        saveData()
    }

    
    
}



