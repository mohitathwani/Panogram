//
//  FilterManager.swift
//  Panogram
//
//  Created by Labs on 7/21/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import CoreImage

protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues :[Self] {get}
}

extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    static var allValues: [Self] {
        return Array(self.cases())
    }
}
enum Filter: String, EnumCollection {
    case blur = "Blur"
    case sepia = "Sepia"
}

class FilterManager {
    static let sharedManager = FilterManager()
    private let ciContext = CIContext()
    private init() {}
    
    func apply(filter: Filter, toImages images:[UIImage]) -> [UIImage] {
        switch filter {
        case .blur:
            return applyBlur(toImages: images)
            
        case .sepia:
            return applySepia(toImages: images)
        }
    }
    
    private func applySepia(toImages images:[UIImage]) -> [UIImage] {
        let sepiaFilter = SepiaFilter()
        
        return [UIImage]()
    }
    
    private func applyBlur(toImages images:[UIImage]) -> [UIImage] {
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {assert(false); return []}
        
        var outputImages = [UIImage]()
        
        for image in images {
            let ciImage = CIImage(image: image)
            blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
//            blurFilter.setValue(5,forKey: kCIInputRadiusKey)
            
            guard let outputImage = blurFilter.outputImage else {
                assert(false); return []
            }
            
            var originalRect = outputImage.extent
            originalRect.origin.x          += (originalRect.size.width  - image.size.width ) / 2;
            originalRect.origin.y          += (originalRect.size.height - image.size.height) / 2;
            originalRect.size               = image.size;
            
            let cgImage = ciContext.createCGImage(outputImage, from: originalRect)
            outputImages.append(UIImage(cgImage: cgImage!))
        }
        return outputImages
    }
}
