//
//  CarouselView.swift
//  Panogram
//
//  Created by TeraMo Labs on 3/14/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit
import SnapKit

class CarouselView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    func initializeView() {
        Bundle.main.loadNibNamed("CarouselView", owner: self, options: nil)
        addSubview(contentView)
        
        let carouselCellNib = UINib(nibName: "CarouselCell", bundle: nil)
        
        collectionView.register(carouselCellNib, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.backgroundColor = UIColor.blue
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionViewLayout.minimumLineSpacing = 5
        configureCollectionViewLayoutItemSize()
    }
    
    lazy var collectionViewWidth = collectionViewLayout.collectionView!.frame.size.width
    
    lazy var collectionViewHeight = collectionViewLayout.collectionView!.frame.size.height
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewWidth - inset * 2, height: collectionViewHeight)
        
        collectionViewLayout.collectionView!.reloadData()
    }
    
    private func calculateSectionInset() -> CGFloat {
        
        let inset = (collectionViewWidth) / 9
        return inset
    }
}

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.backgroundColor = UIColor.brown
        if(indexPath.row == 0) {
            
            cell.imageView.backgroundColor = UIColor.red
        }
        
        if(indexPath.row == 1) {
            cell.imageView.backgroundColor = UIColor.green
        }
        
        if(indexPath.row == 2) {
            cell.imageView.backgroundColor = UIColor.darkGray
        }
        
        
        return cell
    }
}
