//
//  AboutViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/28/17.
//
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "About / Settings"
        self.navigationController?.isNavigationBarHidden = false
        
    }
}
