//
//  WatermarkCell.swift
//  SocialSportsConnect
//
//  Created by PingLi on 6/15/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

class WatermarkCell: UICollectionViewCell {
    
    @IBOutlet weak var watermarkImageView: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
}
