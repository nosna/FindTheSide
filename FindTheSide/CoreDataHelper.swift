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
    
    
    static func saveLevel(){
        let userEntity = NSEntityDescription.entity(forEntityName: "Level", in: managedContext)!
        do{
            try managedContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func retrieveNote() -> Int64
    {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Level")
        do {
            let results = try managedContext.fetch(userFetch)
            let level = results.first as! Level
            return level.levelNum
        } catch let error as NSError {
            print("Could not fetch \(error)")
            return 0
        }
    }

}
