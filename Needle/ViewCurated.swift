//
//  ViewController.swift
//  Needle
//
//  Created by Simon Cleriot on 8/18/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import UIKit
import Koloda
import pop

class ViewCurated: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    @IBOutlet weak var kolodaView: KolodaView!
    
    var articles = [ArticleModel]()
    var indexForSegue = -1
    
    let progressHUD = ProgressHUD(text: "Chargement en cours...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.view.addSubview(progressHUD)
        loadArticles()
    }
    
    func loadArticles() {
        ArticleModel.getArticles() { articles in
            self.articles.extend(articles)
            self.kolodaView.reloadData()
            self.progressHUD.removeFromSuperview()
        }
    }
    
    @IBAction func dontLike(sender: UIButton) {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func like(sender: UIButton) {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(articles.count)
    }
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        var a: ArticleModel = articles[Int(index)]
        
        let v = KolodaCustomView(frame: koloda.frame)
        //Source https://github.com/namanhams/Swift-UIImageView-AFNetworking
        v.imageUrl = NeedleApiManager.photoPath+"/"+a.photo!
        v.distance = a.distanceString
        v.price = a.priceString
        v.priceDiscount = a.priceDiscountString
        return v
    }
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        /*return NSBundle.mainBundle().loadNibNamed("OverlayView",
            owner: self, options: nil)[0] as? OverlayView*/
        return nil
    }
    
    
    
    //MARK: KolodaViewDelegate
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        if direction == .Left {
            articles[Int(index)].markAsDisliked()
        }
        else if direction == .Right {
            articles[Int(index)].markAsLiked()
        }
        
        if index >= 4 {
            loadArticles()
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        //UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
        indexForSegue = Int(index)
        self.performSegueWithIdentifier("details", sender: self)
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        return nil
    }
    
    quic
}

