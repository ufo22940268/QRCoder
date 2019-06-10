//
//  ColorPallateMenu.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/4.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import UIKit

class ColorPaletteCollectionView: UICollectionView {
    
    var allColors = [
        UIColor.black,
        UIColor.fromHexString(hex: "ff3b30"),
        UIColor.fromHexString(hex: "ff9500"),
        UIColor.fromHexString(hex: "ffcc00"),
        UIColor.fromHexString(hex: "4ed964"),
        UIColor.fromHexString(hex: "5ac8fa"),
        UIColor.fromHexString(hex: "007aff"),
        UIColor.fromHexString(hex: "5756d6")
    ]
    
    var canvas: ColorPaletteCanvas = .front {
        didSet {
            switch canvas {
            case .front, .text:
                allColors[0] = .black
            case .back:
                allColors[0] = .white
            }
            reloadData()
        }
    }
    
    func selectColor(color: UIColor) {
        selectItem(at: IndexPath(row: allColors.firstIndex(of: color) ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 32, height: 32)
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)

        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        dataSource = self
        register(ColorPaletteCircle.self, forCellWithReuseIdentifier: "cell")
        
        selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorPaletteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorPaletteCircle
        cell.color = allColors[indexPath.row]
        return cell
    }
}