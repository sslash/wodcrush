//
//  stringUtils.swift
//  wodcrush
//
//  Created by michael gunnulfsen on 14/01/2020.
//  Copyright © 2020 michael gunnulfsen. All rights reserved.
//

import Foundation
import UIKit

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
    let color = uiColorWithHexString(hexString: hexString, alpha: alpha)
    return color.cgColor
}

func uiColorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {
    
    // Convert hex string to an integer
    let hexint = Int(intFromHexString(hexStr: hexString))
    let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
    
    // Create color object, specifying alpha as well
    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    return color
}
