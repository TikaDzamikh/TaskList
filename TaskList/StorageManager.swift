//
//  StorageManager.swift
//  TaskList
//
//  Created by Timur Dzamikh on 04.04.2023.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTask() -> Task {
        let task = Task(context: persistentContainer.viewContext)
        return task
    }
    
    func deleteTask(_ task: Task) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }
    
    func fetchTasks() -> [Task] {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print(error)
            return []
        }
    }
}
