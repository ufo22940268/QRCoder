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
    func execute()
    func undo()
}

struct AddCenterImageOperation: Operation {
    var qrImageView: QRImageView
    var image: UIImage
    
    func execute() {
        qrImageView.decorate(withImage: image)
    }
    
    func undo() {
        qrImageView.removeCenterImage()
    }
}
