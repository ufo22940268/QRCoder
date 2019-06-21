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
import SwiftyJSON
import RxAlamofire
import RxSwift

class CDNService {
    
    static let shared = CDNService()

    fileprivate func upload(_ data: Data, api: String, fileName: String, mimeType: String, _ complete: @escaping (String?) -> Void) {
        Alamofire.upload(multipartFormData: { multiData in
            multiData.append(data, withName: "file1", fileName: fileName, mimeType: mimeType)
        }, to: URL(string: api.buildURL())!,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { (response) in
                    switch response.result {
                    case let .success(value):
                        let json = JSON(value)
                        complete(json["url"].rawString())
                    case .failure(_):
                        complete(nil)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    func upload(image: UIImage, complete: @escaping (String?) -> Void) {
        let data: Data = image.pngData()!
        upload(data, api: "/upload", fileName: "a.png", mimeType: "image", complete)
    }
    
    func upload(movie: URL, complete: @escaping (String?) -> Void) {
        let data: Data = try! Data(contentsOf: movie)
        upload(data, api: "/upload/video", fileName: "a.mov", mimeType: "video", complete)
    }
}
