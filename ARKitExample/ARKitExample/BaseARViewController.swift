//
//  BaseARViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 16/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class BaseARViewController: UIViewController {
    
    var sceneView: ARSCNView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setUPSceneview() {
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
    }
    
    func generateScene(with nodes: [SCNNode]) -> SCNScene {
        let scene = SCNScene()
        nodes.forEach {
            scene.rootNode.addChildNode($0)
        }
        return scene
    }
    
    func generateNode(with geometry: SCNGeometry, _ materials: [SCNMaterial], at position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.geometry = geometry
        node.geometry?.materials = materials
        node.position = position
        return node
    }
    
    func generateMaterial(background: Any?) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = background
        return material
    }
}
