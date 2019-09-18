//
//  FixtureContentVC.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/11/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import GoogleMobileAds

class FixtureContentVC: UITableViewController, GADInterstitialDelegate {

    var fixtureDate : String!
    var fixtureArray = [Fixture]()
    var displayFixtureArray = [Fixture]()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        tableView.register(UINib.init(nibName: "MatchCell", bundle: nil), forCellReuseIdentifier: "MatchCell")
//        tableView.register(LeagueCell.self, forCellReuseIdentifier: "LeagueCell")
//        tableView.register(MatchCell.self, forCellReuseIdentifier: "MatchCell")
        tableView.backgroundColor = UIColor(rgb: 0x2f2f2f)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        showFixtures()
        
        if !IAPHandler.shared.isRemovingAdsProductPurchased() {
            interstitial = createAndLoadInterstitial()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8335979304422353/1912546070")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func showFixtures(){
        let url = "https://api-football-v1.p.rapidapi.com/v2/fixtures/date/\(fixtureDate!)"
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("cd973f4d84msh6c77d8e44986bc1p106e6fjsne0d3a5572c4c", forHTTPHeaderField: "X-RapidAPI-Key")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        manager.get( url,
                     parameters: nil,
                     success: { (operation: AFHTTPRequestOperation,responseObject: Any?) in
                        print("JSON: " + responseObject.debugDescription)
                        if let json = responseObject as? [String: Any], let apiJson = json["api"] as? [String: Any], let fixturesJsonArray = apiJson["fixtures"] as? [[String: Any]]{
                            for fixtureJson in fixturesJsonArray{
                                let fixture = Fixture(json: fixtureJson)
                                fixture.league = self.getLeagueById(leagueId: fixture.leagueId!)
                                self.fixtureArray.append(fixture)
                            }
//                            DispatchQueue.main.async {
                                self.reorderByLeague()
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.tableView.reloadData()
                            
//                            }
                            
                        }
//                        if let json = responseObject as? NSDictionary{
//                            if let apiJson = json["api"] as? NSDictionary{
//                                if let fixturesJson = apiJson["fixtures"] as? NSDictionary{
//                                    let fixture = Fixture(json: fixturesJson as! [String : Any])
//                                    self.fixtureArray.append(fixture)
//                                }
//                            }
//                        }
                        
        },
                     failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                        print("Error: " + error.localizedDescription)
        })
    }
    
    func getLeagueById(leagueId : Int) -> League?{
        for league in AppManager.shared().leagueArray {
            if let id = league.league_id, id == leagueId {
                return league
            }
        }
        
        return nil
    }
    
    func reorderByLeague(){
        let sortedArray = fixtureArray.sorted {
            $0.leagueId! < $1.leagueId!
        }
        
        displayFixtureArray = [Fixture]()
        var prevLeagueId = -1
        for i in 0...sortedArray.count-1 {
            if let leagudId = sortedArray[i].leagueId, leagudId != prevLeagueId {
                let item = Fixture()
                item.itemType = .LeagueType
                item.league = sortedArray[i].league
                item.date = sortedArray[i].date
                displayFixtureArray.append(item)
                prevLeagueId = leagudId
            }
            displayFixtureArray.append(sortedArray[i])
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return displayFixtureArray.count
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if let type = self.displayFixtureArray[indexPath.row].itemType, type == .LeagueType
        {
            return 36.0;//Choose your custom row height
        }else{
            return 44.0;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let fixture = self.displayFixtureArray[indexPath.row]
        if let type = fixture.itemType, type == .LeagueType
        {
            let cell:LeagueCell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell",  for: indexPath) as! LeagueCell

            cell.leagueNameLabel?.text = fixture.league?.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            if let  date = dateFormatter.date(from: fixtureDate){
                dateFormatter.dateFormat = "dd MMMM"
                cell.dateLabel?.text = dateFormatter.string(from: date)
            }
          
            
            if let strUrl = fixture.league?.logoUrl, let url = URL.init(string: strUrl) {
                cell.flagImageView?.setImageWith(url)
            }else{
                cell.flagImageView?.image = UIImage(named: "fixture_football")
            }
            return cell
            
        }else if let type = fixture.itemType, type == .MatchType{
            let cell:MatchCell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell

            cell.timeLabel.text = "\(Utils.getTimeFromTimestamp(timeStamp: fixture.time!)!)"
            cell.teamNameLabel.text = "\(fixture.homeTeamName!)\n\(fixture.awayTeamName!)"
            cell.teamNameLabel.numberOfLines = 0
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        //getting the index path of selected row
        let fixture = self.displayFixtureArray[indexPath.row]
        
        if !IAPHandler.shared.isRemovingAdsProductPurchased() {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        }
        
        if let type = fixture.itemType, type == .MatchType
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TemplateVC") as? TemplateVC
            AppManager.shared().shareFixture = fixture
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
