//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
//        //display logo image
//        let logo = UIImage(named: "logo_title.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Logo Watermark\n", terminator: "")
            
//            let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "WaterMarkVC")
//            let topViewController : UIViewController = self.navigationController!.topViewController!
////            if(topViewController.isKind(of: ShareVC.self)){
//                topViewController.present(destViewController, animated: true, completion: nil)
////            }
            
            break
        case 1:
            if !IAPHandler.shared.isRemovingAdsProductPurchased(){
                print("Remove Ads\n", terminator: "")
                
                IAPHandler.shared.purchaseMyProduct(index: 0)
//                IAPHandler.shared.restorePurchase()
     
            }else{
                print("About\n", terminator: "")
                Utils.callAlertView(title: "About the app", message: "Had enough of posting sports events on social media ? Always trying to be up to date with events ? Social Sports Post App now allows you to quickly and easily share great event posts !" , fromViewController: self)
            }
            
            break
        case 2:
            print("About\n", terminator: "")
            
//            self.openViewControllerBasedOnIdentifier("FixtureVC")
            Utils.callAlertView(title: "About the app", message: "Had enough of posting sports events on social media ? Always trying to be up to date with events ? Social Sports Post App now allows you to quickly and easily share great event posts !" , fromViewController: self)
            
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.rightBarButtonItem = customBarItem;
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 20, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 20, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 20, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 20, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 20, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 20, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = 1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
}
