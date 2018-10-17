//
//  PlainDetectingViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 16/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class PlainDetectingViewController: BaseARViewController, ARSCNViewDelegate {
    
    private var label: UILabel!
    var planes: [OverlayPlane] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPSceneview()
        self.sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
    }
    
    override func setUPSceneview() {
        super.setUPSceneview()
        self.sceneView.delegate = self
        self.label = generateLabel()
        self.sceneView.addSubview(label)
    }
    
    private func generateLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.sceneView.frame.width, height: 44))
        label.center = self.view.center
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.alpha = 0
        return label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]
        
        self.sceneView.session.run(configuration)
    }
    
    override func handleSceneViewTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let sceneView = gesture.view as? ARSCNView else { return }
        let location = gesture.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let result = hitTestResult.first else { return }
        addBox(on: result)
    }
    
    private func addBox(on result: ARHitTestResult) {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        box.materials = [material]
        
        let node = SCNNode(geometry: box)
        let worldTransform = result.worldTransform
        node.position = SCNVector3(worldTransform.columns.3.x,
                                   worldTransform.columns.3.y,
                                   worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}

extension PlainDetectingViewController {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        /*
        DispatchQueue.main.async {
            self.label.text = "Plane Detected"
            
            UIView.animate(withDuration: 3, animations: {
                self.label.alpha = 1
            }, completion: { _ in
                self.label.alpha = 0
            })
        }
         */
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        let plane = OverlayPlane(anchor: anchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        let plane = self.planes.filter {
            $0.anchor.identifier == anchor.identifier
        }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor)
    }
}
