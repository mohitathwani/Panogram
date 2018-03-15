//
//  ImageEditVC.swift
//  Panogram
//
//  Created by Labs on 7/9/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import ASJTagsView

class ImageEditVC: UIViewController, ErrorPresenting {
    
    @IBOutlet weak var carouselView: CarouselView!
    var filters: [Filter] = [.blur]
    
    @IBOutlet weak var tagView: ASJTagsView!
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
    
    var tags = Set<String>()
    
    var images = [UIImage]() {
        didSet {
            PhotoEditor.sharedEditor.analyze(images: images, completion: { [weak self] (tags) in
                if let weakSelf = self {
                    weakSelf.tags = tags
                    weakSelf.tagView.appendTags(Array(tags))
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        weakSelf.tagView.alpha = 1.0
                    })
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView.images = images
        
        leftImageView.image = images[0]
        centerImageView.image = images[1]
        rightImageView.image = images[2]
        
        tagView.alpha = 0
        tagView.tagSpacing = 3.0
        tagView.tagColorTheme = .indigo
        
//        addGradientToView()
        
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addGradientToView()  {
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor(hex: 0x17ead9).cgColor, UIColor(hex: 0x6078ea).cgColor, UIColor(hex: 0x123456).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}
extension ImageEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        
        cell.filterNameLabel.text = filters[indexPath.row].rawValue
        
        cell.leftImageView.image = leftImageView.image
        cell.centerImageView.image = centerImageView.image
        cell.rightImageView.image = rightImageView.image
        
        return cell
    }
}

extension ImageEditVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let images = [leftImageView.image!, centerImageView.image!, rightImageView.image!]
        
        let outputImages = FilterManager.sharedManager.apply(filter: filters[indexPath.row], toImages: images)
        
        leftImageView.image = outputImages[0]
        centerImageView.image = outputImages[1]
        rightImageView.image = outputImages[2]
    }
}
