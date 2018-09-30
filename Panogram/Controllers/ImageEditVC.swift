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

    @IBOutlet weak var bottomContainerView: StackContainerView!
    @IBOutlet weak var topContainerView: StackContainerView!
    @IBOutlet weak var carouselView: CarouselView!
    var filters: [Filter] = Filter.allValues

    @IBOutlet weak var tagView: ASJTagsView!

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

        tagView.alpha = 0
        tagView.tagSpacing = 3.0
        tagView.tagColorTheme = .indigo

        carouselView.images = images
        carouselView.eaglContext = FilterManager.sharedManager.eaglContext
        carouselView.ciContext = FilterManager.sharedManager.ciContext

        topContainerView.height = 3
        bottomContainerView.height = 4
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView.scrollToCenter()
    }

    func addGradientToView() {
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
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? FilterCell else {
        fatalError()
      }

        cell.filterNameLabel.text = filters[indexPath.row].rawValue

        return cell
    }
}

extension ImageEditVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let filteredImages = FilterManager.sharedManager.apply(filter: filters[indexPath.row], toImages: images)

        carouselView.filteredImages = filteredImages

    }
}
