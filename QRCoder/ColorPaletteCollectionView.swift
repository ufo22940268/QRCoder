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
    
    var selectedIndex = 0
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 32, height: 32)
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)

        contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
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
