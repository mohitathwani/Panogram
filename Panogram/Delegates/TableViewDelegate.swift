//
//  TableViewDelegate.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/7/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit

protocol CellSelected: class {
    func splitImage(_ image: UIImage)
}

class TableViewDelegate: NSObject, UITableViewDelegate, ManagesCellSection {
    var selectedIndexPath: IndexPath?
    weak var delegate: CellSelected?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let prevSelectedIndexPath = selectedIndexPath {
            if let prevSelectedCell = tableView.cellForRow(at: prevSelectedIndexPath) as? ImageSelectionCell {
                prevSelectedCell.setSelected(false)
            }
        }
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ImageSelectionCell, let panoramaImage = selectedCell.panoramaImageView.image else {return}
        
        selectedCell.setSelected(true)
        
        selectedIndexPath = indexPath
        
        if var dataSource = tableView.dataSource as? ManagesCellSection {
            dataSource.selectedIndexPath = indexPath
        }
        
        delegate?.splitImage(panoramaImage)
        
    }
    
}


