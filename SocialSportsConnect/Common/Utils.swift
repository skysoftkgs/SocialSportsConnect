//
//  Utils.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/14/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

class Utils {
    
    static func callAlertView(title: String, message: String, fromViewController: UIViewController!){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        fromViewController.present(ac, animated: true)
    }
    
    static func getTimeFromTimestamp(timeStamp: Int64) -> String!{
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date) as String
        return strDate
    }
}
