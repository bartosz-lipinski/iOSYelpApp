//
//  FilterViewController.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/20/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var filterContainer: UIView!

    @IBOutlet var offering_deal: UISwitch!
    @IBOutlet var sort_by: UISegmentedControl!

    var settings: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        filterContainer.layer.borderWidth = 1.0
        filterContainer.layer.borderColor = UIColor.lightGrayColor().CGColor
        filterContainer.layer.cornerRadius = 5.0

        self.title = "Search Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
