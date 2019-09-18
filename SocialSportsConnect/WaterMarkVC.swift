//
//  WaterMarkVC.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/25/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit
import Foundation

class WaterMarkVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
//    @IBOutlet weak var imageImportView: TouchableView!
    @IBOutlet weak var editButton: UIButton!
    
    var bgImage : UIImage?
    var shareVC : ShareVC?
    var imagePicker: ImagePicker!
    var waterMarkFileNameArray = [String]()
    var waterMarkViewArray = [ZDStickerView]()
    var editMode : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editMode = false
        waterMarkFileNameArray = UserDefaults.standard.stringArray(forKey: "waterMarkImagePath") ?? [String]()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        imageCollectionView.reloadData()
                
        if let image = bgImage {
            bgImageView.image = image
        }
        bgImageView.clipsToBounds = true
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
//        imageImportView.addTapGesture(tapNumber: 1, target: self, action: #selector(onImageImportClicked));
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppManager.shared().wherePost == 1 || AppManager.shared().wherePost == 3 {
            let width = containerView.frame.width + 50
            let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: width)
            let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: width)
            self.view.addConstraint(widthConstraint)
            self.view.addConstraint(heightConstraint)
        }
    }
 
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.pngData() else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
            waterMarkFileNameArray.append(imageName)
            UserDefaults.standard.set(waterMarkFileNameArray, forKey: "waterMarkImagePath")
            
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
    @objc func deleteWatermark(_ sender: UIButton){
        let tag = sender.tag
        let deleteAlert = UIAlertController(title: "Delete watermark", message: "Are you sure to delete watermark ?", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.waterMarkFileNameArray.remove(at: tag)
            UserDefaults.standard.set(self.waterMarkFileNameArray, forKey: "waterMarkImagePath")
            self.imageCollectionView.reloadData()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
            deleteAlert.dismiss(animated: true, completion: nil)
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    

    @IBAction func addWaterMarkAction(_ sender: Any) {
        self.imagePicker.present(from: self.view)
    }
    
    @IBAction func editWaterMarkAction(_ sender: Any) {
        
        if editMode! {
            editMode = false
            editButton.setTitle("Edit", for: .normal)
        }else{
            editMode = true
            editButton.setTitle("Done", for: .normal)
        }
        
        imageCollectionView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyAction(_ sender: Any) {
        if let vc = self.shareVC {
//            vc.waterMarkImage = self.waterMarkImageView.image
//            vc.waterMarkFrame = self.waterMarkImageView.frame
//            waterMarkImageView.layer.borderWidth = 0
//            waterMarkImageView.layer.cornerRadius = 0
            for waterMarkView in waterMarkViewArray {
                waterMarkView.hideDelHandle()
                waterMarkView.hideEditingHandles()
            }
            
            vc.waterMarkImage = self.containerView.asImage()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc func onImageImportClicked() {
//
//    }
    
    
    // MARK: - Photo table
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        return waterMarkFileNameArray.count + 1;
        return waterMarkFileNameArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatermarkCell", for: indexPath) as! WatermarkCell;
        cell.closeButton.tag = indexPath.row
        cell.closeButton.addTarget(self, action: #selector(deleteWatermark(_:)), for: .touchUpInside)
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.cornerRadius = 5
        
//        if(indexPath.row == 0){
//            cell.watermarkImageView.image = UIImage(named: "ic_plus")
//
//        }else{
            cell.watermarkImageView.image = loadImageFromDiskWith(fileName: waterMarkFileNameArray[indexPath.row])
            if (editMode) {
                cell.closeButton.isHidden = false
            }else{
                cell.closeButton.isHidden = true
            }
        
//        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 80, height: 80);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        if(indexPath.row == 0){
//            self.imagePicker.present(from: self.view)
//
//        }else{
            if let image = loadImageFromDiskWith(fileName: waterMarkFileNameArray[indexPath.row]){
                let width = image.size.width > containerView.frame.width ? containerView.frame.width : image.size.width
                let frame = CGRect(x: 20, y: 20, width: width, height: width / image.size.width * image.size.height )
                let imageView = UIImageView(frame: frame)
                imageView.image = image
                let resizableView = ZDStickerView(frame: frame)
                resizableView.tag = 1000
//                resizableView.stickerViewDelegate = self
                resizableView.contentView = imageView
                resizableView.borderColor = UIColor.white
                resizableView.borderWidth = 2.0
                resizableView.preventsPositionOutsideSuperview = false
                resizableView.translucencySticker = false
                resizableView.allowPinchToZoom = true
                resizableView.showEditingHandles()
                containerView.addSubview(resizableView)
                waterMarkViewArray.append(resizableView)
            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WaterMarkVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image1 = image {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
            let myString = formatter.string(from: date)
            saveImage(imageName: "watermark_\(myString).png", image: image1)
            self.imageCollectionView.reloadData()

        }
    }
}
