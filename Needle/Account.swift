//
//  Account.swift
//  Needle
//
//  Created by Simon Cleriot on 8/25/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class Account {
    
    static func signup(username: String, password: String, callback:()->Void )
    {
        let authHeader = "\(NeedleApiManager.clientID):\(NeedleApiManager.clientSecret)"
        let utf8str = authHeader.dataUsingEncoding(NSUTF8StringEncoding)
        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        {
            let headers = [
                "Authorization": "Basic \(base64Encoded)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            let apiPath = "\(NeedleApiManager.apiPath)/accounts/signup"
            let parameters = [
                "email": username,
                "password": password
            ]
            
            Alamofire.request(.POST, apiPath, parameters: parameters, headers: headers)
                .responseJSON { _, _, data, error in
                    if let data: AnyObject = data {
                        println(data)
                        println(error)
                        let result = JSON(data)
                        
                        
                        callback()
                    }
                    
            }
        }
    }
}