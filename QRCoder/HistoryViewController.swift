//
//  HistoryViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/3.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryLabelView: UILabel {
    
    var sideInset: CGFloat = 4
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: sideInset, dy: 0))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width = size.width + sideInset*2
        return size
    }
}

class HistoryViewController: UITableViewController {
    
    var qrcodes: Results<QRCodeModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 1)))
        
        loadData()
    }
    
    func loadData() {
        qrcodes = realm?.objects(QRCodeModel.self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let qrcodes = qrcodes else { return 0 }
        return qrcodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryCell
        
        let qrcode = qrcodes![indexPath.row]
        cell.title.text = qrcode.formatTitle
        cell.category.text = qrcode.categoryEntity.title
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.extra.text = formatter.string(from: qrcode.createdDate)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "showQRCode") as! ShowQRCodeViewController
        let qrcode = qrcodes![indexPath.row]
        vc.qrCodeMaterial = qrcode.material
        navigationController?.pushViewController(vc, animated: true)
    }
}
