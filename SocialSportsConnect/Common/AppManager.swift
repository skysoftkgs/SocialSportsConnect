//
//  AppManager.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/16/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import Foundation

class AppManager {
    
    // MARK: - Properties
    
    var leagueArray = [League]()
    var shareFixture : Fixture? = Fixture()
    var wherePost: Int?
    var templateImage: UIImage?
//    var template_image_path: String?
    
    private static var sharedAppManager: AppManager = {
        let appManager = AppManager()
        
        return appManager
    }()
    
    // MARK: -
    
  
    
    // Initialization
    
    private init() {

    }
    
    // MARK: - Accessors
    
    class func shared() -> AppManager {
        return sharedAppManager
    }
    
}
