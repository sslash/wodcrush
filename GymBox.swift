//
//  GymBox.swift
//  wodcrush
//
//  Created by michael gunnulfsen on 02/01/2020.
//  Copyright © 2020 michael gunnulfsen. All rights reserved.
//

import Foundation
import UIKit

class GymBox {
    var gymName: String
    var imageLogoUri: String
    var wodText: String
    var address: String
    
    init(gymName: String, wodText: String, address: String, imageLogoUri: String) {
        self.gymName = gymName
        self.imageLogoUri = imageLogoUri
        self.wodText = wodText
        self.address = address
    }
}
