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
        print(panoramasCollection)
//        return nil
    }
    
}
