//
//  ViewController.swift
//  Panogram
//
//  Created by Labs on 6/27/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import Pastel
import SnapKit

class LaunchVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = LaunchBackgroundView(frame: view.bounds)
        view.insertSubview(backgroundView, at: 0)
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let logoSnapPoint = CGPoint(x: view.center.x, y: view.center.y - 180)
        animator = UIDynamicAnimator(referenceView: view)
        snapBehavior = UISnapBehavior(item: logoImageView, snapTo: logoSnapPoint)
        animator?.delegate = self
        animator?.addBehavior(snapBehavior!)
        
    }
}

extension LaunchVC: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print(logoImageView.constraints)
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(self.logoImageView.frame.origin.y)
//            make.centerX.equalTo(self.view)
//            make.width.equalTo(self.logoImageView.frame.size.width)
//            make.height.equalTo(self.logoImageView.frame.size.height)
        }
    }
}

