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
        case note
        case contact
        
        var icon: UIImage {
            switch  self {
            case .link:
                return #imageLiteral(resourceName: "link.png")
            case .note:
                return #imageLiteral(resourceName: "file-solid.png")
            case .contact:
                return #imageLiteral(resourceName: "address-card-solid.png")
            }
        }
        
        var title: String {
            switch self {
            case .link:
                return "链接"
            case .note:
                return "文本"
            case .contact:
                return "名片"
            }
        }
        
        private static let allBackgroundColors: [UIColor] = [
            UIColor.fromHexString(hex: "ff3b30"),
            UIColor.fromHexString(hex: "ff9500"),
            UIColor.fromHexString(hex: "ffcc00"),
            UIColor.fromHexString(hex: "4ed964"),
            UIColor.fromHexString(hex: "5ac8fa"),
            UIColor.fromHexString(hex: "007aff"),
            UIColor.fromHexString(hex: "5756d6"),
        ]
        
        var backgroundColor: UIColor {
            let index = ActionCell.Item.allCases.firstIndex { $0 == self }
            return ActionCell.Item.allBackgroundColors[index!%ActionCell.Item.allBackgroundColors.count]
        }
    }
    
    var item: Item! {
        didSet {
            iconView.image = item.icon
            titleView.text = item.title
            backgroundColor = item.backgroundColor
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
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 8.0
        
        clipsToBounds = false
        
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.layer.cornerRadius = 8
        selectedBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}
