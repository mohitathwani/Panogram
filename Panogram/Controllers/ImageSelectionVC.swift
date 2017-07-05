//
//  ImageSelectionVC.swift
//  Panogram
//
//  Created by Labs on 7/4/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

class ImageSelectionVC: UIViewController {
    
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a Panorama"
        print(images)
    }
}

extension ImageSelectionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorColor = UIColor.clear
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagesSelectionCell", for: indexPath) as! ImageSelectionCell
        
        cell.panoramaImageView.image = images[indexPath.row]
        return cell
    }
}
