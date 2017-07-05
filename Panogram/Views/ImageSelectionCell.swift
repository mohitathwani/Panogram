//
//  ImageSelectionCell.swift
//  Panogram
//
//  Created by Labs on 7/4/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit
import QuartzCore

class ImageSelectionCell: UITableViewCell {

    @IBOutlet weak var panoramaImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        panoramaImageView.layer.shadowColor = UIColor.gray.cgColor
        panoramaImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        panoramaImageView.layer.shadowRadius = 5.0
        panoramaImageView.layer.shadowOpacity = 0.8
        panoramaImageView.layer.cornerRadius = 15.0
//        panoramaImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
