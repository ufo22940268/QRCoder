//
//  QRImageView.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import CoreImage

class QRImageView: UIView {
    
    lazy var qrView: UIImageView = {
        let view = UIImageView().useAutolayout()
        return view
    }()
    
    lazy var centerImageView: UIImageView = {
        let view = UIImageView().useAutolayout()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 60),
            view.heightAnchor.constraint(equalToConstant: 60)
            ])
        view.isHidden = true
        return view
    }()
    
    var qrText: String! {
        didSet {
            let filter = CIFilter(name: "CIQRCodeGenerator")!
            filter.setValue("http://v2ex.com".data(using: .isoLatin1), forKey: "inputMessage")
            guard var ciImage = filter.outputImage else { return }
            let scale = self.bounds.width/ciImage.extent.width
            ciImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            qrView.image = UIImage(ciImage: ciImage)
        }
    }
    
    var centerImage: UIImage? {
        didSet {
            if let centerImage = centerImage {
                centerImageView.image = centerImage
                centerImageView.isHidden = false
            } else {
                centerImageView.isHidden = true
            }
        }
    }
    
    
    func decorate(withImage image: UIImage) {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100)).image { (context) in
            image.draw(in: CGRect(origin: .zero, size: context.format.bounds.size))
        }
        centerImage = image
    }

    override func awakeFromNib() {
        addSubview(qrView)
        qrView.sameSizeAsParent()
        
        addSubview(centerImageView)
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
}
