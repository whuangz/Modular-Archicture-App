//
//  GradientView.swift
//  Smack
//
//  Created by William Huang on 25/05/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

@IBDesignable
public class GradientView: UIView {

    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1) {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.4259771155, green: 0.7462966996, blue: 0.8775706887, alpha: 1) {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
