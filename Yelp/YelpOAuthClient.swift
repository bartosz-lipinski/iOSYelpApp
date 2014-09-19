//
//  YelpOAuthClient.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/18/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import Foundation

class YelpOAuthClient: BDBOAuth1RequestOperationManager {

    init(consumerKey: String, consumerSecret: String, accessToken: String, accessSecret: String) {
        let baseURL = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseURL, consumerKey: consumerKey, consumerSecret: consumerSecret)
        let token: BDBOAuthToken = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        requestSerializer.saveAccessToken(token)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func search(query: String, callback: (response: AnyObject!, error: NSError!) -> Void) -> AFHTTPRequestOperation {
        var parameters = ["term": query, "location": "San Jose"]

        return self.GET("search", parameters: parameters, success: {
            // Success
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            callback(response: response, error: nil)
        }, failure: {
            // Failure
            (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            callback(response: nil, error: error)
        })
    }
}
