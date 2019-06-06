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
    case front, back, text
    
    var icon: UIImage {
        switch self {
        case .front:
            return #imageLiteral(resourceName: "th-large.png")
        case .back:
            return #imageLiteral(resourceName: "square.png")
        case .text:
            return #imageLiteral(resourceName: "font.png")
        }
    }
    
    var title: String {
        switch self {
        case .front:
            return "前景色"
        case .back:
            return "背景色"
        case .text:
            return "字体颜色"
        }
    }
}

protocol ColorPalettePopupDelegate: class {
    func onCanvasChanged(canvas: ColorPaletteCanvas)
}

class ColorPalettePopupViewController: UITableViewController {
    
    lazy var canvases: [ColorPaletteCanvas] = {
        if haveText {
            return  ColorPaletteCanvas.allCases
        } else {
            return ColorPaletteCanvas.allCases.filter { $0 != ColorPaletteCanvas.text }
        }
    }()
    weak var delegate: ColorPalettePopupDelegate?
    var selectedCanvas = ColorPaletteCanvas.front {
        didSet {
            tableView.reloadData()
        }
    }
    var haveText: Bool!
    
    init(haveText: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.haveText = haveText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ColorPalettePopupCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
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
        dismiss(animated: true, completion: nil)
    }
}
