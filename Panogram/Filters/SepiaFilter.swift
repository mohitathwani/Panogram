//
//  SepiaFilter.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/22/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit
import CoreImage

class SepiaFilter {
    func applyTo(image: UIImage) -> CIImage{
        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not convert UIImage to CIImage")
        }
        let filteredImage = ciImage.applyingFilter("CISepiaTone",
                                                   parameters: [kCIInputIntensityKey: 0.9])
        
        return filteredImage
    }
}
