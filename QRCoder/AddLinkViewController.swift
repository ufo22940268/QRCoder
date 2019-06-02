//
//  AddLinkViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class AddLinkViewController: UITableViewController {
    
    @IBOutlet weak var linkField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        linkField.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onNextClicked(_ sender: Any) {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "showQRCode") as? ShowQRCodeViewController
        vc?.qrCodeMaterial = LinkMaterial(str: linkField.text)
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension AddLinkViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.text.count > 0 && textView.text.isURL()
    }
}
