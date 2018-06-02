//
//  OpenSettingsView.swift
//  Panogram
//
//  Created by TeraMo Labs on 6/2/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import UIKit
import SnapKit

class OpenSettingsView: UIView {
    
    var textLabel: UILabel!
    var openSettingsButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        textLabel = UILabel(frame: frame)
        textLabel.text = "Please enable photo access permission from the Settings app on your phone."
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textColor = .gray
        textLabel.textAlignment = .center
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        openSettingsButton = UIButton(type: .system)
        openSettingsButton.setTitle("Open Settings", for: .normal)
        openSettingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addSubview(openSettingsButton)
        
        openSettingsButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(16)
        }
    }
    
}
