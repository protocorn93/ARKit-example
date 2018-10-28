//
//  ViewController.swift
//  Plane Detection In Depth
//
//  Created by 이동건 on 17/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var trackingQualityLabel: UILabel!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        addGestureOnSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    private func addGestureOnSceneView() {
        self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    private func handleQualityOfTracking(with state: ARCamera.TrackingState) {
        trackingQualityLabel.text = "\(state)"
        UIView.animate(withDuration: 1, animations: {
            self.trackingQualityLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.trackingQualityLabel.alpha = 0
            })
        }
    }
    
    //MARK: Actions
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let sceneView = gesture.view as? ARSCNView else { return }
        let location = gesture.location(in: sceneView)
        let hitResult = sceneView.hitTest(location, types: [.existingPlane,.existingPlaneUsingExtent])
        guard let result = hitResult.first else { return }
        
        guard let treeScene = SCNScene(named: "art.scnassets/box.scn") else { return }
        guard let node = treeScene.rootNode.childNode(withName: "box", recursively: false) else { return }
        
        node.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(node)
    }
}

//MARK:- ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        let planeNode = SCNNode()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray.withAlphaComponent(0.6)
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        plane.materials = [material]
        
        planeNode.geometry = plane
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        guard let node = node.childNodes.first else { return }
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray.withAlphaComponent(0.6)
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        plane.materials = [material]
        
        node.geometry = plane
        node.position = SCNVector3(anchor.center.x, 0, anchor.center.z)

    }
    
    // ARSessionObserver
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        handleQualityOfTracking(with: camera.trackingState)
    }
}
