//
//  AddTitleDialog.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/1.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit

class AddTitleDialog {
    
    var dialog: UIAlertController!
    
    init() {
    }
    
    func present(by viewController: UIViewController, confirm: @escaping (_ text: String) -> Void) {
        dialog = UIAlertController(title: "请输入文字", message: nil, preferredStyle: .alert)
        var textView: UITextField!
        dialog.addTextField { (textField) in
            textView = textField
        }
        dialog.addAction(UIAlertAction(title: "确认", style: .default, handler: { (UIAlertAction) in
            if let text = textView.text {
                confirm(text)
            }
        }))
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        viewController.present(dialog, animated: true, completion: nil)
    }
}
