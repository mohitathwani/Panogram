//
//  ImageSelectionVC.swift
//  Panogram
//
//  Created by Labs on 7/4/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

class ImageSelectionVC: UIViewController, ErrorPresenting, OpenSettings {
  
  @IBOutlet weak var nextButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var rightImageView: UIImageView!
  @IBOutlet weak var centerImageView: UIImageView!
  @IBOutlet weak var leftImageView: UIImageView!
  
  var selectedIndexPath: IndexPath?
  let tableViewDataSource = TableViewDataSource()
  let tableViewDelegate = TableViewDelegate()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Panoramas"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    checkPermission()
    //        tableView.reloadData()
    
    self.tableView.dataSource = tableViewDataSource
    self.tableView.delegate = tableViewDelegate
    tableViewDelegate.delegate = self
    self.tableView.separatorColor = UIColor.clear
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let selectedIndexPath =
      (tableView.dataSource as? TableViewDataSource)?.selectedIndexPath,
      let dVC = segue.destination as? ImageEditVC,
      let selectedCell =
      tableView.cellForRow(at: selectedIndexPath) as? ImageSelectionCell else {
        return
    }
    
    dVC.panoramaImage = selectedCell.panoramaImageView.image
  }
  
  @IBAction func nextTapped(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "imageEditSegue", sender: nil)
  }
}

extension ImageSelectionVC {
  func checkPermission() {
    PhotosManager.sharedManager.requestPermission { [weak self] in
      if PhotosManager.sharedManager.isAuthorized {
        self?.cacheImages()
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
        
      }
      else {
        DispatchQueue.main.async {
          guard let unwrappedSelf = self else {
            fatalError("self is nil")
          }
          
          let osv = OpenSettingsView(frame: CGRect.zero, delegate: unwrappedSelf)
          self?.view.addSubview(osv)
          
          osv.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
          })
        }
      }
    }
  }
  
  func cacheImages() {
    do {
      try PhotosManager.sharedManager.cacheImages()
    }
    catch FetchError.collectionFetchError {
      self.displayAlert(title: "Panoramas not found", message: "Looks like you don't have any panoramas. Open the Camera app to click a panoramic image and come back here to edit it.", action: nil)
    }
    catch {
      
    }
  }
  
  func openSettings() {
    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
  }
}

extension ImageSelectionVC: CellSelected {
  func splitImage(_ image: UIImage) {
    do {
      let images = try PhotoEditor.sharedEditor.cut(panoramaImage: image)
      leftImageView.image = images[0]
      centerImageView.image = images[1]
      rightImageView.image = images[2]
      nextButton.isEnabled = true
    } catch PhotoEditorError.imageCutError {
      displayAlert(title: "Image Split Error", message: "There seems to be an issue trying to split the image. Please try with another image.", action: nil)
    } catch {}
  }
}

extension ImageSelectionVC: UITableViewDelegate {
  
}
