//
//  DetailViewController.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/20/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var businessId = ""

    var locationManager = CLLocationManager()

    var client = YelpOAuthClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Detail"

        MMProgressHUD.showWithStatus("Loading...")

        client.getBusinessDetail(businessId) {
            (response: AnyObject!, error: NSError!) -> Void in

            MMProgressHUD.dismiss()

            if error == nil {
                var business = response as NSDictionary

                var thumbnailImageUrl = business["image_url"] as String
                self.thumbnailImageView.setImageWithURL(NSURL(string: thumbnailImageUrl))

                var ratingImageUrl = business["rating_img_url_large"] as String
                self.starRatingImageView.setImageWithURL(NSURL(string: ratingImageUrl))

                self.businessNameLabel.text = business["name"] as? String

                var reviewCount = business["review_count"] as Int
                self.reviewCountLabel.text = "\(reviewCount) reviews"

                var location = business["location"] as NSDictionary
                var addressParts = location["address"] as [String]
                var address = " ".join(addressParts)
                var city = location["city"] as String
                var state_code = location["state_code"] as String
                var postal_code = location["postal_code"] as String
                self.addressLabel.text = "\(address), \(city), \(state_code) \(postal_code)"

                var categories = business["categories"] as [NSArray]

                var categoriesLabels: [String] = categories.reduce([]) {
                    var currentValue = $0 as [String]
                    var category = $1 as [String]
                    var label = category[0]
                    currentValue.append(label)
                    return currentValue
                }

                self.categoryLabel.text = ", ".join(categoriesLabels)

                self.locationManager.requestAlwaysAuthorization()

                var geocoder = CLGeocoder()
                geocoder.geocodeAddressString(self.addressLabel.text) {
                    (placemarks: [AnyObject]!, error: NSError!) -> Void in
                    if let placemark = placemarks?[0] as? CLPlacemark {
                        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                        self.mapView.region = MKCoordinateRegion(
                            center: placemark.location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                    }
                }
            } else {
                var alert = UIAlertController(title: "Error", message: "API error", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: false, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
