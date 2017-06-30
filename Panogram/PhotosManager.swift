//
//  PhotosManager.swift
//  Panogram
//
//  Created by Labs on 6/30/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import Photos

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
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization {_ in }
    }
    
}
