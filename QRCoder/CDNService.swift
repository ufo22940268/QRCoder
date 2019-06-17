//
//  CDNService.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/12.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
import SwiftyJSON

class CDNService {
    
    static let shared = CDNService()

    func upload(image: UIImage, complete: @escaping (String?) -> Void) {
//        AF.upload(multipartFormData: { multiData in
//            multiData.append(image.pngData()!, withName: "file1", fileName: "a.png")
//        }, to: URL(string: "/upload".buildURL())!)
//            .responseJSON { (response) in
//                switch response.result {
//                case let .success(value):
//                    let json = JSON(value)
//                    complete(json["url"].rawString())
//                case .failure(_):
//                    complete(nil)
//                }
//        }
    }
}
