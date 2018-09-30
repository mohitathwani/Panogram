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
    static var allValues: [Self] {get}
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
    case bloom = "Bloom"
    case comic = "Comic"
    case photoEffect = "Photo Effect"
}

class FilterManager {
    static let sharedManager = FilterManager()

    private(set) var eaglContext: EAGLContext!
    private(set) var ciContext: CIContext!

    private init() {
        eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        ciContext = CIContext(eaglContext: eaglContext, options: convertToOptionalCIContextOptionDictionary([convertFromCIContextOption(CIContextOption.workingColorSpace): NSNull()]))
    }

    func apply(filter: Filter, toImages images: [UIImage]) -> [CIImage] {
        switch filter {
        case .blur:
//            fatalError("Not implemented yet")
            return applyBlur(toImages: images)

        case .sepia:
            return applySepia(toImages: images)

        case .bloom:
            return applyBloom(toImages: images)

        case .comic:
            return applyComic(toImages: images)

        case .photoEffect:
            return applyPhotoEffect(toImages: images)
        }
    }

    private func applyPhotoEffect(toImages images: [UIImage]) -> [CIImage] {
        let photoEffectFilter = PhotoEffectFilter()

        return apply(filter: photoEffectFilter, toImages: images)
    }
    private func applyComic(toImages images: [UIImage]) -> [CIImage] {
        let comicFilter = ComicFilter()

        return apply(filter: comicFilter, toImages: images)
    }

    private func applyBloom(toImages images: [UIImage]) -> [CIImage] {
        let bloomFilter = BloomFilter()

        return apply(filter: bloomFilter, toImages: images)

    }

    private func applyBlur(toImages images: [UIImage]) -> [CIImage] {
        let blurFilter = BlurFilter()

        return apply(filter: blurFilter, toImages: images)
    }

    private func applySepia(toImages images: [UIImage]) -> [CIImage] {
        let sepiaFilter = SepiaFilter()

        return apply(filter: sepiaFilter, toImages: images)
    }

    private func apply(filter: Filterable, toImages images: [UIImage]) -> [CIImage] {
        let filteredImages = images.map { (image) in
            return filter.applyTo(image: image)
        }

        return filteredImages
    }

    private func applyBlur(toImages images: [UIImage]) -> [UIImage] {
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
            originalRect.origin.x          += (originalRect.size.width  - image.size.width ) / 2
            originalRect.origin.y          += (originalRect.size.height - image.size.height) / 2
            originalRect.size               = image.size

            let cgImage = ciContext.createCGImage(outputImage, from: originalRect)
            outputImages.append(UIImage(cgImage: cgImage!))
        }
        return outputImages
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalCIContextOptionDictionary(_ input: [String: Any]?) -> [CIContextOption: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (CIContextOption(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromCIContextOption(_ input: CIContextOption) -> String {
	return input.rawValue
}
