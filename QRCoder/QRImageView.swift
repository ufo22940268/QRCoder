//
//  QRImageView.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import CoreImage

class QRImageView: UIImageView {
    
    var qrText: String! {
        didSet {
            let filter = CIFilter(name: "CIQRCodeGenerator")!
            filter.setValue("http://v2ex.com".data(using: .isoLatin1), forKey: "inputMessage")
            guard var ciImage = filter.outputImage else { return }
            let scale = self.bounds.width/ciImage.extent.width
            ciImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            image = UIImage(ciImage: ciImage)
        }
    }
}