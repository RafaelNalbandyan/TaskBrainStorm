//
//  CoreDataService.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import CoreData
import UIKit

enum LocalStorageType {
    case coreData,
         realm // for example
}

class CoreDataService {
    enum CoreDataEntities: String {
        case usersEntity = "UsersEntity"
    }
    
    let context: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        self.persistentContainer = appDelegate.persistentContainer
        self.context = context
    }
}
