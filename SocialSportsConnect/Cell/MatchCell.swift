//
//  MatchCell.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/13/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
