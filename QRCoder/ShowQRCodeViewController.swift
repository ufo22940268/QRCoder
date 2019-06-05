//
//  ShowQRCodeViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import MobileCoreServices
import RealmSwift

enum QRCodeOptionMenu {
    case palette
}

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
    @IBOutlet weak var optionMenuContainer: OptionMenuContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isInitial() {
            qrCodeMaterial = LinkMaterial(str: "v2ex.com")
        }
        navigationController?.isToolbarHidden = false
        qrImageView.qrText = qrCodeMaterial.toString()
        toolbarItems = toolbar.items
        showMenu(.palette)
    }
    
    func showMenu(_ menu: QRCodeOptionMenu) {
        let menu = ColorPaletteMenu(host: self).useAutolayout()
        menu.delegate = self
        optionMenuContainer.addSubview(menu)
        NSLayoutConstraint.activate([
            optionMenuContainer.layoutMarginsGuide.leadingAnchor.constraint(equalTo: menu.leadingAnchor),
            optionMenuContainer.layoutMarginsGuide.trailingAnchor.constraint(equalTo: menu.trailingAnchor),
            optionMenuContainer.topAnchor.constraint(equalTo: menu.topAnchor),
            optionMenuContainer.bottomAnchor.constraint(equalTo: menu.bottomAnchor)
            ])
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
        UIView.transition(with: qrImageView, duration: 0.5, options: [.transitionCrossDissolve, .showHideTransitionViews, .allowAnimatedContent, .layoutSubviews], animations: {
            if let op = self.undoStack.popLast() {
                op.undo()
                self.redoStack.append(op)
            }
            self.qrImageView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func onShareClicked(_ sender: Any) {
        let image = qrImageView.snapshot()
        let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareVC, animated: true, completion: {
            let model = self.qrCodeMaterial.exportToModel()
            try! self.realm?.write {
                self.realm?.add(model)
            }
        })
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

extension ShowQRCodeViewController: ColorPaletteMenuDelegate {
    func onColorSelected(canvas: ColorPaletteCanvas, color: UIColor) {
        var operation: Operation!
        switch canvas {
        case .back:
            operation = ChangeBackColorOperation(qrImageView: qrImageView, color: color)
        case .front:
            operation = ChangeFrontColorOperation(qrImageView: qrImageView, color: color)
        }
        operation.execute()
        undoStack.append(operation)
    }
}
