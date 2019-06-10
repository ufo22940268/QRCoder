//
//  Link.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/10.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit

class CustomXMLParser: NSObject, XMLParserDelegate {
    
    var icon: String?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "link", let attrs = attributeDict.first(where: { key, value -> Bool in
            key == "rel" && ["shortcut icon", "icon"].contains(value)
        }) {
            let href = attributeDict["href"]
            if attributeDict["rel"] == "icon" {
                icon = href
            } else if icon == nil {
                icon = href
            }
        }
    }
}

extension URL {
    func parseFavIcon(complete: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: self) { (data, response, _) in
            guard let response = response as? HTTPURLResponse, let data = data, (200...299).contains(response.statusCode) else {
                complete(nil)
                return
            }
            
            let parser = XMLParser(data: data)
            let parserDelegate = CustomXMLParser()
            parser.delegate = parserDelegate
            parser.parse()
            guard let icon = parserDelegate.icon else {
                complete(nil)
                return
            }
            let iconURL = URL(string: icon, relativeTo: self)
            URLSession.shared.dataTask(with: iconURL!, completionHandler: { (data, _, _) in
                guard let data = data else {
                    complete(nil)
                    return
                }
                
                complete(UIImage(data: data))
                return
            }).resume()
        }
        task.resume()
    }
}
