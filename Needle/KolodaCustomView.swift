//
//  KolodaCustomView.swift
//  Needle
//
//  Created by Simon Cleriot on 8/25/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import UIKit

@IBDesignable
class KolodaCustomView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    
    var imageUrl: String? {
        didSet{
            imageView.setImageWithUrl(NSURL(string: self.imageUrl!)!, placeHolderImage: nil)
        }
    }
    var distance: String? {
        didSet {
            distanceLabel.text = self.distance
        }
    }
    var price: String? {
        didSet {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.price!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            priceLabel.attributedText = attributeString
        }
    }
    var priceDiscount: String? {
        didSet {
            discountLabel.text = self.priceDiscount
        }
    }
    
    let nibName = "KolodaCustomView"
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
}
