//
//  MainViewController.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/18/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var client: YelpOAuthClient!

    override func viewDidLoad() {
        super.viewDidLoad()

        client = YelpOAuthClient(
            consumerKey:    "wVsoVMepFyxQU7pM2ZGVXg",
            consumerSecret: "3SdHfo8tTAKW3EYYHoUz4nCbgyM",
            accessToken:    "6nlqBaBh87XC9rV606vGnpQzuaH1VzQi",
            accessSecret:   "YbzRsj464YqRPCzStY2gpnOPOVQ")

        client.search("Restaurant") {
            (response: AnyObject!, error: NSError!) -> Void in
            println(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

