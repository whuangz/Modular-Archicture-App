//
//  ChannelCell.swift
//  Smack
//
//  Created by William Huang on 14/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

public class ChannelCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    public func configureCell(channel: Channel){
        let title = channel.channelName ?? ""
        name.text = "#\(title)"
        name.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                name.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }

}
