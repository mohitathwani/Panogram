//
//  CarouselCell.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/15/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit
import GLKit

class CarouselCell: UICollectionViewCell, GLKViewDelegate {

    @IBOutlet weak var glkView: GLKView!
    @IBOutlet weak var imageView: UIImageView!
    
    var eaglContext: EAGLContext!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
    }

}
