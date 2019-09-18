//
//  FixtureVC.swift
//  SocialSportsConnect
//
//  Created by Li Ping on 5/10/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit
import SwipeMenuViewController
import GoogleMobileAds

class FixtureVC: BaseViewController {

    private var dateArray: [String] = []
    
    var bannerView: GADBannerView!
    
    @IBOutlet weak var swipeMenuView: SwipeMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        initSwipeMenu()
        
//        if !IAPHandler.shared.isRemovingAdsProductPurchased() {
//            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//            bannerView.adUnitID = "ca-app-pub-8335979304422353/2604504192"
////            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//    //        bannerView.adUnitID = "ca-app-pub-6770921823075242/2701799089"
//            bannerView.rootViewController = self
//    //        bannerView.delegate = self
//            addBannerViewToView(bannerView)
//
//            bannerView.load(GADRequest())
//        }
    }
    
    func initSwipeMenu(){
        let weekdays = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
        ]
        
        let today = Date()
//        let calendar = Calendar(identifier: .gregorian)
        let calendar = Calendar.current
        
        for i in 0...6 {
            let iDay = Calendar.current.date(byAdding: .day, value: i, to: today)
            let iDate = calendar.component(.day, from: iDay!)
            let weekDay = calendar.component(.weekday, from: iDay!)
            let dateStr = "\(weekdays[weekDay - 1]).\(iDate)"
            dateArray.append(dateStr)
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FixtureContentVC") as? FixtureContentVC
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.string(from: iDay!)
            vc?.fixtureDate = strDate
            self.addChild(vc!)
        }
       
        swipeMenuView.dataSource = self
        swipeMenuView.delegate = self
        
        var options: SwipeMenuViewOptions = .init()
        options.tabView.needsAdjustItemViewWidth = false
        options.tabView.itemView.width = self.view.frame.width / 7
        options.tabView.additionView.backgroundColor = UIColor(rgb: 0xfdb80a)
        
        swipeMenuView.reloadData(options: options)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .height,
                                multiplier: 1,
                                constant: 50),
             NSLayoutConstraint(item: swipeMenuView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bannerView,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0)
            ])
        
//        NSLayoutConstraint.activate([swipeMenuView.bottomAnchor.constraint(equalTo: bannerView.topAnchor)])
    }
    
    
//    func addBannerViewToView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        if #available(iOS 11.0, *) {
//            // In iOS 11, we need to constrain the view to the safe area.
//            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
//        }
//        else {
//            // In lower iOS versions, safe area is not available so we use
//            // bottom layout guide and view edges.
//            positionBannerViewFullWidthAtBottomOfView(bannerView)
//        }
//
//        view.addConstraint(NSLayoutConstraint(item: swipeMenuView,
//                                              attribute: .bottom,
//                                              relatedBy: .equal,
//                                              toItem: bannerView,
//                                              attribute: .top,
//                                              multiplier: 1,
//                                              constant: 0))
//    }
//
//    // MARK: - view positioning
//    @available (iOS 11, *)
//    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
//        // Position the banner. Stick it to the bottom of the Safe Area.
//        // Make it constrained to the edges of the safe area.
//        let guide = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
//            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
//            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
//            ])
//
//
//    }
//
//    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
//        view.addConstraint(NSLayoutConstraint(item: bannerView,
//                                              attribute: .leading,
//                                              relatedBy: .equal,
//                                              toItem: view,
//                                              attribute: .leading,
//                                              multiplier: 1,
//                                              constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: bannerView,
//                                              attribute: .trailing,
//                                              relatedBy: .equal,
//                                              toItem: view,
//                                              attribute: .trailing,
//                                              multiplier: 1,
//                                              constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: bannerView,
//                                              attribute: .bottom,
//                                              relatedBy: .equal,
//                                              toItem: bottomLayoutGuide,
//                                              attribute: .top,
//                                              multiplier: 1,
//                                              constant: 0))
//
//    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension FixtureVC: SwipeMenuViewDelegate {
    
    // MARK - SwipeMenuViewDelegate
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        // Codes
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        // Codes
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }
}

extension FixtureVC: SwipeMenuViewDataSource {
    
    //MARK - SwipeMenuViewDataSource
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return dateArray.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return dateArray[index]
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = children[index]
        vc.didMove(toParent: self)
        return vc
    }
}
