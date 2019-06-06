//
//  ColorPalatteMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/4.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

protocol  ColorPaletteMenuDelegate: class {
    func onColorSelected(canvas: ColorPaletteCanvas, color: UIColor)
}

class ColorPaletteMenu: UIStackView {
    
    lazy var colorCollectionView: ColorPaletteCollectionView = {
        let view = ColorPaletteCollectionView().useAutolayout()
        view.delegate = self
        return view
    }()
    
    lazy var divider: OptionMenuDivider = {
        let view = OptionMenuDivider()
        return view
    }()
    
    lazy var switcher: UIButton = {
        let view = UIButton().useAutolayout()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 60)])
        view.setImage(#imageLiteral(resourceName: "cog.png"), for: .normal)
        view.addTarget(self, action: #selector(onMoreClicked(sender:)), for: .touchUpInside)
        return view
    }()
    
    weak var hostViewController: UIViewController?
    var canvas: ColorPaletteCanvas = .front {
        didSet {
            colorCollectionView.canvas = canvas
            colorCollectionView.selectColor(color: canvas == .front ? frontColor : backColor)
        }
    }
    
    weak var delegate: ColorPaletteMenuDelegate?
    
    var backColor = UIColor.white
    var frontColor = UIColor.black
    var qrImageView: QRImageView!
    
    init(host: UIViewController, qrImageView: QRImageView) {
        super.init(frame: .zero)
        hostViewController = host
        self.qrImageView = qrImageView
        axis = .horizontal
        addArrangedSubview(colorCollectionView)
        addArrangedSubview(divider)
        divider.setContentHuggingPriority(.required, for: .horizontal)
        addArrangedSubview(switcher)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onMoreClicked(sender: UITapGestureRecognizer) {
        let vc = ColorPalettePopupViewController(haveText: qrImageView.title != nil)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = switcher
        vc.popoverPresentationController?.sourceRect = switcher.bounds.applying(CGAffineTransform(translationX: 0, y: 10))
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.permittedArrowDirections = .down
        vc.preferredContentSize = CGSize(width: 150, height: 44*vc.canvases.count)
        vc.selectedCanvas = canvas
        vc.delegate = self
        
        hostViewController?.present(vc, animated: true, completion: nil)
    }
}

extension ColorPaletteMenu: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

extension ColorPaletteMenu: ColorPalettePopupDelegate {
    func onCanvasChanged(canvas: ColorPaletteCanvas) {
        self.canvas = canvas
    }
}

extension ColorPaletteMenu: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onColorSelected(canvas: canvas, color: colorCollectionView.allColors[indexPath.row])
    }
}
