//
//  MainViewController.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/18/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!

    var client: YelpOAuthClient!

    var businesses: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        searchDisplayController?.displaysSearchBarInNavigationBar = true
        navigationItem.rightBarButtonItem = filterBtn

        // Initialize the Yelp client
        client = YelpOAuthClient(
            consumerKey:    "wVsoVMepFyxQU7pM2ZGVXg",
            consumerSecret: "3SdHfo8tTAKW3EYYHoUz4nCbgyM",
            accessToken:    "6nlqBaBh87XC9rV606vGnpQzuaH1VzQi",
            accessSecret:   "YbzRsj464YqRPCzStY2gpnOPOVQ")

        // This is just an example...
        client.search("Restaurant") {
            (response: AnyObject!, error: NSError!) -> Void in

            if error == nil {
                var object = response as NSDictionary
                self.businesses = object["businesses"] as [NSDictionary]
                self.tableView.reloadData()
            } else {
                // TODO: handle error in the UI...
                println(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
/*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 133
    }
*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessListingCell") as BusinessListingTableViewCell

        var business = businesses[indexPath.row]

        var thumbnailImageUrl = business["image_url"] as String
        cell.thumbnailImageView.setImageWithURL(NSURL(string: thumbnailImageUrl))

        var ratingImageUrl = business["rating_img_url_large"] as String
        cell.starRatingImageView.setImageWithURL(NSURL(string: ratingImageUrl))

        cell.businessNameLabel.text = business["name"] as? String

        var reviewCount = business["review_count"] as Int
        cell.reviewCountLabel.text = "\(reviewCount) reviews"

        var location = business["location"] as NSDictionary
        var addressParts = location["address"] as [String]
        var address = " ".join(addressParts)
        var city = location["city"] as String
        cell.addressLabel.text = "\(address) \(city)"

        var categories = business["categories"] as [NSArray]

        var categoriesLabels: [String] = categories.reduce([]) {
            var currentValue = $0 as [String]
            var category = $1 as [String]
            var label = category[0]
            currentValue.append(label)
            return currentValue
        }

        cell.categoryLabel.text = ", ".join(categoriesLabels)

        return cell
    }
}
