//
//  QRCodeMaterial.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/2.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation

protocol QRCodeMaterial {
    func toString() -> String
}

struct LinkMaterial: QRCodeMaterial {
    
    var str: String
    
    func toString() -> String {
        return str
    }
}

