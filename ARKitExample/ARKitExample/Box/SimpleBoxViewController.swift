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
        let results = sceneView.hitTest(location, options: [:])
        
        if !results.isEmpty {
            let node = results[0].node
            let material = node.geometry?.material(named: "color")
            let color = material?.diffuse.contents as? UIColor
            material?.diffuse.contents = color == UIColor.red ? UIColor.black : UIColor.red
        }
    }
}
