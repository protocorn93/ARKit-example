//
//  Menu.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit

enum Menu: String, CaseIterable, CustomStringConvertible {
    case box
    case text
    
    var description: String {
        return self.rawValue
    }
    
    var vc: UIViewController {
        switch self {
        case .box:
            return SimpleBoxViewController()
        case .text:
            return DisplayingTextViewController()
        }
    }
}
