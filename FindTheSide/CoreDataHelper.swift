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
//    lazy var managedObject = appDelegate.persistentContainer.viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    static func saveLevel(){
        do{
            try
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func retrieveLevel() -> Int{
       let fetchRequest<Int64> = NSFetchRequest(entityName: "Level")
        
        return 0;
    }
}
