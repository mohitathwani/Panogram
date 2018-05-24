//
//  Protocols.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/7/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//
import Foundation
import UIKit
import CoreImage

protocol ManagesCellSection {
    var selectedIndexPath: IndexPath? {get set}
}

protocol Filterable {
    func applyTo(image: UIImage) -> CIImage
}
