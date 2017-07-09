//
//  ImageSelectionVC.swift
//  Panogram
//
//  Created by Labs on 7/4/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

class ImageSelectionVC: UIViewController {
    
    weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a Panorama"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, let dVC = segue.destination as? ImageEditVC, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? ImageSelectionCell else {
            return
        }
        
        dVC.panoramaImage = selectedCell.panoramaImageView.image
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
