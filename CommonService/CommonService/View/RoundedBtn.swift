
//
//  RoundedBtn.swift
//  Smack
//
//  Created by William Huang on 07/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

@IBDesignable

public class RoundedBtn: UIButton {
    @IBInspectable var cornerRadius:CGFloat = 3.0 {
        didSet{
            self.setNeedsLayout()
            //self.layer.cornerRadius = cornerRadius
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    public func setUpView(){
        self.layer.cornerRadius = cornerRadius
    }
}
