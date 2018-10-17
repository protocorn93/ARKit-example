//
//  SimpleBoxViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class SimpleBoxViewController: BaseARViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUPSceneview()
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = generateMaterial(background: UIColor.red)
        material.name = "color"
        let node = generateNode(with: box, [material], at: SCNVector3(0, 0.1, -0.5))
        let scene = generateScene(with: [node])
        self.sceneView.scene = scene
        
        addGesture(on: self.sceneView)
    }
    
    private func addGesture(on view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
    }
    
    //MARK: Action
    @objc func handleTapped(_ gesture: UITapGestureRecognizer) {
        guard let sceneView = gesture.view as? ARSCNView else { return }
        let location = gesture.location(in: sceneView)
        changeMaterial(of: sceneView, at: location)
        capture()
    }
    
    private func changeMaterial(of sceneView: ARSCNView, at location: CGPoint) {
        let results = sceneView.hitTest(location, options: [:])
        
        if !results.isEmpty {
            let node = results[0].node
            let material = node.geometry?.material(named: "color")
            let color = material?.diffuse.contents as? UIColor
            material?.diffuse.contents = color == UIColor.red ? UIColor.black : UIColor.red
        }
    }
    
    private func capture() {
        guard let currentFrame = self.sceneView.session.currentFrame else { return }
        
        let imagePlane = SCNPlane(width: sceneView.bounds.width / 6000, height: sceneView.bounds.height / 6000)
        imagePlane.firstMaterial?.diffuse.contents = self.sceneView.snapshot()
        imagePlane.firstMaterial?.lightingModel = .constant
        
        let planeNode = SCNNode(geometry: imagePlane)
        self.sceneView.scene.rootNode.addChildNode(planeNode)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
    }
}
