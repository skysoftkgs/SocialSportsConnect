//
//  TemplateVC.swift
//  SocialSportsConnect
//
//  Created by PingLi on 5/13/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

import UIKit

class TemplateVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let templateCount = 6
    
  
    @IBOutlet weak var imageImportView: TouchableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        imageImportView.addTapGesture(tapNumber: 1, target: self, action: #selector(onImportClicked));
    }
    
    @objc func onImportClicked() {
        self.imagePicker.present(from: self.view)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCell", for:indexPath as IndexPath) as! TemplateCell
        
        let currentBundle = Bundle(for: TemplateVC.self)
        let path : String?
        if AppManager.shared().wherePost == 1 || AppManager.shared().wherePost == 3 {
            path = currentBundle.path(forResource: "template_post_\(indexPath.row)", ofType: "jpg")
        }else{
            path = currentBundle.path(forResource: "template_story_\(indexPath.row)", ofType: "jpg")
        }
        if path != nil {
            cell.templateImageView.image = UIImage(contentsOfFile: path!)
        }
        cell.layer.cornerRadius = 5
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 2
        var widthRemainingForCellContent = collectionView.bounds.width
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
        }
        let cellWidth = widthRemainingForCellContent / cellsAcross
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        
        var imagePath : String!
        if AppManager.shared().wherePost == 1 || AppManager.shared().wherePost == 3 {
            imagePath = "template_post_\(indexPath.row)"
        }else{
            imagePath = "template_story_\(indexPath.row)"
        }
        
        let currentBundle = Bundle(for: TemplateVC.self)
        let path = currentBundle.path(forResource: imagePath, ofType: "jpg")
        if path != nil {
            AppManager.shared().templateImage = UIImage(contentsOfFile: path!)
        }
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShareVC") as? ShareVC
        self.navigationController?.pushViewController(vc!, animated: true)
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

extension TemplateVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        AppManager.shared().templateImage = image
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShareVC") as? ShareVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}
