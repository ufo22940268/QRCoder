//
//  OptionMenuDivider.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/4.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class OptionMenuDivider: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 10, height: 50)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let rect = rect.insetBy(dx: 0, dy: 14)
        let path = UIBezierPath()
        UIColor.separator.setStroke()
        path.move(to: CGPoint(x: rect.width/2, y: rect.minY))
        path.lineWidth = 1
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.maxY))
        path.stroke()
    }
}
