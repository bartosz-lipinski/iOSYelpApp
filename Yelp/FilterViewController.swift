//
//  FilterViewController.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/20/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var filterContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        filterContainer.layer.borderWidth = 1.0
        filterContainer.layer.borderColor = UIColor.lightGrayColor().CGColor
        filterContainer.layer.cornerRadius = 3.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
