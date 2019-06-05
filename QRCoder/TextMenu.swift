//
//  TextMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/5.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class TextMenu: UIStackView {
    
    lazy var opStackView: UIStackView = {
        let view = UIStackView().useAutolayout()
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 20)
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        
        let removeButton = UIButton().useAutolayout()
        removeButton.setImage(#imageLiteral(resourceName: "ban.png"), for: .normal)
        view.addArrangedSubview(removeButton)
        
        let alignTopButton = UIButton().useAutolayout()
        alignTopButton.setImage(#imageLiteral(resourceName: "align-top.png"), for: .normal)
        view.addArrangedSubview(alignTopButton)
        
        let alignBottomButton = UIButton().useAutolayout()
        alignBottomButton.setImage(#imageLiteral(resourceName: "align-bottom.png"), for: .normal)
        view.addArrangedSubview(alignBottomButton)
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        addArrangedSubview(opStackView)
        
        let divider = OptionMenuDivider()
        addArrangedSubview(divider)
        divider.setContentHuggingPriority(.required, for: .horizontal)
        
        let setting = UIButton().useAutolayout()
        NSLayoutConstraint.activate([
            setting.widthAnchor.constraint(equalToConstant: 60)])
        setting.setImage(#imageLiteral(resourceName: "cog.png"), for: .normal)
        //        setting.addTarget(self, action: #selector(onMoreClicked(sender:)), for: .touchUpInside)
        addArrangedSubview(setting)
        

    }    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
