//
//  SettingsViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/24/17.
//
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var tempUnits: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tempUnits.selectedSegmentIndex = Preferences().tempUnits == .Celsius ? 1 : 0
        
    }
    
    @IBAction func updateTempUnits(sender: UIButton) {
        let tempUnits: TempUnits = self.tempUnits.selectedSegmentIndex == 1 ? .Celsius : .Fahrenheit
        print(tempUnits.asParameter())
    }
    
    
}
