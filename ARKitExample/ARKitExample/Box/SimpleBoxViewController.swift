//
//  SimpleBoxViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class SimpleBoxViewController: UIViewController {

    var sceneView: ARSCNView!
    
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
        let material = generateMaterial(background: .red)
        material.name = "color"
        let node = generateNode(with: box, [material], at: SCNVector3(0, 0.1, -0.5))
        let scene = generateScene(with: [node])
        self.sceneView.scene = scene
        
        addGesture(on: self.sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
    
    private func generateMaterial(background: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = background
        return material
    }
    
    private func addGesture(on view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
    }
    
    //MARK: Action
    @objc func handleTapped(_ gesture: UITapGestureRecognizer) {
        guard let sceneView = gesture.view as? ARSCNView else { return }
        let location = gesture.location(in: sceneView)
        let results = sceneView.hitTest(location, options: [:])
        
        if !results.isEmpty {
            let node = results[0].node
            let material = node.geometry?.material(named: "color")
            let color = material?.diffuse.contents as? UIColor
            material?.diffuse.contents = color == UIColor.red ? UIColor.black : UIColor.red
        }
    }
}
