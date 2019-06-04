//
//  ColorPalatteMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/4.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class ColorPaletteMenu: UIStackView {
    
    lazy var colorCollectionView: ColorPaletteCollectionView = {
        let view = ColorPaletteCollectionView().useAutolayout()
        return view
    }()
    
    lazy var divider: OptionMenuDivider = {
        let view = OptionMenuDivider()
        return view
    }()
    
    lazy var switcher: UIImageView = {
        let view = UIImageView().useAutolayout()
        view.contentMode = .center
        view.image = #imageLiteral(resourceName: "cog.png")
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreClicked(sender:))))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        axis = .horizontal
        addArrangedSubview(colorCollectionView)
        addArrangedSubview(divider)
        divider.setContentHuggingPriority(.required, for: .horizontal)
        addArrangedSubview(switcher)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onMoreClicked(sender: UITapGestureRecognizer) {
        print("onMoreClicked")
    }
}
