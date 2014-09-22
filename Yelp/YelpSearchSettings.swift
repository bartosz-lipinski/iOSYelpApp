//
//  YelpSearchSettings.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/22/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import Foundation

struct YelpSearchSettings {
    var radius: Int // in meters
    var sortBy: Int // 0=Best Matched, 1=Distance, 2=Highest Rated
    var deals: Bool
}

protocol YelpSearchSettingsDelegate {
    func getCurrentSearchSettings() -> YelpSearchSettings
    func applyYelpSearchSettings(settings: YelpSearchSettings)
}
