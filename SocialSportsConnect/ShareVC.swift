//
//  FixtureDetailVC.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/13/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import AFNetworking
import MBProgressHUD
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookLogin
import InstagramLogin

class ShareVC: BaseViewController,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate {

    
    var waterMarkImage : UIImage?
    var waterMarkFrame : CGRect?
    
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var leftTeamLogo: UIImageView!
    @IBOutlet weak var rightTeamLogo: UIImageView!
    
    @IBOutlet weak var leftTeamName: UILabel!
    
    @IBOutlet weak var rightTeamName: UILabel!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var fixtureDate: UILabel!
    @IBOutlet weak var fixtureTime: UILabel!
    
    @IBOutlet weak var saveView: TouchableView!
    
    @IBOutlet weak var instagramView: TouchableView!
    
    @IBOutlet weak var facebookView: TouchableView!
    
    @IBOutlet weak var whatsappView: TouchableView!
    
    @IBOutlet weak var mailView: TouchableView!
    
    @IBOutlet weak var imagePostView: UIView!
    
    @IBOutlet weak var waterMarkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        if let strUrl = AppManager.shared().shareFixture?.homeTeamLogo, let url = URL.init(string: strUrl) {
            leftTeamLogo.setImageWith(url, placeholderImage: UIImage(named: "fixture_football"))
        }
        
        if let strUrl = AppManager.shared().shareFixture?.awayTeamLogo, let url = URL.init(string: strUrl) {
            rightTeamLogo.setImageWith(url, placeholderImage: UIImage(named: "fixture_football"))
        }
        
        if let strUrl = AppManager.shared().shareFixture?.league?.logoUrl, let url = URL.init(string: strUrl) {
            leagueImageView.setImageWith(url, placeholderImage: UIImage(named: "fixture_football"))
        }
        
        leagueNameLabel.text = AppManager.shared().shareFixture?.league?.name
        leagueNameLabel.numberOfLines = 0
        leagueNameLabel.font = UIFont(name: "Helvetica-Bold", size:10)
        
        leftTeamName.text = AppManager.shared().shareFixture?.homeTeamName
        leftTeamName.numberOfLines = 0
        leftTeamName.font = UIFont(name: "Helvetica-BoldOblique", size:18)
        rightTeamName.text = AppManager.shared().shareFixture?.awayTeamName
        rightTeamName.numberOfLines = 0
        rightTeamName.font = UIFont(name: "Helvetica-BoldOblique", size:18)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let strDate = AppManager.shared().shareFixture?.date?.prefix(10), let  date = dateFormatter.date(from: String(strDate)){
            dateFormatter.dateFormat = "dd MMMM yyyy"
            fixtureDate.text = "  \(dateFormatter.string(from: date))  "
            fixtureDate.font = UIFont(name: "Helvetica-BoldOblique", size:18)
            
            if let t1 = AppManager.shared().shareFixture?.time, let t2 = Utils.getTimeFromTimestamp(timeStamp:t1) {
                 fixtureTime.text = "  \(t2)  "
            }else{
                fixtureTime.text = ""
            }
            fixtureTime.font = UIFont(name: "Helvetica-BoldOblique", size:16)
        }
        
        saveView.addTapGesture(tapNumber: 1, target: self, action: #selector(onSaveViewClicked))
        instagramView.addTapGesture(tapNumber: 1, target: self, action: #selector(onInstagramViewClicked))
        facebookView.addTapGesture(tapNumber: 1, target: self, action: #selector(onFacebookViewClicked))
        whatsappView.addTapGesture(tapNumber: 1, target: self, action: #selector(onWhatsappViewClicked))
        mailView.addTapGesture(tapNumber: 1, target: self, action: #selector(onMailViewClicked))
        
        if let image = AppManager.shared().templateImage {
            templateImageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let image = self.waterMarkImage, let frame = self.waterMarkFrame{
//            self.waterMarkImageView.frame = frame
//            self.waterMarkImageView.image = image
//        }
//
//        waterMarkImageView.isHidden = false
        
        if let image = self.waterMarkImage{
            self.templateImageView.image = image
            self.imagePostView.bringSubviewToFront(self.templateImageView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppManager.shared().wherePost == 1 || AppManager.shared().wherePost == 3 {
            let widthConstraint = imagePostView.widthAnchor.constraint(equalToConstant: imagePostView.frame.width + 50)
            let heightConstraint = imagePostView.heightAnchor.constraint(equalToConstant: imagePostView.frame.width + 50)
            self.view.addConstraint(widthConstraint)
            self.view.addConstraint(heightConstraint)
        }
    }
    
    @IBAction func onDoneClicked(_ sender: Any) {
        print(imagePostView.frame.width)
        print(imagePostView.frame.height)
    }
    
    //MARK: - Slide Menu
    
    override func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            let destViewController : WaterMarkVC = self.storyboard!.instantiateViewController(withIdentifier: "WaterMarkVC") as! WaterMarkVC
            waterMarkImageView.isHidden = true
            destViewController.bgImage = imagePostView.asImage()
            destViewController.shareVC = self
            
            self.present(destViewController, animated: true, completion: nil)
            
            break
            
        case 1:
            super.slideMenuItemSelectedAtIndex(index)
            break
            
        case 2:
            super.slideMenuItemSelectedAtIndex(index)
            break
            
        default:
            print("default\n", terminator: "")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Share actions
    
    // ------------- Save to photo library ------------
    
    @objc func onSaveViewClicked(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let selectedImage = imagePostView.asImage()
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            Utils.callAlertView(title: NSLocalizedString("Save error", comment: ""), message: error.localizedDescription, fromViewController: self)
            
        } else {
            Utils.callAlertView(title: NSLocalizedString("Saved!", comment: ""), message: "Your image has been saved to your photos.", fromViewController: self)
        }
    }
    
    // ------------- Send via email ------------
    
    @objc func onMailViewClicked(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setCcRecipients(["yyyy@xxx.com"])
            mail.setSubject("Your messagge")
            mail.setMessageBody("Message body", isHTML: false)
            let imageData: NSData = imagePostView.asImage().pngData()! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName.png")
            self.present(mail, animated: true, completion: nil)
        }else{
            Utils.callAlertView(title: NSLocalizedString("Warning", comment: ""), message: "You can't send email", fromViewController: self)
        }
    }
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result){
        case MFMailComposeResult.cancelled:
            print("Mail cancelled");
            break;
        case MFMailComposeResult.saved:
            print("Mail saved");
            break;
        case MFMailComposeResult.sent:
            print("Mail sent");
            break;
        case MFMailComposeResult.failed:
            print("Mail sent failure: %@", error?.localizedDescription ?? "");
            break;
        default:
            break;
        }
        // Close the Mail Interface
        controller.dismiss(animated: true)
    }
    
    // ------------- Post on Instagram ------------
    
    var instagramLogin: InstagramLoginViewController!
    
    // 1. Set your client info from Instagram's developer portal (https://www.instagram.com/developer/clients/manage)
    let clientId = "dfcde29cbe15477a88ae2d79f3df2328"
    let redirectUri = "1e1f5b1cee29437f93776a3a04c2dce5"
    
    func loginWithInstagram() {
        
        instagramLogin = InstagramLoginViewController(clientId: clientId, redirectUri: redirectUri)
        instagramLogin.delegate = self
        
        instagramLogin.scopes = [.basic, .publicContent] // [.basic] by default; [.all] to set all permissions
        instagramLogin.title = "Instagram" // If you don't specify it, the website title will be showed
        instagramLogin.progressViewTintColor = .blue // #E1306C by default
        
        // If you want a .stop (or other) UIBarButtonItem on the left of the view controller
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        
        // You could also add a refresh UIBarButtonItem on the right
        instagramLogin.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))
        
        // 4. Present it inside a UINavigationController (for example)
        present(UINavigationController(rootViewController: instagramLogin), animated: true)
    }
    
    @objc func dismissLoginViewController() {
        instagramLogin.dismiss(animated: true)
    }
    
    @objc func refreshPage() {
        instagramLogin.reloadPage()
    }

    @objc func onInstagramViewClicked(){
//        loginWithInstagram()
        ShareHelper.shareToInstagramPost(image: self.imagePostView.asImage(), onView: self.view, vc: self)
    }
        
    
    // ------------- Post on Facebook ------------
    
    @objc func onFacebookViewClicked(){
        DispatchQueue.main.async {
            
            if (AccessToken.isCurrentAccessTokenActive) {
                ShareHelper.shareImageViaFacebook(image: self.imagePostView.asImage(), fromViewController: self)

            }else{
                let loginManager = LoginManager()
                loginManager.logOut()
                loginManager.logIn(permissions: [], viewController: self, completion: { (result) in
                    switch result {
                    case .cancelled:
                        print("cancelled")
                    case .failed(let error):
                        print(error)
                    case .success(let _, _, _):
//                        if grantedPermissions.contains("publish_actions"){
                            ShareHelper.shareImageViaFacebook(image: self.imagePostView.asImage(), fromViewController: self)
//                        }
                    }
                })
            }
        }
    }
    
    func shareToFacebookStory (){
        DispatchQueue.main.async {
            ObjcUtils.share(toFacebookStory: self.imagePostView.asImage())
        }
    }
    
    // ------------- Post on Whatsapp ------------
    
    @objc func onWhatsappViewClicked(){
        DispatchQueue.main.async {
            ShareHelper.shareImageViaWhatsapp(image: self.imagePostView.asImage(), onView: self.view, vc: self)
        }
    }
}

// MARK: - InstagramLoginViewControllerDelegate

extension ShareVC: InstagramLoginViewControllerDelegate {
    
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {
        
//        ShareHelper.shareImageViaInstagram(image: self.imagePostView.asImage(), onView: self.view, vc: self)
        ShareHelper.shareToInstagramPost(image: self.imagePostView.asImage(), onView: self.view, vc: self)
        // And don't forget to dismiss the 'InstagramLoginViewController'
        instagramLogin.dismiss(animated: true)
    }
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
