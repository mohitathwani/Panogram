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
    private var logoSnapPoint: CGPoint {
        return CGPoint(x: view.center.x, y: view.center.y - 180)
    }
    
    @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
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
        
        
        animator = UIDynamicAnimator(referenceView: view)
        snapBehavior = UISnapBehavior(item: logoImageView, snapTo: logoSnapPoint)
        animator?.delegate = self
        animator?.addBehavior(snapBehavior!)
        
    }
}

extension LaunchVC: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        view.removeConstraint(logoCenterYConstraint)
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(logoSnapPoint.y)
        }
    }
}

