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
    
    func analyze(images: [UIImage]) {
        let googleNetPlaces = GoogLeNetPlaces()
        var googleNetPlacesOutputs = [GoogLeNetPlacesOutput]()
        
        for image in images {
            if let resizedImage = resize(image: image), let pixelBuffer = resizedImage.pixelBuffer() {
                do {
                    try googleNetPlacesOutputs.append(googleNetPlaces.prediction(sceneImage: pixelBuffer))
                } catch {
                    assert(false)
                }
            }
        }
    }
    
    func resize(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 224, height: 224))
        image.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
