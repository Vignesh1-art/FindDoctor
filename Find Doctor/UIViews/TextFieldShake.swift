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
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0,10,0,-10,0,10,0]
        animation.keyTimes = [0,0.14,0.28,0.42,0.56,0.7,0.84]
        animation.duration = 0.2
        animation.isAdditive = true
        self.layer.add(animation, forKey: "1")
    }
}
