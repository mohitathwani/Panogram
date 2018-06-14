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
  private var pAssets = [PHAsset]()
  public var assets: [PHAsset] {
    return pAssets
  }
  
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
  
  func requestPermission(completion: @escaping () -> Void) {
    PHPhotoLibrary.requestAuthorization {_ in
      completion()
    }
  }
  
  func cacheImages() throws {
    let fetchOptions = PHFetchOptions()
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    
    let assetCollectionFetchResult =
      PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                              subtype: .smartAlbumPanoramas,
                                              options: nil)
    
    guard let panoramasCollection = assetCollectionFetchResult.firstObject else {
      throw FetchError.collectionFetchError
    }
    
    let assetsFetchResult = PHAsset.fetchAssets(in: panoramasCollection, options: fetchOptions)
    
    let cachingImageManager = PHCachingImageManager()
//    for index in 0..<assetsFetchResult.count {
//      let asset = assetsFetchResult.object(at: index)
//      pAssets.append(asset)
//    }
    
    assetsFetchResult.enumerateObjects { (asset, idx, stop) in
      self.pAssets.append(asset)
    }
    
    let cacheImageSize = CGSize(width: 600, height: 200)
    cachingImageManager.startCachingImages(for: pAssets,
                                           targetSize: cacheImageSize,
                                           contentMode: .default, options: nil)
    
  }
  
  func fetchImage(at index: Int, cached: Bool, completion:@escaping (Int, UIImage) -> Void) {
    
    let queue = DispatchQueue(label: "in.teramolabs.fetchimages")
    
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    
    let asset = pAssets[index]
    
    queue.async { [row = index] in
      if cached == true {
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 600, height: 200), contentMode: .default, options: options, resultHandler: { (image, info) in
          guard let infoDict = info as? [String:Any] else {return}
          if let isDegraded = infoDict[PHImageResultIsDegradedKey] as? Bool, isDegraded == false {
            
            guard let picture = image else {return}
            
            DispatchQueue.main.async{
              completion(row, picture)
            }
          }
        })
      }
      else {
        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
          guard let imageData = data, let image = UIImage(data: imageData) else {
            return
          }
          DispatchQueue.main.async {
            completion(row, image)
          }
        })
      }
    }
  }
}
