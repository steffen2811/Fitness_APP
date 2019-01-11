//
//  CoreDataStack.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 10/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    //adds the coreData persistentContainer under the name Fitness_app.
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Fitness_app")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    //saves the content to the Fitness_app persistentContainer and returns error if it cant be done 
    class func saveContext () {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
