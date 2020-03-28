
//
//  GymBoxCell.swift
//  wodcrush
//
//  Created by michael gunnulfsen on 02/01/2020.
//  Copyright © 2020 michael gunnulfsen. All rights reserved.
//
import UIKit

class GymBoxCell: UITableViewCell {
    var selectionCallback: ((_ text: String) -> Void)?
    var imageLogoUri: String = ""
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var gymName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var wodText: UILabel!
    
    func renderGymBox(gymBox: GymBox) {
        gymName.text = gymBox.gymName
        address.text = gymBox.address
        imageLogoUri = gymBox.imageLogoUri
        wodText.text = gymBox.wodText
        
        // image style
        self.imageLogo.layer.cornerRadius = 4
        self.imageLogo.clipsToBounds = true
        self.imageLogo.layer.borderColor = colorWithHexString(hexString: "#F4F7FC")
        self.imageLogo.layer.borderWidth = 1.0
        
        self.cellView.layer.cornerRadius = 4
        self.cellView.clipsToBounds = true
    }
    
    
    func fetchImage(documentsPath: String) {
        if (self.imageLogoUri == "") {
            return
        }
        
        let localImagePath = documentsPath + "/\(self.gymName.text ?? "default-image").jpg"
        
        // try to fetch the image locally first
        if let uiImage = UIImage(contentsOfFile: localImagePath) {
            self.imageLogo.image = uiImage
            return
        }
        
        // fetch remote image and store in local storage
        let url = URL(string: self.imageLogoUri)!
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if error != nil {
                print("error \(error)")
            } else {
                if let data = data {
                    
                    // put on image view
                    if let theImage = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            self.imageLogo.image = theImage
                        }
                        
                        
                        // save the image
                        if (documentsPath != "") {
                            do {
                                try theImage.jpegData(compressionQuality: 0.75)?.write(to: URL(fileURLWithPath: localImagePath))
                                print("Image saved \(localImagePath)")
                            } catch {
                                print("Failed to save image locally \(localImagePath)")
                            }
                            
                        }
                        
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        if let label = (sender.view) as? UILabel {
            if let text = label.text {
                self.selectionCallback?(text)
            }
        }
    }
}
