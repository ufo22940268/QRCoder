//
//  QRCodeMaterial.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/6/2.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import Contacts
import RealmSwift
import Contacts

protocol QRCodeMaterial {
    func toString() -> String
    func exportToModel() -> QRCodeModel
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
    
    func exportToModel() -> QRCodeModel {
        let model = QRCodeModel()
        model.category = ActionCell.Category.link.rawValue
        model.text = toString()
        return model
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
    
    func exportToModel() -> QRCodeModel {
        let model = QRCodeModel()
        model.category = ActionCell.Category.note.rawValue
        model.text = toString()
        return model
    }
}

struct ContactMaterial: QRCodeMaterial {
    var contact: CNContact!
    
    func toString() -> String {
        let data = try! CNContactVCardSerialization.data(with: [contact])
        let vcard = String(data: data, encoding: .utf8)
        return vcard!
    }
    
    func exportToModel() -> QRCodeModel {
        let model = QRCodeModel()
        model.category = ActionCell.Category.contact.rawValue
        model.text = toString()
        return model
    }
}


class QRCodeModel: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var category: Int = 0
    @objc dynamic var createdDate: Date = Date()
    
    var formatTitle: String {
        switch categoryEntity {
        case .contact:
            let contact = try! CNContactVCardSerialization.contacts(with: text.data(using: .isoLatin1)!).first!
            return contact.givenName
        default:
            return text
        }
    }
    
    var categoryEntity: ActionCell.Category {
        return ActionCell.Category.allCases.first { $0.rawValue == category }!
    }
}
