//
//  ColorPaletteCircle.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/4.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit

class ColorPaletteCircle: UICollectionViewCell {
 
    var color: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(ovalIn: rect.insetBy(dx: 4, dy: 4))
        color.setFill()
        path.fill()
        
        if isSelected {
            let hightlightPath = UIBezierPath(ovalIn: rect.insetBy(dx: 0.5, dy: 0.5))
            tintColor.setStroke()
            hightlightPath.lineWidth = 1
            hightlightPath.stroke()
        }
    }
}
