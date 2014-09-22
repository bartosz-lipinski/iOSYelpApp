//
//  FilterViewController.swift
//  Yelp
//
//  Created by Julien Lecomte on 9/20/14.
//  Copyright (c) 2014 Julien Lecomte. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var delegate: YelpSearchSettingsDelegate?

    @IBOutlet weak var filterContainer: UIView!

    @IBOutlet var dealSwitch: UISwitch!
    @IBOutlet var radiusSlider: UISlider!
    @IBOutlet var radiusLabel: UILabel!
    @IBOutlet var sortBySegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        filterContainer.layer.borderWidth = 1.0
        filterContainer.layer.borderColor = UIColor.lightGrayColor().CGColor
        filterContainer.layer.cornerRadius = 5.0

        navigationItem.hidesBackButton = true

        // Initialize settings UI with current settings...
        var settings: YelpSearchSettings! = delegate?.getCurrentSearchSettings()
        dealSwitch.on = settings.deals
        radiusSlider.value = Float(settings.radius)
        radiusLabel.text = "\(settings.radius) miles"
        sortBySegmentedControl.selectedSegmentIndex = settings.sortBy
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onRadiusSliderValueChanged(sender: AnyObject) {
        var sliderValue = Float(lroundf(radiusSlider.value))
        radiusSlider.setValue(sliderValue, animated: true)
        radiusLabel.text = "\(Int(sliderValue)) miles"
    }

    @IBAction func doneEditingSearchSettings(sender: AnyObject) {
        delegate?.applyYelpSearchSettings(YelpSearchSettings(
            radius: lroundf(radiusSlider.value),
            sortBy: sortBySegmentedControl.selectedSegmentIndex,
            deals: dealSwitch.on
        ))

        navigationController?.popViewControllerAnimated(true)
    }
}
