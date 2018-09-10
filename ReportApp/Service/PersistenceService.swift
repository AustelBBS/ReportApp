//
//  PersistenceService.swift
//  ReportApp
//
//  Created by Macintosh on 9/10/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
  static var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "ReportApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
   static func saveContext () {
        let context = PersistenceService.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
