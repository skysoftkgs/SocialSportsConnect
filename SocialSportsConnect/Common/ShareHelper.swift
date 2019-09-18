//
//  ShareHelper.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/14/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit
import FBSDKShareKit

class ShareHelper: NSObject  {
    
    static var documentInteractionController: UIDocumentInteractionController!
    
    static func shareImageViaWhatsapp(image: UIImage, onView: UIView, vc: UIViewController) {
        let urlWhats = "whatsapp://app"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    
                    guard let imageData = image.pngData() else { debugPrint("Cannot convert image to data!"); return }
                    
                    let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                    do {
                        try imageData.write(to: tempFile, options: .atomic)
                        self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
                        self.documentInteractionController.uti = "net.whatsapp.image"
                        self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: onView, animated: true)
                        
                    } catch {
                        Utils.callAlertView(title: NSLocalizedString("information", comment: ""), message: "There was an error while processing, please contact our support team.", fromViewController: vc)
                    
                        return
                    }
                    
                } else {
                    Utils.callAlertView(title: NSLocalizedString("warning", comment: ""), message: "Cannot open Whatsapp, be sure Whatsapp is installed on your device.", fromViewController: vc)
                }
            }
        }
    }
    
    
    static func shareImageViaInstagram(image: UIImage, onView: UIView, vc: UIViewController) {
        let urlWhats = "instagram://app"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    
                    guard let imageData = image.pngData() else { debugPrint("Cannot convert image to data!"); return }
                    
                    let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/fitbestPhoto.igo")
                    do {
                        try imageData.write(to: tempFile, options: .atomic)
                        self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
                        self.documentInteractionController.uti = "com.instagram.exclusivegram"
                        self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: onView, animated: true)
                        
                    } catch {
                        Utils.callAlertView(title: NSLocalizedString("information", comment: ""), message: "There was an error while processing, please contact our support team.", fromViewController: vc)
                    
                        return
                    }
                    
                } else {
                    Utils.callAlertView(title: NSLocalizedString("warning", comment: ""), message: "Cannot open Instagram, be sure Instagram is installed on your device.", fromViewController: vc)
                }
            }
        }
    }
    
    static func shareToInstagramPost(image: UIImage, onView: UIView, vc: UIViewController){
        DispatchQueue.main.async {
            
            //Share To Instagram:
            let instagramURL = URL(string: "instagram://app")
            if UIApplication.shared.canOpenURL(instagramURL!) {
                
                let imageData = image.jpegData(compressionQuality: 1.0)
                let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
                
                do {
                    try imageData?.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                } catch {
                    print(error)
                }
                
                let fileURL = URL(fileURLWithPath: writePath)
                self.documentInteractionController = UIDocumentInteractionController(url: fileURL)
                self.documentInteractionController.delegate = vc as? UIDocumentInteractionControllerDelegate
                self.documentInteractionController.uti = "com.instagram.exlusivegram"
                
                //                if UIDevice.current.userInterfaceIdiom == .phone {
                self.documentInteractionController.presentOpenInMenu(from: onView.bounds, in: onView, animated: true)
                //                } else {
                //                    self.documentController.presentOpenInMenu(from: self.IGBarButton, animated: true)
                //                }
            } else {
                Utils.callAlertView(title: NSLocalizedString("Warning", comment: ""), message: "Instagram is not installed", fromViewController: vc)
                print(" Instagram is not installed ")
            }
        }
    }
    
    func shareToInstagramStory(image: UIImage){
        let url = URL(string: "instagram-stories://share")!
        if UIApplication.shared.canOpenURL(url){
            
            let backgroundData = image.jpegData(compressionQuality: 1.0)
            //            let creditCardImage = UIImage(named: "share_instagram")!
            //            let stickerData = UIImagePNGRepresentation(creditCardImage)!
            let pasteBoardItems = [
                ["com.instagram.sharedSticker.backgroundImage" : backgroundData],
                ["com.instagram.sharedSticker.stickerImage" : backgroundData],
                ]
            
            if #available(iOS 10.0, *) {
                
                UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
            } else {
                UIPasteboard.general.items = pasteBoardItems
            }
            UIApplication.shared.openURL(url)
        }
    }
    
    static func shareImageViaFacebook(image: UIImage, fromViewController: UIViewController) {

        let sharePhoto = SharePhoto()
        sharePhoto.image = image
        sharePhoto.isUserGenerated = true

        let content = SharePhotoContent()
        content.photos = [sharePhoto]

        let dialog = ShareDialog()
//        dialog.delegate = (fromViewController as! SharingDelegate)
        dialog.fromViewController = fromViewController
        dialog.shareContent = content
        dialog.mode = .shareSheet
        dialog.show()
    }
    
    static func shareImageViaActivity(image: UIImage, onView: UIViewController) {
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        // so that iPads won't crash
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = vc.popoverPresentationController {
                popoverController.sourceView = onView.view
                popoverController.sourceRect = CGRect(x: onView.view.bounds.midX, y: onView.view.bounds.maxY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        // exclude some activity types from the list (optional)
        onView.present(vc, animated: true)
        
    }    
}
