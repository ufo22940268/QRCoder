//
//  TextMenuInputTransition.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/6.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit

class TextMenuInputTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TextMenuInputAnimator()
    }
}

class TextMenuInputAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inputVC = transitionContext.viewController(forKey: .to)! as! TextMenuInputViewController
        let inputView = transitionContext.view(forKey: .to)!
        inputView.alpha = 0
        transitionContext.containerView.addSubview(inputView)
        let editField = inputVC.editText!
        editField.transform = CGAffineTransform(translationX: 0, y: 40)
        UIView.transition(with: transitionContext.containerView, duration: transitionDuration(using: transitionContext), options: [.transitionCrossDissolve], animations: {
            inputView.alpha = 1
            editField.transform = .identity
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
