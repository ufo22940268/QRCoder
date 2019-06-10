//
//  ImageMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/5.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

protocol ImageMenuDelegate: class {
    func onChange(image: CenterImage?)
    func chooseImage()
}

enum ImageShape: Int, CaseIterable {
    case none = 0
    case rectangle = 1
}

class ImageMenu: UIStackView {
    
    enum Item: Int, CaseIterable {
        case remove, rectangle
        case qq, wechat, weibo
        case favicon
        
        var image: UIImage? {
            switch self {
            case .remove, .rectangle, .favicon:
                return nil
            case .qq:
                return #imageLiteral(resourceName: "qq-brand.png")
            case .wechat:
                return #imageLiteral(resourceName: "weixin-brand.png")
            case .weibo:
                return #imageLiteral(resourceName: "weibo-brand.png")
            }
        }
        
    }
    
    lazy var faviconButton: UIButton = {
        let view = UIButton().useAutolayout()
        view.imageView?.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(onSelectItem(sender:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 30)
            ])
        return view
    }()
    
    var favicon: UIImage? {
        didSet {
            guard let favicon = favicon, faviconButton.superview == nil else { return }
            faviconButton.setImage(favicon, for: .normal)
            UIView.transition(with: self, duration: 0.15, options: [.transitionCrossDissolve], animations: {
                self.opStackView.insertArrangedSubview(self.faviconButton, at: 1)
            }, completion: nil)
        }
    }
    
    lazy var opStackView: UIStackView = {
        let view = UIStackView().useAutolayout()
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 20)
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        
        let removeButton = UIButton().useAutolayout()
        removeButton.setImage(#imageLiteral(resourceName: "ban.png"), for: .normal)
        view.addArrangedSubview(removeButton)
        removeButton.addTarget(self, action: #selector(onSelectItem(sender:)), for: .touchUpInside)
        
        let rectangleButton = UIButton().useAutolayout()
        rectangleButton.setImage(#imageLiteral(resourceName: "rectangle-frame.png"), for: .normal)
        view.addArrangedSubview(rectangleButton)
        rectangleButton.addTarget(self, action: #selector(onSelectItem(sender:)), for: .touchUpInside)
        rectangleButton.tag = ImageShape.rectangle.rawValue
        
        for brandItem in Item.allCases.filter({ ![Item.remove, Item.rectangle, Item.favicon].contains($0)}) {
            let btn = UIButton().useAutolayout()
            btn.setImage(brandItem.image, for: .normal)
            view.addArrangedSubview(btn)
            btn.addTarget(self, action: #selector(onSelectItem(sender:)), for: .touchUpInside)
            btn.imageView?.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                btn.widthAnchor.constraint(equalToConstant: 30)
                ])
            if brandItem == .qq {
                btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
            }
            btn.tag = ImageShape.rectangle.rawValue
        }
                
        return view
    }()
    
    weak var host: UIViewController?
    weak var delegate: ImageMenuDelegate?
    var selectedItem: Item! {
        didSet {
            opStackView.arrangedSubviews.forEach {
                if let selectedItem = selectedItem, $0.tag == selectedItem.rawValue {
                    $0.tintColor = tintColor
                } else {
                    $0.tintColor = .black
                }
            }
        }
    }
    
    init(host: UIViewController) {
        super.init(frame: .zero)
        self.host = host
        axis = .horizontal
        addArrangedSubview(opStackView)
        
        defer {
            selectedItem = .none
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSettingClicked(sender: UIButton) {
        delegate?.chooseImage()
    }
    
    @objc func onSelectItem(sender: UIButton) {
        let index = opStackView.subviews.firstIndex(of: sender)
        let item = Item.allCases.first { $0.rawValue == index }!
        selectedItem = item
        
        switch item {
        case .rectangle:
            delegate?.chooseImage()
        case .remove:
            delegate?.onChange(image: nil)
        case .favicon:
            delegate?.onChange(image: CenterImage(image: favicon!, kind: .icon))
        default:
            delegate?.onChange(image: CenterImage(image: item.image!, kind: .icon))
        }
    }
}
