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
import SVProgressHUD

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
    
    
    @IBAction func selectImageClicked(_ sender: UIButton) {
        PhotosManager.sharedManager.requestPermission {
            if PhotosManager.sharedManager.isAuthorized {
                self.fetchImages()
            }
            else {
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                })
                
                self.displayAlert(title: "Panogram needs access to your photos", message: "Please go to the Settings app and grant permission to Panogram to access your photos.", action: openSettingsAction)
            }
        }
    }
    
    func fetchImages() {
        do {
            SVProgressHUD.show(withStatus: "Fetching panoramas...")
            try PhotosManager.sharedManager.fetchImages(completion: { (images) in
                SVProgressHUD.dismiss()
                print(images)
            })
        }
        catch FetchError.collectionFetchError {
            self.displayAlert(title: "Panoramas not found", message: "Looks like you don't have any panoramas. Open the Camera app to click a panoramic image and come back here to edit it.", action: nil)
        }
        catch {
            
        }
    }
}

extension LaunchVC: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        view.removeConstraint(logoCenterYConstraint) //FIXME: This line seems to be causing a problem
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(logoSnapPoint.y)
        }
    }
}

