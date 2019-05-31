//
//  ActionCell.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class ActionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.45
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 4.0
        
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.layer.cornerRadius = 8
        selectedBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}
