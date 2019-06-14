//
//  ChartMenu.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/13.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//
import UIKit

protocol ChartMenuDelegate: class {
    func onEnableChart(_ enabled: Bool, switch: UISwitch)
}

class ChartMenu: UIStackView {
    
    enum Item: Int, CaseIterable {
        case enabled, disabled
    }
    
    lazy var switcher: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(onSwitchChanged(sender:)), for: .valueChanged)
        return view
    }()
    
    weak var delegate: ChartMenuDelegate?
    
    lazy var opStackView: UIStackView = {
        let view = UIStackView().useAutolayout()
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 20)
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        
        let label = UILabel().useAutolayout()
        label.text = "二维码记录"
        view.addArrangedSubview(label)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        view.addArrangedSubview(switcher)
        
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
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSettingClicked(sender: UIButton) {
    }
    
    @objc func onSwitchChanged(sender: UISwitch)  {
        print(sender.isOn)
        delegate?.onEnableChart(sender.isOn, switch: sender)
    }
    
    @objc func onSelectItem(sender: UIButton) {
        let index = opStackView.subviews.firstIndex(of: sender)
        let item = Item.allCases.first { $0.rawValue == index }!
        selectedItem = item
    }
}
