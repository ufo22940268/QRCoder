//
//  CDNService.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/12.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CDNService {
    
    static let shared = CDNService()
    let host = "http://127.0.0.1:3000"
    
    func upload(image: UIImage, complete: @escaping () -> Void) {
        AF.upload(multipartFormData: { multiData in
            multiData.append(image.pngData()!, withName: "file1", fileName: "a.png")
        }, to: URL(string: "\(host)/upload")!)
            .responseJSON { (response) in
                print(response)
                complete()
        }
    }
}
