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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(colorCollectionView)
        colorCollectionView.sameSizeAsParent()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
