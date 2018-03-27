//
//  BaseService.swift
//  RiBoScheduleAssistant
//
//  Created by Rin Pham on 3/14/18.
//  Copyright © 2018 Rin Pham. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias Completion = (_ data: JSON, _ statusCode: Int?, _ error: String?) -> Void
typealias Result = (_ data: Any, _ statusCode: Int?, _ error: String?) -> Void
typealias ListResult = (_ data: [Any], _ statusCode: Int?, _ error: String?) -> Void
typealias ObjectLink = (link: String, paramater: [String: Any])

class BaseService {
    
    static func requestService(apiPath: String?, method: HTTPMethod, parameters: Parameters?, completion: @escaping Completion) {
        if let apiPath = apiPath {
            Alamofire.request(apiPath, method: method, parameters: parameters, headers: AppLinks.header).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let error = JSON(value)["detail"].string {
                        completion(JSON.null, response.response?.statusCode, error)
                    } else {
                        completion(JSON(value), response.response?.statusCode, nil)
                    }
                case .failure(let error):
                    completion(JSON.null, response.response?.statusCode, error.localizedDescription)
                }
            }
        }
    }
    
}
