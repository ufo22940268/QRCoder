//
//  AddNoteViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/3.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class AddNoteViewController: UITableViewController {

    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.largeTitleDisplayMode = .never
        noteField.becomeFirstResponder()
    }
    
    
    @IBAction func onNextClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "showQRCode") as! ShowQRCodeViewController
        vc.qrCodeMaterial = NoteMaterial(note: noteField.text)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        nextButton.isEnabled = textView.text.count > 0
    }
}
