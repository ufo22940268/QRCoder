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
        view.clipsToBounds = true
        view.layer.cornerRadius = centerRadius
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var centerRadius: CGFloat = 8
    
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
    
    lazy var centerImageContainer: UIView = {
        let view = UIView().useAutolayout()
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = centerRadius
        view.backgroundColor = .white
        return view
    }()
    
    var centerImage: UIImage? {
        didSet {
            if let centerImage = centerImage {
                centerImageView.image = centerImage
                centerImageContainer.isHidden = false
            } else {
                centerImageContainer.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        addSubview(qrView)
        qrView.sameSizeAsParent()
        
        addSubview(centerImageContainer)
        centerImageContainer.addSubview(centerImageView)
        
        NSLayoutConstraint.activate([
            centerImageContainer.widthAnchor.constraint(equalTo: centerImageView.widthAnchor, multiplier: 1.0, constant: 8),
            centerImageContainer.heightAnchor.constraint(equalTo: centerImageView.heightAnchor, multiplier: 1.0, constant: 8),
            centerImageContainer.centerXAnchor.constraint(equalTo: centerImageView.centerXAnchor),
            centerImageContainer.centerYAnchor.constraint(equalTo: centerImageView.centerYAnchor)
            ])
        
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func decorate(withImage image: UIImage) {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100)).image { (context) in
            image.draw(in: CGRect(origin: .zero, size: context.format.bounds.size))
        }
        centerImage = image
    }
    
    func removeCenterImage() {
        centerImage = nil
    }

}
