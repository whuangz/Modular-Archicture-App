//
//  CircleImage.swift
//  Smack
//
//  Created by William Huang on 09/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

@IBDesignable
public class CircleImage: UIImageView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    public func setUpView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
