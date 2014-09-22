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

    func search(query: String, limit: Int, offset: Int, settings: YelpSearchSettings, callback: (response: AnyObject!, error: NSError!) -> Void) -> AFHTTPRequestOperation {

        var parameters = [
            "term": query,
            "location": "San Jose",
            "offset": offset,
            "limit": limit,
            "radius_filter": settings.radius * 1609,
            "deals_filter": settings.deals,
            "sort": settings.sortBy
        ]

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

    func getBusinessDetail(businessId: String, callback: (response: AnyObject!, error: NSError!) -> Void) -> AFHTTPRequestOperation {

        return self.GET("business/\(businessId)", parameters: nil, success: {
            // Success
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            callback(response: response, error: nil)
        }, failure: {
            // Failure
            (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            callback(response: nil, error: error)
        })
    }

    // Singleton stuff...

    class var sharedInstance: YelpOAuthClient {

        struct Static {
            static var instance: YelpOAuthClient?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = YelpOAuthClient(
                consumerKey:    "wVsoVMepFyxQU7pM2ZGVXg",
                consumerSecret: "3SdHfo8tTAKW3EYYHoUz4nCbgyM",
                accessToken:    "6nlqBaBh87XC9rV606vGnpQzuaH1VzQi",
                accessSecret:   "YbzRsj464YqRPCzStY2gpnOPOVQ"
            )
        }

        return Static.instance!
    }
}
