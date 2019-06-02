//
//  ActionCell.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit


class ActionCell: UICollectionViewCell {
    
    enum Item: CaseIterable {
        
        case link
        
        var icon: UIImage {
            return #imageLiteral(resourceName: "link.png")
        }
        
        var title: String {
            return "链接"
        }
    }
    
    var item: Item! {
        didSet {
            iconView.image = item.icon
            titleView.text = item.title
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.45
        layer.shadowRadius = 8.0
                
        clipsToBounds = false
        
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.layer.cornerRadius = 8
        selectedBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}
