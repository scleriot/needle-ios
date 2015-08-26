//
//  NeedleApiManager.swift
//  Needle
//
//  Created by Simon Cleriot on 8/24/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

class NeedleApiManager
{
    static let sharedInstance = NeedleApiManager()
    static let apiPath = "http://pro.needleapp.fr/api"
    static let photoPath = "http://pro.needleapp.fr"
    
    var OAuthTokenCompletionHandler:(NSError? -> Void)?
    
    var clientID = "dev"
    var clientSecret = "secret"
    
    var OAuthToken: String? {
        set {
            if let valueToSave = newValue
            {
                let error = Locksmith.updateData(["token": valueToSave], forUserAccount: "needle", inService: "token")
                if let errorReceived = error
                {
                    println(error)
                    Locksmith.deleteDataForUserAccount("needle")
                }
                addSessionHeader("Authorization", value: "Bearer \(newValue!)")
            }
            else // they set it to nil, so delete it
            {
                Locksmith.deleteDataForUserAccount("needle")
                removeSessionHeaderIfExists("Authorization")
            }
        }
        get {
            // try to load from keychain
            let (dictionary, error) = Locksmith.loadDataForUserAccount("needle", inService: "token")
            if let token =  dictionary?["token"] as? String {
                return token
            }
            removeSessionHeaderIfExists("Authorization")
            return nil
        }
    }
    var OAuthRefreshToken: String? {
        set {
            if let valueToSave = newValue
            {
                let error = Locksmith.updateData(["token": valueToSave], forUserAccount: "needle", inService: "refresh_token")
                if let errorReceived = error
                {
                    println(error)
                }
            }
        }
        get {
            // try to load from keychain
            let (dictionary, error) = Locksmith.loadDataForUserAccount("needle", inService: "refresh_token")
            if let token =  dictionary?["token"] as? String {
                return token
            }
            return nil
        }
    }
    
    
    
    func hasOAuthToken() -> Bool
    {
        return (self.OAuthToken != nil)
    }
    func addSessionHeader(key: String, value: String)
    {
        let manager = Alamofire.Manager.sharedInstance
        if var sessionHeaders = manager.session.configuration.HTTPAdditionalHeaders as? Dictionary<String, String>
        {
            sessionHeaders[key] = value
            manager.session.configuration.HTTPAdditionalHeaders = sessionHeaders
        }
        else
        {
            manager.session.configuration.HTTPAdditionalHeaders = [
                key: value
            ]
        }
    }
    
    func removeSessionHeaderIfExists(key: String)
    {
        let manager = Alamofire.Manager.sharedInstance
        if var sessionHeaders = manager.session.configuration.HTTPAdditionalHeaders as? Dictionary<String, String>
        {
            sessionHeaders.removeValueForKey(key)
            manager.session.configuration.HTTPAdditionalHeaders = sessionHeaders
        }
    }
    
    
    
    
    
    
    
    func startOAuth2Login(username: String, password: String, successCallback: ()->(), errorCallback: ()->() )
    {
        let authHeader = "\(self.clientID):\(self.clientSecret)"
        let utf8str = authHeader.dataUsingEncoding(NSUTF8StringEncoding)
        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        {
            let headers = [
                "Authorization": "Basic \(base64Encoded)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            let parameters = [
                "username": username,
                "password": password,
                "grant_type": "password"
            ]
            
            let tokenPath = "\(NeedleApiManager.apiPath)/oauth/token"
            Alamofire.request(.POST, tokenPath, headers: headers, parameters: parameters)
                .responseJSON { _, _, data, error in
                    println(data)
                    if let anError = error
                    {
                        println(anError)
                        
                        return
                    }
                    else if let data: AnyObject = data
                    {
                        let result = JSON(data)
                        if (result["code"].int != nil) {
                            //TODO handle error 503
                            errorCallback()
                        }
                        else {
                            self.OAuthToken = result["access_token"].string
                            self.OAuthRefreshToken = result["refresh_token"].string
                            println(self.OAuthToken!)
                            successCallback()
                        }
                    }
                }
        }
    }
    
    func refreshOAuth2Token(successCallback: ()->()) {
        if let refresh_token = self.OAuthRefreshToken {
            let authHeader = "\(self.clientID):\(self.clientSecret)"
            let utf8str = authHeader.dataUsingEncoding(NSUTF8StringEncoding)
            if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            {
                let headers = [
                    "Authorization": "Basic \(base64Encoded)",
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                let parameters = [
                    "refresh_token": refresh_token,
                    "grant_type": "password"
                ]
                
                let tokenPath = "\(NeedleApiManager.apiPath)/oauth/token"
                Alamofire.request(.POST, tokenPath, headers: headers, parameters: parameters)
                    .responseJSON { _, _, data, error in
                        println(data)
                        if let anError = error
                        {
                            println(anError)
                            
                            return
                        }
                        else if let data: AnyObject = data
                        {
                            let result = JSON(data)
                            if (result["code"].int != nil) {
                                //TODO handle error 503
                            }
                            else {
                                self.OAuthToken = result["access_token"].string
                                self.OAuthRefreshToken = result["refresh_token"].string
                                println(self.OAuthToken!)
                                successCallback()
                            }
                        }
                }
            }
        }
    }
    
    func alamofireManager() -> Manager
    {
        let manager = Alamofire.Manager.sharedInstance
        addSessionHeader("Content-Type", value: "application/x-www-form-urlencoded")
        return manager
    }
}