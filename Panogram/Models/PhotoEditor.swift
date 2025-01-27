//
//  PhotoEditor.swift
//  Panogram
//
//  Created by Labs on 7/9/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import CoreGraphics

enum PhotoEditorError: Error {
    case imageCutError
}

class PhotoEditor {
    static let sharedEditor = PhotoEditor()
    private init() {}
    
    func cut(panoramaImage: UIImage) throws -> [UIImage] {
        let width = panoramaImage.size.width / 3
        let height = panoramaImage.size.height
        
        let leftImageFrame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let centerImageFrame = CGRect(x: width, y: 0, width: width, height: height)
        
        let rightImageFrame = CGRect(x: width * 2, y: 0, width: width, height: height)
        
        guard
            let leftCGImage = panoramaImage.cgImage?.cropping(to: leftImageFrame),
            let centerCGImage = panoramaImage.cgImage?.cropping(to: centerImageFrame),
            let rightCGImage = panoramaImage.cgImage?.cropping(to: rightImageFrame) else {
                throw PhotoEditorError.imageCutError
        }
        
        let leftImage = UIImage(cgImage: leftCGImage)
        let centerImage = UIImage(cgImage: centerCGImage)
        let rightImage = UIImage(cgImage: rightCGImage)
        
        return [leftImage, centerImage, rightImage]
    }
    
    func analyze(images: [UIImage], completion: @escaping (Set<String>) -> Void) {
        
        DispatchQueue.global().async {
            let googleNetPlaces = GoogLeNetPlaces()
            var googleNetPlacesOutputs = [GoogLeNetPlacesOutput]()
            
            var tags = Set<String>()
            
            let byValue = {
                (elem1:(key: String, val: Double), elem2:(key: String, val: Double))->Bool in
                if elem1.val > elem2.val {
                    return true
                } else {
                    return false
                }
            }
            
            for image in images {
                if let resizedImage = self.resize(image: image, width: 224, height: 224), let pixelBuffer = resizedImage.pixelBuffer() {
                    do {
                        try googleNetPlacesOutputs.append(googleNetPlaces.prediction(sceneImage: pixelBuffer))
                    } catch {
                        assert(false)
                    }
                }
            }
            
            if googleNetPlacesOutputs.count > 0 {
                var index = 0
                
                let leftSortedDictArray = googleNetPlacesOutputs[0].sceneLabelProbs.sorted(by: byValue)
                
                let centerSortedDictArray = googleNetPlacesOutputs[1].sceneLabelProbs.sorted(by: byValue)
                
                let rightSortedDictArray = googleNetPlacesOutputs[2].sceneLabelProbs.sorted(by: byValue)
                
                while tags.count < 9 {
                    tags.insert(leftSortedDictArray[index].key)
                    tags.insert(centerSortedDictArray[index].key)
                    tags.insert(rightSortedDictArray[index].key)
                    
                    index += 1
                }
            }
            DispatchQueue.main.async {
                completion(tags)
            }
        }
    }
    
    func resize(image: UIImage, width: Int, height: Int) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
