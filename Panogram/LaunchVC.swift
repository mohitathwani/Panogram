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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = LaunchBackgroundView(frame: view.bounds)
        view.insertSubview(backgroundView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

