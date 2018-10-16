//
//  DisplayingTextViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class DisplayingTextViewController: BaseARViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPSceneview()
    
        let textGeometry = SCNText(string: "Hello World", extrusionDepth: 1)
        let material = generateMaterial(background: UIColor.black)
        let node = generateNode(with: textGeometry, [material], at: SCNVector3(x: 0, y: 0, z: -1))
        node.scale = SCNVector3(0.02, 0.02, 0.02)
        let scene = generateScene(with: [node])
        
        self.sceneView.scene = scene
    }
}
