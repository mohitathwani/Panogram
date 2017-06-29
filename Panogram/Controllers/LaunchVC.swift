//
//  ViewController.swift
//  Panogram
//
//  Created by Labs on 6/27/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import Pastel

class LaunchVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = LaunchBackgroundView(frame: view.bounds)
        view.insertSubview(backgroundView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let logoSnapPoint = CGPoint(x: view.center.x, y: view.center.y - 180)
        animator = UIDynamicAnimator(referenceView: view)
        snapBehavior = UISnapBehavior(item: logoImageView, snapTo: logoSnapPoint)
        animator?.addBehavior(snapBehavior!)
        
    }
}

