//
//  ActionCell.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class ActionCell: UICollectionViewCell {
    
    enum Category: Int, CaseIterable {
        
        case link
        case note
        case contact
        case image
        
        var icon: UIImage {
            switch  self {
            case .link:
                return #imageLiteral(resourceName: "link.png")
            case .note:
                return #imageLiteral(resourceName: "file-solid.png")
            case .contact:
                return #imageLiteral(resourceName: "address-card-solid.png")
            case .image:
                return #imageLiteral(resourceName: "image.png")
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
            case .image:
                return "图片"
            }
        }
        
        private static let allBackgroundColors: [(UIColor, UIColor)] = [
            (UIColor.fromHexString(hex: "ff3b30"), UIColor.fromHexString(hex: "E40F03")),
            (UIColor.fromHexString(hex: "ff9500"), UIColor.fromHexString(hex: "864F01")),
            (UIColor.fromHexString(hex: "ffcc00"), UIColor.fromHexString(hex: "A58402")),
            (UIColor.fromHexString(hex: "4ed964"), UIColor.fromHexString(hex: "4ed964")),
            (UIColor.fromHexString(hex: "5ac8fa"), UIColor.fromHexString(hex: "5ac8fa")),
            (UIColor.fromHexString(hex: "007aff"), UIColor.fromHexString(hex: "007aff")),
            (UIColor.fromHexString(hex: "5756d6"), UIColor.fromHexString(hex: "5756d6")),
        ]
        
        var backgroundStartColor: UIColor {
            let index = ActionCell.Category.allCases.firstIndex { $0 == self }
            return ActionCell.Category.allBackgroundColors[index!%ActionCell.Category.allBackgroundColors.count].0
        }
        
        var backgroundEndColor: UIColor {
            let index = ActionCell.Category.allCases.firstIndex { $0 == self }
            return ActionCell.Category.allBackgroundColors[index!%ActionCell.Category.allBackgroundColors.count].1
        }

    }
    
    var item: Category! {
        didSet {
            iconView.image = item.icon
            titleView.text = item.title
            gradientLayer.colors = [
                item.backgroundStartColor.withAlphaComponent(0.7).cgColor,
                item.backgroundStartColor.cgColor
            ]
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    var gradientLayer: CAGradientLayer!
    
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
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 8.0
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 8
        layer.insertSublayer(gradientLayer, at: 0)
        
        clipsToBounds = false
        
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.layer.cornerRadius = 8
        selectedBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = bounds
    }
}
