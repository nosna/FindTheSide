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
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var ten: UIButton!
    @IBOutlet weak var eleven: UIButton!
    @IBOutlet weak var twelve: UIButton!
    @IBOutlet weak var thirteen: UIButton!
    @IBOutlet weak var fourteen: UIButton!
    @IBOutlet weak var fifteen: UIButton!
    @IBOutlet weak var sixteen: UIButton!
    var b:[UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        b = [one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen]
        ViewController.highest = CoreDataHelper.retrieveLevel() ?? nil
        if(ViewController.highest != nil){
            ViewController.highestNum = Int(ViewController.highest.levelNum)
        } else {
            ViewController.highestNum = 1
        }
        print("The highest level so far is " + String(ViewController.highestNum))
        if ViewController.highestNum < 16 {
            for num in ViewController.highestNum+2...15 {
                //b[num].titleLabel!.textColor = UIColor.white
                b[num].tintColor = UIColor.white
                //b[num].titleLabel!.textColor = UIColor.white
                b[num].setTitleColor(UIColor.white, for: .normal)
                b[num].isEnabled = false
            }
       }
//            else {
//            for num in 2...15 {
//                //b[num].titleLabel!.textColor = UIColor.white
//                b[num].tintColor = UIColor.white
//                //b[num].titleLabel!.textColor = UIColor.white
//                b[num].setTitleColor(UIColor.white, for: .normal)
//                b[num].isEnabled = false
//            }
//        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "game"){
            var secondController = segue.destination as! ViewController
            let button = sender as! UIButton
            secondController.level = button.tag
            print("I'm in segue")
        }
    }
}
