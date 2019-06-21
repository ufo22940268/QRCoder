//
//  Extensions.swift
//  QrCoder
//
//  Created by Frank Cheng on 2019/5/31.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

let localApiHost = "http://192.168.31.77:3000"
let remoteApiHost = "http://106.12.82.179:3000"
#if DEBUG
let apiHost = localApiHost
#else
let apiHost = remoteApiHost
#endif

extension UIView {
    @discardableResult
    func useAutolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func sameSizeAsParent() {
        guard let superview = superview else { fatalError() }
        self.useAutolayout()
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            heightAnchor.constraint(equalTo: superview.heightAnchor)])
    }
}

extension String {
    func isURL() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    func buildURL() -> String {
        return "\(apiHost)\(self)"
    }
}

extension UIColor {
    static func fromHexString(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static let separator = UIColor.fromHexString(hex: "D1D1D4")
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension UIViewController {    
    func isInitial() -> Bool {
        //        guard UIDevice.isSimulator else { fatalError() }
        let initialVC =  storyboard!.instantiateInitialViewController()!
        if let navigationVC = initialVC as? UINavigationController {
            return type(of: navigationVC.topViewController!) == type(of: self)
        } else {
            return type(of: initialVC) == type(of: self)
        }
    }
    
    var realm: Realm? {
        return try! Realm()
    }
}

