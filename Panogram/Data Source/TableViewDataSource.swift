//
//  TableViewDataSource.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/7/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource, ManagesCellSection {
    
    var selectedIndexPath: IndexPath?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotosManager.sharedManager.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagesSelectionCell", for: indexPath) as! ImageSelectionCell
        
        if selectedIndexPath != nil && selectedIndexPath! == indexPath {
            cell.setSelected(true)
        } else {
            cell.setSelected(false)
        }
        
        PhotosManager.sharedManager.fetchImage(at: indexPath.row, cached: true) { (row, image) in
            if row == indexPath.row {
                cell.panoramaImageView.image = image
            }
        }
        return cell
    }
}
