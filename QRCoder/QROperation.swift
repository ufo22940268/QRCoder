//
//  QROperation.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit

protocol Operation {
    mutating func execute()
    func undo()
}

struct AddCenterImageOperation: Operation {
    var qrImageView: QRImageView
    var image: UIImage
    var previousImage: UIImage?
    
    init(qrImageView: QRImageView, image: UIImage) {
        self.qrImageView = qrImageView
        self.image = image
    }
    
    mutating func execute() {
        previousImage = qrImageView.centerImage
        qrImageView.decorate(withImage: image)
    }
    
    func undo() {
        qrImageView.decorate(withImage: previousImage)
    }
}

struct AddTitleOperation: Operation {
    var qrImageView: QRImageView
    var title: String
    var previousTitle: String?
    
    init(qrImageView: QRImageView, title: String) {
        self.qrImageView = qrImageView
        self.title = title
    }

    mutating func execute() {
        previousTitle = qrImageView.title
        qrImageView.decorate(withTitle: title)
    }
    
    func undo() {
        qrImageView.decorate(withTitle: previousTitle)
    }
}

struct ChangeFrontColorOperation: Operation {
    
    var color: UIColor!
    var previousColor: UIColor = defaultQRImageFrontColor
    var qrImageView: QRImageView

    init(qrImageView: QRImageView, color: UIColor) {
        self.qrImageView = qrImageView
        self.color = color
    }
    
    mutating func execute() {
        previousColor = qrImageView.frontColor
        qrImageView.frontColor = color
    }
    
    func undo() {
        qrImageView.frontColor = previousColor
    }
}

struct ChangeBackColorOperation: Operation {
    
    var color: UIColor!
    var previousColor: UIColor = defaultQRImageBackColor
    var qrImageView: QRImageView
    
    init(qrImageView: QRImageView, color: UIColor) {
        self.qrImageView = qrImageView
        self.color = color
    }
    
    mutating func execute() {
        previousColor = qrImageView.backColor
        qrImageView.backColor = color
    }
    
    func undo() {
        qrImageView.backColor = previousColor
    }
}


struct TextOperation: Operation {
    
    var qrImageView: QRImageView
    var previousText: String!
    var text: String?
    
    init(qrImageView: QRImageView, text: String?) {
        self.qrImageView = qrImageView
        self.text = text
    }
    
    mutating func execute() {
        previousText = qrImageView.title
        qrImageView.title = text
    }
    
    func undo() {
        qrImageView.title = previousText
    }
}



struct TextAlignOperation: Operation {
    
    var qrImageView: QRImageView
    var previousAlign: TextAlign!
    var align: TextAlign!
    
    init(qrImageView: QRImageView, align: TextAlign) {
        self.qrImageView = qrImageView
        self.align = align
    }
    
    mutating func execute() {
        previousAlign = qrImageView.titleAlign
        qrImageView.titleAlign = align
    }
    
    func undo() {
        qrImageView.titleAlign = previousAlign
    }
}
