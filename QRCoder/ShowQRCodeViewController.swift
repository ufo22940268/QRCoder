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
import RxAlamofire
import RxSwift
import SwiftyJSON

enum QRCodeOptionMenu: Int, CaseIterable {
    case image
    case palette
    case text
    case chart
}

class ShowQRCodeViewController: UIViewController {

    @IBOutlet weak var qrImageView: QRImageView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var redoButton: UIBarButtonItem!
    @IBOutlet var undoButton: UIBarButtonItem!
    
    @IBOutlet weak var loadingContainer: UIStackView!
    @IBOutlet weak var chartBarButton: UIBarButtonItem!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var qrCodeMaterial: QRCodeMaterial! {
        didSet {
            let _ = view
            qrImageView.qrText = qrCodeMaterial.toString()
            print("qr text: \(qrCodeMaterial.toString())")
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
    
    var qrCodeModel: QRCodeModel?
    
    var imageToUpload: UIImage!
    var movieToUpload: URL?
    
    @IBOutlet var toolbarButtons: [UIBarButtonItem]!
    
    var loading: Bool! = false {
        didSet {
            loadingContainer.isHidden = !loading
        }
    }
    
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
        
        if imageToUpload != nil {
            upload(image: imageToUpload)
        } else if let movieToUpload = movieToUpload {
            upload(movie: movieToUpload)
        }
        
        if qrCodeMaterial != nil {
            createQRModal()
        }
        
        if let qrCodeModel = qrCodeModel, let items = toolbar.items, !qrCodeModel.canConvertToRedirection {
            toolbar.setItems(Array(items[0..<items.count - 2]), animated: false)
        }
        toolbarItems = toolbar.items
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    func upload(image: UIImage) {
        showLoading(true, label: "正在上传图片")
        CDNService.shared.upload(image: image, complete: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                self.qrCodeMaterial = LinkMaterial(str: url)
                self.createQRModal()
                self.showLoading(false)
            }
        })
    }
    
    func upload(movie: URL) {
        showLoading(true, label: "正在上传视频")
        CDNService.shared.upload(movie: movie, complete: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                self.qrCodeMaterial = LinkMaterial(str: url)
                self.createQRModal()
                self.showLoading(false)
            }
        })
    }
    
    func createQRModal() {
        if let qrCodeMaterial = qrCodeMaterial {
            let model = qrCodeMaterial.exportToModel()
            try! self.realm?.write {
                self.realm?.add(model)
            }
            qrCodeModel = model
        }
    }
    
    func showLoading(_ show: Bool, label: String? = nil) {
        loading = show
        if let label = label {
            loadingLabel.text = label
        }
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
        case .chart:
            let chartView = ChartMenu(host: self).useAutolayout()
            chartView.delegate = self
            menuView = chartView
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

    func onBackgroundImageSelected(image: UIImage) {
        qrImageView.backImage = image
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

extension ShowQRCodeViewController: ChartMenuDelegate {
    func onEnableChart(_ enabled: Bool, switch: UISwitch) {
        UIView.transition(with: toolbar, duration: 0.15, options: .transitionCrossDissolve, animations: {
            let icon: UIImage!
            if enabled {
                icon = #imageLiteral(resourceName: "chart-bar.png")
            } else {
                icon = #imageLiteral(resourceName: "chart-bar-empty.png")
            }
            self.chartBarButton.image = icon
        }, completion: nil)
        
        if enabled {
            `switch`.isEnabled = false
            let _ = request(.post, "/redirection/add".buildURL(), parameters: ["url": qrCodeMaterial.toString()])
                .responseJSON()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { resp in
                    switch resp.result {
                    case let .success(data):
                        let json = JSON(data)
                        if let to = json["to"].string {
                            self.qrCodeMaterial = LinkMaterial(str: to)
                            `switch`.isEnabled = true
                            try? self.realm?.write {
                                self.qrCodeModel?.redirectURL = to
                            }
                        }
                    case let .failure(error):
                        print(error)
                        break;
                    }
                }, onError: nil)
                .disposed(by: disposeBag)
        } else {
            try? self.realm?.write {
                self.qrCodeModel?.redirectURL = nil
            }
            self.qrCodeMaterial = qrCodeModel?.material
        }
    }
}
