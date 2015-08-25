//
//  ViewController.swift
//  Needle
//
//  Created by Simon Cleriot on 8/18/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import UIKit


class ViewDetails: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var article: ArticleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = article?.title
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: article?.priceString ?? "")
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        self.priceLabel.attributedText = attributeString
        self.discountLabel.text = article?.priceDiscountString
        self.logoView.setImageWithUrl(NSURL(string: article?.companyLogo ?? "")!, placeHolderImage: nil)
        self.imageView.setImageWithUrl(NSURL(string: NeedleApiManager.photoPath+"/"+(article?.photo ?? ""))!, placeHolderImage: nil)
    }
}

