//
//  ColorPalatteMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/4.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class ColorPaletteMenu: UIStackView {
    
    lazy var colorCollectionView: ColorPaletteCollectionView = {
        let view = ColorPaletteCollectionView().useAutolayout()
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
    
    var hostViewController: UIViewController!
    
    init(host: UIViewController) {
        super.init(frame: .zero)
        hostViewController = host
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
        print("onMoreClicked")
        let vc = ColorPalettePopupViewController()
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = switcher
        vc.popoverPresentationController?.sourceRect = switcher.bounds.applying(CGAffineTransform(translationX: 0, y: 10))
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.permittedArrowDirections = .down
        vc.preferredContentSize = CGSize(width: 150, height: 88)
        
        hostViewController.present(vc, animated: true, completion: nil)
    }
}

extension ColorPaletteMenu: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        print("should")
        return false
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("dismiss")
    }
}
