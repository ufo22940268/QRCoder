//
//  ShowQRCodeViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import MobileCoreServices

class ShowQRCodeViewController: UIViewController {

    @IBOutlet weak var qrImageView: QRImageView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var redoButton: UIBarButtonItem!
    @IBOutlet var undoButton: UIBarButtonItem!
    var qrCodeMaterial: QRCodeMaterial!
    
    var undoStack: [Operation] = [Operation]() {
        didSet {
            undoButton.isEnabled = !undoStack.isEmpty
        }
    }
    
    var redoStack: [Operation] = [Operation]() {
        didSet {
            redoButton.isEnabled = !redoStack.isEmpty
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.isToolbarHidden = false
        qrImageView.qrText = qrCodeMaterial.toString()
        toolbarItems = toolbar.items
    }
    
    @IBAction func onAddImage(sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.mediaTypes = [kUTTypeImage as String]
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }

    
    @IBAction func onAddTitle(_ sender: Any) {
        AddTitleDialog().present(by: self) { text in
            var op = AddTitleOperation(qrImageView: self.qrImageView, title: text)
            op.execute()
            self.undoStack.append(op)
        }
    }
    
    @IBAction func onRedoClicked(_ sender: Any) {
        if var op = redoStack.popLast() {
            op.execute()
            undoStack.append(op)
        }
    }
    
    @IBAction func onUndoClicked(_ sender: Any) {
        if let op = undoStack.popLast() {
            op.undo()
            redoStack.append(op)
        }
    }
    
    @IBAction func onShareClicked(_ sender: Any) {
        let image = qrImageView.snapshot()
        print(image)
        let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareVC, animated: true, completion: nil)
    }
}

extension ShowQRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info.first(where: { $0.key == UIImagePickerController.InfoKey.originalImage })?.value as? UIImage {
            var operation = AddCenterImageOperation(qrImageView: qrImageView, image: image)
            undoStack.append(operation)
            redoStack.removeAll()
            operation.execute()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
