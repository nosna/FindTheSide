//
//  CoreDataHelper.swift
//  FindTheSide
//
//  Created by Yujia Gao on 10/20/18.
//  Copyright © 2018 nosnaCo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper{
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    lazy var managedContext = appDelegate.persistentContainer.viewContext
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    static let userEntity = NSEntityDescription.entity(forEntityName: "Level", in: managedContext)!
    
    static func createLevel(num: Int64){
        let level = NSManagedObject(entity: userEntity, insertInto: managedContext)
        level.setValue(num, forKey: "levelNum")
        do{
            try managedContext.save()
            print("Succeeded in saving")
        } catch {
            print("Failed saving")
        }
    }
    
    static func deleteLevel(level: Level){
        managedContext.delete(level)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func retrieveLevel() -> Level?
    {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Level")
        do {
            let results = try managedContext.fetch(userFetch)
            let level = results.first as! Level
            return level
        } catch let error as NSError {
            print("Could not fetch \(error)")
            return nil
        }
    }

}
