//
//  GymBoxCell.swift
//  wodcrush
//
//  Created by michael gunnulfsen on 02/01/2020.
//  Copyright © 2020 michael gunnulfsen. All rights reserved.
//
import UIKit

// TODO: move this into helpers
func intFromHexString(hexStr: String) -> UInt32 {
    var hexInt: UInt32 = 0
    // Create scanner
    let scanner: Scanner = Scanner(string: hexStr)
    // Tell scanner to skip the # character
    scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
    // Scan hex value
    scanner.scanHexInt32(&hexInt)
    return hexInt
}

func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> CGColor {
    
    // Convert hex string to an integer
    let hexint = Int(intFromHexString(hexStr: hexString))
    let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
    
    // Create color object, specifying alpha as well
    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
    return color
}

class GymBoxCell: UITableViewCell {
    var imageLogoUri: String = ""
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var gymName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var wodText: UILabel!
    
    func setGymBox(gymBox: GymBox) {
        gymName.text = gymBox.gymName
        wodText.text = gymBox.wodText
        address.text = gymBox.address
        imageLogoUri = gymBox.imageLogoUri
        
        // image style
        self.imageLogo.layer.cornerRadius = 4
        self.imageLogo.clipsToBounds = true
        self.imageLogo.layer.borderColor = colorWithHexString(hexString: "#F4F7FC")
        self.imageLogo.layer.borderWidth = 1.0
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
    
}
