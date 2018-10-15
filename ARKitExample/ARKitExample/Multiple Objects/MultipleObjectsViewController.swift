//
//  MultipleObjectsViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class MultipleObjectsViewController: UIViewController {
    private var sceneView: ARSCNView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIImage(named: "brick.jpg")
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.geometry?.materials = [boxMaterial]
        boxNode.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        
        let sphere = SCNSphere(radius: 0.05)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "earth.jpg")
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(-0.1, 0, -0.3)
        
        scene.rootNode.addChildNode(boxNode)
        scene.rootNode.addChildNode(sphereNode)
        
        self.sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.sceneView.session.pause()
    }
}
