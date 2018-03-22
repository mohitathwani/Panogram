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
    
    lazy var images = [UIImage]()
    
    private var indexOfCellBeforeDragging = 0
    
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
//        collectionView.backgroundColor = UIColor.blue
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionViewLayout.minimumLineSpacing = 0
//        configureCollectionViewLayoutItemSize()
    }
    
    var collectionViewWidth: CGFloat {
        return collectionViewLayout.collectionView!.frame.size.width
    }
    
    var collectionViewHeight: CGFloat {
        return collectionViewLayout.collectionView!.frame.size.height
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewWidth - inset * 2, height: collectionViewHeight)
        
        collectionViewLayout.collectionView!.reloadData()
    }
    
    override func layoutSubviews() {
        configureCollectionViewLayoutItemSize()
    }
    
    private func calculateSectionInset() -> CGFloat {
        return 100
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        return Int(round(proportionalOffset))
    }
    
    func scrollToCenter() {
        let indexPath = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
//        cell.backgroundColor = UIColor.brown
//        if(indexPath.row == 0) {
//
//            cell.imageView.backgroundColor = UIColor.red
//        }
//
//        if(indexPath.row == 1) {
//            cell.imageView.backgroundColor = UIColor.green
//        }
//
//        if(indexPath.row == 2) {
//            cell.imageView.backgroundColor = UIColor.darkGray
//        }
        
        cell.imageView.image = images[indexPath.row]
        
        
        return cell
    }
}

extension CarouselView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < images.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x <  swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
