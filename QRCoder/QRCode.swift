//
//  QRCodeMaterial.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/2.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import Contacts

protocol QRCodeMaterial {
    func toString() -> String
}

struct LinkMaterial: QRCodeMaterial {
    
    var url: String!
    
    init(str: String) {
        if str.range(of: #"[^:]+://.+"#, options: .regularExpression, range: nil, locale: nil) == nil {
            url = "http://" + str
        } else {
            url = str
        }
    }
    
    func toString() -> String {
        return url
    }
}

struct NoteMaterial: QRCodeMaterial {
    
    var note: String!
    
    func  toString() -> String {
        return note
    }
}

struct ContactMaterial: QRCodeMaterial {
    var contact: CNContact!
    
    func toString() -> String {
        let data = try! CNContactVCardSerialization.data(with: [contact])
        let vcard = String(data: data, encoding: .utf8)
        return vcard!
    }
}
