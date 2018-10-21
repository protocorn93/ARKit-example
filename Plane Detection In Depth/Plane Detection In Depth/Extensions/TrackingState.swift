//
//  TrackingState.swift
//  Plane Detection In Depth
//
//  Created by 이동건 on 21/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation
import ARKit

extension ARCamera.TrackingState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Tracking is not available now"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion :
                return "Too fast to track"
            case .initializing:
                return "Initializing"
            case .insufficientFeatures:
                return "We need textured surface"
            case .relocalizing:
                return "Relocalizing"
            }
        case .normal:
            return "Now Tracking"
        }
    }
}
