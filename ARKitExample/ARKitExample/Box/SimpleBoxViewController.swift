//
//  SimpleBoxViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class SimpleBoxViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    
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
        // Create a new scene
        let scene = SCNScene()
        
        // Geometry
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        // Materials
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        // Node
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0, -0.5)
        
        // Add Node
        scene.rootNode.addChildNode(node)
        // Allocate Scene
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
