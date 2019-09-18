//
//  LeagueCell.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/13/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

class LeagueCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
