//
//  CustomCellViewPenderie.swift
//  Needle
//
//  Created by Simon Cleriot on 8/26/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import UIKit

class CustomViewCellPenderie : UITableViewCell {
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!

    func loadItem(article: ArticleModel) {
        
        self.logoView.setImageWithUrl(NSURL(string: article.companyLogo!)!, placeHolderImage: nil)
        self.photoView.setImageWithUrl (NSURL(string: NeedleApiManager.photoPath+"/"+article.photo!)!, placeHolderImage: nil)
        
        self.titleLabel.text = article.title
        self.discountLabel.text = article.priceDiscountString
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: article.priceString!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        self.priceLabel.attributedText = attributeString
        
        self.layoutSubviews()
    }
}