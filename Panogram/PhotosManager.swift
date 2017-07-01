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
    
    func fetchImages() throws{
        let assetCollectionFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: nil)
        
        guard let panoramasCollection = assetCollectionFetchResult.firstObject else {
            
            throw FetchError.collectionFetchError
        }
        
        let assetsFetchResult = PHAsset.fetchAssets(in: panoramasCollection, options: nil)
        
        for i in 0..<assetsFetchResult.count {
            let asset = assetsFetchResult.object(at: i)
            let pixelHeight = asset.pixelHeight
            let pixelWidth = asset.pixelWidth
            
            //FIXME: Fix code below.Research on options
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixelWidth, height: pixelHeight), contentMode: .default, options: nil, resultHandler: { (image, info) in
                print(image, info)
            })
        }
    }
    
}
