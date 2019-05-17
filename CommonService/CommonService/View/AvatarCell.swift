//
//  AvatarCell.swift
//  Smack
//
//  Created by William Huang on 08/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

public enum AvatarType{
    case dark
    case light
}

public class AvatarCell: UICollectionViewCell {
    @IBOutlet weak var avatarImg: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    public func configureCell(index: Int, avatarType: AvatarType){
        if avatarType == .dark {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }else if avatarType == .light{
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    public func setUpView(){
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
