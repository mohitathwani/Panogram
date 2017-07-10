//
//  ImageEditVC.swift
//  Panogram
//
//  Created by Labs on 7/9/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

class ImageEditVC: UIViewController {
    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    var panoramaImage: UIImage! {
        didSet {
            do {
                try images = PhotoEditor.sharedEditor.cut(panoramaImage: panoramaImage)
            } catch PhotoEditorError.imageCutError {
                displayAlert(title: "Image Split Error", message: "There seems to be an issue trying to split the image. Please try with another image.", action: nil)
            } catch {}
        }
    }
    
    var images = [UIImage]() {
        didSet {
            PhotoEditor.sharedEditor.analyze(images: images)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftImageView.image = images[0]
        centerImageView.image = images[1]
        rightImageView.image = images[2]
    }
}
