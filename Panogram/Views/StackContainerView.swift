//
//  StackContainerView.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/20/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit

class StackContainerView: UIView {

    var height = 1.0
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 1.0, height: height)
    }
}
