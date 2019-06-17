//
//  RedirectionService.swift
//  QRCoder
//
//  Created by Frank Cheng on 2019/6/15.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import Foundation
import UIKit
import RxAlamofire
import RxSwift
import SwiftyJSON

class RedirectionService {
    static let shared = RedirectionService()
    
    func getLogs(id: String) -> Observable<JSON> {
        return json(.get, "/redirection/summary/\(id)".buildURL())
            .observeOn(MainScheduler.instance)
            .map({ (resp) -> JSON in
                JSON(resp)["summary"]
            })
    }
}
