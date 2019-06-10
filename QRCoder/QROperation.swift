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

struct BaseOperation<E> : Operation {
    
    var attribute: E?
    var qrImageView: QRImageView!
    var previousAttribute: E?
    var attributeName: String!
    
    init(qrImageView: QRImageView, attribute: E?, attributeName: String) {
        self.qrImageView = qrImageView
        self.attribute = attribute
        self.attributeName = attributeName
    }
    
    mutating func execute() {
        previousAttribute = self.qrImageView.value(forKey: attributeName) as? E
        qrImageView.setValue(attribute, forKey: attributeName)
    }

    func undo() {
        qrImageView.setValue(previousAttribute, forKey: attributeName)
    }
}

struct AddCenterImageOperation: Operation {
    var qrImageView: QRImageView
    var image: CenterImage?
    var previousImage: CenterImage?
    
    init(qrImageView: QRImageView, image: CenterImage?) {
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

struct ChangeTextColorOperation: Operation {
    
    var color: UIColor!
    var previousColor: UIColor = defaultQRImageFrontColor
    var qrImageView: QRImageView
    
    init(qrImageView: QRImageView, color: UIColor) {
        self.qrImageView = qrImageView
        self.color = color
    }
    
    mutating func execute() {
        previousColor = qrImageView.titleColor
        qrImageView.titleColor = color
    }
    
    func undo() {
        qrImageView.titleColor = previousColor
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

struct ImageShapeOperation: Operation {
    
    var qrImageView: QRImageView
    var pevious: ImageShape!
    var value: ImageShape!
    
    init(qrImageView: QRImageView, value: ImageShape) {
        self.qrImageView = qrImageView
        self.value = value
    }
    
    mutating func execute() {
        pevious = qrImageView.imageShape
        qrImageView.imageShape = value
    }
    
    func undo() {
        qrImageView.imageShape = pevious
    }
}
