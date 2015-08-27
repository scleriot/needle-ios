//
//  ViewController.swift
//  Needle
//
//  Created by Simon Cleriot on 8/18/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import UIKit


class ViewPenderie: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var articles = [ArticleModel]()
    let progressHUD = ProgressHUD(text: "Chargement en cours...")
    var indexForSegue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CustomCellViewPenderie", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 150
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.addSubview(progressHUD)
        ArticleModel.getCloset() { articles in
            self.articles = articles
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.progressHUD.removeFromSuperview()
            })
        }
    }
    
    @IBAction func goShopping(sender: UIButton) {
        var confirmAlert = UIAlertController(title: "Go Shopping !", message: "Sélectionnez dans la liste l'article que vous souhaitez aller acheter, vous obtiendrez alors plus d'informations sur le magasin !", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(confirmAlert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomViewCellPenderie = tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomViewCellPenderie
        cell.loadItem(articles[indexPath.row])
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        tableView.layoutSubviews()
        
        indexForSegue = indexPath.row
        self.performSegueWithIdentifier("storedetails", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! ViewStore
        destinationVC.article = articles[indexForSegue!]
        destinationVC.hidesBottomBarWhenPushed = true
    }
}

