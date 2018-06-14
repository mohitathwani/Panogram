//
//  CarouselCell.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/15/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit
import GLKit

extension CGRect
{
    func aspectFitInRect(target: CGRect) -> CGRect {
        let scale: CGFloat = {
            let scale = target.width / self.width
            return self.height * scale <= target.height ?
                scale :
                target.height / self.height
        }()
      
        let width = self.width * scale
        let height = self.height * scale
        let xPos = target.midX - width / 2
        let yPos = target.midY - height / 2
      
        return CGRect(x: xPos,
                      y: yPos,
                      width: width,
                      height: height)
    }
}

class CarouselCell: UICollectionViewCell, GLKViewDelegate {

    @IBOutlet weak var glkView: GLKView!
    @IBOutlet weak var imageView: UIImageView!
    var filteredImage: CIImage? {
        willSet {
            if newValue != nil {
                glkView.delegate = self
                glkView.setNeedsDisplay()
                glkView.isHidden = false
            } else {
                glkView.isHidden = true
            }
        }
    }
    
    var eaglContext: EAGLContext! {
        willSet {
            glkView.context = newValue
        }
    }
    var ciContext: CIContext!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        guard let ciImage = filteredImage else {return}
        
        let drawableRect = CGRect(origin: CGPoint.zero,
                                     size: CGSize(width: glkView.drawableWidth,
                                                  height: glkView.drawableHeight))
        
        let targetRect = ciImage.extent.aspectFitInRect(
            target: drawableRect)
        
        ciContext.draw(ciImage,
                       in: targetRect,
                       from: ciImage.extent)
    }

}
