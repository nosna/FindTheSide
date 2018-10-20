//
//  ViewController.swift
//  superfun
//
//  Created by nosna on 10/18/18.
//  Copyright © 2018 nosnaCo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    //hello!!!!!!!!
    //wby
    
    //time
    var time: Timer!
    var countdown:Int = 60
    let configuration = ARWorldTrackingConfiguration()
    var level = 2
    var highest: Level!
    
    @IBOutlet weak var timer: UILabel!
    
    @objc
    func countdownAction() {
        countdown -= 1
        if countdown == 0 {
            time.invalidate()
            timer.text = "Time out!"
        } else {
            timer.text = "\(countdown)"
        }
        
    }
    //
    
    
    @IBOutlet weak var tryAgain: UIButton!
    @IBOutlet weak var nextLevel: UIButton!
    @IBOutlet weak var menu: UIButton!
    
    override func viewDidLoad() {
        
        //time
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)        
        //
        super.viewDidLoad()
        // Set the view's delegate
//        sceneView.delegate = self
        //        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        // 
        // Set the scene to the view
        //        sceneView.scene = scene
        //        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        //
        nextLevel.isEnabled = false;
        menu.isEnabled = false;
        tryAgain.isEnabled = false;
        highest = CoreDataHelper.retrieveLevel()
        print("The highest level so far is " + String(highest.levelNum))
        generateCubes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    func generateCubes() {
        let spCube = Int.random(in: 1...level)
        
        for cube in 1 ... level {
            let cubeNode = SCNNode()
            cubeNode.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
            cubeNode.geometry?.firstMaterial?.specular.contents = UIColor.white
            cubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            
            let x = Float.random(in: -0.5 ... 0.5)
            let y = Float.random(in: -0.5 ... 0.5)
            let z = Float.random(in: -0.5 ... 0)
            cubeNode.position = SCNVector3(x, y, z)
            
            sceneView.scene.rootNode.addChildNode(cubeNode)
            
            if cube == spCube {
                let vecs = [SCNVector3(0.005,0,0),SCNVector3(-0.005,0,0),SCNVector3(0,0.005,0),SCNVector3(0,-0.005,0),SCNVector3(0,0,0.005),SCNVector3(0,0,-0.005)]
                let spSide = vecs.randomElement()
                let sideNode = SCNNode(geometry: SCNBox(width: 0.049, height: 0.049, length: 0.049, chamferRadius: 0.001))
                sideNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                sideNode.position = spSide!
                cubeNode.addChildNode(sideNode)
            }
        }
    }
    
//    @IBAction func reset(_ sender: Any) {
//        restartSession()
//    }
    
    func reset(){
        sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes{
            (node,_) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    
        //timer
        countdown = 60
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo:nil, repeats: true)
        }
    
    func gameIsWon(){
        reset()
        nextLevel.isEnabled = true
        menu.isEnabled = true
        var currentHighest = CoreDataHelper.retrieveLevel()?.levelNum
        if(level > Int(currentHighest!)) {
        CoreDataHelper.createLevel(num: <#T##Int64#>)
        }
    }
    
    func gameIsLost(){
        reset()
        tryAgain.isEnabled = true
    }
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
