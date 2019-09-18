//
//  ViewController.swift
//  SocialSportsConnect
//
//  Created by Li Ping on 5/10/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class HomeVC: BaseViewController {
  
    @IBOutlet weak var instagramPostView: TouchableView!
    @IBOutlet weak var instagramStoryView: TouchableView!
    @IBOutlet weak var facebookPostView: TouchableView!
    @IBOutlet weak var facebookStoryView: TouchableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "logo_title_home.png"))
        let buttonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = buttonItem
                
        getLeagues { (success) -> Void in

        }
        
        
//        let htmlString = "<font color=\"red\" size = \"4px\">This is  </font> <p><font color=\"blue\"> some text!</font>"
//        
//        let encodedData = htmlString.data(using: String.Encoding.utf8)!
//        do {
//            let attributedString = try NSMutableAttributedString(data: encodedData,
//                                                                 options: [.documentType : NSAttributedString.DocumentType.html],
//                                                                 documentAttributes: nil)
//            
//            myLabel.numberOfLines = 0
//            myLabel.attributedText = attributedString
//        
//            
//        } catch _ {
//            print("Cannot create attributed String")
//        }
        
        IAPHandler.shared.fetchAvailableProducts()
        addSlideMenuButton()
        
        instagramPostView.addTapGesture(tapNumber: 1, target: self, action: #selector(onInstagramPostClicked));
        instagramStoryView.addTapGesture(tapNumber: 1, target: self, action: #selector(onInstagramStoryClicked));
        facebookPostView.addTapGesture(tapNumber: 1, target: self, action: #selector(onFacebookPostClicked));
        facebookStoryView.addTapGesture(tapNumber: 1, target: self, action: #selector(onFacebookStoryClicked));
    }

    @objc func onInstagramPostClicked(){
        AppManager.shared().wherePost = 1
        goFixturePage()
    }
    
    @objc func onInstagramStoryClicked(){
        AppManager.shared().wherePost = 2
        goFixturePage()
    }
    
    @objc func onFacebookPostClicked(){
        AppManager.shared().wherePost = 3
        goFixturePage()
    }
    
    @objc func onFacebookStoryClicked(){
        AppManager.shared().wherePost = 4
        goFixturePage()
    }
    
    func goFixturePage() {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShareVC") as? ShareVC
//        self.navigationController?.pushViewController(vc!, animated: true)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FixtureVC") as? FixtureVC
        if AppManager.shared().leagueArray.count > 0 {
            self.navigationController?.pushViewController(vc!, animated: true)

        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            getLeagues { (success) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                if success {
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    Utils.callAlertView(title: "Error", message: "Server error!", fromViewController: self)
                }

            }
        }
    }
    
    func getLeagues(completion: @escaping ((Bool) -> Void)){
        let url = "https://api-football-v1.p.rapidapi.com/v2/leagues"
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("cd973f4d84msh6c77d8e44986bc1p106e6fjsne0d3a5572c4c", forHTTPHeaderField: "X-RapidAPI-Key")
        manager.get( url,
                     parameters: nil,
                     success: { (operation: AFHTTPRequestOperation,responseObject: Any?) in
                        print("JSON: " + responseObject.debugDescription)
                        AppManager.shared().leagueArray.removeAll()
                        if let json = responseObject as? [String: Any], let apiJson = json["api"] as? [String: Any], let leaguesJsonArray = apiJson["leagues"] as? [[String: Any]]{
                            for leagueJson in leaguesJsonArray{
                                let league = League(json: leagueJson)
                                AppManager.shared().leagueArray.append(league)
                            }
                        }
                        completion(true)
                        
        },
                     failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                        print("Error: " + error.localizedDescription)
                        completion(false)
        })
    }
}

