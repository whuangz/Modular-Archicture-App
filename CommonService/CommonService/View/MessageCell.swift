//
//  MessageCell.swift
//  Smack
//
//  Created by William Huang on 16/07/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

public class MessageCell: UITableViewCell {

    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var msgBody: UILabel!
    @IBOutlet weak var msgTimeStamp: UILabel!
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configureCell(msg : Message){
        msgBody.text = msg.message
        userName.text = msg.userName
        userImg.image = UIImage(named: msg.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: msg.userAvatarColor)
        
        
        guard var isoDate = msg.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = String(isoDate[..<end])
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        if let finalDate = chatDate{
            let date = newFormatter.string(from: finalDate)
            msgTimeStamp.text = date
        }
    }
    
}
