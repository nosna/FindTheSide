//
//  LevelsPage.swift
//  FindTheSide
//
//  Created by Jianing Fu on 10/20/18.
//  Copyright © 2018 nosnaCo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class LevelsPage: UIViewController, ARSCNViewDelegate {


    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    static var tag = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.highest = CoreDataHelper.retrieveLevel() ?? nil
        if(ViewController.highest != nil){
            ViewController.highestNum = Int(ViewController.highest.levelNum)
            print("The highest level so far is " + String(ViewController.highest.levelNum))
        }
    }
    

    @IBAction func startSearchQuery(sender: AnyObject) {
        let button = sender as! UIButton
        LevelsPage.tag = button.tag
        print("the tag of the button is " + String(LevelsPage.tag))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        var secondController = segue.destination as! ViewController
        secondController.level = LevelsPage.tag
        
        
    }
}
