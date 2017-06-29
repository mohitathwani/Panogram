//
//  LaunchBackGroundView.swift
//  Panogram
//
//  Created by Labs on 6/28/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import Pastel

class LaunchBackgroundView: PastelView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        startPastelPoint = .bottomLeft
        endPastelPoint = .topRight
        animationDuration = 3.0
        setColors([UIColor(hex: 0x17ead9),
                              UIColor(hex: 0x6078ea),
                              UIColor(hex: 0x123456)])
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
