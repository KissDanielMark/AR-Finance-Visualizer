//
//  ViewController.swift
//  AR_Demo
//
//  Created by Kiss Dániel Márk on 2023. 03. 21..
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    @IBOutlet weak var arView: ARView!
    var tankAnchor: TinyToyTank._TinyToyTank?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        tankAnchor = try! TinyToyTank.load_TinyToyTank()
        tankAnchor!.cannon?.setParent(
          tankAnchor!.tank, preservingWorldTransform: true)
       
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        arView.scene.anchors.append(tankAnchor!)
    }
    @IBAction func forwardPressed(_ sender: Any) {
        tankAnchor!.notifications.tankForward.post()
    }
    
    @IBAction func rightPressed(_ sender: Any) {
        tankAnchor!.notifications.tankRight.post()
    }
    @IBAction func firePressed(_ sender: Any) {
        tankAnchor!.notifications.cannonFire.post()
    }
}
