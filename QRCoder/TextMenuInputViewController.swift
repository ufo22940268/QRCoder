//
//  TextMenuInputViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/6.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

protocol TextMenuInputDelegate: class {
    func onChange(text: String?)
}

class TextMenuInputViewController: UIViewController {

    @IBOutlet weak var editText: UITextField!
    @IBOutlet weak var topTools: UIView!
    
    weak var delegate: TextMenuInputDelegate?
    
    override func awakeFromNib() {
        let _ = view
        editText.keyboardAppearance = .dark
    }
    
    @IBAction func onComplete(_ sender: Any) {
        editText.resignFirstResponder()
        self.dismiss(animated: true, completion: {
            self.delegate?.onChange(text: self.editText.text)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editText.becomeFirstResponder()
    }
}
