//
//  ViewStore
//  Needle
//
//  Created by Simon Cleriot on 8/18/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ViewStore: UIViewController {
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var article: ArticleModel?
    var location: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = article?.title
        self.addressLabel.text = article?.companyAddress
        self.logoView.setImageWithUrl(NSURL(string: article?.companyLogo ?? "")!, placeHolderImage: nil)
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(article?.companyAddress!, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate,
                    300 * 2.0, 300 * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.location = placemark
            }
        })
    }
    
    @IBAction func goShopping(sender: AnyObject) {
        let place = MKPlacemark(placemark: location)
        let mapItem = MKMapItem(placemark: place)
        
        let options = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeWalking]
        
        mapItem.openInMapsWithLaunchOptions(options)
    }
}

