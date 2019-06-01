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
