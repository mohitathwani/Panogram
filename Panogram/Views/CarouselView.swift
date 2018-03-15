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
    
    var images = [UIImage]() {
        willSet {
            leftImageView = UIImageView(image: newValue[0])
            centerImageView = UIImageView(image: newValue[1])
            rightImageView = UIImageView(image: newValue[2])
            setupImageViews()
        }
    }
    
    private lazy var leftImageView = UIImageView()
    private lazy var centerImageView = UIImageView()
    private lazy var rightImageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        scrollView.backgroundColor = UIColor.red
        addSubview(contentView)
        addSubview(leftImageView)
        addSubview(centerImageView)
        addSubview(rightImageView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupImageViews() {
        scrollView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        scrollView.addSubview(centerImageView)
        centerImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(20)
            make.height.equalToSuperview()
        }
        
        scrollView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(centerImageView.snp.right).offset(20)
            make.height.equalToSuperview()
        }
        
        scrollView.contentSize = CGSize(width: leftImageView.image!.size.width * 3 + 40, height: frame.height)
        
        scrollView.setContentOffset(CGPoint(x: leftImageView.image!.size.width , y:0), animated: true)
        
        scrollView.isPagingEnabled = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
