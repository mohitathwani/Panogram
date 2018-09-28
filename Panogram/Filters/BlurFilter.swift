//
//  BlurFilter.swift
//  Panogram
//
//  Created by TeraMo Labs on 5/23/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class BlurFilter: Filterable {
    func applyTo(image: UIImage) -> CIImage {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not convert UIImage to CIImage")
        }
        let filteredImage = ciImage.applyingFilter("CIGaussianBlur",
                                                   parameters: [kCIInputRadiusKey: 5])
        
        return filteredImage
    }
}
