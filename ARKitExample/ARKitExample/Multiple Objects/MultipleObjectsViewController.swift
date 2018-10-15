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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.sceneView.session.pause()
    }
    
    private func setUPSceneview() {
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
    }
    
    private func generateScene(with nodes: [SCNNode]) -> SCNScene {
        let scene = SCNScene()
        nodes.forEach {
            scene.rootNode.addChildNode($0)
        }
        return scene
    }
    
    private func generateNode(with geometry: SCNGeometry, _ materials: [SCNMaterial], at position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.geometry = geometry
        node.geometry?.materials = materials
        node.position = position
        return node
    }
    
    private func generateMaterial(background: UIImage?) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = background
        return material
    }
}
