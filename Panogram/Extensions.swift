//
//  Extensions.swift
//  Panogram
//
//  Created by Labs on 6/27/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

extension UIColor {
    convenience public init(red:UInt8, green:UInt8, blue:UInt8) {
        let r = CGFloat(Double(red)/255.0)
        let g = CGFloat(Double(green)/255.0)
        let b = CGFloat(Double(blue)/255.0)
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience public init(hex: Int) {
        let r = UInt8(((hex >> 16) & 0xFF))
        let g = UInt8(((hex >> 8) & 0xFF))
        let b = UInt8((hex & 0xFF))
        self.init(red: r, green: g, blue: b)
    }
}

extension UIViewController {
    func displayAlert(title: String, message:String, action: UIAlertAction) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
