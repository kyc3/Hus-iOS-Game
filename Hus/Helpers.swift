//
//  Helpers.swift
//  Hus
//
//  Created by Yannick Winter on 18.08.17.
//  Copyright © 2017 Winterapps. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    
    static func rotate(view: UIView, direction: RotationDirection) {
        if direction == .upsideDown {
            view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        else {
            view.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
}

enum RotationDirection {
    case normal
    case upsideDown
    
}
