//
//  MultipleObjectsViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class MultipleObjectsViewController: BaseARViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPSceneview()
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxMaterial = generateMaterial(background: UIImage(named: "brick.jpg"))
        let boxNode = generateNode(with: box, [boxMaterial], at: SCNVector3(0, 0, -0.5))
        
        let sphere = SCNSphere(radius: 0.08)
        let sphereMaterial = generateMaterial(background: UIImage(named: "earth.jpg"))
        let sphereNode = generateNode(with: sphere, [sphereMaterial], at: SCNVector3(-0.1, 0, -0.3))
        
        let scene = generateScene(with: [boxNode, sphereNode])
        self.sceneView.scene = scene
    }
}
