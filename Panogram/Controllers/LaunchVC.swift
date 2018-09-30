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

class LaunchVC: UIViewController, ErrorPresenting {

  @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
  @IBOutlet weak var selectImageButton: UIButton!
  @IBOutlet weak var logoImageView: UIImageView!

  private var animator: UIDynamicAnimator?
  private var snapBehavior: UISnapBehavior?
  private var logoSnapPoint: CGPoint {
    return CGPoint(x: view.center.x, y: view.center.y - 180)
  }

  private var images = [UIImage]()

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

    selectImageButton.alpha = 0.0
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
        self.cacheImages()
        self.performSegue(withIdentifier: "imageSelectionSegue", sender: nil)
        //                self.fetchImages()
      } else {
        let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
          UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        })

        let title = "Panogram needs access to your photos"
        let message = "Please go to the Settings app and grant permission to Panogram to access your photos."
        self.displayAlert(title: title, message: message,
                          action: openSettingsAction)
      }
    }
  }

  func cacheImages() {
    do {
      try PhotosManager.sharedManager.cacheImages()
    } catch FetchError.collectionFetchError {
      self.displayAlert(title: "Panoramas not found", message: "Looks like you don't have any panoramas. Open the Camera app to click a panoramic image and come back here to edit it.", action: nil)
    } catch {

    }
  }

  //    func fetchImages() {
  //        do {
  //            SVProgressHUD.show(withStatus: "Fetching panoramas...")
  //            try PhotosManager.sharedManager.fetchImages(completion: {[weak self] (images) in
  //                SVProgressHUD.dismiss()
  //                if self != nil {
  //                    self!.images = images
  //                    self!.performSegue(withIdentifier: "imageSelectionSegue", sender: nil)
  //                }
  //            })
  //        }
  //        catch FetchError.collectionFetchError {
  //            self.displayAlert(title: "Panoramas not found",
  //  message: "Looks like you don't have any panoramas. Open the Camera app to click a
  //  panoramic image and come back here to edit it.", action: nil)
  //        }
  //        catch {
  //
  //        }
  //    }
}

extension LaunchVC: UIDynamicAnimatorDelegate {
  func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
    view.removeConstraint(logoCenterYConstraint) //FIXME: This line seems to be causing a problem
    logoImageView.snp.makeConstraints { (make) in
      make.top.equalTo(self.view).offset(logoSnapPoint.y)
    }

    UIView.animate(withDuration: 0.4) {
      self.selectImageButton.alpha = 1.0
    }
  }
}

extension LaunchVC {
  //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //        guard let dVC = segue.destination as? UINavigationController, let imageSelectionVC = dVC.topViewController as? ImageSelectionVC else {
  //            return
  //        }
  //
  //        imageSelectionVC.images = images
  //    }
}
