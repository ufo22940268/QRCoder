//
//  ColorPalettePopupViewController.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/5.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class ColorPalettePopupCell: UITableViewCell {
    
    var isActive = false {
        didSet {
            let color = isActive ? tintColor : UIColor.darkText
            textLabel?.textColor = color
            imageView?.tintColor = color
        }
    }
}

enum ColorPaletteCanvas: CaseIterable {
    case front, back
    
    var icon: UIImage {
        switch self {
        case .front:
            return #imageLiteral(resourceName: "th-large.png")
        case .back:
            return #imageLiteral(resourceName: "square.png")
        }
    }
    
    var title: String {
        switch self {
        case .front:
            return "前景色"
        case .back:
            return "背景色"
        }
    }
}

protocol ColorPalettePopupDelegate: class {
    func onCanvasChanged(canvas: ColorPaletteCanvas)
}

class ColorPalettePopupViewController: UITableViewController {
    
    var canvases = ColorPaletteCanvas.allCases
    weak var delegate: ColorPalettePopupDelegate?
    var selectedCanvas = ColorPaletteCanvas.front {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ColorPalettePopupCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        selectedCanvas = .front
        tableView.allowsSelection = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColorPalettePopupCell
        let canvas = canvases[indexPath.row]
        cell.imageView?.image = canvas.icon
        cell.textLabel?.text = canvas.title
        cell.textLabel?.textAlignment = .right
        cell.isActive = indexPath.row == canvases.firstIndex(of: selectedCanvas)!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canvases.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCanvas = canvases[indexPath.row]
        tableView.reloadData()
        
        delegate?.onCanvasChanged(canvas: selectedCanvas)
    }
}
