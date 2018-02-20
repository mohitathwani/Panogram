//
//  ImageSelectionVC.swift
//  Panogram
//
//  Created by Labs on 7/4/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

class ImageSelectionVC: UIViewController, ErrorPresenting {
    
    weak var tableView: UITableView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a Panorama"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermission()
//        tableView.reloadData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let selectedIndexPath = tableView.indexPathForSelectedRow, let dVC = segue.destination as? ImageEditVC, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? ImageSelectionCell else {
//            return
//        }
//
//        dVC.panoramaImage = selectedCell.panoramaImageView.image
//    }
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
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                })
                
                self?.displayAlert(title: "Panogram needs access to your photos", message: "Please go to the Settings app and grant permission to Panogram to access your photos.", action: openSettingsAction)
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
}

extension ImageSelectionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        tableView.separatorColor = UIColor.clear
        return PhotosManager.sharedManager.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagesSelectionCell", for: indexPath) as! ImageSelectionCell
        
        PhotosManager.sharedManager.fetchImage(at: indexPath.row, cached: true) { (row, image) in
            if row == indexPath.row {
                cell.panoramaImageView.image = image
            }
        }
        return cell
    }
}

extension ImageSelectionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do {
            guard let selectedCell = tableView.cellForRow(at: indexPath) as? ImageSelectionCell, let panoramaImage = selectedCell.panoramaImageView.image else {return}
            
            let images = try PhotoEditor.sharedEditor.cut(panoramaImage: panoramaImage)
            leftImageView.image = images[0]
            centerImageView.image = images[1]
            rightImageView.image = images[2]
        } catch PhotoEditorError.imageCutError {
            displayAlert(title: "Image Split Error", message: "There seems to be an issue trying to split the image. Please try with another image.", action: nil)
        } catch {}
    }
}
