//
//  ViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import ContactsUI

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view

        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        let itemWidth = (view.bounds.width - 16*2 - 10)/2
        collectionLayout.itemSize = CGSize(width: itemWidth, height: 80)
        collectionLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.register(UINib(nibName: "ActionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.isToolbarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
