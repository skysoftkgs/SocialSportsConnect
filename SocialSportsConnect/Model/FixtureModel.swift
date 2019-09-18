//
//  FixtureModel.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/15/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import Foundation

enum ItemType : Int{
    case LeagueType = 0
    case MatchType = 1
}

class Fixture {
//    var date : String?
    var itemType : ItemType! = .MatchType
    var time : Int64?
    var date : String?
    var homeTeamName : String?
    var homeTeamLogo : String?
    var awayTeamName : String?
    var awayTeamLogo : String?
    var leagueId : Int?
    var league : League?
    
    init(){
        
    }
    
    init(json: [String: Any]) {
        self.time = json["event_timestamp"] as? Int64
        self.date = json["event_date"] as? String
        if let homeTeam = json["homeTeam"] as? NSDictionary {
            self.homeTeamName = homeTeam["team_name"] as? String
            self.homeTeamLogo = homeTeam["logo"] as? String
        }
        if let awayTeam = json["awayTeam"] as? NSDictionary {
            self.awayTeamName = awayTeam["team_name"] as? String
            self.awayTeamLogo = awayTeam["logo"] as? String
        }
        self.leagueId = json["league_id"] as? Int
        
    }
    
}

class League{
    var league_id : Int?
    var name : String?
    var logoUrl : String?
    var flagUrl : String?
    
    init(json: [String: Any]) {
        self.league_id = json["league_id"] as? Int
        self.name = json["name"] as? String
        self.logoUrl = json["logo"] as? String
        self.flagUrl = json["flag"] as? String
    }
}
