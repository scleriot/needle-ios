//
//  ArticleModel.swift
//  Needle
//
//  Created by Simon Cleriot on 8/25/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ArticleModel {
    var id: Int?
    var price: Float?
    var priceDiscount: Float?
    var photo: String?
    var title: String?
    var description: String?
    var distance: Double?
    
    var companyName: String?
    var companyLogo: String?
    var companyPhone: String?
    var companyAddress: String?
    

    
    var priceString: String? {
        get {
            if let p = self.price {
                return "\(p)€"
            }
            else {
                return nil
            }
        }
    }
    var priceDiscountString: String? {
        get {
            if let p = self.priceDiscount {
                return "\(p)€"
            }
            else {
                return nil
            }
        }
    }
    var distanceString: String? {
        get {
            if let d = self.distance {
                return "\(round(d))m"
            }
            else {
                return nil
            }
        }
    }
    
    
    func markAsLiked() {
        if let id = self.id {
            let apiPath = "\(NeedleApiManager.apiPath)/likes/\(id)"
            
            NeedleApiManager.sharedInstance.alamofireManager().request(.POST, apiPath)
        }
    }
    func markAsDisliked() {
        if let id = self.id {
            let apiPath = "\(NeedleApiManager.apiPath)/dislikes/\(id)"
            
            NeedleApiManager.sharedInstance.alamofireManager().request(.POST, apiPath)
        }
    }
    
    
    static func getArticles(callback:(articles:[ArticleModel])->Void )
    {
        let apiPath = "\(NeedleApiManager.apiPath)/articles/user_recommendation"
        let parameters = [
            "latitude": 0,
            "longitude": 0
        ]

        NeedleApiManager.sharedInstance.alamofireManager().request(.GET, apiPath, parameters: parameters)
            .responseJSON { _, _, data, error in
                if let data: AnyObject = data {
                    let result = JSON(data)
                    var articles = [ArticleModel]()
                    for (index: String, item: JSON) in result {
                        var a = ArticleModel()
                        a.id = item["id"].int
                        a.price = item["price"].float
                        a.priceDiscount = item["price_discount"].float
                        a.photo = item["photo"].string
                        a.title = item["title"].string
                        a.description = item["description"].string
                        a.distance = item["distance"].double
                        
                        a.companyName = item["company_name"].string
                        a.companyLogo = item["company_logo"].string
                        a.companyPhone = item["company_phone"].string
                        a.companyAddress = item["company_address"].string
                        
                        articles.append(a)
                    }
                    
                    callback(articles: articles)
                }
            }
    }
    
    
}