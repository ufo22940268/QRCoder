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

enum QRCodeOptionMenu: Int, CaseIterable {
    case image = 0
    case palette = 1
    case text = 2
}

class ShowQRCodeViewController: UIViewController {

    @IBOutlet weak var qrImageView: QRImageView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var redoButton: UIBarButtonItem!
    @IBOutlet var undoButton: UIBarButtonItem!
    
    var qrCodeMaterial: QRCodeMaterial! {
        didSet {
            qrImageView.qrText = qrCodeMaterial.toString()
            if let linkMaterial = qrCodeMaterial as? LinkMaterial {
                let url = URL(string: linkMaterial.url)
                url?.parseFavIcon(complete: { (image) in
                    DispatchQueue.main.async {
                        self.favicon = image
                    }
                })
            }
        }
    }
    
    var imageToUpload: UIImage!
    
    @IBOutlet var toolbarButtons: [UIBarButtonItem]!
    
    var loading: Bool! = false
    
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
    var menu: QRCodeOptionMenu?
    var favicon: UIImage? {
        didSet {
            if let menuView = menuView as? ImageMenu {
                menuView.favicon = self.favicon
            }
        }
    }
    
    var menuView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isInitial() {
            qrCodeMaterial = LinkMaterial(str: "v2ex.com")
        }
        navigationController?.isToolbarHidden = false
        toolbarItems = toolbar.items
        
        if imageToUpload != nil {
            upload(image: imageToUpload)
        }
    }
    
    func upload(image: UIImage) {
        loading = true
        CDNService.shared.upload(image: image, complete: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                self.qrCodeMaterial = LinkMaterial(str: url)
                self.loading = false
            }
        })
    }
    
    func showMenu(_ menu: QRCodeOptionMenu) {
        hideMenu()
        
        self.menu = menu
        switch menu {
        case .image:
            let imageView = ImageMenu(host: self).useAutolayout()
            imageView.favicon = self.favicon
            imageView.delegate = self
            menuView = imageView
        case .palette:
            let paletteView = ColorPaletteMenu(host: self, qrImageView: qrImageView).useAutolayout()
            paletteView.delegate = self
            menuView = paletteView
        case .text:
            let textView = TextMenu(host: self).useAutolayout()
            textView.delegate = self
            menuView = textView
        }
        if let menuView = menuView {
            optionMenuContainer.isHidden = false
            optionMenuContainer.addSubview(menuView)
            NSLayoutConstraint.activate([
                optionMenuContainer.layoutMarginsGuide.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
                optionMenuContainer.layoutMarginsGuide.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
                optionMenuContainer.topAnchor.constraint(equalTo: menuView.topAnchor),
                optionMenuContainer.bottomAnchor.constraint(equalTo: menuView.bottomAnchor)
                ])
        }
    }
    
    func hideMenu() {
        menu = nil
        optionMenuContainer.isHidden = true
        optionMenuContainer.subviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func onRedoClicked(_ sender: Any) {
        if var op = redoStack.popLast() {
            op.execute()
            undoStack.append(op)
        }
    }
    
    @IBAction func onUndoClicked(_ sender: Any) {
        hideMenu()
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
    
    @IBAction func onToolbarClicked(_ sender: UIBarButtonItem) {
        let clickedMenu = QRCodeOptionMenu.allCases.first { $0.rawValue == sender.tag }!
        toolbarButtons.filter { $0 != sender }.forEach { $0.tintColor = .black }
        let isOpen = menu == clickedMenu
        if isOpen {
            hideMenu()
            sender.tintColor = .black
        } else {
            showMenu(clickedMenu)
            sender.tintColor = view.tintColor
        }
    }
}

extension ShowQRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info.first(where: { $0.key == UIImagePickerController.InfoKey.originalImage })?.value as? UIImage {
            var operation = AddCenterImageOperation(qrImageView: qrImageView, image: CenterImage(image: image, kind: .normal))
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
        case .text:
            operation = ChangeTextColorOperation(qrImageView: qrImageView, color: color)
        }
        operation.execute()
        undoStack.append(operation)
    }
}

extension ShowQRCodeViewController: TextMenuDelegate {
    func onChange(text: String?) {
        var op = BaseOperation<String>(qrImageView: qrImageView, attribute: text, attributeName: "title")
        op.execute()
        undoStack.append(op)
    }
    
    func onChange(align: TextAlign) {        
        var op = TextAlignOperation(qrImageView: qrImageView, align: align)
        op.execute()
        undoStack.append(op)
    }
}

extension ShowQRCodeViewController: ImageMenuDelegate {
    func onChange(image: CenterImage?) {
        var op = AddCenterImageOperation(qrImageView: qrImageView, image: image)
        op.execute()
        undoStack.append(op)
    }
    
    func chooseImage() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.mediaTypes = [kUTTypeImage as String]
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
}
