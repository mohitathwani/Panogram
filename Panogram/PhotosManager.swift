//
//  PhotosManager.swift
//  Panogram
//
//  Created by Labs on 6/30/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import Photos

enum FetchError: Error {
    case collectionFetchError
}

class PhotosManager {
    static let sharedManager = PhotosManager()
    private init() {}
    
    var isAuthorized: Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    func requestPermission(completion: @escaping ()->Void) {
        PHPhotoLibrary.requestAuthorization {_ in
            completion()
        }
    }
    
    func fetchImages(completion:@escaping ([UIImage]) -> Void) throws{
        
        let assetCollectionFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: nil)
        
        guard let panoramasCollection = assetCollectionFetchResult.firstObject else {
            throw FetchError.collectionFetchError
        }
        
        let queue = DispatchQueue(label: "in.teramolabs.fetchimages")
        queue.async {
            let assetsFetchResult = PHAsset.fetchAssets(in: panoramasCollection, options: nil)
            var imagesArray = [UIImage]()
            
            for i in 0..<assetsFetchResult.count {
                let asset = assetsFetchResult.object(at: i)
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
                    guard let imageData = data, let image = UIImage(data: imageData) else {
                        return
                    }
                    imagesArray.append(image)
                })
                
            }
            DispatchQueue.main.async {
                completion(imagesArray)
            }
        }
    }
    
}
