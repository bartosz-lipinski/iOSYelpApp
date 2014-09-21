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

    var client = YelpOAuthClient.sharedInstance

    var businesses: [NSDictionary] = []
    var query = "Restaurants"
    var offset = 0
    let n = 20

    var settings = [
        "open_now": false,
        "offering_deal": false,
        "sort_by": 0
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        MMProgressHUD.setPresentationStyle(MMProgressHUDPresentationStyle.None)

        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.titleView = searchBar

        // Trigger initial search...
        searchBar.text = query
        fetchBusinessListing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

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
        cell.addressLabel.text = "\(address), \(city)"

        var categories = business["categories"] as [NSArray]

        var categoriesLabels: [String] = categories.reduce([]) {
            var currentValue = $0 as [String]
            var category = $1 as [String]
            var label = category[0]
            currentValue.append(label)
            return currentValue
        }

        cell.categoryLabel.text = ", ".join(categoriesLabels)

        // Additional data used for segue...
        cell.businessId = business["id"] as String

        // Infinite scrolling...
        if indexPath.row >= businesses.count - 1 && offset < businesses.count {
            offset += n
            fetchBusinessListing()
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = query
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if searchBar.text != query {
            query = searchBar.text
            offset = 0
            businesses = []
            tableView.reloadData()
            fetchBusinessListing()
        }
    }

    func fetchBusinessListing() {
        MMProgressHUD.showWithStatus("Loading...")

        client.search(query, limit: n, offset: offset) {
            (response: AnyObject!, error: NSError!) -> Void in

            MMProgressHUD.dismiss()

            if error == nil {
                var object = response as NSDictionary
                var business = object["businesses"] as [NSDictionary]

                if self.offset > 0 {
                    self.businesses += business
                } else {
                    self.businesses = business
                }

                self.tableView.reloadData()
            } else {
                var alert = UIAlertController(title: "Error", message: "API error", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: false, completion: nil)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail" {
            var cell = sender as BusinessListingTableViewCell
            var detailViewController = segue.destinationViewController as DetailViewController
            detailViewController.businessId = cell.businessId
        } else if segue.identifier == "Settings" {
            // TODO
        }
    }

}
