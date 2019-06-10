//
//  QRImageView.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import CoreImage
import AVKit

let defaultQRImageFrontColor: UIColor = .black
let defaultQRImageBackColor: UIColor = .white

struct CenterImage {
    enum Kind {
        case normal
        case icon
    }
    var image: UIImage
    let kind: Kind
}

class QRImageView: UIStackView {
    
    var imageShape: ImageShape = .none {
        didSet {
            switch imageShape {
            case .none:
                centerImageContainer.isHidden = true
            case .rectangle:
                centerImageContainer.isHidden = false
            }
        }
    }
    
    lazy var qrView: UIImageView = {
        let view = UIImageView().useAutolayout()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 250),
            view.heightAnchor.constraint(equalToConstant: 250)
            ])
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
        return view
    }()
    
    var frontColor: UIColor = defaultQRImageFrontColor {
        didSet {
            qrView.image = buildQRImage()
        }
    }
    
    var backColor: UIColor = defaultQRImageBackColor {
        didSet {
            qrView.image = buildQRImage()
        }
    }

    var centerRadius: CGFloat = 8
    
    var qrText: String! {
        didSet {
            qrView.image = buildQRImage()
        }
    }
    
    @objc var title: String? {
        didSet {
            if let title = self.title, !title.isEmpty {
                titleView.text = title
                titleView.isHidden = false
            } else {
                titleView.isHidden = true
            }
        }
    }
    
    var titleAlign: TextAlign! = TextAlign.default {
        didSet {
            switch titleAlign! {
            case .top:
                removeArrangedSubview(titleView)
                insertArrangedSubview(titleView, at: 0)
            case .bottom:
                removeArrangedSubview(titleView)
                insertArrangedSubview(titleView, at: arrangedSubviews.count)
            }
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            titleView.textColor = titleColor
        }
    }
    
    lazy var titleView: UILabel! = {
       let view = UILabel().useAutolayout()
        view.isHidden = true
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }()
    
    lazy var centerImageContainer: UIView = {
        let view = UIView().useAutolayout()
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = centerRadius
        view.backgroundColor = .white
        return view
    }()
    
    var centerImage: CenterImage? {
        didSet {
            if let centerImage = centerImage {
                centerImageView.image = centerImage.image
                
                switch centerImage.kind {
                case .normal:
                    centerImageView.contentMode = .scaleAspectFill
                case .icon:
                    centerImageView.contentMode = .scaleAspectFit
                }
                centerImageContainer.isHidden = false
            } else {
                centerImageContainer.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        addArrangedSubview(qrView)
        
        axis = .vertical
        addSubview(centerImageContainer)
        centerImageContainer.addSubview(centerImageView)
        
        NSLayoutConstraint.activate([
            centerImageContainer.widthAnchor.constraint(equalTo: centerImageView.widthAnchor, multiplier: 1.0, constant: 8),
            centerImageContainer.heightAnchor.constraint(equalTo: centerImageView.heightAnchor, multiplier: 1.0, constant: 8),
            centerImageContainer.centerXAnchor.constraint(equalTo: centerImageView.centerXAnchor),
            centerImageContainer.centerYAnchor.constraint(equalTo: centerImageView.centerYAnchor)
            ])
        
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: qrView.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: qrView.centerYAnchor)
            ])
        
        addArrangedSubview(titleView)
    }
    
    func buildQRImage() -> UIImage {
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(self.qrText.data(using: .utf8), forKey: "inputMessage")
        guard var ciImage = filter.outputImage else { fatalError() }
        
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setValue(ciImage, forKey: "inputImage")
        colorFilter.setValue(backColor.coreImageColor, forKey: "inputColor1")
        colorFilter.setValue(frontColor.coreImageColor, forKey: "inputColor0")
        ciImage = colorFilter.outputImage!
        
        let scale = self.bounds.width/ciImage.extent.width
        ciImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        return UIImage(ciImage: ciImage)
    }
    
    func decorate(withImage centerImage: CenterImage?) {
        if var centerImage = centerImage {
            var image = centerImage.image
            let outputSize = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))).size
            image = UIGraphicsImageRenderer(size: outputSize).image { (context) in
                image.draw(in: CGRect(origin: .zero, size: context.format.bounds.size))
             }
            centerImage.image = image
            self.centerImage = centerImage
        } else {
            self.centerImage = nil
        }
    }
    
    func decorate(withTitle title: String?) {
        self.title = title
    }
    
    func snapshot() -> UIImage {
        return UIGraphicsImageRenderer(bounds: bounds).image { (context) in
            self.layer.render(in: context.cgContext)
        }
    }
}
