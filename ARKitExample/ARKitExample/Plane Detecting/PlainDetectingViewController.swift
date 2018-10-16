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
