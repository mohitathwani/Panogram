//
//  FilterManager.swift
//  Panogram
//
//  Created by Labs on 7/21/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import CoreImage

enum Filter: String {
    case blur = "Blur"
}

class FilterManager {
    static let sharedManager = FilterManager()
    private let ciContext = CIContext()
    private init() {}
    
    func apply(filter: Filter, toImages images:[UIImage]) -> [UIImage] {
        switch filter {
        case .blur:
            return applyBlur(toImages: images)
        }
    }
    
    private func applyBlur(toImages images:[UIImage]) -> [UIImage] {
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {assert(false)}
        
        var outputImages = [UIImage]()
        
        for image in images {
            let ciImage = CIImage(image: image)
            blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
//            blurFilter.setValue(5,forKey: kCIInputRadiusKey)
            
            guard let outputImage = blurFilter.outputImage else {
                assert(false)
            }
            
            let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent)
            outputImages.append(UIImage(cgImage: cgImage!))
        }
        return outputImages
    }
}
