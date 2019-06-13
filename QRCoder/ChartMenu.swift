//
//  ChartMenu.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/13.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//
import UIKit

class ChartMenu: UIStackView {
    
    enum Item: Int, CaseIterable {
        case enabled, disabled
    }
    
    lazy var opStackView: UIStackView = {
        let view = UIStackView().useAutolayout()
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 20)
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
                
        return view
    }()
    
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
        }
    }
    
    var host: UIViewController!
    
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
        
//        defer {
//            selectedItem = .disabled
//        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSettingClicked(sender: UIButton) {
    }
    
    @objc func onSelectItem(sender: UIButton) {
        let index = opStackView.subviews.firstIndex(of: sender)
        let item = Item.allCases.first { $0.rawValue == index }!
        selectedItem = item
    }
}
