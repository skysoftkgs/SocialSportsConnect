//
//  LeftAlignedIconButton.swift
//  SocialSportsConnect
//
//  Created by Li Ping on 5/10/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        imageView?.contentMode = .scaleAspectFit

//        let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
//
//        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
//        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
}
