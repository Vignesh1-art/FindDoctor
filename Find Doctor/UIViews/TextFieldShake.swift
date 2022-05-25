//
//  TextFieldShake.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 18/05/22.
//

import Foundation
import UIKit

class TextFieldShake : UITextField {
    func shake() {
        let viewToShake = self
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        viewToShake.layer.add(animation, forKey: "position")
    }
}
