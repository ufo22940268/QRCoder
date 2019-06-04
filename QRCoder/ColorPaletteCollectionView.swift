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
        UIColor.fromHexString(hex: "ff3b30"),
        UIColor.fromHexString(hex: "ff9500"),
        UIColor.fromHexString(hex: "ffcc00"),
        UIColor.fromHexString(hex: "4ed964"),
        UIColor.fromHexString(hex: "5ac8fa"),
        UIColor.fromHexString(hex: "007aff"),
        UIColor.fromHexString(hex: "5756d6")
    ]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        dataSource = self
        register(ColorPaletteCircle.self, forCellWithReuseIdentifier: "cell")
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
