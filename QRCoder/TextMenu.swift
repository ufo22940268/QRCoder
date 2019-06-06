//
//  TextMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/5.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

protocol TextMenuDelegate: TextMenuInputDelegate {
    func onChange(align: TextAlign)
}

enum TextAlign {
    case top
    case bottom
    
    static let `default` = TextAlign.bottom
}

class TextMenu: UIStackView {
    
    var customTransitioningDelegate = TextMenuInputTransitioningDelegate()
    
    enum Item: Int, CaseIterable {
        case remove = 0, top = 1, bottom = 2
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
        
        let alignTopButton = UIButton().useAutolayout()
        alignTopButton.setImage(#imageLiteral(resourceName: "align-top.png"), for: .normal)
        view.addArrangedSubview(alignTopButton)
        alignTopButton.addTarget(self, action: #selector(onSelectItem(sender:)), for: .touchUpInside)

        let alignBottomButton = UIButton().useAutolayout()
        alignBottomButton.setImage(#imageLiteral(resourceName: "align-bottom.png"), for: .normal)
        view.addArrangedSubview(alignBottomButton)
        alignBottomButton.addTarget(self, action: #selector(onSelectItem(sender:)), for: .touchUpInside)

        return view
    }()
    
    weak var host: UIViewController?
    weak var delegate: TextMenuDelegate?
    var selectedItem: Item! {
        didSet {
            Item.allCases.forEach {
                let view = opStackView.subviews[$0.rawValue]
                if $0 == selectedItem {
                    view.tintColor = tintColor
                } else {
                    view.tintColor = .black
                }
            }
            
            switch selectedItem! {
            case .top:
                alignSnapshot = .top
            case .bottom:
                alignSnapshot = .bottom
            default:
                break
            }
        }
    }
    
    var alignSnapshot: TextAlign = .default
    
    init(host: UIViewController) {
        super.init(frame: .zero)
        self.host = host
        axis = .horizontal
        addArrangedSubview(opStackView)
        
        let divider = OptionMenuDivider()
        addArrangedSubview(divider)
        divider.setContentHuggingPriority(.required, for: .horizontal)
        
        let setting = UIButton().useAutolayout()
        NSLayoutConstraint.activate([
            setting.widthAnchor.constraint(equalToConstant: 60)])
        setting.setImage(#imageLiteral(resourceName: "cog.png"), for: .normal)
        setting.addTarget(self, action: #selector(onSettingClicked(sender:)), for: .touchUpInside)
        addArrangedSubview(setting)
        
        defer {
            selectedItem = .bottom
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSettingClicked(sender: UIButton) {
        let vc = host?.storyboard?.instantiateViewController(withIdentifier: "textMenuInput") as? TextMenuInputViewController
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .custom
        vc?.transitioningDelegate = customTransitioningDelegate
        vc?.delegate = self
        host?.present(vc!, animated: true, completion: nil)
    }
    
    @objc func onSelectItem(sender: UIButton) {
        let index = opStackView.subviews.firstIndex(of: sender)
        let item = Item.allCases.first { $0.rawValue == index }!
        selectedItem = item
        switch item {
        case .remove:
            delegate?.onChange(text: nil)
        case .bottom:
            delegate?.onChange(align: .bottom)
        case .top:
            delegate?.onChange(align: .top)
        }
    }
}

extension TextMenu: TextMenuInputDelegate {
    func onChange(text: String?) {
        if selectedItem == .remove {
            switch alignSnapshot {
            case .top:
                selectedItem = .top
            case .bottom:
                selectedItem = .bottom
            }
        }
        delegate?.onChange(text: text)
    }
}
