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
    func execution()
    func undo()
}

struct AddCenterImageOperation: Operation {
    var qrImageView: QRImageView
    var image: UIImage
    
    func execution() {
        qrImageView.decorate(withImage: image)
    }
    
    func undo() {
        qrImageView.removeCenterImage()
    }
}
