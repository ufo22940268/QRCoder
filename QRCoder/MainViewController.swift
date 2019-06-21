//
//  ViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import ContactsUI
import MobileCoreServices
import AVKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view

        let itemWidth: CGFloat = (view.bounds.width - 16*2 - 10)/2
        collectionLayout.itemSize = CGSize(width: itemWidth, height: 80)
        collectionLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.register(UINib(nibName: "ActionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        self.navigationController?.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        collectionView.visibleCells.forEach { collectionView.deselectItem(at: collectionView.indexPath(for: $0)!, animated: false) }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActionCell
        let item = ActionCell.Category.allCases[indexPath.row]
        cell.item = item
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ActionCell.Category.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch ActionCell.Category.allCases[indexPath.row] {
        case .link:
            let vc = storyboard?.instantiateViewController(withIdentifier: "addLink")
            navigationController?.pushViewController(vc!, animated: true)
        case .note:
            let vc = storyboard?.instantiateViewController(withIdentifier: "addNote")
            navigationController?.pushViewController(vc!, animated: true)
        case .contact:
            let vc = CNContactPickerViewController()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            break
        case .image:
            let vc = UIImagePickerController()
            vc.mediaTypes = [kUTTypeImage as String]
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .video:
            let vc = UIImagePickerController()
            vc.mediaTypes = [kUTTypeMovie as String]
            vc.videoQuality = .typeLow
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
}

extension MainViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "showQRCode") as! ShowQRCodeViewController
            vc.qrCodeMaterial = ContactMaterial(contact: contact)
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info.first(where: { $0.key == .originalImage })?.value as? UIImage  {
            let vc = storyboard?.instantiateViewController(withIdentifier: "showQRCode") as! ShowQRCodeViewController
            vc.imageToUpload = image
            picker.dismiss(animated: true, completion: {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        } else if let movieURL = (info.first { $0.key == UIImagePickerController.InfoKey.mediaURL })?.value as? URL {
            picker.dismiss(animated: true) {
                print("movieURL: \(movieURL)")
                let movie = AVAsset(url: movieURL)
                if movie.duration.seconds > 60*3 {
                    self.alertVideoTooLong()
                } else {
                    print(movie.duration.seconds)
                }
            }
        }
    }
    
    func alertVideoTooLong() {
        let vc = UIAlertController(title: nil, message: "视频太大", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
}
