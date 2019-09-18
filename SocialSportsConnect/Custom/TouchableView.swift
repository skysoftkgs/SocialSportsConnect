//
//  TouchableView.swift
//  SocialSportsConnect
//
//  Created by Li Ping on 5/10/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

@IBDesignable class TouchableView: UIView {

    var originColor: UIColor!
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        originColor = self.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        originColor = self.backgroundColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.originColor.withAlphaComponent(0.5)
        })
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
       
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.originColor
        })
    }
    
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.cancelsTouchesInView = false
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
