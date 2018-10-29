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
    
    @IBAction func nxt(_ sender: UIButton) {
        gameIsWon()
        level += 1
        self.nextLevel.isHidden = true
        self.menu.isHidden = true
        countdown = 60
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo:nil, repeats: true)
    }
    
    
    @IBAction func rst(_ sender: Any) {
        //reset(judge:true, worl:true)
        gameIsLost()
        self.tryAgain.isHidden = true
        countdown = 60
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo:nil, repeats: true)
    }
    
    @IBAction func restart(_ sender: UIButton) {
        reset(judge:true, worl:true)
        isFirst = true
    }
    
    //time
    var time: Timer!
    var countdown:Int = 60
    let configuration = ARWorldTrackingConfiguration()
    static var highest: Level!
    static var highestNum: Int!
    var spCubeLoc = SCNVector3(0,0,0)
    var otherCubes: [SCNVector3] = []
    var level = 0
    var isFirst = true
    var isWon = false
    var beeNode: SCNNode!
    @IBOutlet weak var timer: UILabel!
    

    @objc
    func countdownAction() {
        countdown -= 1
        if countdown == 0 {
            time.invalidate()
            gameIsLost()
        } else {
            timer.text = "\(countdown)"
        }
    }

    
    @IBOutlet weak var tryAgain: UIButton!
    @IBOutlet weak var nextLevel: UIButton!
    @IBOutlet weak var menu: UIButton!
    
    override func viewDidLoad() {
        
        //MARK: time
        super.viewDidLoad()
        print(level)
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)        
        //
        // Set the view's delegate
        sceneView.delegate = self
        //        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        // 
        // Set the scene to the view
        //        sceneView.scene = scene
        //        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        //
        nextLevel.isHidden = true
        menu.isHidden = true
        tryAgain.isHidden = true
//        session(ARSession, didUpdate: ARFrame)
    }
    
    //MARK: ARView
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
        let spCube = Int.random(in: 1...(2 * level + 1))
        
        for cube in 1 ... (2 * level + 1) {
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
                
                spCubeLoc = cubeNode.position
            } else {
                otherCubes.append(cubeNode.position)
            }
        }
    }
    
//    @IBAction func reset(_ sender: Any) {
//        restartSession()
//    }
    
    func reset(judge:Bool, worl:Bool){
        sceneView.session.pause()
        otherCubes.removeAll()
        self.sceneView.scene.rootNode.enumerateChildNodes{
            (node,_) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    
        if judge == true {
        //timer
          countdown = 60
          time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo:nil, repeats: true)
        } else if judge == false{
            if worl == true {
                time.invalidate()
                timer.text = "You Win"
            } else {
                time.invalidate()
                timer.text = "You Lose"
            }
            
        }
    }
    
    //MARK: - Game Result
    func gameIsWon(){
        reset(judge: false, worl: true)
        
        //ViewController.highest = CoreDataHelper.retrieveLevel() ?? nil
        if(ViewController.highest != nil){
            //var highNum = ViewController.highest.levelNum
            if(level > ViewController.highestNum) {
                CoreDataHelper.createLevel(num: Int64(level))
                CoreDataHelper.deleteLevel(level: ViewController.highest)
                ViewController.highestNum = level
            }
        } else {
            CoreDataHelper.createLevel(num: Int64(level))
        }
        
        isFirst = true
    }
    
    func gameIsLost(){
        reset(judge: false, worl: false)
        isFirst = true
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if isFirst {
            generateCubes()
        }
        
        guard let pointOfView = sceneView.pointOfView else {
            return
        }
        
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentCameraLocation = SCNVector3Make(orientation.x + location.x, orientation.y + location.y, orientation.z + location.z)
        
//        print(spCubeLoc.x, spCubeLoc.y, spCubeLoc.z)
//        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
//            if node.geometry is SCNSphere {
//                node.removeFromParentNode()
//            }
//        }
        
        
        DispatchQueue.main.async {
            print("here")
            if self.isFirst {
//                let beeScene = SCNScene(named: "art.scnassets/bee.scn")!
//                self.beeNode = beeScene.rootNode.childNode(withName: "bee", recursively: true)
                var ballShape = SCNSphere(radius: 0.02)
                self.beeNode = SCNNode(geometry: ballShape)
                self.beeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                self.beeNode.position = currentCameraLocation
                self.sceneView.scene.rootNode.addChildNode(self.beeNode)
                self.isFirst = false
            } else {
                self.beeNode.position = currentCameraLocation
            }
            print(currentCameraLocation.x, currentCameraLocation.y, currentCameraLocation.z)
            print(self.spCubeLoc.x, self.spCubeLoc.y, self.spCubeLoc.z)
            if self.spCubeLoc.x-0.03 ... self.spCubeLoc.x+0.03 ~= currentCameraLocation.x &&
                self.spCubeLoc.y-0.03 ... self.spCubeLoc.y+0.03 ~= currentCameraLocation.y &&
                self.spCubeLoc.z-0.03 ... self.spCubeLoc.z+0.03 ~= currentCameraLocation.z {
                
                print("touched sp")
                if(ViewController.highest != nil){
                    //var highNum = ViewController.highest.levelNum
                    if(self.level > ViewController.highestNum) {
                        CoreDataHelper.createLevel(num: Int64(self.level))
                        CoreDataHelper.deleteLevel(level: ViewController.highest)
                        ViewController.highestNum = self.level
                    }
                } else {
                    CoreDataHelper.createLevel(num: Int64(self.level))
                }
                self.nextLevel.isHidden = false
                self.menu.isHidden = false
            } else {
                //            print(level)
                for cube in 0...self.otherCubes.count - 1 {
//                    print(self.otherCubes[cube].x, self.otherCubes[cube].y, self.otherCubes[cube].z)
                    if (self.otherCubes[cube].x - 0.035 ... self.otherCubes[cube].x + 0.035).contains(currentCameraLocation.x) &&
                        (self.otherCubes[cube].y - 0.035 ... self.otherCubes[cube].y + 0.035).contains(currentCameraLocation.y) &&
                        (self.otherCubes[cube].z - 0.035 ... self.otherCubes[cube].z + 0.035).contains(currentCameraLocation.z) {
                        print("touched others")
                        self.tryAgain.isHidden = false
                    }
                }
            }
        }
        
    }
    
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
